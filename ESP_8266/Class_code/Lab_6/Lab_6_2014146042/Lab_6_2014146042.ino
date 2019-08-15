#include <Wire.h>
#include <SparkFun_APDS9960.h>
SparkFun_APDS9960 apds = SparkFun_APDS9960();

const short int RELAY = 15; 
int isr_flag = 0; 

void setup() {
    pinMode(RELAY, OUTPUT);
    Serial.begin(115200);
    Serial.println("Starting APDS-9960 Gesture");
    if ( apds.init() ){
        Serial.println(F("APDS-9960 initialization complete"));
    } else {         
        Serial.println(F("Something went wrong during APDS-9960 init!"));
    }          
    if ( apds.enableGestureSensor(true) ){
        Serial.println(F("Gesture sensor is now running"));
    } else {
        Serial.println(F("Something went wrong during gesture sensor init!"));
    }    
}

void loop() {
    handleGesture();
}

void handleGesture() {
    if ( apds.isGestureAvailable() ) {
        switch ( apds.readGesture() ) {
            case DIR_UP:
                digitalWrite(RELAY, HIGH);
                break;
            case DIR_DOWN:
                digitalWrite(RELAY, LOW);
                break;
            default:
                Serial.println("NONE");
        }
    }
}
