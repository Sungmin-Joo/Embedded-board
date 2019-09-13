const short int RELAY = 15;
const short int KEY = 0; 
void setup() {
    pinMode(RELAY, OUTPUT);
    pinMode(KEY, INPUT);
    
    Serial.begin(115200);
    Serial.println("Starting"); 
}
void loop() {
    if(digitalRead(KEY)){
        digitalWrite(RELAY, HIGH);
        Serial.println("Relay on");            
    } else {
        digitalWrite(RELAY, LOW);
        Serial.println("Relay off");
    }
   delay(300);
    
}
