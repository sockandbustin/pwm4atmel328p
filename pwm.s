         ;GENERAL PURPOSE ACCUMULATOR 
         
         ;https://www.avrfreaks.net/forum/understanding-8-bit-timer-asm-code-atmega328
         
          .nolist
.include "m328Pdef.inc"
.list

#device ATmega328P

        .ORG 0000 
       SUB_ROUTINE: 
           SBI DDRB,0           ;SET PORTB0 FOR OUTPUT 
           LDI r16 ,0b01000010    ;ACTIVATE CTC MODE 
           OUT TCCR0A, r16         ;SET FLAG ON COMPARE MATCH 
           
           ;---The clock section bits are the last three bits in the TCCR1B register.
          LDI r16,0b00000101    ; fast blink time    
         
     
           ;  LDI r16,0b00000100    ;  makes blink EXTREMELY FAST      
         
           OUT TCCR0B,r16         ;SET PRESCALER TO /1024 
           
           ;- lets try editing compare value .. 
           LDI r16,255            ;OUR COMPARE VALUE 
           OUT OCR0A, r16          ;INTO THE COMPARE REGISTER 
           
           
       MAIN_LOOP: 
             SBI   PINB,0       ;FLIP THE 0 BIT 
             RCALL PAUSE        ;WAIT 
              RJMP MAIN_LOOP    ;GO BACK AND DO IT AGAIN 

       PAUSE:           
       PLUPE: IN    r16 ,TIFR0        ;WAIT FOR TIMER                
              ANDI  r16 ,0B00000100  ;(1<<OCF0A) 
              
               BREQ PLUPE 
              LDI  r16,0b00000100  ;CLEAR FLAG 
              OUT  TIFR0, r16        ;NOTE: WRITE A 1 (NOT 0) 
               RET 
               
               
               
               ; we were having problems with a bent pin? 
               ;that could be whats causing problems on that 1 microchip ? 