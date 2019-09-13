// yield()
const int SW = 2;
int ping = 0; 
void setup() {
    Serial.begin(115200);
    delay(100);
    Serial.println("Booting");
    attachInterrupt(SW, buttonPushed, FALLING);
}
void loop() {
    int i = 0;
    for(;;)
    {       
        i++;
        //yield();
        delay(1);
    }
}
void buttonPushed() {    
    Serial.println("still alive");
    }
