#include <mega128.h>
#include "delay.h"
#define byte unsigned char

void setup();
int detect_mode(int);


//------------------------  main source  ---------------------------
void main()
{
    int mode = 0;
    setup();
    while(1)
    {
        mode = detect_mode(mode);
        if(mode == 1)
        {
            if(PORTB == 0xFF)
                PORTB = 0xFE;
            else
                PORTB = (PORTB << 1)|0x01;
        }
        else if(mode == 2)
        {
            if(PORTB == 0xFF)
                PORTB = 0x7F;
            else
                PORTB = (PORTB >> 1)|0x80;
        }
        else if(mode == 3)
        {
            if(PORTB != 0xFF)
                PORTB = 0xFF;
            else
                PORTB = ~PORTB;
        }
        else if(mode == 4)
        {
            if(PORTB != 0xF0)
                PORTB = 0xF0;
            else
                PORTB = ~PORTB;
        }
        delay_ms(1000);
    }
}
//------------------------------------------------------------------

void setup()
{
    DDRB = 0xFF;
    DDRD = 0x00;
    PORTB = 0xFF;
}

int detect_mode(int temp)
{
    if(PIND != 0xFF)
    {
        if(PIND == 0xFE)
        {
            if(temp == 3 || temp == 4)
                PORTB = 0xFF;
            temp = 1;
        }
        else if(PIND == 0xFD)
        {
            if(temp == 3 || temp == 4)
                PORTB = 0xFF;
            temp = 2;
        }
        else if(PIND == 0xFB)
            temp = 3;
        else if(PIND == 0xF7)
            temp = 4;
        delay_ms(20);
        
        while(PIND != 0xFF);
        delay_ms(10);
    }
    return temp;
}