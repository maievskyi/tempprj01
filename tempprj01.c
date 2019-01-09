/*****************************************************
Можно использовать для тестирования Arduino на мигание
светодиодом и тактирование 16 мгц

This program was produced by the
CodeWizardAVR V2.05.3 Standard
Automatic Program Generator
© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 02.01.2019
Author  : PerTic@n
Company : If You Like This Software,Buy It
Comments:


Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 16,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega8.h>

#include <delay.h>

// Alphanumeric LCD functions
//#include <alcd.h>   // для LCD от CWision
#define Tstep 1000          //по достжению  (int Tcountint Tcount=Tstep) * время прерыв [TIM0_OVF] = время 1 сек
#define Testled PORTB.5     // тестовый св-диод на плате arduino

#define mks_after_com 4  //для обработки команд 4 ms Хотя даташ, требует задержку не менее 40мкс
#define mks_strobe    5   //задержку для стробирующего импульса, подбирается опытным путем,
						// 5 мкс было достаточной длительностью для данного LCD.

#define RS  PORTB.0
#define E   PORTB.1
#define D4  PORTD.4
#define D5  PORTD.5
#define D6  PORTD.6
#define D7  PORTD.7 //9877654321
int Tcount = 0;

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)  //прерывание по переполнению на 1 мс
{
//----------- Reinitialize Timer 0x06 value for the interrapt 1 ms
TCNT0=0x06;
// Place your code here
Tcount+=1;
if (Tcount == Tstep) {
Tcount = 0;                // обнуление для 1 секунды шага
 Testled^=1;               //инвертировать светодиод
};
//-----------------------------------------------------------------
}

unsigned char adc_data;
#define ADC_VREF_TYPE 0x60

// ADC interrupt service routine
interrupt [ADC_INT] void adc_isr(void)
{
// Read the 8 most significant bits
// of the AD conversion result
adc_data=ADCH;
}

// Read the 8 most significant bits
// of the AD conversion result
// with noise canceling
unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
#asm
    in   r30,mcucr
    cbr  r30,__sm_mask
    sbr  r30,__se_bit | __sm_adc_noise_red
    out  mcucr,r30
    sleep
    cbr  r30,__se_bit
    out  mcucr,r30
#endasm
return adc_data;
}
//void send_LCD(char RS_value,char DB4_value,char DB5_value,char DB6_value,char DB7_value) {
//int t;
//}
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
void lcd_dat(unsigned char x){     //111111111111>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
RS=1;  // ввод данные
E=1;  //есть стробимпульс
PORTD |=0x0F;       //обнул СТАРШ лин PORTD
PORTD |=(x & 0xF0); // запись ст пб в порт, младш лин PORTD не меняется
delay_us(40); 	    //   время 1-строб
E=0;  //нет стробимпульса (запись)
delay_us(40); 	    //   задежка после записи
E=1;  //есть стробимпульс
PORTD |=0x0F;       //опять обнул СТАРШ лин PORTD
PORTD |=(x << 4); // запись мл пб в старш лин порт, младш лин PORTD не меняется
delay_us(40); 	    //   время 1-строб
E=0;  //нет стробимпульса (запись)
delay_us(40); 	    //   задежка после записи
}
void lcd_com(unsigned char x){  //2222222222222222222>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
RS=0;  // ввод команды
E=1;  //есть стробимпульс
PORTD |=0x0F;       //обнул СТАРШ лин PORTD
PORTD |=(x & 0xF0); // запись ст пб в порт, младш лин PORTD не меняется
delay_us(40); 	    //   время 1-строб
E=0;  //нет стробимпульса (запись)
delay_us(40); 	    //   задежка после записи
E=1;  //есть стробимпульс
PORTD |=0x0F;       //опять обнул СТАРШ лин PORTD
PORTD |=(x << 4); // запись мл пб в старш лин порт, младш лин PORTD не меняется
delay_us(40); 	    //   время 1-строб
E=0;  //нет стробимпульса (запись)
delay_us(40); 	    //   задежка после записи
}
void lcd_init(void){ //3333333333333333333333333333>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
 /*Если кратко, то инициализация это последовательность команд
Команда №6 — 0x30 – установить режим 8 бит
Команда №6 — 0x28 – установить режим 4 бита
Команда №4 — 0x08 – выключить дисплей
Команда №1 — 0x01–  сброс дисплея
Команда №3 — 0x06–  при записи, курсор сдвигать вправо
Команда №4 — 0x0C – включить дисплей
*/
delay_ms(20); 	// сгенерируем задержку 20 мс
 // ----- команда №6 (установка разрядности) посылаем 0x30 на D4-D7 -----
 // send_LCD(0,1,1,0,0);              // RS=0, DB4=1, DB5=1, DB6=0, DB7=0
lcd_com(0x30);    // 8-bit reshim
//...............
RS=0;                                                           // ввод команды
E=1;                                                            //есть стробимпульс
PORTD |=0x0F;                                                   //обнул СТАРШ лин PORTD
PORTD |=(0x20 & 0xF0);                 // запись ст пб в порт, младш лин PORTD не меняется
delay_us(40); 	                                                //   время 1-строб
E=0;                                //нет стробимпульса (запись)
delay_us(40); 	                                                // задежка после записи
//......................................так как произошло перекл на 4 bit, то повтор ->
lcd_com(0x28);    // 4-bit reshim
lcd_com(0x08);    // полное выключение дисплея, курс не видн, не мигает
lcd_com(0x01);    // очистка дисплея
lcd_com(0x06);    // реж сдвига курсора вправо, без сдв экр-на
lcd_com(0x0C);    // включение дисплея, курс не видн, не мигает
}    // end LCD_INIT
//...............................................................................
// Declare your global variables here
//char Fled = 0; // флаг для свтда
//char Foldled = 0; // флаг для свтда

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=Out
// State7=T State6=T State5=T State4=T State3=T State2=P State1=0 State0=0
// Func7=In Func6=In Func5=Out Func4=In Func3=In Func2=In Func1=Out Func0=Out
// State7=T State6=T State5=0 State4=T State3=T State2=P State1=0 State0=0
PORTB=0x04;
DDRB=0x23;//DDRB=0x03;

// Port C initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State6=P State5=P State4=P State3=P State2=P State1=P State0=T
PORTC=0x7E;
DDRC=0x00;

// Port D initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
// State7=0 State6=0 State5=0 State4=0 State3=P State2=P State1=P State0=P
PORTD=0x0F;
DDRD=0xF0;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 250,000 kHz
TCCR0=0x03;
TCNT0=0x06;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x01;

// USART initialization
// USART disabled
UCSRB=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 125,000 kHz
// ADC Voltage Reference: AVCC pin
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x8F;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTB Bit 0
// RD - PORTB Bit 3
// EN - PORTB Bit 1
// D4 - PORTD Bit 4
// D5 - PORTD Bit 5
// D6 - PORTD Bit 6
// D7 - PORTD Bit 7
// Characters/line: 16
//lcd_init(16);      //врем откл т к переключало самостоятельно порты (В5)?

// Global enable interrupts
#asm("sei")

while (1)
      {
      // Place your code here
      #asm("cli")		// запретим прерывания
		delay_us(150); 	// сгенерируем задержку 150 мкс
		//...
		delay_ms(15); 	// сгенерируем задержку 15 мс
		#asm("sei")		// разрешим прерывания



      }
}
