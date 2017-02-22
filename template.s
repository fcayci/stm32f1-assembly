@ STM32F107 - Assembly template
@ Turns on GPIOD Pin 1

@ Start with enabling thumb 32 mode since Cortex-M3 do not work with arm mode
@ Unified syntax is used to enable good of the both words...
@ Make sure to run arm-none-eabi-objdump.exe -d prj1.elf to check if
@ the assembler used proper insturctions. (Like ADDS)

	.thumb
	.syntax unified

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Definitions
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Definitions section. Define all the registers and
@ constants here for code readability.
@ Constants
@ Keep the STACKINIT variable.
	.equ     STACKINIT,   0x20008000
	.equ     DELAY,       80000

@ Register Addresses
@ You can find the base addresses for all the peripherals from Memory Map section
@ RM0008 on page 49. Then the offsets can be found on their relevant sections.
@ As shown in GPIOD_ODR register
	.equ     RCC_APB2ENR,   0x40021018      @ enable clock
	.equ     GPIOD_CRL,     0x40011400      @ PORTD control register low
	.equ     GPIOD_ODR,     0x4001140C      @ PORTD output data (Page 172 from RM0008)

.section .text
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Vectors
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Vector table start
	.word    STACKINIT
	.word    _start + 1

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Main code starts from here
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

_start:
	@ Enable GPIOD Peripheral Clock (Page 145 from RM0008)
	LDR R6, = RCC_APB2ENR  @ Load peripheral clock enable regiser
	LDR R5, [R6]           @ Read its content
	ORR R5, 0x00000020     @ Set Bit 5 to enable GPIOD clock
	STR R5, [R6]           @ Store back the result in Perihperal clock enable register

	@ Make GIOOD Pin1 as output pin (Page 170 from RM0008)
	LDR R6, = GPIOD_CRL    @ Load GPIOD control register low  (Pin1 is in CRL register)
	LDR R5, = 0x00000020   @ Set MODE bits to 10 and CNF bits to 00, thus 0x00000020
	STR R5, [R6]           @ Store back the result in GPIOD control register low

	@ Set GIOOD Pin1 to 1 (Page 172 from RM0008)
	LDR R6, = GPIOD_ODR    @ Load GPIOD output data register
	LDR R5, = 0x00000002   @ Set Pin 1 to 1
	STR R5, [R6]           @ Store back the result in GPIOD output data register

loop:
	NOP                    @ No operation. Do nothing. Just stay in the loop forever.
	B loop
