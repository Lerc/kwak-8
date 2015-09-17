
package ;
import haxe.Int32;
import js.html.Int8Array;
import js.html.Uint16Array;
import js.html.Uint8Array;

using StringTools;
/**
 * ...
 * @author Lerc
 */
@:build( RegisterMacro.memoryMappedRegister("r0",0) )
@:build( RegisterMacro.memoryMappedRegister("r1",1) )
@:build( RegisterMacro.memoryMappedRegister("r2",2) )
@:build( RegisterMacro.memoryMappedRegister("r3",3) )
@:build( RegisterMacro.memoryMappedRegister("r4",4) )
@:build( RegisterMacro.memoryMappedRegister("r5",5) )
@:build( RegisterMacro.memoryMappedRegister("r6",6) )
@:build( RegisterMacro.memoryMappedRegister("r7",7) )
@:build( RegisterMacro.memoryMappedRegister("r8",8) )
@:build( RegisterMacro.memoryMappedRegister("r9",9) )
@:build( RegisterMacro.memoryMappedRegister("r10",10) )
@:build( RegisterMacro.memoryMappedRegister("r11",11) )
@:build( RegisterMacro.memoryMappedRegister("r12",12) )
@:build( RegisterMacro.memoryMappedRegister("r13",13) )
@:build( RegisterMacro.memoryMappedRegister("r14",14) )
@:build( RegisterMacro.memoryMappedRegister("r15",15) )
@:build( RegisterMacro.memoryMappedRegister("r16",16) )
@:build( RegisterMacro.memoryMappedRegister("r17",17) )
@:build( RegisterMacro.memoryMappedRegister("r18",18) )
@:build( RegisterMacro.memoryMappedRegister("r19",19) )
@:build( RegisterMacro.memoryMappedRegister("r20",20) )
@:build( RegisterMacro.memoryMappedRegister("r21",21) )
@:build( RegisterMacro.memoryMappedRegister("r22",22) )
@:build( RegisterMacro.memoryMappedRegister("r23",23) )
@:build( RegisterMacro.memoryMappedRegister("r24",24) )
@:build( RegisterMacro.memoryMappedRegister("r25",25) )
@:build( RegisterMacro.memoryMappedRegister("XL",26) )
@:build( RegisterMacro.memoryMappedRegister("XH",27) )
@:build( RegisterMacro.memoryMappedRegister("YL",28) )
@:build( RegisterMacro.memoryMappedRegister("YH",29) )
@:build( RegisterMacro.memoryMappedRegister("ZL",30) )
@:build( RegisterMacro.memoryMappedRegister("ZH", 31) )
/*
@:build( RegisterMacro.memoryMappedRegister("PINA", 32) )
@:build( RegisterMacro.memoryMappedRegister("DDRA", 33) )
@:build( RegisterMacro.memoryMappedRegister("PORTA",34) )
@:build( RegisterMacro.memoryMappedRegister("PINB", 35) )
@:build( RegisterMacro.memoryMappedRegister("DDRB", 36) )
@:build( RegisterMacro.memoryMappedRegister("PORTB", 37) )
@:build( RegisterMacro.memoryMappedRegister("PINC", 38) )
@:build( RegisterMacro.memoryMappedRegister("DDRC", 39) )
@:build( RegisterMacro.memoryMappedRegister("PORTC", 40) )
@:build( RegisterMacro.memoryMappedRegister("PIND", 41) )
@:build( RegisterMacro.memoryMappedRegister("DDRD", 42) )
@:build( RegisterMacro.memoryMappedRegister("PORTD", 43) )
@:build( RegisterMacro.memoryMappedRegister("TIFR0", 53 ) )
@:build( RegisterMacro.memoryMappedRegister("TIFR1", 54 ) )
@:build( RegisterMacro.memoryMappedRegister("TIFR2", 55 ) )
@:build( RegisterMacro.memoryMappedRegister("PCIFR", 59 ) )
@:build( RegisterMacro.memoryMappedRegister("EIFR",  60) )
@:build( RegisterMacro.memoryMappedRegister("EIMSK", 61) )
@:build( RegisterMacro.memoryMappedRegister("GPIOR0", 62) )
@:build( RegisterMacro.memoryMappedRegister("EECR", 63) )
@:build( RegisterMacro.memoryMappedRegister("EEDR", 64) )
@:build( RegisterMacro.memoryMappedRegister("EEARL", 65) )
@:build( RegisterMacro.memoryMappedRegister("EEARH", 66) )
@:build( RegisterMacro.memoryMappedRegister("GTCCR", 67) )
@:build( RegisterMacro.memoryMappedRegister("TCCR0A", 68) )
@:build( RegisterMacro.memoryMappedRegister("TCCR0B", 69) )
@:build( RegisterMacro.memoryMappedRegister("TCNT0", 70) )
@:build( RegisterMacro.memoryMappedRegister("OCR0A", 71) )
@:build( RegisterMacro.memoryMappedRegister("OCR0B", 72) )
@:build( RegisterMacro.memoryMappedRegister("GPIOR1", 74) )
@:build( RegisterMacro.memoryMappedRegister("GPIOR2", 75) )
@:build( RegisterMacro.memoryMappedRegister("SPCR", 76) )
@:build( RegisterMacro.memoryMappedRegister("SPSR", 77) )
@:build( RegisterMacro.memoryMappedRegister("SPDR", 78) )
@:build( RegisterMacro.memoryMappedRegister("ASCR", 80) )
@:build( RegisterMacro.memoryMappedRegister("OCDR", 81 ) )
@:build( RegisterMacro.memoryMappedRegister("SMCR", 83 ) )
@:build( RegisterMacro.memoryMappedRegister("MCUSR",84  ) )
@:build( RegisterMacro.memoryMappedRegister("MCUCR",85  ) )
@:build( RegisterMacro.memoryMappedRegister("SPMCSR",87  ) )
*/
@:build( RegisterMacro.memoryMappedRegister("RAMPZ", 91 ) )
@:build( RegisterMacro.memoryMappedRegister("EIND", 92 ) )
@:build( RegisterMacro.memoryMappedRegister("SPL", 93 ) )
@:build( RegisterMacro.memoryMappedRegister("SPH", 94 ) )
@:build( RegisterMacro.memoryMappedRegister("SREG",95 ) )
@:build( RegisterMacro.memoryMappedRegister("WDTCSR",96 ) )
@:build( RegisterMacro.memoryMappedRegister("CLKPR", 97  ) )
/*
@:build( RegisterMacro.memoryMappedRegister("PRR", 100 ) )
@:build( RegisterMacro.memoryMappedRegister("OSCCAL", 102  ) )
@:build( RegisterMacro.memoryMappedRegister("PCICR",104  ) )
@:build( RegisterMacro.memoryMappedRegister("EICRA", 105  ) )
@:build( RegisterMacro.memoryMappedRegister("PCMSK0", 107 ) )
@:build( RegisterMacro.memoryMappedRegister("PCMSK1", 108 ) )
@:build( RegisterMacro.memoryMappedRegister("PCMSK2", 109 ) )
@:build( RegisterMacro.memoryMappedRegister("TIMSK0", 110 ) )
@:build( RegisterMacro.memoryMappedRegister("TIMSK1", 111 ) )
@:build( RegisterMacro.memoryMappedRegister("TIMSK2", 112 ) )
@:build( RegisterMacro.memoryMappedRegister("PCMSK3", 115 ) )
@:build( RegisterMacro.memoryMappedRegister("ADCL", 120  ) )
@:build( RegisterMacro.memoryMappedRegister("ADCH", 121 ) )
@:build( RegisterMacro.memoryMappedRegister("ADCSRA", 122  ) )
@:build( RegisterMacro.memoryMappedRegister("ADCSRB", 123 ) )
@:build( RegisterMacro.memoryMappedRegister("ADMUX", 124 ) )
@:build( RegisterMacro.memoryMappedRegister("DIDR0", 126 ) )
@:build( RegisterMacro.memoryMappedRegister("DIDR1", 127 ) )
@:build( RegisterMacro.memoryMappedRegister("TCCR1A", 128) )
@:build( RegisterMacro.memoryMappedRegister("TCCR1B", 129 ) )
@:build( RegisterMacro.memoryMappedRegister("TCCR1C", 130 ) )
@:build( RegisterMacro.memoryMappedRegister("TCNT1L", 132 ) )
@:build( RegisterMacro.memoryMappedRegister("TCNT1H", 133 ) )
@:build( RegisterMacro.memoryMappedRegister("ICR1L",  134 ) )
@:build( RegisterMacro.memoryMappedRegister("ICR1H", 135 ) )
@:build( RegisterMacro.memoryMappedRegister("OCR1AL", 136 ) )
@:build( RegisterMacro.memoryMappedRegister("OCR1AH", 137 ) )
@:build( RegisterMacro.memoryMappedRegister("OCR1BL", 138 ) )
@:build( RegisterMacro.memoryMappedRegister("OCR1BH", 139 ) )
@:build( RegisterMacro.memoryMappedRegister("TCCR2A", 176  ) )
@:build( RegisterMacro.memoryMappedRegister("TCCR2B", 177 ) )
@:build( RegisterMacro.memoryMappedRegister("TCNT2", 178 ) )
@:build( RegisterMacro.memoryMappedRegister("OCR2A", 179 ) )
@:build( RegisterMacro.memoryMappedRegister("OCR2B", 180 ) )
@:build( RegisterMacro.memoryMappedRegister("ASSR", 182 ) )
@:build( RegisterMacro.memoryMappedRegister("TWBR", 184 ) )
@:build( RegisterMacro.memoryMappedRegister("TWSR", 185 ) )
@:build( RegisterMacro.memoryMappedRegister("TWAR", 186 ) )
@:build( RegisterMacro.memoryMappedRegister("TWDR", 187 ) )
@:build( RegisterMacro.memoryMappedRegister("TWCR", 188 ) )
@:build( RegisterMacro.memoryMappedRegister("TWAMR", 189  ) )
@:build( RegisterMacro.memoryMappedRegister("UCSR0A", 192 ) )
@:build( RegisterMacro.memoryMappedRegister("UCSR0B", 193 ) )
@:build( RegisterMacro.memoryMappedRegister("UCSR0C", 194 ) )
@:build( RegisterMacro.memoryMappedRegister("UBRR0L", 196 ) )
@:build( RegisterMacro.memoryMappedRegister("UBRR0H", 197 ) )
@:build( RegisterMacro.memoryMappedRegister("UDR0", 198 ) )
*/
class AVR8
{
	public var ram(default,null) : Uint8Array;
	var ramSigned : Int8Array;
	var ramAsWords : Uint16Array;
	public var log : String = ""; 
	public var progMem(default,null) : Uint16Array;
	public var progMemAsBytes(default,null) : Uint8Array;
	
	public var outPortFunctions : Array<Int->Void> = [ for (i in 0...255) null ];
	
	public var PC : Int = 0;
	public var SP(get, set) : Int;
	public var X(get, set) : Int;
	public var Y(get, set) : Int;
	public var Z(get, set) : Int;
	
	public var clockCycleCount : Int = 0;
	public var interruptDepth : Int = 0;
	
	inline static var CFLAG = 0x01;
	inline static var ZFLAG = 0x02;
	inline static var NFLAG = 0x04;
	inline static var VFLAG = 0x08;
	inline static var SFLAG = 0x10;
	inline static var HFLAG = 0x20;
	inline static var TFLAG = 0x40;
	inline static var IFLAG = 0x80;
	
	
	//interrupts
	inline static var RESET = 0x00;
	inline static var INT0 = 0x02;
	inline static var INT1 = 0x04;
	inline static var INT2 = 0x06;
	inline static var PCINT0 = 0x08;
	inline static var PCINT1 = 0x0A;
	inline static var PCINT2 = 0x0C;
	inline static var PCINT3 = 0x0E;
	inline static var WDT = 0x10;
	inline static var TIMER2_COMPA = 0x12;
	inline static var TIMER2_COMPB = 0x14;
	inline static var TIMER2_OVF = 0x16;
	inline static var TIMER1_CAPT = 0x18;
	inline static var TIMER1_COMPA = 0x1A;
	inline static var TIMER1_COMPB = 0x1C;
	inline static var TIMER1_OVF = 0x1E;
	inline static var TIMER0_COMPA = 0x20;
	inline static var TIMER0_COMPB = 0x22;
	inline static var TIMER0_OVF = 0x24;

	public function new() 
	{		
		ram = new Uint8Array(65536);
		ramSigned = new Int8Array(ram.buffer);
		ramAsWords = new Uint16Array(ram.buffer);
		
		progMem = new Uint16Array(65536);
		progMemAsBytes = new Uint8Array(progMem.buffer);
	}
	
	public function writeProgMem(startAddress : Int32, bytes : Array<Int>) {
		 var walk = 0;
		 for (b in bytes) {
			 this.progMemAsBytes[startAddress + walk] = b;
			 walk += 1;
		 }
	}
	
	inline function instructionLength(instruction : Int) :Int {
		/*	1001 000d dddd 0000		LDS Rd,k (next word is rest of address)
			1001 001d dddd 0000		STS k,Rr (next word is rest of address)
			1001 010k kkkk 110k		JMP k (next word is rest of address)
			1001 010k kkkk 111k		CALL k (next word is rest of address) */
			
		if ( (instruction & 0xf800)	!= 0x9000) return 1;
		if ( (instruction & 0xfc0f) == 0x9000) return 2;
		if ( (instruction & 0xfc0c) == 0x940c) return 2;
		return 1;		
	}
	
	inline function memLoad(address : Int) : Int {
	  if (address > 256) return ram[address];
	  
	  //handle IO here.	  
	  return ram[address];
	}
	
	inline function memStore(address : Int,value:Int) {
	  if (address > 256) {
			ram[address] = value;
			//traceInstruction('Memory Write $value -> [${StringTools.hex(address,4)}]');
	  } else {
		//handle IO here
		
			//trace('Out ${address.hex(2)} <- $value');
			if (outPortFunctions[address] != null) {
				outPortFunctions[address](value);
			}
		  
		ram[address] = value;
	  }
	}
	
	inline static function xor(a:Bool, b:Bool) {
		return a?!b:b;
	}
	
	function sub(d : Int, r:Int, carry :Int = 0) : Int {
		var result = d - r - carry;
		var borrows = (~d & r) | (r & result) | (~d & result);
		var overflows = (d & ~r & ~result) | (~d & r & result); 
		var oldZ = (SREG & ZFLAG);
		SREG &= ~(HFLAG | SFLAG | VFLAG  | NFLAG | ZFLAG | CFLAG);
		var n = result & 0x80;
		var v = overflows & 0x80;
		if ((borrows & 0x08) != 0) SREG |= HFLAG;
		if (r+carry>d) SREG |= CFLAG;
		if (n !=0) SREG |= NFLAG;
		if (v !=0) SREG |= VFLAG;
		if ((n ^ v) != 0) SREG |= SFLAG; 
		if ((result & 0xff) == 0) SREG |= oldZ;
		return result;
	}

	function add(d : Int, r:Int, carry : Int = 0) : Int {
	  var result = d + r + carry;
		var borrows = (d & r) | (r & ~result) | (d & ~result);
		var overflows = (d & r & ~result) | (~d & ~r & result); 
		SREG &= ~(HFLAG | SFLAG | VFLAG  | NFLAG | ZFLAG | CFLAG);
		var n = result & 0x80;
		var v = overflows & 0x80;
		if ((borrows & 0x08) != 0) SREG |= HFLAG;
		if (result > 0xff) SREG |= CFLAG;
		if (n !=0) SREG |= NFLAG;
		if (v !=0) SREG |= VFLAG;
		if ((n ^ v) != 0) SREG |= SFLAG; 
		if ((result & 0xff) == 0) SREG |= ZFLAG;
		return result;
	}
	
	inline function pop8() : Int {
		return ram[++SP ];
	}
	inline function pop16() : Int {
		 return (pop8() << 8) + pop8();
	}
	inline function push8(value) {
		ram[SP--] = value;
	}
	inline function push16(value) {
		push8(value & 0xff);
		push8(value >> 8);
	}
	inline function setFlagsFromLogicResult(result : Int) {
		SREG &= ~(SFLAG | VFLAG | NFLAG | ZFLAG);
		if ( (result & 0x80) != 0) SREG |= SFLAG | NFLAG;
		if (result == 0) SREG |= ZFLAG;			
	}
	
	function hereString() : String {
		return ('${StringTools.hex(PC, 4) } : [${StringTools.hex(progMem[PC], 4)}]');
	}
	
	inline function traceInstruction(s:String) {
		//trace(hereString() + " " + s);
		log += hereString() + " " + s + "\n";
	}
	public function exec() {
		var clocks = 1; //probably one clock
		var nextPC = PC + 1; //probably one word
		var instruction = progMem[PC];

		switch (instruction & 0xf000) {
			case 0x0000: {  //nop movw muls mulsu fmul fmuls fmulsu cpc sbc add 
				switch (instruction & 0x0c00) { 
					case 0x0000: {
						switch (instruction & 0xff00) {
							case 0x0000: {  //nop
							  //traceInstruction('NOP');
							}
							case  0x0100: { //movw
							  var d = (instruction & 0x00f0) >> 4;
							  var r = (instruction & 0x000f);
							  //traceInstruction('MOVW r$d:${d+1},r$r${r+1}');
							  ramAsWords[d] = ramAsWords[r];
							}
							case 0x0200: { //muls
							  var d = 16+(instruction & 0x00f0) >> 4;
							  var r = 16+(instruction & 0x000f);
							  var result = (ramSigned[d] * ramSigned[r]) & 0xffff;
							  //traceInstruction('MULS r$d,r$r');

							  r0 = (result & 0xff);
							  r1 = (result & 0xff00) >> 8;
							  SREG &= ~(ZFLAG|CFLAG);
							  if (result == 0) SREG |= ZFLAG;
							  else if ( (result & 0x8000) == 0x8000) SREG |= CFLAG;
							  clocks = 2;
							}
							case 0x0300: { //mulsu, fmul, fmuls, fmulsu
								
							}
						}
					}
					case 0x0400: { //cpc
						var d = (instruction & 0x01f0) >> 4;
						var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
						//traceInstruction('CPC r$d,r$r');
						sub(ram[d], ram[r], SREG & CFLAG);
					}
					case 0x0800: { //sbc
						var d = (instruction & 0x01f0) >> 4;
						var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
						//traceInstruction('SBC r$d,r$r');
						ram[d] = sub(ram[d], ram[r], SREG & CFLAG);
					}
					case 0x0c00: { //add
						var d = (instruction & 0x01f0) >> 4;
						var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
						//traceInstruction('ADD r$d,r$r   ${ram[d]} + ${ram[r]} ');

						ram[d] = add(ram[d], ram[r]);
					}
				
				}
			}
			case 0x1000: { //cpse cp sub adc 
				switch (instruction & 0x0c00) { 
					case 0x0000: {  //cpse
						var d = (instruction & 0x01f0) >> 4;
						var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
						//traceInstruction('CPSE r$d,r$r');
						if (ram[d] == ram[r]) {
							var skipLength = instructionLength(progMem[PC + 1]);
							//trace("skiplength =" , skipLength); 
							nextPC = PC + 1 +skipLength;
							clocks = 1 + skipLength;
						}
					}
					case 0x0400: { //cp					
						var d = (instruction & 0x01f0) >> 4;
						var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
						//traceInstruction('CP r$d,r$r');
						SREG != ZFLAG;
						sub(d, r);
					}
					case 0x0800: { //sub
						var d = (instruction & 0x01f0) >> 4;
						var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
						//traceInstruction('SUB r$d,r$r');
						ram[d] = sub(ram[d], ram[r]);
					}
					case 0x0c00: { //adc
						var d = (instruction & 0x01f0) >> 4;
						var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
						//traceInstruction('ADC r$d,r$r   ${ram[d]} + ${ram[r]} + ${SREG & CFLAG}');
					    ram[d] = add(ram[d], ram[r], SREG & CFLAG);	
					}
				}
			}
			case 0x2000: { //and eor or mov
				switch (instruction & 0x0c00) { 
					case 0x0000: {  //and
						var d = (instruction & 0x01f0) >> 4;
						var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
						//traceInstruction(' AND r$d,r$r');
						var result = ram[d] & ram[r];	
						ram[d] = result;
						setFlagsFromLogicResult(result);
					}
					case 0x0400: { //eor
						var d = (instruction & 0x01f0) >> 4;
						var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
						//traceInstruction(' EOR r$d,r$r');
						var result = ram[d] ^ ram[r];	
						ram[d] = result;
						setFlagsFromLogicResult(result);
						
					}
					case 0x0800: { //or
						var d = (instruction & 0x01f0) >> 4;
						var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
						//traceInstruction(' OR r$d,r$r');
						var result = ram[d] | ram[r];	
						ram[d] = result;
						setFlagsFromLogicResult(result);
						
					}
					case 0x0c00: { //mov
						var d = (instruction & 0x01f0) >> 4;
						var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
						//traceInstruction(' MOV r$d,r$r');
						ram[d] = ram[r];
					}
				}
				
			}
			case 0x3000: { //cpi 
				var k = ((instruction & 0x0f00) >> 4) | (instruction & 0x000f);
				var d = 16 +  ( (instruction & 0x00f0) >> 4);
				//traceInstruction(' CPI r$d,#$k   [r$d] is ${ram[d]}');
				SREG |= ZFLAG;
				sub(ram[d], k);
				//traceInstruction(' Z Flag is ${SREG&ZFLAG}');

			}
			case 0x4000: { //sbci
				var k = ((instruction & 0x0f00) >> 4) | (instruction & 0x000f);
				var d = 16 +  ( (instruction & 0x00f0) >> 4);
				//traceInstruction(' SBCI r$d,#$k');
				ram[d]=sub(ram[d], k, SREG & CFLAG);
				
			}
			case 0x5000: { //subi				
				var k = ((instruction & 0x0f00) >> 4) | (instruction & 0x000f);
				var d = 16 +  ( (instruction & 0x00f0) >> 4);
				//traceInstruction(' SUBI r$d,#$k');
				ram[d]=sub(ram[d], k);
			}
			case 0x6000: { //ori 
				var k = ((instruction & 0x0f00) >> 4) | (instruction & 0x000f);
				var d = 16 +  ( (instruction & 0x00f0) >> 4);
				//traceInstruction(' ORI r$d,#$k');
				ram[d]=ram[d] | k;
				setFlagsFromLogicResult(ram[d]);				
			}
			case 0x7000: { //andi
				var k = ((instruction & 0x0f00) >> 4) | (instruction & 0x000f);
				var d = 16 +  ( (instruction & 0x00f0) >> 4);
				//traceInstruction(' ANDI r$d,#$k');
				ram[d]=ram[d] & k;
				setFlagsFromLogicResult(ram[d]);								
			}		
			case 0x8000 | 0xa000: {  // ldd std
				var q = (instruction & 0x0007) | ( (instruction & 0x0C) >> 7) | ( (instruction  & 0x2000) >> 8 );
				var d = (instruction & 0x01f0) >> 4;
				var store = (instruction & 0x0200) != 0;
				var useY = (instruction & 0x0008) != 0;
				
				if (store) {
					if (useY) {
						//traceInstruction(' STD r$d,Y+$q');
						memStore(Y + q, ram[d]);
					} else {
						//traceInstruction(' STD r$d,Z+$q');
						memStore(Z + q, ram[d]);
					}
				} else {
					if (useY) {
						//traceInstruction(' LDD r$d,Y+$q');
						
						ram[d] = memLoad(Y + q);
					} else {
						//traceInstruction(' LDD r$d,Z+$q');
						ram[d] = memLoad(Z + q);
					}
				}
				clocks = 2;
			}
			case 0xb000: { //in out
				var a = (instruction & 0x000f) | ( (instruction & 0x0600) >> 5);
				var d = (instruction & 0x01f0) >> 4;
				if ( (instruction & 0x0800)==0) {
					//traceInstruction(' IN r$d,$$${a.hex(2)}');
					ram[d] = memLoad(a + 32);
				} else {
					//traceInstruction(' OUT r$d,$$${a.hex(2)}');
					memStore(a + 32,ram[d]);
				}
			}
			case 0xc000: { //rjmp
				var k = (instruction & 0x0fff);
				if (k > 2048) k -= 4096;
				//traceInstruction(' RJMP ${StringTools.hex(PC+k+1,4)}');
				nextPC = PC + k + 1;
				clocks = 2;
			}
			case 0xd000: { //rcall
				var k = (instruction & 0x0fff);
				if (k > 2048) k -= 4096;
				//traceInstruction(' RCALL ${StringTools.hex(PC+k+1,4)}');				
				nextPC = PC + k + 1;
				push16(PC + 1);
				clocks = 3;				
			}
			case 0xe000: { //ldi
				var k = ((instruction & 0x0f00) >> 4) | (instruction & 0x000f);
				var d = 16 + ((instruction & 0x0f0) >> 4);
				ram[d] = k;
				//traceInstruction(' LDI r$d,$k');
				
			}
			case 0xf000: { // bld bst sbrc sbrs  +conditional branches 
				var bit = 1 << (instruction & 0x0007);
				if ( (instruction & 0x0800) ==0 ) {
					//it's a branch;				
					var doBranch = (SREG & bit)!=0;
					if ((instruction & 0x0400) != 0) doBranch = !doBranch;
					//traceInstruction('conditional branch on $bit branching=$doBranch');
					if (doBranch) {
						var k = (instruction & 0x03f8) >> 3;
						if (k > 63) k -= 128;
						nextPC = PC + k + 1;
					}					
				} else {
					if ( (instruction & 0x0400) == 0) {
						//bld bst
						var d = (instruction & 0x01f0) >> 4;
						if ((instruction & 0x0200) == 0) {
							//traceInstruction('BLD r$d,${instruction & 0x0007}');				
						  	if ( (SREG & TFLAG) != 0) {
								ram[d] |= bit;
							} else {
								ram[d] &= ~bit;								
							}
						} else {
							//traceInstruction('BST r$d,$bit');				
							if ( (ram[d] & bit) != 0) {
								SREG |= ZFLAG;
							} else {
								SREG &= ~ZFLAG;
							}
						}
					}  else {
						//sbrc sbrs
						var d = (instruction & 0x01f0) >> 4;
						var bitCheck = ram[d] & bit;
						var skip = ((instruction & 0x0200) == 0) == (bitCheck == 0);
						if (skip) {
							var skipLength = instructionLength(progMem[PC + 1]);
							nextPC = PC + 1 +skipLength;
							clocks = 1 + skipLength;							
						}						
					}
				}
				
			}
			case 0x9000: {
				switch (instruction & 0xfe00) {
					case 0x9000: { //lds   ld   lpm  elpm  pop
						var d = (instruction & 0x01f0) >> 4;
						switch (instruction & 0xfe0f) {
							case 0x9000: {
								//LDS Rd,k
								var k = progMem[PC + 1];
								nextPC = PC + 2;
								ram[d] = memLoad(k);
								clocks = 2;
							}								
							case 0x9001: {								
								//LD Rd,Z+
								ram[d] = memLoad(Z);
								Z += 1;								
								clocks = 2;
							}
							case 0x9002: {								
								//LD Rd,-Z
								Z -= 1;
								ram[d] = memLoad(Z);
								clocks = 2;
							}
							case 0x9004: {
								//LPM Rd,Z
								ram[d] = progMemAsBytes[Z];
								clocks = 3;
							}
							case 0x9005: {
								//LPM Rd,Z+
								//trace('reading $Z  as ${progMemAsBytes[Z]}');
								ram[d] = progMemAsBytes[Z];
								Z += 1;		
								clocks = 3;
							}
							case 0x9006: {
								//ELPM Rd,Z
								ram[d] = progMemAsBytes[(RAMPZ << 16) | Z];
								clocks = 3;
							}								
							case 0x9007: {
								//ELPM Rd,Z+
								ram[d] = progMemAsBytes[(RAMPZ << 16) | Z];
								Z += 1; if (Z == 0) RAMPZ += 1;
								clocks = 3;
							}
							case 0x9009: {								
								//LD Rd,Y+
								ram[d] = memLoad(Y);
								Y += 1;
								clocks = 2;
							}
							case 0x900A: {
								//LD Rd,-Y
								Y -= 1;
								ram[d] = memLoad(Y);
								clocks = 2;
							}
							case 0x900C: {
								//LD Rd,X
								ram[d] = memLoad(X);
								clocks = 2;
							}
							case 0x900D: {
								//LD Rd,X+
								ram[d] = memLoad(X);
								X += 1;
								clocks = 2;
							}
							case 0x900E: {
								//LD Rd,-X
								X -= 1;
								ram[d] = memLoad(X);								
								clocks = 2;
							}
							case 0x900F: {
								//POP
								SP += 1;
								ram[d] = ram[SP];
								clocks = 2;
								//traceInstruction('pop   SP=0x${StringTools.hex(SP,4)} 0x${StringTools.hex(ram[SP],2)}->R$d');

							}
						}
					}
					case 0x9200: { //sts st push
						var d = (instruction & 0x01f0) >> 4;
						switch (instruction & 0xfe0f) {
							case 0x9200: {
								//STS k,Rd
								var k = progMem[PC + 1];
								nextPC = PC + 2;
								memStore(k,ram[d]);
								clocks = 2;
							}								
							case 0x9201: {								
								//ST Z+,Rd
								memStore(Z,ram[d]);
								Z += 1;								
								clocks = 2;
							}
							case 0x9202: {								
								//ST -Z,Rd
								Z -= 1;
								memStore(Z,ram[d]);
								clocks = 2;
							}
							case 0x9209: {								
								//ST Y+,Rd
								memStore(Y,ram[d]);
								Y += 1;
								clocks = 2;
							}
							case 0x920A: {
								//ST -Y,Rd
								Y -= 1;
								memStore(Y,ram[d]);
								clocks = 2;
							}
							case 0x920C: {
								//ST X,Rd
								memStore(X,ram[d]);
								clocks = 2;
							}
							case 0x920D: {
								//ST X+,Rd
								memStore(X,ram[d]);
								X += 1;
								clocks = 2;
							}
							case 0x920E: {
								//ST -X,Rd
								X -= 1;
								memStore(X,ram[d]);
								clocks = 2;
							}
							case 0x920F: {
								//PUSH
								//traceInstruction('push  R$d  0x${StringTools.hex(ram[d],2)} -> [0x${StringTools.hex(SP,4)}]  ');
								ram[SP]=ram[d];
								SP -= 1;
								clocks = 2;
								

							}
						}
						
					}
					case 0x9400: { 	// com neg swap inc asr lsr ror dec jmp call bset 
									// ijmp eijmp bclr ret icall reti eicall sleep break 
									// wdr   lpm R0,Z    elpm R0   spm
						switch (instruction & 0xfe0f) {
							case 0x9400: { //com 
								var d = (instruction & 0x01f0) >> 4;
								ram[d] = 0xff - ram[d];
								SREG &= ~(SFLAG | VFLAG | NFLAG | ZFLAG);
								SREG |= CFLAG;
								if ((ram[d] & 0x80) != 0) {
									SREG |= SFLAG | NFLAG;
								}
								if (ram[d] == 0) SREG |= ZFLAG;
							}
							case 0x9401: { //neg 
								var d = (instruction & 0x01f0) >> 4;
								ram[d] = sub(0, ram[d]);
							}
							case 0x9402: { //swap
								var d = (instruction & 0x01f0) >> 4;
								var value = ram[d];
								ram[d] = ((value << 4) | (value >> 4)) & 0xff;
							}
							case 0x9403: { //inc
								var d = (instruction & 0x01f0) >> 4;
								//traceInstruction(' INC r$d');
								SREG &= ~(SFLAG | VFLAG | NFLAG | ZFLAG);
								var v = ram[d] == 0x7f;
								var n = (ram[d] & 0x80) != 0; 
								ram[d] += 1;
								if (v) SREG |= VFLAG;
								if (n) SREG |= NFLAG;
								if (v != n) SREG |= NFLAG;
								if (ram[d] == 0) SREG |= ZFLAG;
							}
							case 0x9404: { // no instruction for this !?!
								
							}
							case 0x9405: { //asr
								var d = (instruction & 0x01f0) >> 4;
								var value = ram[d];
								SREG &= ~(SFLAG | VFLAG | NFLAG | ZFLAG | CFLAG);
								var carry = (value & 1);
								SREG |= carry;
								var topBit = (value & 0x80) ;
								var newValue = (value >> 1) | topBit;
								ram[d] = newValue;
								if (newValue == 0) SREG |= ZFLAG;
								var n = topBit != 0;
								var v = xor(n, carry != 0);
								var s = xor(n, v);
								if (n) SREG |= NFLAG;									
								if (v) SREG != VFLAG;
								if (s) SREG != SFLAG;
							}
							case 0x9406: { //lsr
								var d = (instruction & 0x01f0) >> 4;
								var value = ram[d];
								var bit0 = value & 1;
								var newValue = (value >> 1) ;
								ram[d] = newValue;
								SREG &= ~(SFLAG | VFLAG | NFLAG | ZFLAG | CFLAG);
								if (bit0 != 0) SREG |= (CFLAG | VFLAG | SFLAG);
								if (newValue == 0) SREG |= ZFLAG;
							}
							case 0x9407: { //ror
								var d = (instruction & 0x01f0) >> 4;
								var value = ram[d];
								var carry = (SREG & CFLAG);
								var bit0 = value & 1;
								var newValue = (value >> 1) | carry << 7;
								ram[d] = newValue;
								SREG &= ~(SFLAG | VFLAG | NFLAG | ZFLAG | CFLAG);
								if (bit0 != 0) SREG |= (CFLAG | VFLAG | SFLAG);
								if (newValue == 0) SREG |= ZFLAG;
							}
							case 0x9408: { // bset bclr ret reti sleep break  wdr   lpm R0,Z    elpm R0   spm
								if ( (instruction & 0xff0f) == 0x9408 ) { // bset bclr
									var bit = 1 << ( (instruction & 0x0030) >> 4);
									if ( (instruction & 0x0040 == 0) ) {
										SREG |= bit;
									} else {
										SREG &= ~bit;
									}								
								} else switch (instruction) {
									case 0x9508: { // ret
										nextPC = pop16();
										//traceInstruction('RET  -> 0x${StringTools.hex(nextPC,4)}');
									}
									case 0x9518: { // reti
										nextPC = pop16();
										SREG |= IFLAG;
									}
									case 0x9588: { //sleep
										
									}
									case 0x9598: { //break
										
									}
									case 0x95a8: { //wdr
										
									}
									case 0x95C8: { //lpm R0,Z
										r0 = progMemAsBytes[Z];										
									}
									case 0x95d8: { //elpm R0
										r0 = progMemAsBytes[RAMPZ<<16+Z];										
									}
									case 0x95e8: { // spm
										
									}
									case 0x95f8: { // spm Z+
										
									}
								}
							}
							case 0x9409: { // ijmp eijmp icall eicall 
								switch (instruction) {
									case 0x9409: {  // ijmp
										
									}
									case 0x9419: { //eijmp
										
									}
									case 0x9509: { //icall
										
									}
									case 0x9519: { //eicall
										
									}
								}
							}
							case 0x940A: { // dec
								var d = (instruction & 0x01f0) >> 4;
								var value = ram[d]-1;
								var v = (value == 0x7f);
								var n = ((value & 0x80) != 0);
								ram[d] = value;
								SREG &= ~(SFLAG | VFLAG | NFLAG | ZFLAG);
								if (v) SREG |= VFLAG;
								if (n) SREG |= NFLAG;
								if (xor(n, v)) SREG |= SFLAG;
								if (value==0) SREG |= ZFLAG;
							}
							case 0x940C | 0x940D: { //  jmp
								var k = progMem[PC + 1];
								k |= (instruction & 0x01f0) << 13 | (instruction & 1) << 16;
								//traceInstruction('JMP 0x${StringTools.hex(k,4)}');
								nextPC = k;
							}
							case 0x940E | 0x940F: { //  call
								var k = progMem[PC + 1];
								k |= (instruction & 0x01f0) << 13 | (instruction & 1) << 16;
								nextPC = k;
								push16(PC + 2);
								//traceInstruction('call 0x${StringTools.hex(k,4)}');
							}
						}
					}
					case 0x9600: {  // addiw sbiw
						
					}
					case 0x9800: { // cbi sbic
						
					}
					case 0x9a00: { // sbi sbis
						
					}
					case 0x9c00 | 0x9e00: { // mul
						var d = (instruction & 0x01f0) >> 4;
						var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
						var product = ram[d] * ram[r];
						//traceInstruction('mul r$d,r$r  0x${StringTools.hex(ram[d],2)} * 0x${StringTools.hex(ram[r],2)} = 0x${StringTools.hex(product,4)}  ');

						r0 = (product & 0xff);
						r1 = ((product >> 8) & 0xff);

						SREG &= ~(CFLAG | ZFLAG);
						if ( (product & 0x8000) != 0) SREG |= CFLAG;
						if (product == 0) SREG |= ZFLAG;
					}
				}
			}
			default: {
				throw "shouldn't happen";
			}
		}

		PC = nextPC;
		handle_hardware(clocks); 				
	}
	inline function handle_hardware(clockCycles:Int) {
		clockCycleCount += clockCycles;
		/*   change to ifdef  later.... 
		if (TCCR1B != 0) {//same hacky-wrong as uzem 
			var TCNT1 = TCNT1L | (TCNT1H << 8);
			var OCR1A = OCR1AL | (OCR1AH << 8);
			
			if ( (TCNT1 < OCR1A) && ( (TCNT1 + clockCycles) >= OCR1A) ) {
				TCNT1 -= (OCR1A - clockCycles);
				if ( (TIMSK1 & 2) !=0) {
					interrupt(TIMER1_COMPA);
				}
			} else {
				TCNT1 += clockCycles;
			}
			TCNT1L = TCNT1 & 0xff;
			TCNT1H = (TCNT1 >> 8) & 0xff;
		}
		*/
	}
	function interrupt(vector:Int) {
		if ( (SREG & IFLAG) != 0 ) {
			SREG &= ~IFLAG;
			ram[SP--] = PC & 0xff;
			ram[SP--] = (PC >> 8) & 0xff;
			PC = vector;
			
			// As per comment in uzeem
				// bill the cycles consumed.
				// (this in theory can recurse back into here but we've
				// already cleared the interrupt enable flag)
			//looks to me like you could miss timer intterupts 	if they happen right after another interrupt.  Is that right?
			handle_hardware(5); 
			
			interruptDepth += 1;
		}
	}
	
	public function tick(clockCycles : Int) {
		var endTime = clockCycleCount + clockCycles;
		for (i in 0...10000000) {		
			exec();
			if (clockCycleCount > endTime) break;
		}
	}
	
	public function traceRegisters() {
		function hexreg(n) {
			return StringTools.hex(ram[n], 2);
		}
		
		for (i in 0...7) {
			trace('r$i : ${hexreg(i)}        r${i+8} : ${hexreg(i+8)}        r${i+16} : ${hexreg(i+16)}         r${i+24} : ${hexreg(i+24)}    ');
		}
	}
	
	inline function get_SP() {
		return SPL + (SPH << 8);
	}

	inline function set_SP(value:Int) {
		SPL = value & 0xff;
		SPH = (value >> 8) & 0xff;
		return (value & 0xffff);
	}
	
	inline function get_X() {
		return XL + (XH << 8);
	}

	inline function set_X(value:Int) {
		XL = value & 0xff;
		XH = (value >> 8) & 0xff;
		return (value & 0xffff);
	}

	inline function get_Y() {
		return YL + (YH << 8);
	}

	inline function set_Y(value:Int) {
		YL = value & 0xff;
		YH = (value >> 8) & 0xff;
		return (value & 0xffff);
	}
	
	inline function get_Z() {
		return ZL + (ZH << 8);
	}

	inline function set_Z(value:Int) {
		ZL = value & 0xff;
		ZH = (value >> 8) & 0xff;
		return (value & 0xffff);
	}
	
}