#include <DHT.h>
#define             DHTTYPE DHT22
// DHT22 is attached to GPIO14 on this Kit
#define             DHTPIN  14
DHT                 dht(DHTPIN, DHTTYPE, 11);
char                dht_buffer[10];
float               humidity;
float               temp_f;
unsigned long       lastDHTReadMillis = 0;
// will store last temp was read
#define             interval  2000

void setup(){     
    Serial.begin(115200);
    delay(500);
    Serial.println("starting");
}

void loop() {
    String str; 
    gettemperature();
    Serial.print("Temperature : ");
    Serial.print(temp_f);
    Serial.print(", Humidity : ");
    Serial.println(humidity);
    Serial.println("------------------------------");
    str = String(temp_f) + ' ' + String(humidity);
    Serial.println(str);
    Serial.println("------------------------------");
    delay(1000);
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
