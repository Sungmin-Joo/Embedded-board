#include <PubSubClient.h>
#include <ESP8266WiFi.h>
#include <DNSServer.h>
#include <ESP8266WebServer.h>
#include <EEPROM.h>
#include <ESP8266mDNS.h>
#include <DHT.h>

//--------------------- use relay -------------------------
const short int RELAY = 15; 

//--------------------- use in captive --------------------
#define   EEPROM_LENGTH 1024 
short int flag = 0;
char eRead[30]; 
byte len; 
char ssid[30]; 
char password[30];
char ip[15]; 
bool captive = true; 
const byte DNS_PORT = 53; 
const int mqttPort = 1883;
const char* mqttUser = "Joo_act";
const char* mqttPassword = "hi";
const char* ESP_ID = "ESP8266_Act";
const String temp = String(ESP_ID) + "/" + String(mqttUser);

IPAddress apIP(192, 168, 1, 1); 
DNSServer dnsServer;
ESP8266WebServer webServer(80); 
WiFiClient espClient;
PubSubClient client(espClient);

//interrupt
void GPIO0() {     
    SaveString(0, ""); // blank out the SSID field in EEPROM     
    ESP.restart(); 
}

String responseHTML = ""     
    "<!DOCTYPE html><html><head><title>CaptivePortal</title></head><body><center>"     
    "<p>WiFi & MQTT Setup</p>"     
    "<form action='/button'>"     
    "<p><input type='text' name='ssid' placeholder='SSID' onblur='this.value=removeSpaces(this.value);'></p>"     
    "<p><input type='text' name='password' placeholder='WLAN Password'></p>"
    "<p><input type='text' name='ip' placeholder='MQTT Server'></p>"     
    "<p><input type='submit' value='Submit'></p></form>"    
    "<p>WiFi & MQTT Setup Page</p></center></body>"   
    "<script>function removeSpaces(string) {"     
    "   return string.split(' ').join('');"     
    "}</script></html>"; 

void setup() { 
    Serial.begin(115200);    
    pinMode(RELAY, OUTPUT);
    EEPROM.begin(EEPROM_LENGTH); 
    ReadString(0, 30);    
    if (!strcmp(eRead, "")) {   
        setup_captive();    
    } else {   
        captive = false;     
        strcpy(ssid, eRead);  
        ReadString(30, 30);   
        strcpy(password, eRead);
        ReadString(60, 15);
        strcpy(ip, eRead);         
        setup_runtime();   
    } 
}

void setup_runtime() { 
    WiFi.mode(WIFI_STA); 
    WiFi.begin(ssid, password);   
    Serial.println(""); 

    // Wait for connection     
    int i = 0;    
    while (WiFi.status() != WL_CONNECTED) { 
        delay(500);  
        Serial.print(".");  
        if(i++ > 15) {        
            captive = true;    
            setup_captive();        
            return;        
        }    
    }  
    Serial.println("");    
    Serial.print("Connected to "); Serial.println(ssid);    
    Serial.print("IP address: "); Serial.println(WiFi.localIP()); 
    Serial.print("MQTT_IP address: ");Serial.println(String(ip));
    attachInterrupt(0,GPIO0,FALLING);
    
    client.setServer(ip, mqttPort);
    client.setCallback(callback);
    delay(2000);
    while (!client.connected()) {
        Serial.println("Connecting to MQTT...");
        if (client.connect(ESP_ID, mqttUser, mqttPassword )) {
            Serial.println("connected");
        } 
        else {
            Serial.print("failed with state "); Serial.println(client.state());
            captive = true; 
            setup_captive();        
            return;
            //restart captive 
        }
    } // end of while 
    client.subscribe((temp + "/cmd/lamp").c_str());
}

void setup_captive() {  
    WiFi.mode(WIFI_AP);  
    WiFi.softAPConfig(apIP, apIP, IPAddress(255, 255, 255, 0));    
    WiFi.softAP("JooDuino_re"); 
         
    dnsServer.start(DNS_PORT, "*", apIP);
     
    webServer.on("/button", button); 
    
    webServer.onNotFound([]() {      
        webServer.send(200, "text/html", responseHTML);   
    });   
    webServer.begin();   
    Serial.println("Captive Portal Started"); 
} 

void loop() {   
    if (captive){  
        dnsServer.processNextRequest();
        webServer.handleClient();  
    }    
    else{
        client.loop();        
    }
}

void button(){     
    Serial.println("button pressed");   
    Serial.println(webServer.arg("ssid")); 
    Serial.println(webServer.arg("ip"));   
    SaveString( 0, (webServer.arg("ssid")).c_str());   
    SaveString(30, (webServer.arg("password")).c_str());
    SaveString(60, (webServer.arg("ip")).c_str());  
    webServer.send(200, "text/plain", "OK");   
    ESP.restart(); 
} 

//define callback function
void callback(char* topic, byte* payload, unsigned int length) {
    Serial.print("Message arrived in topic: ");
    Serial.println(topic);
    if(payload[1] == 'n')
    {
        digitalWrite(RELAY, HIGH);
        Serial.println("-- Relay 0n --");
    }
    else
    {
        digitalWrite(RELAY, LOW);   
        Serial.println("-- Relay 0ff --");
    }
}

// Saves string to EEPROM 
void SaveString(int startAt, const char* id) {
    for (byte i = 0; i <= strlen(id); i++) {   
        EEPROM.write(i + startAt, (uint8_t) id[i]);  
    }     
    EEPROM.commit();
}
 
// Reads string from EEPROM
void ReadString(byte startAt, byte bufor) {  
    for (byte i = 0; i <= bufor; i++) {    
        eRead[i] = (char)EEPROM.read(i + startAt);
    }    
    len = bufor;
}
