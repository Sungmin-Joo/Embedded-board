# Embedded-board
Control Atmega128, ESP8266, Achro-I.MX6Q//201809~201905  


 대학교 수업에서 제어했던 임베디드 보드에 관한 자료들을 정리  
  

  

 ## 간단한 보드별 프로젝트 설명 
 
* ### Achro-I.MX6Q  

  -  운영체제를 탑재한 쿼드코어 고성능 임베디드 보드  
     자세한 스펙은 [보드 정보](http://huins.com/m13.php?m=rd&no=330)에서 확인 가능  
  
  -  디바이스 드라이버 제작 + Character File 제어를 통한 Kernel Programming을 연습  
  
  -  학기 프로젝트로는 C Socket 모듈을 사용하여 Server, Client를 따로 구성 두 대의 Achro-I.MX6Q 사용.  
     -> Server, Client모두 직접 프로그래밍  
  
  
* ### Atmega128  

  -  전자공학과 임베디드 전공과정을 밟으면서 가장 먼저 실습했던 MCU  
     교육용으로 만들어진 키트로 학습했기 때문에 타이머, 내,외부 인터럽트등이 내장되어있고 I2C, Serial, U(S)ART 통신을 쉽게 사용 가능    
     
  -  "랜덤게임", "스마트 커튼" 두 개의 프로젝트로 1년 동안 Atmega128을 제어  
    

 
* ### ESP_8266  

  -  와이파이를 지원하는 NodeMCU 
  
  -  Arduino IDE에서 개발  
  
  -  NodeRED + Cloud_Computing을 통해 IoT환경을 구현해보는 실습을 주로 함  
  
  -  InfluxDB와 Grafana + Docker + ESP8266 조합으로 Smart Home Environment



 ## 정보

 주성민(Joo Sung Min) – big-joo_dev@naver.com
