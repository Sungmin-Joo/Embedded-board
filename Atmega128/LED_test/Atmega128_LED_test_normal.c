#include <mega128.h>
#include "delay.h"
#define byte unsigned char
#define check PIND ==0xFE || PIND ==0xFD || PIND ==0xFB || PIND ==0xF7
void main()
{
    byte mode = 0;
    DDRB = 0xFF;
    DDRD = 0x00;
    PORTB = 0xFF;
    
    while(1)
    {
        if(check)
        {
            mode = PIND;
            break;
        }
    }
    
    while(1)
    {
        if(mode == 0xFE)
        {
            PORTB = 0xFE;
            while(1)
            {
                if(PORTB == 0xFF)
                    PORTB = 0xFE;
                delay_ms(500);
                PORTB = (PORTB << 1)|0x01;
                if(check)
                {
                    mode = PIND;
                    break;
                }
            }
        }
        else if(mode == 0xFD)
        {
            PORTB = 0x7F;
            while(1)
            {
                if(PORTB == 0xFF)
                    PORTB = 0x7F;
                delay_ms(500);
                PORTB = (PORTB >> 1)|0x80;
                if(check)
                {
                    mode = PIND;
                    break;
                }
            }
        }
        else if(mode == 0xFB)
        {
            while(1)
            {
                PORTB = 0x00;
                delay_ms(500);
                PORTB = 0xFF;
                delay_ms(500);
                if(check)
                {
                    mode = PIND;
                    break;
                }
            }
        }
        else if(mode == 0xF7)
        {
            while(1)
            {
                PORTB = 0xF0;
                delay_ms(500);
                PORTB = 0x0F;
                delay_ms(500);
                PORTB = 0xFF;
                if(check)
                {
                    mode = PIND;
                    break;
                }      
            }
        }
    }        
}