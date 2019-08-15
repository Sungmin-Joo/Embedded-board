#include <Wire.h>
#include <OLED32.h>
#include <DHT.h> 
#define             DHTTYPE DHT22
#define             DHTPIN  14
DHT                 dht(DHTPIN, DHTTYPE, 11);
char                dht_buffer[10];
float               humidity;
float               temp_f;
unsigned long       lastDHTReadMillis = 0;
#define             interval  2000    

int val;
char string[10];
//display(SDA, SCL)
OLED display(4,5);

void setup() {
    Serial.begin(115200);
    display.begin();
    delay(500);
    Serial.println("starting"); 
}
void loop() {
    gettemperature();
    Serial.print("Temperature : ");
    Serial.print(temp_f);
    sprintf(dht_buffer,"%4.2f",temp_f);
    display.print("Temp :");
    display.print(dht_buffer,1,9);
    Serial.print(", Humidity : ");
    Serial.println(humidity);
    sprintf(dht_buffer,"%5.2f",humidity);
    display.print("Hum :",2);
    display.print(dht_buffer,3,9);
    delay(100); 
    //display.print(string,3,10);
}

void gettemperature() {
    unsigned long currentMillis = millis(); 
    if(currentMillis - lastDHTReadMillis >= interval) {
        lastDHTReadMillis = currentMillis; 
        humidity = dht.readHumidity();
        temp_f = dht.readTemperature();
        if (isnan(humidity) || isnan(temp_f)){
            return;         
        }     
    } 
}
