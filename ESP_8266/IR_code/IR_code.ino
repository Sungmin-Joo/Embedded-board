#include <IRrecv.h>

int RECV_PIN = 02;//시그널 핀을 연결
int ledPin = 13;

IRrecv irrecv(RECV_PIN);
decode_results results;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  //IR 리시버 시작하기
  irrecv.enableIRIn();
  //LED
  pinMode(ledPin, OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  if(irrecv.decode(&results)){
    unsigned int ircode = results.value;
    Serial.println(ircode);
    irrecv.resume();//다음 데이터를 수신

    //LED 제어
    if(ircode == 542980295){ //LED 켜기
      digitalWrite(ledPin, HIGH);
    } else if (ircode == 542976215){ //LED 끄기
      digitalWrite(ledPin, LOW);
    }
  }
  delay(100);
}
