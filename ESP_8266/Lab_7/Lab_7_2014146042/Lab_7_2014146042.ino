#include <Wire.h>
#include <OLED32.h>
#include <DHT.h> 
#define             DHTTYPE DHT22
#define             DHTPIN  14
DHT                 dht(DHTPIN, DHTTYPE, 11);
char                dht_buffer[10];
char                en_buffer[10];
float               temp_f;
unsigned long       lastDHTReadMillis = 0;
#define             interval  2000   
const int           pulseA = 12;
const int           pulseB = 13;
const int           pushSW = 2;
volatile int        lastEncoded = 0;
volatile long       encoderValue = 0; 

OLED display(4,5);

void handleRotary() {        
    int MSB = digitalRead(pulseA); 
    int LSB = digitalRead(pulseB);

    int encoded = (MSB << 1) |LSB;
    int sum  = (lastEncoded << 2) | encoded;
    if(sum == 0b1101 || sum == 0b0100 || sum == 0b0010 || sum == 0b1011) encoderValue ++;
    if(sum == 0b1110 || sum == 0b0111 || sum == 0b0001 || sum == 0b1000) encoderValue --;
    lastEncoded = encoded;
    if (encoderValue > 255) {
        encoderValue = 255;
    } else if (encoderValue < 0 ) {
        encoderValue = 0;
    }
}
void buttonClicked() {
    Serial.println("pushed");
}
 
void setup() {
    Serial.begin(115200);
    display.begin();
    delay(500);
    pinMode(pushSW, INPUT_PULLUP);
    pinMode(pulseA, INPUT_PULLUP);
    pinMode(pulseB, INPUT_PULLUP);
    attachInterrupt(pushSW, buttonClicked, FALLING);
    attachInterrupt(pulseA, handleRotary, CHANGE);
    attachInterrupt(pulseB, handleRotary, CHANGE);
} 
void loop() {
    gettemperature();
    sprintf(dht_buffer,"%4.2f",temp_f);
    display.print("Current : ");
    display.print(dht_buffer,0,10);
    delay(100);
    sprintf(en_buffer,"%4d",map(encoderValue,0,255,10,40));
    display.print("Target :",3,3);
    display.print(en_buffer,3,9);
}
void gettemperature() {
    unsigned long currentMillis = millis(); 
    if(currentMillis - lastDHTReadMillis >= interval) {
        lastDHTReadMillis = currentMillis; 
        temp_f = dht.readTemperature();
        if (isnan(temp_f)){
            return;         
        }     
    } 
}
