const short int RELAY = 15; 
const short int SW0 = 0;
void setup() {
    pinMode(SW0, INPUT_PULLUP);
    pinMode(RELAY, OUTPUT);
    Serial.begin(115200);
    Serial.println("Starting"); 
}
void loop() {  
    if (digitalRead(SW0) == LOW){
        digitalWrite(RELAY, HIGH);
        Serial.println("Relay on");
    }
    else{    
        digitalWrite(RELAY, LOW);
        Serial.println("Relay off");
    }
    
}
/*
void setup() {
    pinMode(RELAY, OUTPUT);
    Serial.begin(115200);
    Serial.println("Starting"); 
}
void loop() {     
    int val;
    val = analogRead(0);     
    Serial.println(val,DEC);
    delay(100);
    if (val < 200) {
        digitalWrite(RELAY, HIGH);
        Serial.println("Relay on");     
    }else {         
        digitalWrite(RELAY, LOW);
        Serial.println("Relay off");
    }delay(300);
    
}
*/
