/****************************************************************************

Проект:		Лаб. работа 1
Название:	Дискретные порты ввода-вывода
Файл:		lab1.c
Авторы:		Романов И.Л., Синяев. Н.С.
Описание:	Генерация требуемой анимации

****************************************************************************/
#include "aduc812.h"
#include "led.h"
#include "max.h"

static const unsigned char LAB_MAGIC = 0x77;
static const unsigned char ANIM_DELAY = 700;

/*
Generates delay of execution
INPUT:
	ms - delay length in milliseconds
*/
void delay ( unsigned long ms )
{
	volatile unsigned long i, j;

    for( j = 0; j < ms; j++ )
    {
        for( i = 0; i < 50; i++ );
    }
}


/*
Anim() logic explanation:
i   v           summand     
    00000000    00000011
1   00000011    00000011    v += summand
    00000011    00000110    summand <<= 1
    00000001                v >>= 1
    10000001                v += 0x80
2   10000111    00000110    v += summand
    10000111    00001100    summand <<= 1
    01000011    00001100    v >>= 1
    11000011    00001100    v += 0x80
    etc
*/
/*
Performs requested animation
*/
void anim( void ) {
    unsigned char v = 0x00;
    unsigned char summand = 0x03;
    unsigned char i = 0;
    
    for ( i = 0; i < 4; i++ ) {
        v += summand;
        summand <<=1;
        v >>=1;        
        v += 0x80;
        leds(v);
        delay(ANIM_DELAY);
    }
    
    for ( i = 0; i < 4; i++ ) {
        v -= summand;
        summand <<=1;
        v >>=1;        
        if (i != 3) {            
            v += 0x80;
        }
        leds(v);
        delay(ANIM_DELAY);
    }
}


void main( void )
{
    while( 1 )
    {
        unsigned char dip_value = read_max(EXT_LO);
        if ( LAB_MAGIC == dip_value )
        {
            anim();
        }
        else 
        {
            leds(dip_value);
        }
    }
}
