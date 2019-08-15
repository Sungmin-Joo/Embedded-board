#include <mega128.h>
#include <delay.h>
#include "lcd.h"

#define FND_Null        17
#define FND_Star        14
#define FND_Sharp       15
#define M1              10
#define M2              11
#define M3              12
#define M4              13

#define Do 1908 // 262Hz (3817us) 1908us 
#define Re 1700 // 294Hz (3401us) 1701us 
#define Mi 1515 // 330Hz (3030us) 1515us 
#define Fa 1432 // 349Hz (2865us) 1433us 
#define Sol 1275 // 370Hz (2703us) 1351us 
#define La 1136 // 440Hz (2273us) 1136us 
#define Si 1012 // 494Hz (2024us) 1012us
#define HDo 956

unsigned char str_date[17] = " 2018-12-30";
unsigned char str_time[17] = "    23:59 50";
unsigned char str_alarm_menu1[17] = "Alarm setting!";
unsigned char str_alarm_menu2[17] = "Alarm num : ";
unsigned char str_emty1[17] = "     -  -  ";
unsigned char str_emty2[17] = "      :     ";
unsigned char str_alarm1[3][17] = {" 0000-00-00", " 0000-00-00", " 0000-00-00"};
unsigned char str_alarm2[3][17] = {"    00:00 00", "    00:00 00", "    00:00 00"};
unsigned char data;

int set_count = 0;
int cnt = 0;
bit zero_flag = 0;
bit mod = 0;
int setting_count = 0;
bit time_set_flag = 0;

int sec = 0;
int min = 0;
int hr = 0;
int day = 0;
int month = 0;
int year = 0;

void Init_Reg(void)
{
    DDRG |= 1<<PORTG4;
    DDRC = 0x0f;            // 상위 4bit Col(입력), 하위 4bit Row(출력)
    PORTC = 0x0f;           //Port 초기화       
}

void myDelay_us(unsigned int delay)
{
    int i;
    for(i=0; i<delay; i++)
    {
        delay_us(1);
    }
}
void SSound(int time)
{
    int i, tim;
    tim = 50000/time;
    for(i=0; i<tim; i++) // 음계마다 같은 시간 동안 울리도록 time 변수 사용
    {
        PORTG |= 1<<PORTG4; //부저ON, PORTG의 4번 핀 ON(out 1)
        myDelay_us(time);
        PORTG &= ~(1<<PORTG4);  //부저OFF, PORTG의 4번 핀 OFF(out 0)
        myDelay_us(time);
    }
}

void Init_Timer0(void)
{
    TIMSK = (1<<OCIE0); // 1. 출력 비교 인터럽트 허가
    TCCR0 |= (1<<WGM01) | (1<<CS01); // 2. TCCR0 레지스터 CTC 모드 설정
    OCR0 = 100; // 2. 50us마다 출력 비교를 한다.
    SREG |= 0x80; // 3. 인터럽트 동작 시작(전체 인터럽트 허가 선택)
}


// 50us마다 인터럽트 비교 일치 인터럽트가 발생
interrupt [TIM0_COMP] void timer0_out_comp(void)
{
    cnt++; // 인터럽트 횟수 증가
    // 50us의 인터럽트를 20000번 계수시키면 1초에 가까운 시간이 만들어진다.
    if(cnt == 20000) // 50us * 20000 = 1sec
    {
        cnt = 0;
        if(!time_set_flag)
        {
            sec = str_time[11] - 0x30;
            sec += (str_time[10]  - 0x30)*10;
            
            min = str_time[8] - 0x30;
            min += (str_time[7]  - 0x30)*10;

            hr = str_time[5] - 0x30;
            hr += (str_time[4]  - 0x30)*10;            
            
            day = str_date[10] - 0x30;
            day += (str_date[9]  - 0x30)*10;
            
            month = str_date[7] - 0x30;
            month += (str_date[6]  - 0x30)*10;
            
            year = str_date[4] - 0x30;
            year += (str_date[3]  - 0x30)*10;
            year += (str_date[2]  - 0x30)*100;
            year += (str_date[1]  - 0x30)*1000;
             
            if(sec >= 59)
            {
                 sec = 0;
                 if(min >= 59)
                 {
                    min = 0;
                    if(hr >= 23)
                    {
                        hr = 0;
                        if(day >= 30)
                        {
                            day = 1;
                            if(month >= 12)
                            {
                                month = 1;
                                year++;
                            }
                            else
                            {
                                month++;
                            }
                        }
                        else
                        {
                            day++;
                        }
                    }
                    else
                    {
                        hr++;
                    }
                 }
                 else
                 {
                    min++;
                 }                 
            }
            else
            {
                 sec++;
            }
            
            
            
            str_time[11] = (sec % 10) + 0x30;
            str_time[10] = (sec / 10) + 0x30;
            str_time[8] = (min % 10) + 0x30;
            str_time[7] = (min / 10) + 0x30;
            str_time[5] = (hr % 10) + 0x30;
            str_time[4] = (hr / 10) + 0x30;
            
            str_date[10] = (day % 10) + 0x30;
            str_date[9] = (day / 10) + 0x30;
            str_date[7] = (month % 10) + 0x30;
            str_date[6] = (month / 10) + 0x30;
            str_date[4] = (year % 10) + 0x30;
            str_date[3] = ((year / 10) % 10) + 0x30;
            str_date[2] = ((year / 100) % 10) + 0x30;
            str_date[1] = (year / 1000) + 0x30;
             
        }
    }
}


unsigned char KeyScan(void)                     
{
    unsigned int Key_Scan_Line_Sel = 0xf7;            
    unsigned char Key_Scan_sel=0, key_scan_num=0;         
    unsigned char Get_Key_Data=0, key_Num = 0;                  
      
    for(Key_Scan_sel=0; Key_Scan_sel<4; Key_Scan_sel++)     
    {            
          PORTC = Key_Scan_Line_Sel;               
          delay_us(10);                                
          Get_Key_Data = (PINC & 0xf0);      
            
          if(Get_Key_Data != 0x00)
          {                  
                switch(Get_Key_Data)                   
                {
                      case 0x10:            
                            key_scan_num = Key_Scan_sel*4 + 1;                
                            break;                
                      case 0x20:           
                            key_scan_num = Key_Scan_sel*4 + 2;                
                            break;                
                      case 0x40:                     
                            key_scan_num = Key_Scan_sel*4 + 3;                
                            break;                
                      case 0x80:                                                    
                            key_scan_num = Key_Scan_sel*4 + 4;                 
                            break;
                      default :
                            key_scan_num = FND_Null; 
                            break;                
                }
                if(key_scan_num != FND_Null)
                {
                    if(key_scan_num%4 != 0)
                    {
                        key_Num = (key_scan_num/4)*3+(key_scan_num%4);
                        if(key_Num >= 10)
                        {
                            switch(key_Num)
                            {
                                case 10 :
                                    key_Num = FND_Star;
                                    break;
                                case 11 :
                                    key_Num = 0;
                                    break; 
                                case 12 :
                                    key_Num = FND_Sharp;
                                    break;
                                default :
                                    break;
                            }
                        }
                    }
                    else
                    key_Num = (key_scan_num/4)+9;  
                }
                zero_flag = 1;           
                return key_Num;       
          }             
          Key_Scan_Line_Sel = (Key_Scan_Line_Sel>>1);     
    }    
    return key_scan_num;         
}

interrupt [TIM0_OVF] void timer0_overflow(void)
{
    
}

void BBIC()
{         
    SSound(Do);
    delay_ms(100);
}

void print_time()
{
    char conv = 0;
    LCD_Pos(0,0);   // LCD의 위치 1, 라인 1 지정
    LCD_Str(str_date);  // 문자열 str을 LCD 출력

    if(mod)
    {
        LCD_Pos(1,0);   // LCD의 위치 1, 라인 1 지정
        LCD_Str(str_time);  // 문자열 str을 LCD 출력
    }
    else
    {
        LCD_Pos(1,1);
        conv = (str_time[4] - 0x30)*10 + (str_time[5] - 0x30);
        if(conv < 12)
        {
            LCD_Str("AM");    
        }
        else
        {
            LCD_Str("PM");
            if(conv != 12)
                conv -= 12;

        } 
        LCD_Pos(1,4);LCD_Char((conv / 10) + 0x30);
        LCD_Pos(1,5);LCD_Char((conv % 10) + 0x30);
        LCD_Pos(1,6);LCD_Char(':'); 
        LCD_Pos(1,7);LCD_Char(str_time[7]);
        LCD_Pos(1,8);LCD_Char(str_time[8]);
        LCD_Pos(1,10);LCD_Char(str_time[10]);
        LCD_Pos(1,11);LCD_Char(str_time[11]);
    } 
}

void Time_set()
{
    LCD_Clear();
    LCD_Pos(0,0);   // LCD의 위치 1, 라인 1 지정
    LCD_Str(str_date);  // 문자열 str을 LCD 출력 
    LCD_Pos(1,0);   // LCD의 위치 1, 라인 1 지정
    LCD_Str(str_time);  // 문자열 str을 LCD 출력
    delay_ms(100);
    LCD_Comm(0x0f);
    LCD_Delay(2);
    set_count = 1;
    while(1)
    {
        //print_time();
        zero_flag = 0;
        LCD_Pos(0,set_count);
        //LCD_Char(' ');
        data = KeyScan();
        if((data >= 0 && zero_flag) && data <= 9)
        {
            BBIC();
            zero_flag = 0;
            delay_ms(80);
            str_date[set_count++] = data + 0x30;
            LCD_Char(data + 0x30);
            if(set_count == 5)
                set_count++;
            else if(set_count == 8)
                set_count++;
            else if(set_count >= 11)
                break;                     
        } 
    }
    
    set_count = 4;
    
    while(1)
    {
        //print_time();
        zero_flag = 0;
        LCD_Pos(1,set_count);
        //LCD_Char(' ');
        data = KeyScan();
        if((data >= 0 && zero_flag) && data <= 9)
        {
            BBIC();
            zero_flag = 0;
            delay_ms(80);
            str_time[set_count++] = data + 0x30;
            LCD_Char(data + 0x30);
            if(set_count == 6)
                set_count++;
            else if(set_count == 9)
                set_count++;
            else if(set_count >= 12)
                break;                      
        } 
    }  
    LCD_Comm(0b00001100);
    LCD_Delay(2);
            
}

void Alram_set(void)
{
    if(setting_count >= 3)
    {
        LCD_Clear();
        LCD_Pos(0,0);
        LCD_Str("Full alarm!");
        LCD_Pos(1,0);
        LCD_Str("Reboot please!");
        delay_ms(1500);
        LCD_Clear();
    }
    else
    {
        LCD_Clear();
        LCD_Pos(0,0);
        LCD_Str(str_alarm_menu1);
        LCD_Pos(1,0);
        LCD_Str(str_alarm_menu2);
        LCD_Char(setting_count + 0x30);
        delay_ms(1500);
        LCD_Clear();
        LCD_Pos(0,0);
        LCD_Str(str_emty1);
        LCD_Pos(1,0);
        LCD_Str(str_emty2);
        
        
        LCD_Comm(0x0f);
        LCD_Delay(2);
        set_count = 1;
        while(1)
        {
            zero_flag = 0;
            LCD_Pos(0,set_count);
            data = KeyScan();
            if((data >= 0 && zero_flag) && data <= 9)
            {
                BBIC();
                zero_flag = 0;
                delay_ms(80);
                str_alarm1[setting_count][set_count++] = data + 0x30;
                LCD_Char(data + 0x30);
                if(set_count == 5)
                    set_count++;
                else if(set_count == 8)
                    set_count++;
                else if(set_count >= 11)
                    break;                     
            } 
        }
        
        set_count = 4;
        
        while(1)
        {
            zero_flag = 0;
            LCD_Pos(1,set_count);
            data = KeyScan();
            if((data >= 0 && zero_flag) && data <= 9)
            {
                BBIC();
                zero_flag = 0;
                delay_ms(80);
                str_alarm2[setting_count][set_count++] = data + 0x30;
                LCD_Char(data + 0x30);
                if(set_count == 6)
                    set_count++;
                else if(set_count == 9)
                    set_count++;
                else if(set_count >= 12)
                    break;                      
            } 
        }  
        LCD_Comm(0b00001100);
        LCD_Delay(2);
        setting_count++;
    }

}

void Alram_on(void)
{
    LCD_Clear();    
    while(1)
    {
        LCD_Pos(0,0);
        LCD_Str("Alarm!! Alarm!!");
        LCD_Pos(1,0);
        LCD_Str("Press Key!!");
        SSound(Do);
        delay_ms(300);
        
        LCD_Clear();
        data = KeyScan();
        if(data)
            break;
            
        SSound(Mi);
        delay_ms(300);
        
        data = KeyScan();
        if(data)
            break;
    }
}

void Alram_check(void)
{
    int i, j, flag = 1;
    for(i = 0; i < 3; i++)
    {
        for(j = 0; j < 17; j++)
        {
            if(str_date[j] != str_alarm1[i][j])
            {
                flag = 0;
                break;
            }
            else if(str_time[j] != str_alarm2[i][j])
            {
                flag = 0;
                break;   
            }
        }
        if(flag)
        {
            Alram_on();
            setting_count--;
        }
        flag = 1;
    }
       
}

void main(void)
{
    LCD_Init();     //LCD 초기화
    Init_Timer0();
    LCD_Clear();
    //이거 Init_Reg가 위에가면 안됨 LCD_Init()에서 DDRG를 건드림 스바련이.
    Init_Reg();

    while(1)
    {
        data = KeyScan();
        print_time();         
        Alram_check();
        if(data == M2)
        {
            BBIC();
            Alram_set();
        }
        else if(data == M1)
        {
            BBIC();
            time_set_flag = 1;
            Time_set();
            time_set_flag = 0;
        }
        else if(data == M3)
        {
            BBIC();
            mod = ~mod;
            delay_ms(100);
        }
    }
    
}