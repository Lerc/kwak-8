
package ;
import haxe.Int32;
import js.lib.Int8Array;
import js.lib.Int32Array;
import js.lib.Uint16Array;
import js.lib.Uint8Array;

using StringTools;

#if InstructionTable

@:enum 
abstract Instruction(Int) from Int to Int {
  var nop=0;
  var cpse=1; 
  var cp=2; 
  var sub=3; 
  var adc=4; 
  var and=5; 
  var eor=6; 
  var or=7; 
  var mov=8; 
  var movw=9; 
  var muls=10; 
  var cpc=11; 
  var sbc=12; 
  var add=13; 
  var cpi=14;
  var subi=15; 
  var ori=16; 
  var andi=17; 
  var std_y=18; 
  var std_z=19; 
  var ldd_y=20; 
  var ldd_z=21;
  var port_in=22; 
  var port_out=23;
  var rjmp=24; 
  var rcall=25; 
  var ldi=26; 
  var brbs=27; 
  var brbc=28; 
  var bld=29; 
  var bst=30; 
  var sbrc=31; 
  var sbrs=32; 
  var lpm_z=33; 
  var lpm_z_p=34; 
  var elpm_z=35; 
  var elpm_z_p=36;
  var lds=37; 
  var ld_z_p=38; 
  var ld_p_z=39; 
  var ld_y_p=40; 
  var ld_p_y=41; 
  var ld_x=42; 
  var ld_x_p=43; 
  var ld_p_x=44; 
  var pop=45;
  var sts=46; 
  var st_z_p=47; 
  var st_p_z=48;
  var st_y_p=49; 
  var st_p_y=50; 
  var st_x=51; 
  var st_x_p=52; 
  var st_p_x=53; 
  var push=54;
  var com=55;
  var neg=56; 
  var swap=57; 
  var inc=58; 
  var asr=59; 
  var lsr=60; 
  var ror=61; 
  var bset=62; 
  var bclr=63; 
  var ret=64; 
  var reti=65; 
  var ijmp=66; 
  var icall=67; 
  var dec=68; 
  var jmp=69; 
  var call=70; 
  var sbiw=71; 
  var adiw=72; 
  var mul=73;
  var sbci=74; 

  var fmuls=75;
  var sleep=76; 
  var breakpoint=77; 
  var wdr=78; 
  var spm_z=79; 
  var spm_z_p=80; 
  var eijmp=81; 
  var eicall=82; 
  var no_bitio=83; 
  var not_an_instruction=84;
}

typedef InstructionFn = Int->Int->Void;

typedef DecodedInstructionFunction = {
	var fn :  InstructionFn; //Int->Int->Void;
	var a : Int;
	var b : Int;
}


typedef DecodedInstruction = {
	var opcode:Instruction;
	var a : Int;
	var b : Int;
}


#end

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

@:build( RegisterMacro.memoryMappedRegister("RAMPZ", 91 ) )
@:build( RegisterMacro.memoryMappedRegister("EIND", 92 ) )
@:build( RegisterMacro.memoryMappedRegister("SPL", 93 ) )
@:build( RegisterMacro.memoryMappedRegister("SPH", 94 ) )
@:build( RegisterMacro.memoryMappedRegister("SREG",95 ) )
@:expose
class AVR8
{
	public var ram(default, null) : Uint8Array;
	var ramSigned : Int8Array;
	var ramAsWords : Uint16Array;

	public var breakPoints (default,null) : Int32Array;
	public var log : String = ""; 
	public var progMem(default,null) : Uint16Array;
	public var progMemAsBytes(default,null) : Uint8Array;
	
	public var outPortFunctions : Array<Int->Void> = [ for (i in 0...255) null ];
	public var inPortFunctions : Array<Void->Int> = [ for (i in 0...255) null ];
	
	public var PC : Int = 0;
	public var nextPC : Int = 0;

	public var SP(get, set) : Int;
	public var X(get, set) : Int;
	public var Y(get, set) : Int;
	public var Z(get, set) : Int;
	
	public var clockCycleCount : Int = 0;
	public var interruptDepth : Int = 0;
	
	static function __init__():Void {
		#if js
			var p = untyped AVR8.prototype;

			untyped Object.defineProperty(p, "SP", { get: p.get_SP, set:p.set_SP});
			untyped Object.defineProperty(p, "X", { get: p.get_X, set:p.set_X});
			untyped Object.defineProperty(p, "Y", { get: p.get_Y, set:p.set_Y});
			untyped Object.defineProperty(p, "Z", { get: p.get_Z, set:p.set_Z});
   			
		#end
	}
	public inline static var CFLAG = 0x01;
	public inline static var ZFLAG = 0x02;
	public inline static var NFLAG = 0x04;
	public inline static var VFLAG = 0x08;
	public inline static var SFLAG = 0x10;
	public inline static var HFLAG = 0x20;
	public inline static var TFLAG = 0x40;
	public inline static var IFLAG = 0x80;
	
	
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

#if InstructionTable	
	var table : Array<DecodedInstructionFunction>= [for (i in 0...0xffff) null];
	var decodedProgram : Array<DecodedInstruction>;

	var decodeCacheUpdateRequired = true;

	private var instructionFunctions : Map<Instruction,InstructionFn>;
#end

	public function new() 
	{		
#if InstructionTable	
		instructionFunctions = [ 
			Instruction.nop => _nop ,
			Instruction.cpse=> _cpse,
			Instruction.cp=> _cp,
			Instruction.sub=> _sub,
			Instruction.adc=> _adc,
			Instruction.and=> _and,
			Instruction.eor=> _eor,
			Instruction.or=> _or,
			Instruction.mov=> _mov,
			Instruction.movw=> _movw,
			Instruction.muls=> _muls,
			Instruction.cpc=> _cpc,
			Instruction.sbc=> _sbc,
			Instruction.add=> _add,
			Instruction.cpi=> _cpi,
			Instruction.sbci=> _sbci,
			Instruction.subi=> _subi,
			Instruction.ori=> _ori,
			Instruction.andi=> _andi,
			Instruction.std_y=> _std_y,
			Instruction.std_z=> _std_z,
			Instruction.ldd_y=> _ldd_y,
			Instruction.ldd_z=> _ldd_z,
			Instruction.port_in=> _in ,
			Instruction.port_out=> _out,
			Instruction.rjmp=> _rjmp,
			Instruction.rcall=> _rcall,
			Instruction.ldi=> _ldi,
			Instruction.brbs=> _brbs,
			Instruction.brbc=> _brbc,
			Instruction.bld=> _bld,
			Instruction.bst=> _bst,
			Instruction.sbrc=> _sbrc,
			Instruction.sbrs=> _sbrs,
			Instruction.lpm_z=> _lpm_z,
			Instruction.lpm_z_p=> _lpm_z_p,
			Instruction.elpm_z=> _elpm_z,
			Instruction.elpm_z_p=> _elpm_z_p,
			Instruction.lds=> _lds,
			Instruction.ld_z_p=> _ld_z_p,
			Instruction.ld_p_z=> _ld_p_z,
			Instruction.ld_y_p=> _ld_y_p,
			Instruction.ld_p_y=> _ld_p_y,
			Instruction.ld_x=> _ld_x,
			Instruction.ld_x_p=> _ld_x_p,
			Instruction.ld_p_x=> _ld_p_x,
			Instruction.pop=> _pop,
			Instruction.sts=> _sts,
			Instruction.st_z_p=> _st_z_p,
			Instruction.st_p_z=> _st_p_z,
			Instruction.st_y_p=> _st_y_p,
			Instruction.st_p_y=> _st_p_y,
			Instruction.st_x=> _st_x,
			Instruction.st_x_p=> _st_x_p,
			Instruction.st_p_x=> _st_p_x,
			Instruction.push=> _push,
			Instruction.com=> _com,
			Instruction.neg=> _neg,
			Instruction.swap=> _swap,
			Instruction.inc=> _inc,
			Instruction.asr=> _asr,
			Instruction.lsr=> _lsr,
			Instruction.ror=> _ror,
			Instruction.bset=> _bset,
			Instruction.bclr=> _bclr,
			Instruction.ret=> _ret,
			Instruction.reti=> _reti,
			Instruction.ijmp=> _ijmp,
			Instruction.icall=> _icall,
			Instruction.dec=> _dec,
			Instruction.jmp=> _jmp,
			Instruction.call=> _call,
			Instruction.sbiw=> _sbiw,
			Instruction.adiw=> _adiw,
			Instruction.mul=> _mul,
			Instruction.fmuls=> _fmuls,
			Instruction.sleep=> _sleep,
			Instruction.breakpoint=> _break,
			Instruction.wdr=> _wdr,
			Instruction.spm_z=> _spm_z,
			Instruction.spm_z_p=> _spm_z_p,
			Instruction.eijmp=> _eijmp,
			Instruction.eicall=> _eicall,
			Instruction.no_bitio=> _no_bitio,
			Instruction.not_an_instruction=> _not_an_instruction
		];

		for (i in 0...0xffff) {
			table[i]=decodeInstruction(i,apply2);
		}

#end 
		ram = new Uint8Array(65536);
		ramSigned = new Int8Array(ram.buffer);
		ramAsWords = new Uint16Array(ram.buffer);
		
		progMem = new Uint16Array(65536);
		progMemAsBytes = new Uint8Array(progMem.buffer);

	//There's a degree of irony in how wasteful this to reserve 256k for breakpoint codes
		breakPoints = new Int32Array(65536);

	}
	
	public function clearRam() {
		for (i in 0...ram.length) {
			ram[i] = 0;
		}
	}
	
	public function clearProgMem() {
		for (i in 0...progMem.length) {
			progMem[i] = 0;
			breakPoints[i]=0;
		}
	}

	public function reset() {
		clearRam();
		for (i in 0...255) {
			memStore(i, 0);  //clear IO ports
		}
		PC = 0;
		interruptDepth = 0;
		clockCycleCount = 0;
	}
	
	public function clear() {
		clearProgMem();
		reset();
	}
	
	public function writeProgMem(startAddress : Int32, bytes : Uint8Array) {
		 var walk = 0;
		 for (b in bytes) {
			 this.progMemAsBytes[startAddress + walk] = b;
			 walk += 1;
		 }
#if InstructionTable		 
		decodeCacheUpdateRequired=true;
#end		
	}
	
#if InstructionTable		 
	function updateDecodeCache() {
		decodedProgram = [for (i in progMem) decodeInstruction(i,simpleDecode)];
		decodeCacheUpdateRequired=false;
	}
#end		

	public inline function instructionLength(instruction : Int) :Int {
		/*	1001 000d dddd 0000		LDS Rd,k (next word is rest of address)
			1001 001d dddd 0000		STS k,Rr (next word is rest of address)
			1001 010k kkkk 110k		JMP k (next word is rest of address)
			1001 010k kkkk 111k		CALL k (next word is rest of address) */
			
		if ( (instruction & 0xf800)	!= 0x9000) return 1;
		if ( (instruction & 0xfc0f) == 0x9000) return 2;
		if ( (instruction & 0xfc0c) == 0x940c) return 2;
		return 1;		
	}
	
	public inline function instructionAt(memLocation :UInt) {
		return progMem[memLocation];
	}
	
	function memLoad(address : Int) : Int {
	  if (address > 256) {
		  return ram[address];
	  } else {
			if (inPortFunctions[address] != null) {
				return inPortFunctions[address]();
			}
		  
		return ram[address];
	  }
	  
	  //handle IO here.	  
	  return ram[address];
	}
	
	function memStore(address : Int,value:Int) {
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
	

	function sub_with_carry(d : Int, r:Int, carry :Int = 0) : Int {
		var result = d - r - carry;
		result &= 0xff;
		var carries = (~d & r) | (r & result) | (~d & result);
		var overflows = (d & ~r & ~result) | (~d & r & result); 
		//var carries = (( (~d & r) | ( r & result) | (result & ~d) ) & 0x80) ==0x80; 
		var oldZ = (SREG & ZFLAG);
		SREG &= ~(HFLAG | SFLAG | VFLAG  | NFLAG | ZFLAG | CFLAG);
		var n = result & 0x80;
		var v = overflows & 0x80; 
		if ((carries & 0x08) != 0) SREG |= HFLAG; 
		if ((carries & 0x80) !=0) SREG |= CFLAG;
		//if ((carries & 0x80) !=0) SREG |= CFLAG;
		if (n !=0) SREG |= NFLAG; 
		if (v !=0) SREG |= VFLAG;
		if ((n ^ v) != 0) SREG |= SFLAG; 

		//if (PC == 0x165) traceInstruction('  sub $d, $r, $carry -> $result FLAGS:$SREG');

		if ((result) == 0) SREG |= oldZ;
		return result ;
	}

	function sub(d : Int, r:Int) : Int {
		var result = d - r;
		result &= 0xff;
		//var borrows = (~d & r) | (r & result) | (~d & result);
		var carries = (~d & r) | (r & result) | (result & ~d); 
		var overflows = (d & ~r & ~result) | (~d & r & result); 
		SREG &= ~(HFLAG | SFLAG | VFLAG  | NFLAG | ZFLAG | CFLAG);
		var n = result & 0x80;
		var v = overflows & 0x80; 
		if ((carries & 0x08) != 0) SREG |= HFLAG; 
		if ((carries & 0x80) != 0) SREG |= CFLAG; 
		//if ((r &0xff) > (d&0xff)) SREG |= CFLAG;
		if (n !=0) SREG |= NFLAG; 
		if (v !=0) SREG |= VFLAG;
		if ((n ^ v) != 0) SREG |= SFLAG; 
		if ((result) == 0) SREG |= ZFLAG;

		return result ;
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
		return ('${StringTools.hex(PC*2, 4) } : [${StringTools.hex(progMem[PC], 4)}]');
	}
	
	inline function traceInstruction(s:String) {
		//trace(hereString() + " " + s);
		
		//log += hereString() + " " + s + "\n";
		
	}

#if InstructionTable	
inline	function _nop(_,__) {
		clockCycleCount+=1; PC+=1;
	}

inline	function _cpse(d,r) {
		var skipLength=0;
		if (ram[d] == ram[r]) {
			skipLength = instructionLength(progMem[PC + 1]);
			//trace("skiplength =" , skipLength); 							
		} 
		clockCycleCount+=1+skipLength; PC+=1 +skipLength;
	}

inline	function _cp(d,r) {
		sub(ram[d], ram[r]);
		clockCycleCount+=1; PC+=1;
	}

inline	function _sub(d,r) {
		ram[d] = sub(ram[d], ram[r]);
		clockCycleCount+=1; PC+=1;		
	}

inline	function _adc(d,r) {
	    ram[d] = add(ram[d], ram[r], SREG & CFLAG);	
		clockCycleCount+=1; PC+=1;	
	}

inline	function _and(d,r) {
		var result = ram[d] & ram[r];	
		ram[d] = result;
		setFlagsFromLogicResult(result);
		clockCycleCount+=1; PC+=1;
	}

inline	function _eor(d,r) {
		var result = ram[d] ^ ram[r];	
		ram[d] = result;
		setFlagsFromLogicResult(result);
		clockCycleCount+=1; PC+=1;
	}

inline	function _or(d,r) {
		var result = ram[d] | ram[r];	
		ram[d] = result;
		setFlagsFromLogicResult(result);
		clockCycleCount+=1; PC+=1;						
	}

inline	function _mov(d,r) {
		ram[d] = ram[r];
		clockCycleCount+=1; PC+=1;
	}

inline	function _movw(d,r) {
		ramAsWords[d] = ramAsWords[r];
		clockCycleCount+=1; PC+=1;
	}

inline	function _muls(d,r) {
		var result = (ramSigned[d] * ramSigned[r]) & 0xffff;
		r0 = (result & 0xff);
		r1 = (result & 0xff00) >> 8;
		SREG &= ~(ZFLAG|CFLAG);
		if (result == 0) SREG |= ZFLAG;
		else if ( (result & 0x8000) == 0x8000) SREG |= CFLAG;
		clockCycleCount+=1; PC+=2;
	}

inline	function _cpc(d,r) {
		sub_with_carry(ram[d], ram[r], SREG & CFLAG);
		clockCycleCount+=1; PC+=1;
	}

inline	function _sbc(d,r) {
		ram[d] = sub_with_carry(ram[d], ram[r], SREG & CFLAG);
		clockCycleCount+=1; PC+=1;
	}

inline	function _add(d,r) {
		ram[d] = add(ram[d], ram[r]);
		clockCycleCount+=1; PC+=1;
	}

inline	function _cpi(d,k) {	
		SREG |= ZFLAG;
		sub(ram[d], k);
		clockCycleCount+=1; PC+=1;
	}

inline	function _sbci(d,k) {
		ram[d]=sub_with_carry(ram[d], k, SREG & CFLAG);
		clockCycleCount+=1; PC+=1;				
	}

inline	function _subi(d,k) {
		ram[d]=sub(ram[d], k);
		clockCycleCount+=1; PC+=1;				
	}

inline	function _ori(d,k) {
		ram[d]=ram[d] | k;
		setFlagsFromLogicResult(ram[d]);				
		clockCycleCount+=1; PC+=1;
	}
inline	function _andi(d,k)	{
		ram[d]=ram[d] & k;
		setFlagsFromLogicResult(ram[d]);								
		clockCycleCount+=1; PC+=1;
	}

inline	function _std_y(q,d) {
		memStore(Y + q, ram[d]);
		clockCycleCount+=2; PC+=1;
	}

inline	function _std_z(q,d) {
		memStore(Z + q, ram[d]);
		clockCycleCount+=2; PC+=1;
	}

inline	function _ldd_y(d,q) {	
		ram[d] = memLoad(Y + q);
		clockCycleCount+=2; PC+=1;
	}

inline	function _ldd_z(d,q) {	
		ram[d] = memLoad(Z + q);
		clockCycleCount+=2; PC+=1;
	}

inline	function _in(d,a) {
		ram[d] = memLoad(a + 32);
		clockCycleCount+=1; PC+=1;
	}

inline	function _out(a,d) {
		memStore(a + 32,ram[d]);
		clockCycleCount+=1; PC+=1;
	}

inline	function _rjmp(k,_) {
		var nextPC = PC + k + 1;
		clockCycleCount+=2; PC=nextPC;
	}

inline	function _rcall(k,_) {
		var nextPC = PC + k + 1;
		push16(PC + 1);
		clockCycleCount+=3; PC=nextPC;
	}

inline	function _ldi(d,k) {
		ram[d] = k;
		clockCycleCount+=1; PC+=1;				
	}

inline	function _brbs(bit,k) {
		if ((SREG & bit)!=0) {
			PC=PC+k+1;
			clockCycleCount+=2;
		} else {
			PC+=1;
			clockCycleCount+=1;
		}
	}

inline	function _brbc(bit,k) {
		if ((SREG & bit)==0) {
			PC=PC+k+1;
			clockCycleCount+=2;
		} else {
			PC+=1;
			clockCycleCount+=1;
		}
	}

inline	function _bld(d,bit) {
		if ( (SREG & TFLAG) != 0) {
			ram[d] |= bit;
		} else {
			ram[d] &= ~bit;								
		}
		PC+=1;
		clockCycleCount+=1;
	}

inline	function _bst(d,bit) {
		if ( (ram[d] & bit) != 0) {
			SREG |= ZFLAG;
		} else {
			SREG &= ~ZFLAG;
		}
		PC+=1;
		clockCycleCount+=1;
	}

inline	function _sbrc(d,bit) {
		if ( (ram[d] & bit) == 0) {
			var skipLength = instructionLength(progMem[PC + 1]);
			PC += 1 +skipLength;
			clockCycleCount+= 1 + skipLength;							
		}
		else { clockCycleCount+=1;	PC+=1; }
	}

inline	function _sbrs(d,bit) {
		if ( (ram[d] & bit) != 0) {
			var skipLength = instructionLength(progMem[PC + 1]);
			PC += 1 +skipLength;
			clockCycleCount+= 1 + skipLength;							
		}
		else { clockCycleCount+=1;	PC+=1; }
	}

inline	function _lds(d,_){
		var k = progMem[PC + 1];
		ram[d] = memLoad(k);
		clockCycleCount+=2; PC+=2;
	}

inline	function _ld_z_p(d,_) {
		//LD Rd,Z+
		ram[d] = memLoad(Z);
		Z += 1;								
		clockCycleCount+=2; PC+=1;								
	}	


inline	function _ld_p_z(d,_) {
		//LD Rd,-Z
		Z -= 1;
		ram[d] = memLoad(Z);
		clockCycleCount+=2; PC+=1;								
	}

inline	function _lpm_z (d,_) {
		//LPM Rd,Z
		ram[d] = progMemAsBytes[Z];
		clockCycleCount+=3; PC+=1;								
	}

inline	function _lpm_z_p (d,_) {
		//LPM Rd,Z+
		ram[d] = progMemAsBytes[Z];
		Z += 1;		
		clockCycleCount+=3; PC+=1;								
	}

inline	function _elpm_z (d,_) {
		//ELPM Rd,Z
		ram[d] = progMemAsBytes[(RAMPZ << 16) | Z];
		clockCycleCount+=3; PC+=1;								
	}

inline	function _elpm_z_p (d,_) {								
		//ELPM Rd,Z+
		ram[d] = progMemAsBytes[(RAMPZ << 16) | Z];
		Z += 1; if (Z == 0) RAMPZ += 1;
		clockCycleCount+=3; PC+=1;								
	}

inline	function _ld_y_p (d,_) {
		//LD Rd,Y+
		ram[d] = memLoad(Y);
		Y += 1;
		clockCycleCount+=2; PC+=1;								
	}

inline	function _ld_p_y (d,_) {
		//LD Rd,-Y
		Y -= 1;
		ram[d] = memLoad(Y);
		clockCycleCount+=2; PC+=1;								
	}

inline	function _ld_x (d,_) {
		//LD Rd,X
		ram[d] = memLoad(X);
		clockCycleCount+=2; PC+=1;								
	}
	

inline	function _ld_x_p (d,_) {
		//LD Rd,X+
		ram[d] = memLoad(X);
		X += 1;
		clockCycleCount+=2; PC+=1;								
	}

inline	function _ld_p_x (d,_) {
		//LD Rd,-X
		X -= 1;
		ram[d] = memLoad(X);								
		clockCycleCount+=2; PC+=1;								
	}

inline	function _pop (d,_) {
		//POP
		SP += 1;
		ram[d] = ram[SP];
		clockCycleCount+=2; PC+=1;								
	}

inline	function _sts(d,_) {
		//STS k,Rd
		var k = progMem[PC + 1];
		memStore(k,ram[d]);
		clockCycleCount+=2; PC+=2;								
	}

inline	function _st_z_p(d,_) {
		//ST Z+,Rd
		memStore(Z,ram[d]);
		Z += 1;								
		clockCycleCount+=2; PC+=1;								
	}

inline	function _st_p_z(d,_) {
		//ST -Z,Rd
		Z -= 1;
		memStore(Z,ram[d]);
		clockCycleCount+=2; PC+=1;								
	}

inline	function _st_y_p(d,_) {
		//ST Y+,Rd
		memStore(Y,ram[d]);
		Y += 1;
		clockCycleCount+=2; PC+=1;								
	}

inline	function _st_p_y(d,_) {
		//ST -Y,Rd
		Y -= 1;
		memStore(Y,ram[d]);
		clockCycleCount+=2; PC+=1;								
	}

inline	function _st_x(d,_) {
		//ST X,Rd
		memStore(X,ram[d]);
		clockCycleCount+=2; PC+=1;								
	}

inline	function _st_x_p(d,_) {
		//ST X+,Rd
		memStore(X,ram[d]);
		X += 1;
		clockCycleCount+=2; PC+=1;								
	}

inline	function _st_p_x(d,_){
		//ST -X,Rd
		X -= 1;
		memStore(X,ram[d]);
		clockCycleCount+=2; PC+=1;
	}

inline	function _push(d,_) {
		//PUSH
		ram[SP]=ram[d];
		SP -= 1;
		clockCycleCount+=2; PC+=1;								
	}

inline	function _com(d,_) {
		ram[d] = 0xff - ram[d];
		SREG &= ~(SFLAG | VFLAG | NFLAG | ZFLAG);
		SREG |= CFLAG;
		if ((ram[d] & 0x80) != 0) { 	SREG |= SFLAG | NFLAG;	}
		if (ram[d] == 0) SREG |= ZFLAG;
		clockCycleCount+=1; PC+=1;
	}

inline	function _neg(d,_) {
		ram[d] = sub(0, ram[d]);
		clockCycleCount+=1; PC+=1;
	}

inline	function _swap(d,_) {
		var value = ram[d];
		ram[d] = ((value << 4) | (value >> 4)) & 0xff;
		clockCycleCount+=1; PC+=1;
	}

inline	function _inc(d,_) {
		SREG &= ~(SFLAG | VFLAG | NFLAG | ZFLAG);
		var v = ram[d] == 0x7f;
		var n = (ram[d] & 0x80) != 0; 
		ram[d] += 1;
		if (v) SREG |= VFLAG;
		if (n) SREG |= NFLAG;
		if (v != n) SREG |= NFLAG;
		if (ram[d] == 0) SREG |= ZFLAG;
		clockCycleCount+=1; PC+=1;
	}

inline	function _asr(d,_) {
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
		clockCycleCount+=1; PC+=1;
	}

inline	function _lsr(d,_) {
		var value = ram[d];
		var bit0 = value & 1;
		var newValue = (value >> 1) ;
		ram[d] = newValue;
		SREG &= ~(SFLAG | VFLAG | NFLAG | ZFLAG | CFLAG);
		if (bit0 != 0) SREG |= (CFLAG | VFLAG | SFLAG);
		if (newValue == 0) SREG |= ZFLAG;
		clockCycleCount+=1; PC+=1;
	}

inline	function _ror(d,_) {
		var value = ram[d];
		var carry = (SREG & CFLAG);
		var bit0 = value & 1;
		var newValue = (value >> 1) | carry << 7;
		ram[d] = newValue;
		SREG &= ~(SFLAG | VFLAG | NFLAG | ZFLAG | CFLAG);
		if (bit0 != 0) SREG |= (CFLAG | VFLAG | SFLAG);
		if (newValue == 0) SREG |= ZFLAG;
		clockCycleCount+=1; PC+=1;
	}

inline	function _bset(bit,_){
		SREG |= bit;
		clockCycleCount+=1; PC+=1;
	} 

inline	function _bclr(bit,_){
		SREG &= ~bit;
		clockCycleCount+=1; PC+=1;
	} 

inline	function _ret(_,__) {
		PC = pop16();
		clockCycleCount+=4;
	}

inline	function _reti(_,__) {
		PC = pop16();
		SREG |= IFLAG;
		clockCycleCount+=4;
	}

inline	function _ijmp(_,__) {
		PC = Z;
		clockCycleCount+=2;
	}

inline	function _icall(_,__) {
		push16(PC + 1);
		PC = Z;
		clockCycleCount+=3;
	}

inline	function _dec(d,_) {
		var value = ram[d]-1;
		var v = (value == 0x7f);
		var n = ((value & 0x80) != 0);
		ram[d] = value;
		SREG &= ~(SFLAG | VFLAG | NFLAG | ZFLAG);
		if (v) SREG |= VFLAG;
		if (n) SREG |= NFLAG;
		if (xor(n, v)) SREG |= SFLAG;
		if (value==0) SREG |= ZFLAG;
		clockCycleCount+=1; PC+=1;																
	}

inline	function _jmp(highBits,_) {
		var k = progMem[PC + 1];
		k |= highBits;
		clockCycleCount+=3; PC=k;
	}

inline	function _call(highBits,_) {
		var k = progMem[PC + 1];
		k |= highBits;
		push16(PC + 2);
		clockCycleCount+=4; PC=k;																
	}

inline	function _sbiw(d,k) {
		var value = ram[d] + (ram[d + 1] << 8);
		
		SREG &= ~(SFLAG | VFLAG  | NFLAG | ZFLAG | CFLAG);
		var result, v, n, z, c;

		var rdh7 = (ram[d + 1] & 0x80) != 0;

		result =  value - k;

		n = (result & 0x8000) != 0;						
		v = !n && rdh7;
		z = (result & 0xffff) == 0 ;
		c =  n && !rdh7;
		
		if (n) SREG |= NFLAG;
		if (v) SREG |= VFLAG;
		if (n != v) SREG |= SFLAG; 
		if (z) SREG |= ZFLAG;
		if (c) SREG |= CFLAG;

		ram[d] = result & 0xff;
		ram[d + 1] = (result >> 8) & 0xff;

		clockCycleCount+=2; PC+=1;
	}

inline	function _adiw(d,k) {
		var value = ram[d] + (ram[d + 1] << 8);
		
		SREG &= ~(SFLAG | VFLAG  | NFLAG | ZFLAG | CFLAG);
		var result, v, n, z, c;

		var rdh7 = (ram[d + 1] & 0x80) != 0;

		result =  value + k;

		n = (result & 0x8000) != 0;						
		v = n && !rdh7;
		z = (result & 0xffff) == 0 ;
		c = !n && rdh7;
		
		if (n) SREG |= NFLAG;
		if (v) SREG |= VFLAG;
		if (n != v) SREG |= SFLAG; 
		if (z) SREG |= ZFLAG;
		if (c) SREG |= CFLAG;

		ram[d] = result & 0xff;
		ram[d + 1] = (result >> 8) & 0xff;

		clockCycleCount+=2; PC+=1;
	}

	inline function _mul(d,r) {
		var product = ram[d] * ram[r];

		r0 = (product & 0xff);
		r1 = ((product >> 8) & 0xff);

		SREG &= ~(CFLAG | ZFLAG);
		if ( (product & 0x8000) != 0) SREG |= CFLAG;
		if (product == 0) SREG |= ZFLAG;
		clockCycleCount+=2; PC+=1;																
	}

	inline function _fmuls(_,__) {
		trace("mulsu, fmul, fmuls, fmulsu unimplemented");
	}

	inline function _sleep(_,__) {
		traceInstruction('sleep not implemented');
	}

	inline function _break(_,__) {
		traceInstruction('break not implemented');
	}

	inline function _wdr(_,__) {
		traceInstruction('wdr not implemented');
	}

	inline function _spm_z(_,__) {
		traceInstruction('spm not implemented');
	}

	inline function _spm_z_p(_,__) {
		traceInstruction('spm Z+ not implemented');										
	}

	inline function _eijmp(_,__) {
		traceInstruction('eijmp not implemented');
	}

	inline function _eicall(_,__) {
		traceInstruction('eicall not implemented');										
	}

	inline function _no_bitio(_,__) {
		trace("cbi sbic sbi sbis unimplemented");
	}

	inline function _not_an_instruction(a,b) {
		traceInstruction('not an instruction !?!');
	}

	function apply2(opcode:Instruction,a,b) : DecodedInstructionFunction {
		var fn = instructionFunctions[opcode];
		var unbound = untyped __js__('{0}.method',fn);
		return {fn:unbound,a:a,b:b}; 
	}

	function simpleDecode(opcode:Instruction,a,b) : DecodedInstruction {
		return {opcode:opcode,a:a,b:b};
	}

	function decodeInstruction(instruction, format : Dynamic) : Dynamic {
		switch (instruction & 0xf000) {
			case 0x0000: {  //nop movw muls mulsu fmul fmuls fmulsu cpc sbc add 
			switch (instruction & 0x0c00) { 
				case 0x0000: {
					switch (instruction & 0xff00) {
						case 0x0000: {  
							return format(Instruction.nop,0,0);
						}						
						case  0x0100: { //movw
							var d = (instruction & 0x00f0) >> 4;
							var r = (instruction & 0x000f);
							return format(Instruction.movw,d,r);
						}
						case 0x0200: { //muls
							var d = 16+(instruction & 0x00f0) >> 4;
							var r = 16+(instruction & 0x000f);
							return format(Instruction.muls,d,r);
						}
						case 0x0300: { //mulsu, fmul, fmuls, fmulsu
							return format(Instruction.fmuls,0,0);
						}
					}
				}
				case 0x0400: { //cpc
					var d = (instruction & 0x01f0) >> 4;
					var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
					return format(Instruction.cpc,d,r);
				}
				case 0x0800: { //sbc
					var d = (instruction & 0x01f0) >> 4;
					var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
					return format(Instruction.sbc,d,r);
				}
				case 0x0c00: { //add
					var d = (instruction & 0x01f0) >> 4;
					var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
					return format(Instruction.add,d,r);
				}
			}
			throw "shouldn't happen";
			}
			case 0x1000: { //cpse cp sub adc 
				switch (instruction & 0x0c00) { 
					case 0x0000: {
						var d = (instruction & 0x01f0) >> 4;
						var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
						return format(Instruction.cpse,d,r);
					}
					case 0x0400: { //cp					
						var d = (instruction & 0x01f0) >> 4;
						var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
						return format(Instruction.cp,d,r);
					}
					case 0x0800: { //sub
						var d = (instruction & 0x01f0) >> 4;
						var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
						return format(Instruction.sub,d,r);

					}
					case 0x0c00: { //adc
						var d = (instruction & 0x01f0) >> 4;
						var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
						return format(Instruction.adc,d,r);
					}
				}
			}
			case 0x2000: { //and eor or mov
				switch (instruction & 0x0c00) { 
					case 0x0000: {  //and
						var d = (instruction & 0x01f0) >> 4;
						var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
						return format(Instruction.and,d,r);
					}
					case 0x0400: { //eor
						var d = (instruction & 0x01f0) >> 4;
						var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
						return format(Instruction.eor,d,r);
					}
					case 0x0800: { //or
						var d = (instruction & 0x01f0) >> 4;
						var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
						return format(Instruction.or,d,r);
					}
					case 0x0c00: { //mov
						var d = (instruction & 0x01f0) >> 4;
						var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
						return format(Instruction.mov,d,r);
					}
				}
				
			}
			case 0x3000: { //cpi 
				var k = ((instruction & 0x0f00) >> 4) | (instruction & 0x000f);
				var d = 16 +  ( (instruction & 0x00f0) >> 4);

				return format(Instruction.cpi,d,k);
			}
			case 0x4000: { //sbci
				var k = ((instruction & 0x0f00) >> 4) | (instruction & 0x000f);
				var d = 16 +  ( (instruction & 0x00f0) >> 4);
				return format(Instruction.sbci,d,k);
			}
			case 0x5000: { //subi				
				var k = ((instruction & 0x0f00) >> 4) | (instruction & 0x000f);
				var d = 16 +  ( (instruction & 0x00f0) >> 4);
				return format(Instruction.subi,d,k);
			}
			case 0x6000: { //ori 
				var k = ((instruction & 0x0f00) >> 4) | (instruction & 0x000f);
				var d = 16 +  ( (instruction & 0x00f0) >> 4);
				return format(Instruction.ori,d,k);
			}
			case 0x7000: { //andi
				var k = ((instruction & 0x0f00) >> 4) | (instruction & 0x000f);
				var d = 16 +  ( (instruction & 0x00f0) >> 4);
				return format(Instruction.andi,d,k);
			}		
			case 0x8000 | 0xa000: {  // ldd std
				var q = (instruction & 0x0007) | ( (instruction & 0x0C00) >> 7) | ( (instruction  & 0x2000) >> 8 );
				var d = (instruction & 0x01f0) >> 4;
				var store = (instruction & 0x0200) != 0;
				var useY = (instruction & 0x0008) != 0;
				
				if (store) {
					if (useY) {
						return format(Instruction.std_y,q,d);
					} else {
						return format(Instruction.std_z,q,d);
					}
				} else {
					if (useY) {
						return format(Instruction.ldd_y,d,q);
					} else {
						return format(Instruction.ldd_z,d,q);
					}
				}			
			}
			case 0xb000: { //in out
				var a = (instruction & 0x000f) | ( (instruction & 0x0600) >> 5);
				var d = (instruction & 0x01f0) >> 4;
				if ( (instruction & 0x0800)==0) {
					return format(Instruction.port_in,d,a);
				} else {
					return format(Instruction.port_out,a,d);
				}
			}
			case 0xc000: { //rjmp
				var k = (instruction & 0x0fff);
				if (k > 2048) k -= 4096;
				return format(Instruction.rjmp,k,0);				
			}
			case 0xd000: { //rcall
				var k = (instruction & 0x0fff);
				if (k > 2048) k -= 4096;
				return format(Instruction.rcall,k,0);
			}
			case 0xe000: { //ldi
				var k = ((instruction & 0x0f00) >> 4) | (instruction & 0x000f);
				var d = 16 + ((instruction & 0x0f0) >> 4);
				return format(Instruction.ldi,d,k);
			}
			case 0xf000: { // bld bst sbrc sbrs  +conditional branches 
				var bit = 1 << (instruction & 0x0007);								
				if ( (instruction & 0x0800) ==0 ) {
					//it's a branch;				
					var k = (instruction & 0x03f8) >> 3;
					if (k > 63) k -= 128;						
					if ((instruction & 0x0400) == 0) {
						return format(Instruction.brbs,bit,k);
					} else {
						return format(Instruction.brbc,bit,k);
					}
				} else {
					if ( (instruction & 0x0400) == 0) {
						//bld bst
						var d = (instruction & 0x01f0) >> 4;
						if ((instruction & 0x0200) == 0) {
							//traceInstruction('BLD r$d,${instruction & 0x0007}');				
							return format(Instruction.bld,d,bit);
						} else {
							return format(Instruction.bst,d,bit);
						}
					}  else {
						//sbrc sbrs
						var d = (instruction & 0x01f0) >> 4;
						if ((instruction & 0x0200) == 0) {
							return format(Instruction.sbrc,d,bit);
						} else {
							return format(Instruction.sbrs,d,bit);
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
								return format(Instruction.lds,d,0);
							}								
							case 0x9001: {			
								return format(Instruction.ld_z_p,d,0);		
							}
							case 0x9002: {								
								return format(Instruction.ld_p_z,d,0);		
							}
							case 0x9003: {
								return format(Instruction.not_an_instruction,0,0);
							}
							case 0x9004: {
								return format(Instruction.lpm_z,d,0);		
							}
							case 0x9005: {
								return format(Instruction.lpm_z_p,d,0);		
							}
							case 0x9006: {
								return format(Instruction.elpm_z,d,0);		
							}								
							case 0x9007: {
								return format(Instruction.elpm_z_p,d,0);		
							}
							case 0x9008: {
								return format(Instruction.not_an_instruction,0,0);
							}
							case 0x9009: {								
								return format(Instruction.ld_y_p,d,0);		
							}
							case 0x900A: {
								return format(Instruction.ld_p_y,d,0);		
							}
							case 0x900B: {
								return format(Instruction.not_an_instruction,0,0);
							}
							case 0x900C: {
								return format(Instruction.ld_x,d,0);		
							}
							case 0x900D: {
								return format(Instruction.ld_x_p,d,0);		
							}
							case 0x900E: {
								return format(Instruction.ld_p_x,d,0);		
							}
							case 0x900F: {
								return format(Instruction.pop,d,0);		
							}
						}
					}
					case 0x9200: { //sts st push
						var d = (instruction & 0x01f0) >> 4;
						switch (instruction & 0xfe0f) {
							case 0x9200: {
								return format(Instruction.sts,d,0);
							}								
							case 0x9201: {
								return format(Instruction.st_z_p,d,0);
							}
							case 0x9202: {
								return format(Instruction.st_p_z,d,0);
							}
							case 0x9209: {								
								return format(Instruction.st_y_p,d,0);
							}
							case 0x920A: {
								return format(Instruction.st_p_y,d,0);
							}
							case 0x920C: {
								return format(Instruction.st_x,d,0);
							}
							case 0x920D: {
								return format(Instruction.st_x_p,d,0);
							}
							case 0x920E: {
								return format(Instruction.st_p_x,d,0);
							}
							case 0x920F: {
								return format(Instruction.push,d,0);
							}
							default : {
								return format(Instruction.not_an_instruction,0,0);
							}
 
						}
						
					}
					case 0x9400: { 	// com neg swap inc asr lsr ror dec jmp call bset 
									// ijmp eijmp bclr ret icall reti eicall sleep break 
									// wdr   lpm R0,Z    elpm R0   spm
						switch (instruction & 0xfe0f) {
							case 0x9400: { //com 
								var d = (instruction & 0x01f0) >> 4;
								return format(Instruction.com,d,0);
							}
							case 0x9401: { //neg 
								var d = (instruction & 0x01f0) >> 4;
								return format(Instruction.neg,d,0);
							}
							case 0x9402: { //swap
								var d = (instruction & 0x01f0) >> 4;
								return format(Instruction.swap,d,0);
							}
							case 0x9403: { //inc
								var d = (instruction & 0x01f0) >> 4;
								return format(Instruction.inc,d,0);
							}
							case 0x9404: { // no instruction for this !?!
								return format(Instruction.not_an_instruction,0,0);
							}
							case 0x9405: { //asr							
								var d = (instruction & 0x01f0) >> 4;
								return format(Instruction.asr,d,0);
							}
							case 0x9406: { //lsr
								var d = (instruction & 0x01f0) >> 4;
								return format(Instruction.lsr,d,0);
							}
							case 0x9407: { //ror
								var d = (instruction & 0x01f0) >> 4;
								return format(Instruction.ror,d,0);
							}
							case 0x9408: { // bset bclr ret reti sleep break  wdr   lpm R0,Z    elpm R0   spm
								if ( (instruction & 0xff0f) == 0x9408 ) { // bset bclr
									var bit = 1 << ( (instruction & 0x0030) >> 4);
									if ( (instruction & 0x0040 == 0) ) {
										return format(Instruction.bset, bit,0);
									} else {
										return format(Instruction.bclr, bit,0);
									}								
								} else switch (instruction) {
									case 0x9508: { // ret
										return format(Instruction.ret, 0,0);
									}
									case 0x9518: { // reti
										return format(Instruction.reti, 0,0);
									}
									case 0x9588: { //sleep
										return format(Instruction.sleep, 0,0);										
									}
									case 0x9598: { //break
										return format(Instruction.breakpoint, 0,0);
									}
									case 0x95a8: { //wdr
										return format(Instruction.wdr, 0,0);
									}
									case 0x95C8: { //lpm R0,Z
										return format(Instruction.lpm_z, 0,0);
									}
									case 0x95d8: { //elpm R0
										return format(Instruction.elpm_z, 0,0);
									}
									case 0x95e8: { // spm
										return format(Instruction.spm_z, 0,0);
										
									}
									case 0x95f8: { // spm Z+
										return format(Instruction.spm_z_p, 0,0);
									}
									default: { 
										return format(Instruction.not_an_instruction,0,0);
									}
								}
							}
							case 0x9409: { // ijmp eijmp icall eicall 
								switch (instruction) {
									case 0x9409: {  // ijmp
										return format(Instruction.ijmp, 0,0);
									}
									case 0x9419: { //eijmp
										return format(Instruction.eijmp, 0,0);
									}
									case 0x9509: { //icall
										return format(Instruction.icall, 0,0);
									}
									case 0x9519: { //eicall
										return format(Instruction.eicall, 0,0);
									}
									default: { 
										return format(Instruction.not_an_instruction,0,0);
									}
								}
							}
							case 0x940A: { // dec
								var d = (instruction & 0x01f0) >> 4;
								return format(Instruction.dec, d,0);
							}
							case 0x940b: { // DES it seems
								return format(Instruction.not_an_instruction,0,0);
							}
							case 0x940C | 0x940D: { //  jmp
								var highBits = (instruction & 0x01f0) << 13 | (instruction & 1) << 16;
								return format(Instruction.jmp, highBits,0);
							}
							case 0x940E | 0x940F: { //  call
								var highBits = (instruction & 0x01f0) << 13 | (instruction & 1) << 16;
								return format(Instruction.call, highBits,0);
							}
						}
					}
					case 0x9600: {  // addiw sbiw
						var d = ((instruction & 0x0030) >> 3) + 24;
						var k = ((instruction & 0x00C0) >> 2) | (instruction & 0x000f);
						var sub = (instruction & 0x0100) == 0x0100;

						if (sub) {
							return format(Instruction.sbiw,d,k);
						} else {
							return format(Instruction.adiw,d,k);
						}
					}
					case 0x9800: { // cbi sbic
						return format(Instruction.no_bitio,0,0);
					}
					case 0x9a00: { // sbi sbis
						return format(Instruction.no_bitio,0,0);

					}
					case 0x9c00 | 0x9e00: { // mul
						var d = (instruction & 0x01f0) >> 4;
						var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
						return format(Instruction.mul,d,r);
					}
				}
			}
			default: {
				throw "shouldn't happen " + instruction;
			}
		}
		
		throw "shouldn't happen" + instruction;
	}


	public function compareExecutionModes() {
		var initialState = new Uint8Array(65536);
		initialState.set(ram);
		var initialPC = PC;

		exec();

		var aState = new Uint8Array(65536);
		aState.set(ram);
		var aPC = PC;

		ram.set(initialState);
		PC=initialPC;

		tableExec();

		var bState = new Uint8Array(65536);
		bState.set(ram);
		var bPC = PC;

		ram.set(initialState);
		PC=initialPC;

		if (aPC != bPC) {
			trace("program counter different after instuction at "+hereString());
			return;
		}
		for (i in 0...65535) {
			if (aState[i] != bState[i] ) {
				trace("memory different at "+i+" after instuction at "+hereString());
				return;
			}
		}
	}

	inline function decodeCacheExec() {
		var ins=decodedProgram[PC];

		execDecodedInstruction(ins.opcode,ins.a,ins.b);

		//untyped __js__('{0}.fn.call(this,{0}.a,{0}.b)',ins);

	}
	public inline function tableExec() {
		var ins=table[progMem[PC]];
		untyped __js__('{0}.fn.call(this,{0}.a,{0}.b)',ins);
		//ins.fn(ins.a,ins.b);

	}
#end

	public function exec() {
		var clocks = 1; //probably one clock
 		nextPC= PC + 1; //probably one word
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
							  //traceInstruction('MOVW r${d*2}:r${d*2+1},r${r*2}:r${r*2+1}');
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
								trace("mulsu, fmul, fmuls, fmulsu unimplemented");
							}
						}
					}
					case 0x0400: { //cpc
						var d = (instruction & 0x01f0) >> 4;
						var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
						//traceInstruction('CPC r$d,r$r');
						sub_with_carry(ram[d], ram[r], SREG & CFLAG);
					}
					case 0x0800: { //sbc
						var d = (instruction & 0x01f0) >> 4;
						var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
						//traceInstruction('SBC r$d,r$r');
						ram[d] = sub_with_carry(ram[d], ram[r], SREG & CFLAG);
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
						sub(ram[d], ram[r]);
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
				ram[d]=sub_with_carry(ram[d], k, SREG & CFLAG);
				
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
				var q = (instruction & 0x0007) | ( (instruction & 0x0C00) >> 7) | ( (instruction  & 0x2000) >> 8 );
				var d = (instruction & 0x01f0) >> 4;
				var store = (instruction & 0x0200) != 0;
				var useY = (instruction & 0x0008) != 0;
				
				if (store) {
					if (useY) {
						//traceInstruction(' STD Y+$q,r$d');
						memStore(Y + q, ram[d]);
					} else {
						//traceInstruction(' STD Z+$q,r$d');
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
								traceInstruction('not an instruction !?!');
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
										traceInstruction('sleep not implemented');
										
									}
									case 0x9598: { //break
										traceInstruction('break not implemented');
										
									}
									case 0x95a8: { //wdr
										traceInstruction('wdr not implemented');
										
									}
									case 0x95C8: { //lpm R0,Z
										r0 = progMemAsBytes[Z];										
									}
									case 0x95d8: { //elpm R0
										r0 = progMemAsBytes[RAMPZ<<16+Z];										
									}
									case 0x95e8: { // spm
										traceInstruction('spm not implemented');
										
									}
									case 0x95f8: { // spm Z+
										traceInstruction('spm Z+ not implemented');										
									}
								}
							}
							case 0x9409: { // ijmp eijmp icall eicall 
								switch (instruction) {
									case 0x9409: {  // ijmp
										nextPC = Z;
									}
									case 0x9419: { //eijmp
										traceInstruction('eijmp not implemented');
									}
									case 0x9509: { //icall
										push16(PC + 1);
										nextPC = Z;									
									}
									case 0x9519: { //eicall
										traceInstruction('eicall not implemented');										
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
						var d = ((instruction & 0x0030) >> 3) + 24;
						var k = ((instruction & 0x00C0) >> 2) | (instruction & 0x000f);
						var sub = (instruction & 0x0100) == 0x0100;
						var value = ram[d] + (ram[d + 1] << 8);
						
						SREG &= ~(SFLAG | VFLAG  | NFLAG | ZFLAG | CFLAG);
						var result, v, n, z, c;

						var rdh7 = (ram[d + 1] & 0x80) != 0;

						if ( sub ) {
							//trace ('SUBIW $d,$k');
							result =  value - k;

							n = (result & 0x8000) != 0;						
							v = !n && rdh7;
							z = (result & 0xffff) == 0 ;
							c =  n && !rdh7;

						} else {
							result =  value + k;

							n = (result & 0x8000) != 0;						
							v = n && !rdh7;
							z = (result & 0xffff) == 0 ;
							c = !n && rdh7;

						}
						
						if (n) SREG |= NFLAG;
						if (v) SREG |= VFLAG;
						if (n != v) SREG |= SFLAG; 
						if (z) SREG |= ZFLAG;
						if (c) SREG |= CFLAG;

						ram[d] = result & 0xff;
						ram[d + 1] = (result >> 8) & 0xff;
						

					}
					case 0x9800: { // cbi sbic
						trace("cbi sbic unimplemented");
					}
					case 0x9a00: { // sbi sbis
					  trace("sbi sbis unimplemented");	
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

		/*
		for (i in 0...50) {
			compareExecutionModes();
			exec();
		}
		return;
		*/
#if InstructionTable
		if (decodeCacheUpdateRequired) updateDecodeCache();
#end
		var endTime = clockCycleCount + clockCycles;
		for (i in 0...1000000000) {		
			//decodeCacheExec();
			//tableExec();
			exec();
			if (breakPoints[PC]!=0) break;
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
	
	
	
	
	public function disassemble(memLocation : UInt) : String {
		function hex2(value) {	return "0x" + StringTools.hex(value, 2);	}
		function hex4(value) {	return "0x" + StringTools.hex(value, 4);	}
		if (memLocation > progMem.length) return "_not_in_range_";
		var instruction = progMem[memLocation];
		var result : String = 'Unknown Instruction ${hex4(instruction)}';
		
		switch (instruction & 0xf000) {
			case 0x0000: {  //nop movw muls mulsu fmul fmuls fmulsu cpc sbc add 
				switch (instruction & 0x0c00) { 
					case 0x0000: {
						switch (instruction & 0xff00) {
							case 0x0000: {  //nop
							  result = "NOP";
							}
							case  0x0100: { //movw
							  var d = (instruction & 0x00f0) >> 4;
							  var r = (instruction & 0x000f);
							  result='MOVW r${d*2},r${r*2}';							  
							}
							case 0x0200: { //muls
							  var d = 16+(instruction & 0x00f0) >> 4;
							  var r = 16+(instruction & 0x000f);
							  result='MULS r$d,r$r';
							}
							case 0x0300: { //mulsu, fmul, fmuls, fmulsu
								result =("(F)MUL(S)(U)");
							}
						}
					}
					case 0x0400: { //cpc
						var d = (instruction & 0x01f0) >> 4;
						var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
						result = 'CPC r$d,r$r';						
					}
					case 0x0800: { //sbc
						var d = (instruction & 0x01f0) >> 4;
						var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
						result ='SBC r$d,r$r';
					}
					case 0x0c00: { //add
						var d = (instruction & 0x01f0) >> 4;
						var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
						result = 'ADD r$d,r$r   ${ram[d]} + ${ram[r]} ';
					}
				}
			}
			case 0x1000: { //cpse cp sub adc 
				switch (instruction & 0x0c00) { 
					case 0x0000: {  //cpse
						var d = (instruction & 0x01f0) >> 4;
						var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
						result = 'CPSE r$d,r$r';
					}
					case 0x0400: { //cp					
						var d = (instruction & 0x01f0) >> 4;
						var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
						result = 'CP r$d,r$r';
					}
					case 0x0800: { //sub
						var d = (instruction & 0x01f0) >> 4;
						var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
						result= 'SUB r$d,r$r';
					}
					case 0x0c00: { //adc
						var d = (instruction & 0x01f0) >> 4;
						var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
						result ='ADC r$d,r$r';
					}
				}
			}
			case 0x2000: { //and eor or mov
				var d = (instruction & 0x01f0) >> 4;
				var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
				switch (instruction & 0x0c00) { 
					case 0x0000: {  //and
						result='AND r$d,r$r';
					}
					case 0x0400: { //eor
						result='EOR r$d,r$r';
					}
					case 0x0800: { //or
						result='OR r$d,r$r';
					}
					case 0x0c00: { //mov
						result='MOV r$d,r$r';
					}
				}
			}
			case 0x3000: { //cpi 
				var k = ((instruction & 0x0f00) >> 4) | (instruction & 0x000f);
				var d = 16 +  ( (instruction & 0x00f0) >> 4);
				result='CPI r$d,#$k';
			}
			case 0x4000: { //sbci
				var k = ((instruction & 0x0f00) >> 4) | (instruction & 0x000f);
				var d = 16 +  ( (instruction & 0x00f0) >> 4);
				result='SBCI r$d,#$k';
			}
			case 0x5000: { //subi				
				var k = ((instruction & 0x0f00) >> 4) | (instruction & 0x000f);
				var d = 16 +  ( (instruction & 0x00f0) >> 4);
				result = 'SUBI r$d,#$k';
			}
			case 0x6000: { //ori 
				var k = ((instruction & 0x0f00) >> 4) | (instruction & 0x000f);
				var d = 16 +  ( (instruction & 0x00f0) >> 4);
				result='ORI r$d,#$k';
			}
			case 0x7000: { //andi
				var k = ((instruction & 0x0f00) >> 4) | (instruction & 0x000f);
				var d = 16 +  ( (instruction & 0x00f0) >> 4);
				result='ANDI r$d,#$k';
			}		
			case 0x8000 | 0xa000: {  // ldd std
				var q = (instruction & 0x0007) | ( (instruction & 0x0C00) >> 7) | ( (instruction  & 0x2000) >> 8 );
				var d = (instruction & 0x01f0) >> 4;
				var store = (instruction & 0x0200) != 0;
				var useY = (instruction & 0x0008) != 0;
				
				if (store) {
					if (useY) {
						result='STD Y+$q,r$d,';
					} else {
						result='STD Z+$q,r$d,';
					}
				} else {
					if (useY) {
						result='LDD r$d,Y+$q';
					} else {
						result='LDD r$d,Z+$q';
					}
				}
			}
			case 0xb000: { //in out
				var a = (instruction & 0x000f) | ( (instruction & 0x0600) >> 5);
				var d = (instruction & 0x01f0) >> 4;
				if ( (instruction & 0x0800)==0) {
					result = 'IN r$d,${hex2(a)}';
				} else {
					result='OUT ${hex2(a)},r$d';
				}
			}
			case 0xc000: { //rjmp
				var k = (instruction & 0x0fff);
				if (k > 2048) k -= 4096;
				result='RJMP ${hex4((memLocation+k+1)*2)}';
			}
			case 0xd000: { //rcall
				var k = (instruction & 0x0fff);
				if (k > 2048) k -= 4096;
				result='RCALL ${hex4((memLocation+k+1)*2)}';				
			}
			case 0xe000: { //ldi
				var k = ((instruction & 0x0f00) >> 4) | (instruction & 0x000f);
				var d = 16 + ((instruction & 0x0f0) >> 4);
				result='LDI r$d,$k';
			}
			case 0xf000: { // bld bst sbrc sbrs  +conditional branches 
				var conditionCode = (instruction & 0x0007);
				var clearCodes  = ['CC', 'NE', 'PL', 'VC', 'GE', 'HC', 'TC', 'ID'];
				var setCodes = ['CS', 'EQ', 'MI', 'VS', 'LT', 'HS', 'TS', 'IE'];

				
				if ( (instruction & 0x0800) ==0 ) {
					//it's a branch;				
					var currentCode = (((instruction & 0x0400) != 0) ? clearCodes : setCodes)[conditionCode];  
					var k = (instruction & 0x03f8) >> 3;
					if (k > 63) k -= 128;
					result = 'BR$currentCode ${hex4((memLocation +k +1)*2)}';
				} else {
					if ( (instruction & 0x0400) == 0) {
						//bld bst
						var d = (instruction & 0x01f0) >> 4;
						if ((instruction & 0x0200) == 0) {
							result ='BLD r$d,${instruction & 0x0007}';				
						} else {
							result='BST r$d,${instruction & 0x0007} may be emulated wrong, check it';				
						}
					}  else {
						//sbrc sbrs
						var d = (instruction & 0x01f0) >> 4;
						var skipOnClear = ((instruction & 0x0200) == 0);
						result = (skipOnClear?'SBRC':'SBRS') + 'r$d,${instruction & 0x0007}';
					}
				}
			}
			case 0x9000: {
				switch (instruction & 0xfe00) {
					case 0x9000: { //lds   ld   lpm  elpm  pop
						var d = (instruction & 0x01f0) >> 4;
						switch (instruction & 0xfe0f) {
							case 0x9000: {
								var k = progMem[memLocation + 1];
								result = 'LDS r$d,${hex4(k)}';
							}								
							case 0x9001: {								
								result = 'LD r$d,Z+';
							}
							case 0x9002: {								
								result = 'LD r$d,-Z';
							}
							case 0x9004: {
								result = 'LPM r$d,Z';
							}
							case 0x9005: {
								result = 'LPM r$d,Z+';
							}
							case 0x9006: {
								result = 'ELPM r$d,Z';
							}								
							case 0x9007: {
								result = 'ELPM r$d,Z+';
							}
							case 0x9009: {								
								result = 'LD r$d,Y+';
							}
							case 0x900A: {
								result = 'LD r$d,-Y';
							}
							case 0x900C: {
								result = 'LD r$d,X';
							}
							case 0x900D: {
								result = 'LD r$d,X+';
							}
							case 0x900E: {
								result = 'LD r$d,-X';
							}
							case 0x900F: {
								//POP
								result = 'POP r$d';
							}
						}
					}
					case 0x9200: { //sts st push
						var d = (instruction & 0x01f0) >> 4;
						switch (instruction & 0xfe0f) {
							case 0x9200: {
								var k = progMem[memLocation + 1];
								result = 'STS ${hex4(k)},r$d';
							}								
							case 0x9201: {								
								result = 'ST Z+,r$d';
							}
							case 0x9202: {								
								result = 'ST -Z,r$d';
							}
							case 0x9209: {								
								result = 'ST Y+,r$d';
							}
							case 0x920A: {
								result = 'ST -Y,r$d';
							}
							case 0x920C: {
								result = 'ST X,r$d';
							}
							case 0x920D: {
								result = 'ST X+,r$d';
							}
							case 0x920E: {
								result = 'ST -X,r$d';
							}
							case 0x920F: {
								result = 'PUSH r$d';
							}
						}
					}
					case 0x9400: { 	// com neg swap inc asr lsr ror dec jmp call bset 
									// ijmp eijmp bclr ret icall reti eicall sleep break 
									// wdr   lpm R0,Z    elpm R0   spm
						switch (instruction & 0xfe0f) {
							case 0x9400: { //com 
								var d = (instruction & 0x01f0) >> 4;
								result = 'COM r$d';
							}
							case 0x9401: { //neg 
								var d = (instruction & 0x01f0) >> 4;
								result = 'NEG r$d';
							}
							case 0x9402: { //swap
								var d = (instruction & 0x01f0) >> 4;
								result = 'SWAP r$d';
							}
							case 0x9403: { //inc
								var d = (instruction & 0x01f0) >> 4;
								result = 'INC r$d';
							}
							case 0x9404: { // no instruction for this !?!
								result = 'Not an Instruction?';
							}
							case 0x9405: { //asr
								var d = (instruction & 0x01f0) >> 4;
								result = 'ASR r$d';
							}
							case 0x9406: { //lsr
								var d = (instruction & 0x01f0) >> 4;
								result = 'LSR r$d';
							}
							case 0x9407: { //ror								
								var d = (instruction & 0x01f0) >> 4;
								result = 'ROR r$d';
							}
							case 0x9408: { // bset bclr ret reti sleep break  wdr   lpm R0,Z    elpm R0   spm
								if ( (instruction & 0xff0f) == 0x9408 ) { // bset bclr
									var bit = ( (instruction & 0x0030) >> 4);
									if ( (instruction & 0x0040 == 0) ) {
										result = 'BSET $bit';
									} else {
										result = 'BCLR $bit';
									}								
								} else switch (instruction) {
									case 0x9508: { // ret
										result = "RET";
									}
									case 0x9518: { // reti
										result = "RETI";
									}
									case 0x9588: { //sleep
										result = "SLEEP";
									}
									case 0x9598: { //break
										result = "BREAK";
									}
									case 0x95a8: { //wdr
										result = "WDR";
									}
									case 0x95C8: { //lpm R0,Z
										result = "LPM r0,Z";
									}
									case 0x95d8: { //elpm R0
										result = "ELPM r0,Z";
									}
									case 0x95e8: { // spm
										result = "SPM";
									}
									case 0x95f8: { // spm Z+
										result = "SPM Z+";
									}
								}
							}
							case 0x9409: { // ijmp eijmp icall eicall 
								switch (instruction) {
									case 0x9409: {  // ijmp
										result = "IJMP";
									}
									case 0x9419: { //eijmp
										result = "EIJMP";
									}
									case 0x9509: { //icall
										result = "ICALL";
									}
									case 0x9519: { //eicall
										result = "EICALL";
									}
								}
							}
							case 0x940A: { // dec
								var d = (instruction & 0x01f0) >> 4;
								result = 'DEC r$d';
							}
							case 0x940C | 0x940D: { //  jmp
								var k = progMem[memLocation + 1];								
								k |= (instruction & 0x01f0) << 13 | (instruction & 1) << 16;
								result = 'JMP ${hex4(k*2)}';
							}
							case 0x940E | 0x940F: { //  call
								var k = progMem[memLocation + 1];
								k |= (instruction & 0x01f0) << 13 | (instruction & 1) << 16;
								result = 'CALL ${hex4(k*2)}';
							}
						}
					}
					case 0x9600: {  // addiw sbiw
						var d = ((instruction & 0x0030) >> 3) + 24;
						var k = (instruction & 0x00C0) >> 2 | (instruction & 0x000f);
						var sub = (instruction & 0x0100) == 0x0100;
						
						result = '${sub?"SUB":"ADD"}IW r$d,$k';
					}
					case 0x9800: { // cbi sbic
						result="cbi sbic unimplemented";
					}
					case 0x9a00: { // sbi sbis
					  result="sbi sbis unimplemented";	
					}
					case 0x9c00 | 0x9e00: { // mul
						var d = (instruction & 0x01f0) >> 4;
						var r = (instruction & 0x0200) >> 5 | (instruction & 0x000f);
						result = 'MUL r$d,r$r';
					}
				}
			}
			default: {
				throw "shouldn't happen";
			}
		}

		return result;
	}


#if InstructionTable
	function execDecodedInstruction(opcode,a,b) {

		switch (opcode) {
			case Instruction.nop: _nop(a,b);
			case Instruction.cpse: _cpse(a,b);
			case Instruction.cp: _cp(a,b);
			case Instruction.sub: _sub(a,b);
			case Instruction.adc: _adc(a,b);
			case Instruction.and: _and(a,b);
			case Instruction.eor: _eor(a,b);
			case Instruction.or: _or(a,b);
			case Instruction.mov: _mov(a,b);
			case Instruction.movw: _movw(a,b);
			case Instruction.muls: _muls(a,b);
			case Instruction.cpc: _cpc(a,b);
			case Instruction.sbc: _sbc(a,b);
			case Instruction.add: _add(a,b);
			case Instruction.cpi: _cpi(a,b);
			case Instruction.sbci: _sbci(a,b);
			case Instruction.subi: _subi(a,b);
			case Instruction.ori: _ori(a,b);
			case Instruction.andi: _andi(a,b);
			case Instruction.std_y: _std_y(a,b);
			case Instruction.std_z: _std_z(a,b);
			case Instruction.ldd_y: _ldd_y(a,b);
			case Instruction.ldd_z: _ldd_z(a,b);
			case Instruction.port_in: _in(a,b);
			case Instruction.port_out: _out(a,b);
			case Instruction.rjmp: _rjmp(a,b);
			case Instruction.rcall: _rcall(a,b);
			case Instruction.ldi: _ldi(a,b);
			case Instruction.brbs: _brbs(a,b);
			case Instruction.brbc: _brbc(a,b);
			case Instruction.bld: _bld(a,b);
			case Instruction.bst: _bst(a,b);
			case Instruction.sbrc: _sbrc(a,b);
			case Instruction.sbrs: _sbrs(a,b);
			case Instruction.lpm_z: _lpm_z(a,b);
			case Instruction.lpm_z_p: _lpm_z_p(a,b);
			case Instruction.elpm_z: _elpm_z(a,b);
			case Instruction.elpm_z_p: _elpm_z_p(a,b);
			case Instruction.lds: _lds(a,b);
			case Instruction.ld_z_p: _ld_z_p(a,b);
			case Instruction.ld_p_z: _ld_p_z(a,b);
			case Instruction.ld_y_p: _ld_y_p(a,b);
			case Instruction.ld_p_y: _ld_p_y(a,b);
			case Instruction.ld_x: _ld_x(a,b);
			case Instruction.ld_x_p: _ld_x_p(a,b);
			case Instruction.ld_p_x: _ld_p_x(a,b);
			case Instruction.pop: _pop(a,b);
			case Instruction.sts: _sts(a,b);
			case Instruction.st_z_p: _st_z_p(a,b);
			case Instruction.st_p_z: _st_p_z(a,b);
			case Instruction.st_y_p: _st_y_p(a,b);
			case Instruction.st_p_y: _st_p_y(a,b);
			case Instruction.st_x: _st_x(a,b);
			case Instruction.st_x_p: _st_x_p(a,b);
			case Instruction.st_p_x: _st_p_x(a,b);
			case Instruction.push: _push(a,b);
			case Instruction.com: _com(a,b);
			case Instruction.neg: _neg(a,b);
			case Instruction.swap: _swap(a,b);
			case Instruction.inc: _inc(a,b);
			case Instruction.asr: _asr(a,b);
			case Instruction.lsr: _lsr(a,b);
			case Instruction.ror: _ror(a,b);
			case Instruction.bset: _bset(a,b);
			case Instruction.bclr: _bclr(a,b);
			case Instruction.ret: _ret(a,b);
			case Instruction.reti: _reti(a,b);
			case Instruction.ijmp: _ijmp(a,b);
			case Instruction.icall: _icall(a,b);
			case Instruction.dec: _dec(a,b);
			case Instruction.jmp: _jmp(a,b);
			case Instruction.call: _call(a,b);
			case Instruction.sbiw: _sbiw(a,b);
			case Instruction.adiw: _adiw(a,b);
			case Instruction.mul: _mul(a,b);
			case Instruction.fmuls: _fmuls(a,b);
			case Instruction.sleep: _sleep(a,b);
			case Instruction.breakpoint: _break(a,b);
			case Instruction.wdr: _wdr(a,b);
			case Instruction.spm_z: _spm_z(a,b);
			case Instruction.spm_z_p: _spm_z_p(a,b);
			case Instruction.eijmp: _eijmp(a,b);
			case Instruction.eicall: _eicall(a,b);
			case Instruction.no_bitio: _no_bitio(a,b);
			case Instruction.not_an_instruction: _not_an_instruction(a,b);
		}
	}
#end 
}


