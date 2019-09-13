//#include <Wire.h>
//#include <OLED32.h>
#define Bright 0
int val;
char string[10];
//display(SDA, SCL)
//OLED display(4,5);

void setup() {
    Serial.begin(115200);
    //display.begin();
}
void loop() {     
    val = analogRead(Bright);
    Serial.println(val,DEC);
    Serial.println(String(val));
    //sprintf(string,"%4d",val);
    //display.print("Bright");
    //display.print("=",2,7);
    //display.print(string,3,10);
    delay(1000);
}
