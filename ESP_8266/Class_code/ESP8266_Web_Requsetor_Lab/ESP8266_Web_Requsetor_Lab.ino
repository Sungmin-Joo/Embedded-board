#include <ESP8266WiFi.h> 
#include <ESP8266HTTPClient.h> 

char ssid[] = "SSID";
char password[] = "Password";
 
HTTPClient http;
 
void setup() {  
    Serial.begin(115200);   
    WiFi.mode(WIFI_STA); 
    WiFi.begin(ssid, password);    
    while (WiFi.status() != WL_CONNECTED) {     
        delay(500);    
        Serial.print(".");    
    }
    
    Serial.println("");   
    Serial.print("Connected to "); 
    Serial.println(ssid);   
    Serial.print("IP address: ");
    Serial.println(WiFi.localIP()); 
    http.begin("http://influx:8086/write?db=mydb");
}

void loop() {     
    http.addHeader("Content-Type", "text/plain");
    int httpCode = http.POST("cpu,host=server01,region=us-west value=0.66"); 
    String payload = http.getString(); 
    Serial.println(httpCode);   
    Serial.println(payload);  
    http.end();    
    
    delay(10000); 
} 
