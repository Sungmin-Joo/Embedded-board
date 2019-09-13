#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <DHT.h>

//--------------------- use relay -------------------------
const short int RELAY = 15; 
 
const char* ssid = "504elec";
const char* password = "504a504a";
const char* mqttServer = "192.168.0.27";
const int mqttPort = 1883;
const char* mqttUser = "Joo_act";
const char* mqttPassword = "hi";
const char* ESP_ID = "ESP8266_Act";
const String temp = String(ESP_ID) + "/" + String(mqttUser);
WiFiClient espClient;
PubSubClient client(espClient);

void setup() {
    Serial.begin(115200);
    pinMode(RELAY, OUTPUT);
    WiFi.begin(ssid, password);
    
    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.println("Connecting to WiFi..");
    }
    Serial.println("Connected to the WiFi network");

    client.setServer(mqttServer, mqttPort);
    client.setCallback(callback);
    
    while (!client.connected()) {
        Serial.println("Connecting to MQTT...");
        if (client.connect(ESP_ID, mqttUser, mqttPassword )) {
            Serial.println("connected");
        } 
        else {
            Serial.print("failed with state "); Serial.println(client.state());
            delay(2000);
        }
    } // end of while 
    client.subscribe((temp + "/cmd/lamp").c_str());
} // end of setup

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

void loop() {
    client.loop();
}
