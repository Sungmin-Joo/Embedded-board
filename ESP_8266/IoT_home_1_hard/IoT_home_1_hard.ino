#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
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
// will store last temp was read


//--------------------- use in bright --------------------
#define Bright 0
int bright;


//--------------------- use in wifi --------------------
char ssid[] = "KPU_WiFi1159";
//char password[] = "Password";


HTTPClient http;
void setup() {
    Serial.begin(115200);
    WiFi.mode(WIFI_STA); 
    //WiFi.begin(ssid, password); 
    WiFi.begin(ssid); 
    while (WiFi.status() != WL_CONNECTED) {  
        delay(500);    
        Serial.print(".");  
    }   
    Serial.println("");   
    Serial.print("Connected to ");
    Serial.println(ssid);    
    Serial.print("IP address: "); 
    Serial.println(WiFi.localIP()); 
    http.begin("http://192.168.35.218:8086/write?db=mydb");
}

void loop() {
    String str = "smart,host=Joo,region=TIP-1159 ";
         
    check_temp_and_hu();
    str += "temper=" + String(temp_f) + ",humid=" + String(humidity);
    
    check_bright();
    str += ",bright=" + String(bright);
    
    http.addHeader("Content-Type", "text/plain");
    int httpCode = http.POST(str);
    String payload = http.getString();    
    Serial.println(httpCode);   
    Serial.println(payload);  
    http.end();   
    delay(60000);
}

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

void check_bright() {
    bright = analogRead(Bright);
    Serial.print("Bright : ");
    Serial.println(bright,DEC);
    delay(100);
}
