const short int LED1 = 2;

void setup() {
  // put your setup code here, to run once:
  pinMode(LED1, OUTPUT);
}

void loop() {
  digitalWrite(LED1, HIGH);   // LED 를 켭니다. (HIGH 는 전압을 의미합니다.)
  delay(100);                       // 1초동안 대기합니다.
  digitalWrite(LED1, LOW);    // 전압을 LOW 로 설정하여 LED 를 끕니다.
  delay(100);                       // 1초동안 대기합니다.
}
