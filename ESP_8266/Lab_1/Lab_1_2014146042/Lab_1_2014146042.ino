const short int RELAY = 15; 
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
