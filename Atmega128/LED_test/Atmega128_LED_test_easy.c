#include <mega128.h>
#include "delay.h"
#define byte unsigned char

void main()
{
    byte mode = 0;
    DDRB = 0xFF;
    DDRD = 0x00;
    PORTB = 0xFF;
    while(1)
    {
        if(PIND !=0xFF)
            mode = PIND;
        
        if(mode == 0xFE)
        {
            if(PORTB == 0xFF)
                PORTB = 0xFE;
            else
                PORTB = (PORTB << 1)|0x01;
            delay_ms(500);
        }
        else if(mode == 0xFD)
        {
            if(PORTB == 0xFF)
                PORTB = 0x7F;
            else
                PORTB = (PORTB >> 1)|0x80;
            delay_ms(500);
        }
        else if(mode == 0xFB)
        {
            PORTB = 0x00;
            delay_ms(500);
            PORTB = 0xFF;
            delay_ms(500);
        }
        else if(mode == 0xF7)
        {
            PORTB = 0xF0;
            delay_ms(500);
            PORTB = 0x0F;
            delay_ms(500);
            PORTB = 0xFF;      
        }        
    }
}