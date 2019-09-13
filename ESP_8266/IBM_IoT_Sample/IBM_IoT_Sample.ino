#include <ESP8266WiFi.h>
#include <DNSServer.h>
#include <ESP8266WebServer.h>
#include <PubSubClient.h>
#include <ArduinoJson.h>
#include "iotLabUtil.h"

ESP8266WebServer    webServer(80);
WiFiClientSecure    sslClient;
const char*         fingerprint = "16 51 E3 C2 67 C6 AD 23 9C 1A 70 5C 22 A3 B8 C1 7B 7C A6 1D";
PubSubClient        mqClient(sslClient);

char                iot_server[200];

long                pubInterval;
long                lastPublishMillis = 0;

const char*         publishTopic  = "iot-2/evt/status/fmt/json";
const char*         commandTopic  = "iot-2/cmd/+/fmt/+";

String initHTML = ""
    "<html><head><title>IOT Device Setup</title></head>"
    "<body><center><h1>Device Setup Page</h1>"
        "<style>"
            "input {font-size:3em; width:90%; text-align:center;}"
            "button { border:0;border-radius:0.3rem;background-color:#1fa3ec;"
                "color:#fff; line-height:2em;font-size:3em;width:90%;}"
        "</style>"
        "<form action='/save'>"
            "<p><input type='text' name='ssid' placeholder='SSID'>"
            "<p><input type='text' name='w_pw'placeholder='password'>"
            "<p><input type='text' name='org'placeholder='Org Id'>"
            "<p><input type='text' name='devType'placeholder='Device Type'>"
            "<p><input type='text' name='devId'placeholder='Device Id'>"
            "<p><input type='text' name='token'placeholder='Auth Token'>"
            "<p><input type='text' name='pInterval'placeholder='Publish Interval'>"
            "<p><button type='submit'>Save</button>"
        "</form>"
    "</center></body></html>";

void setup() {
    Serial.begin(115200);
    eeprom_begin();
    chkFactoryReset();
    
    init_config_json();
    JsonObject& cfg = *ptr_config;
    // *** If no "config" is found or "config" is not "done", run configDevice ***
    if(!cfg.containsKey("config") || strcmp((const char*)cfg["config"], "done")) {
         configDevice();
    }

    WiFi.mode(WIFI_STA);
    WiFi.begin((const char*)cfg["ssid"], (const char*)cfg["w_pw"]);
    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
    }
    Serial.printf("\nDevice is ready on IP address : "); Serial.println(WiFi.localIP()); 

    sprintf(iot_server, "%s.messaging.internetofthings.ibmcloud.com", (const char*)cfg["org"]);
    if (!sslClient.connect(iot_server, 8883)) {
        Serial.println("connection failed");
        return;
    }
    if (!sslClient.verify(fingerprint, iot_server)) {
        Serial.println("certificate doesn't match");
        return;
    }
    
    mqClient.setServer(iot_server, 8883);   //IOT
    mqClient.setCallback(msgHandler);
    reconnect();
    
    JsonObject& meta = cfg["meta"];
    pubInterval = meta.containsKey("PubInterval") ? meta["PubInterval"] : 0;
}

void loop() {
    // main loop
    if (!mqClient.connected()) {
        reconnect();
    }
    mqClient.loop();
    if ((pubInterval !=0) && (millis() - lastPublishMillis > pubInterval)) {
        publishHello("Just Checking");
        lastPublishMillis = millis();    
    }  
}

void publishHello(char* greet){
    StaticJsonBuffer<512> jsonOutBuffer;
    char msgBuffer[100];             
    JsonObject& root = jsonOutBuffer.createObject();
    JsonObject& data = root.createNestedObject("d");

    data["greeting"] = greet;

    root.printTo(msgBuffer, sizeof(msgBuffer));
    if (mqClient.publish(publishTopic, msgBuffer)) {
        Serial.println("device Publish ok");
    } else {
        Serial.print("device Publish failed:");
    }
}

void msgHandler(char* topic, byte* payload, unsigned int payloadLength) {
    if (!strncmp(commandTopic, topic, 10)) {
        Serial.println("command received");
    }
    if (!strncmp("iot-2/cmd/greeting", topic, 18)) {
        Serial.println("greeting Command");
        publishHello("Hello IOT");
    }
}

void reconnect() {
    char idBuf[100];
    JsonObject& cfg = *ptr_config;

    while (!mqClient.connected()) {
        sprintf(idBuf, "d:%s:%s:%s", (const char*)cfg["org"], (const char*)cfg["devType"], (const char*)cfg["devId"]);
        Serial.print("Attempting MQTT connection...");
        if (mqClient.connect(idBuf,"use-token-auth",(const char*)cfg["token"])) {
            Serial.println("connected");
        } else {
            Serial.printf("failed(rc=%d), try again in 5 seconds\n", mqClient.state());
            delay(5000);
        }
    }
 
    mqClient.subscribe(commandTopic);
}

void configDevice() {
    DNSServer   dnsServer;
    const byte  DNS_PORT = 53;
    IPAddress   apIP(192, 168, 1, 1);
    WiFi.mode(WIFI_AP);
    WiFi.softAPConfig(apIP, apIP, IPAddress(255, 255, 255, 0));
    char ap_name[100];
    sprintf(ap_name, "jsm_%08X", ESP.getChipId());
    WiFi.softAP(ap_name);
    dnsServer.start(DNS_PORT, "*", apIP);

    webServer.on("/save", saveEnv);
    webServer.onNotFound([]() {
        webServer.send(200, "text/html", initHTML);
    });
    webServer.begin();
    Serial.println("starting the config");
    while(1) {
        yield();
        dnsServer.processNextRequest();
        webServer.handleClient();
    }
}

void saveEnv() {
    JsonObject& cfg = *ptr_config;
    Serial.println(webServer.arg("ssid"));
    Serial.println(webServer.arg("passwd"));

    cfg["ssid"] = webServer.arg("ssid");
    cfg["w_pw"] = webServer.arg("w_pw");
    cfg["org"] = webServer.arg("org");
    cfg["devType"] = webServer.arg("devType");
    cfg["devId"] = webServer.arg("devId");
    cfg["token"] = webServer.arg("token");
    cfg.createNestedObject("meta");
    cfg["meta"]["PubInterval"] = webServer.arg("pInterval");

    cfg.printTo(cfgBuffer, sizeof(cfgBuffer));
    Serial.println(cfgBuffer);
    Serial.println((const char*)cfg["ssid"]);
    save_config_json();
    webServer.send(200, "text/html", "ok");
    ESP.restart();
}
