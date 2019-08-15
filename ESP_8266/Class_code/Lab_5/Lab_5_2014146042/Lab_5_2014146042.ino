const int trigPin = 13;
const int echoPin = 12;
const short int RELAY = 15; 
 
long duration;
float distance;
 
void setup(){
    pinMode(RELAY, OUTPUT);
    Serial.begin(115200);
    pinMode(trigPin, OUTPUT);
    pinMode(echoPin, INPUT);
    delay(200); 
}

void loop() {
    digitalWrite(trigPin, LOW);
    delayMicroseconds(2);
    digitalWrite(trigPin, HIGH);
    delayMicroseconds(10);
    digitalWrite(trigPin, LOW);
    duration = pulseIn(echoPin, HIGH);
    distance = duration * 0.017;
    if(distance < 15)
    {
        digitalWrite(RELAY, HIGH);
    }
    else
    {
        digitalWrite(RELAY, LOW);
    }
    delay(100);
}
