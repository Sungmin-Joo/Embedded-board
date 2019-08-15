//----------- 적외선 리시버 관련 헤더 ----------
#include <IRrecv.h>
#define r_1 16724175
#define r_2 16718055
#define r_3 16743045
#define r_up 16769565
#define r_down 16753245
#define r_plus 16754775
#define r_minus 16769055
#define r_init 16748655

//----------- OLED관련 헤더 ----------
#include <Wire.h>
#include <OLED32.h>

//----------- 적외선 리시버 관련 변수들 ----------
int RECV_PIN = 02;//시그널 핀을 연결
int ledPin = 15;
IRrecv irrecv(RECV_PIN);
decode_results results;

//---------- OLED관련 변수 ---------
OLED display(4,5); //여기서 안하면 오류나더라..
unsigned int ir;
unsigned char flag = 1;
bool init_mode = true;

void setup() {
    Serial.begin(115200);
    //---------- OLED관련 설정 ---------
    display.begin();
    display.off();
    delay(500);
    display.on();
    delay(500);
    //---------- 적외선 리시버 관련 설정 ---------
    //IR 리시버 시작하기
    irrecv.enableIRIn();
    //릴레이
    pinMode(ledPin, OUTPUT);
}

void loop() {
    // 적외선 수신기 코드
    if(irrecv.decode(&results)){
        ir_mapping(ir_receive());
    }
    delay(10);
    // OLED 코드
    OLED_State();
}

void OLED_State(){
    if(init_mode)
    {
        display.print("Smart home",0,3);
        display.print(" Home condition", 1,1);
        display.print(" Set temper", 2,1);
        display.print(" Button info", 3,1);
        display.print("o",flag,0);
    }
}
unsigned int ir_receive(){
    unsigned int ircode = results.value;
    if(ircode /100000000 == 0)
    {
        Serial.println(ircode);
    }
    irrecv.resume();//다음 데이터를 수신

        //LED 제어
        /*
        if(ircode == r_1){ //LED 켜기
            digitalWrite(ledPin, HIGH);
        } else if (ircode == r_2){ //LED 끄기
            digitalWrite(ledPin, LOW);
        }
        */
    return ircode;
}

void ir_mapping(unsigned int ir){
    if(ir == r_init)
        init_mode = true;
    else if(ir == r_up){
        if(init_mode)
            display.print(" ",flag,0);
        if(flag >= 3)
            flag = 1;
        else
            flag++;        
    }
    else if(ir == r_down){
        if(init_mode)
            display.print(" ",flag,0);
        if(flag <= 1)
            flag = 3;
        else
            flag--;        
    }
}
