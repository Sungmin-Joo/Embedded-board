#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <DHT.h>

//--------------------- use in temp, hu --------------------
#define             DHTTYPE DHT22
#define             interval  2000
// DHT22 is attached to GPIO14 on this Kit
#define             DHTPIN  14
DHT                 dht(DHTPIN, DHTTYPE, 11);
char                dht_buffer[10];
float               humidity;
float               temp_f;
unsigned long       lastDHTReadMillis = 0;


//--------------------- use in bright --------------------
#define Bright 0
int bright;
 
const char* ssid = "504elec";
const char* password = "504a504a";
const char* mqttServer = "192.168.0.27";
const int mqttPort = 1883;
const char* mqttUser = "Joo";
const char* mqttPassword = "hi";
const char* ESP_ID = "ESP8266_Sensor";
const String temp = String(ESP_ID) + "/" + String(mqttUser) + "/evt";
WiFiClient espClient;
PubSubClient client(espClient);

void setup() {
    Serial.begin(115200);
    WiFi.begin(ssid, password);
    
    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.println("Connecting to WiFi..");
    }
    Serial.println("Connected to the WiFi network");

    client.setServer(mqttServer, mqttPort);
    //client.setCallback(callback);
    
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
    client.publish(temp.c_str(),"Hello from ESP8266");
    //client.subscribe("ESP8266_Sensor/Joo/evt/#");
} // end of setup

void loop() {
    client.loop();
         
    check_temp_and_hu();
    client.publish((temp + "/temperature").c_str(), String(temp_f).c_str());
    delay(50);
    client.publish((temp + "/humidity").c_str(), String(humidity).c_str());
    delay(50);
    check_bright();
    client.publish((temp + "/light").c_str(), String(bright).c_str());
    delay(5000);
}

//check temperature and humidity
void check_temp_and_hu(){
    gettemperature();
    Serial.print("Temperature : ");
    Serial.print(temp_f);
    Serial.print(", Humidity : ");
    Serial.println(humidity);
    delay(100);
}

void gettemperature() {
    unsigned long currentMillis = millis();
    if(currentMillis - lastDHTReadMillis >= interval) { 
        lastDHTReadMillis = currentMillis;
        humidity = dht.readHumidity();
        // Read humidity (percent)
        temp_f = dht.readTemperature();
        // Read temperature as Fahrenheit
        // Check if any reads failed and exit early (to try again).
        if (isnan(humidity) || isnan(temp_f)) {
            return;         
        }    
    } 
}

//check bright
void check_bright() {
    bright = analogRead(Bright);
    Serial.print("Bright : ");
    Serial.println(bright,DEC);
    delay(100);
}
