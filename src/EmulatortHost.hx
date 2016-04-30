package ;
import haxe.Timer;
import js.Browser;
import js.html.ButtonElement;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.DivElement;
import js.html.Document;
import js.html.ImageData;
import js.html.MouseEvent;
import js.html.Node;
import js.html.Uint8ClampedArray;
import js.html.Uint32Array;


using StringTools;

/**
 * ...
 * @author Lerc
 */
class EmulatortHost
{
	var displayCanvas : CanvasElement;
	var infoBox : DivElement;
  var display : CanvasRenderingContext2D;
	var registerBox : DivElement;
	var disassemblyView : DivElement;
	var avr : AVR8;
	
	var halted : Bool = true;
	
	var registerDiv = new Array<DivElement>();
	var pcDiv:DivElement;
	var spDiv:DivElement;
	var sregDiv:DivElement;
	var instructionDiv:DivElement;
	var clockSpeedDiv:DivElement;
	var outputDiv:DivElement;
	var displayClocksDiv:DivElement;
	
	var logDiv:DivElement;
	
	var displayGenerator : Display;
	var clocksPerDisplayUpdate : Int = 0;
	var runButton : ButtonElement;
	var stepButton : ButtonElement;
	
	var testProgram0 = ":020000020000FC\n:0C00000001E0100EFDCF603100000895FB\n:00000001FF";
	//var testProgram = ":020000020000FC\n:10000000E4E2F0E00590002011F002B8FBCFE0E060\n:10001000F0E401E00193100E112091F3FACF60316A\n:100020000000089520202068656C6C6F20776F7247\n:0E0030006C64202020000F00000D0000000076\n:00000001FF";
	var testProgram1 = ":020000020000FC\n:10000000EEE2F0E00590002011F002B8FBCFE0E056\n:10001000F0E401E015E5212D10FC229511932193C8\n:10002000100E112069F3F5CF6031000008952020F3\n:100030002068656C6C6F20776F726C6420202000E4\n:080040000F00000D000000009C\n:00000001FF";
	//var testProgram = ":020000020000FC\n:100000000FEF0DBF0FEF0EBFEAEAF0E013E02AE0BA\n:100010000590002031F002B8002D0E9421001395B8\n:10002000F7CFE0E0F0E401E015E5212D10FC22958A\n:1000300011932193100E112039F3F5CF6031000098\n:1000400008950F921F920F931F932F934F93CF9367\n:10005000DF93EF93FF93005246E0049FE4ECF0E05F\n:10006000E00DF11D40EA249FC0E0D0E4C00DD11D99\n:10007000C00DD11DC00DD11D42E0149FC00DD11D7A\n:1000800043E005900882059009824A9519F0C05610\n:10009000D040F7CFFF91EF91DF91CF914F912F910A\n:1000A0001F910F911F900F90089520202068656C7C\n:1000B0006C6F20776F726C64202020000F00000DA1\n:1000C000000000000000000000009000920082008C\n:1000D000484800000000E8E8E9E9010150AC11647B\n:1000E0008876C050032552D5504491A089710024D0\n:1000F0000000000080044900112000440092002A02\n:100100008850183C0A1180009E0C0200000000007C\n:1001100052000000180C00000000180C0000000045\n:100120000000020000480025920080444996112AF0\n:10013000D0009200D22050448005C9605044104540\n:100140008A290068CAE90049580C1144C029504462\n:1001500059448929184C0025920050445145892959\n:10016000504489698829000000040004000000044C\n:100170008004800445000204C060C06000004400A8\n:1001800082040500508C002A0004508C49B789E392\n:10019000508C599E4992508C598EC972508C49008E\n:1001A000897058444992C92A581C5904C9E0581CFE\n:1001B00059044900508C49C089724890599E49920F\n:1001C00098049200D220005C0049C4294890592527\n:1001D000499148004900C9E0C8D04BB74992C8903E\n:1001E0004BB6499B508C49928972588C590E4900E4\n:1001F000508C499289AA588CC9724992508C1144EA\n:1002000088729C0C920092004890499289724890A2\n:1002100089520225489049B65B9B489002254A9135\n:1002200048901172C005189C0025CAE0580C49007E\n:10023000C96089000224000980200101000000003B\n:040240000000E0E0FA\n:00000001FF\n";
	//var testProgram = haxe.Resource.getString("test3");
	//var testProgram = haxe.Resource.getString("minimalc"); 
	//var testProgram = haxe.Resource.getString("hello");  

		var testProgram = haxe.Resource.getString("spritish");   
	var frameBuffer : ImageData; 
	 
	var scaleBuffer : ImageData;
	
	var mouseX : Int;
	var mouseY : Int;
	var tickCounter : Int = 0;
	var timeCounter : Int = 0;
	
	public function new() 
	{
		displayCanvas = Browser.document.createCanvasElement();
		displayCanvas.addEventListener('mousemove', function(e:MouseEvent){mouseX = e.clientX; mouseY = e.clientY; });
		
		Browser.document.body.appendChild(displayCanvas);
		display = displayCanvas.getContext2d();
	
		displayCanvas.width = 480;
		displayCanvas.height = 360;
		frameBuffer=display.getImageData(0, 0, Display.frameBufferWidth, Display.frameBufferHeight);
		scaleBuffer=display.getImageData(0, 0, 480, 360);
		displayGenerator = new Display(frameBuffer);
	
		
		infoBox = Browser.document.createDivElement();
		Browser.document.body.appendChild(infoBox);
		
		registerBox = Browser.document.createDivElement();
		registerBox.className = "registerbox";
		infoBox.appendChild(registerBox);
		
		disassemblyView = makeDiv(infoBox, "disassembly");
		
		
		for (i in 0...32) {
			registerDiv[i] = makeDiv(registerBox,"register");
		}
		spDiv =makeDiv(registerBox,"register sys sp");
		pcDiv = makeDiv(registerBox, "register sys pc");
		sregDiv = makeDiv(registerBox, "register sys sreg");
		instructionDiv = makeDiv(registerBox, "register sys instruction");
		clockSpeedDiv = makeDiv(registerBox, "register sys clockSpeed");
		displayClocksDiv = makeDiv(registerBox, "register sys ");
		outputDiv = makeDiv(registerBox, "ttyoutput");
		outputDiv.textContent = "";
		clockSpeedDiv.textContent = "halted";
		runButton = Browser.document.createButtonElement();
		runButton.textContent = "Run";
		runButton.className = "run button";
		registerBox.appendChild(runButton);

		stepButton = Browser.document.createButtonElement();
		stepButton.textContent = "Step";
		stepButton.className = "step button";
		registerBox.appendChild(stepButton);

		
		logDiv = makeDiv(Browser.document.body, "log");
		logDiv.textContent = "Log\nStarted...\n ";
		avr = new AVR8();
		updateRegisterView();

		runButton.onclick = function() { halted = !halted; runButton.textContent = halted?"Run":"Stop"; if (halted) setDisassamblyView(avr.PC); };
		stepButton.onclick = function() { if (halted) avr.exec(); setDisassamblyView(avr.PC); updateRegisterView(); };

		
		var hexFile = new HexFile(testProgram);
		var totalData = 0;
		for (mem in hexFile.data) {
			avr.writeProgMem(mem.address, mem.data);
			totalData += mem.data.length;
		  //trace('added ${mem.data.length} bytes at ${mem.address}');
		}
		trace('loaded ${totalData} bytes from hex file');
		

		/* 
		// first test program 
		avr.progMem[0] = 0x1010;
		avr.progMem[1] = 0x940c;		
		avr.progMem[2] = 0x0005;
		avr.progMem[3] = 0x94c3;
		avr.progMem[4] = 0x0c0c;
		avr.progMem[5] = 0x940c;
		avr.progMem[6] = 0x0003;
		*/
		
		installPortIOFunctions();
		
		var timer = new Timer(16);
		timer.run = function() { 
			//avr.tick(40000+Math.floor(Math.random()*5)); //random fluctuations so display update and code don't strobe
			tickCounter = (tickCounter + 1) & 0xff;
			if (halted) return;
			avr.tick(130000);
			//avr.tick(320);
			updateRegisterView();
			//renderMode0();

		};

		var halfsecondTimer = new Timer(500);
		var lastTime = avr.clockCycleCount;
		halfsecondTimer.run = function() { 
			var clocksPassed = avr.clockCycleCount - lastTime;
			lastTime = avr.clockCycleCount;
			timeCounter = (timeCounter + 1) & 0x1ff;
			
			clockSpeedDiv.textContent = (Math.round(clocksPassed / 500) / 1000) + " MHz";	
			//renderMode0();
		};

		
	}
  
	function installPortIOFunctions() {
		var inPort = avr.inPortFunctions;
		var outPort = avr.outPortFunctions;
		
		
		outPort[0x22] = function (value) {
			var newText = (outputDiv.textContent + String.fromCharCode(value));
			outputDiv.textContent = newText.substr( -60);			
		}
		
		var lastDisplayUpdate = avr.clockCycleCount;
		var displayPort = 0x40;		
		outPort[displayPort + 0x00] = function (value) {
			switch (value) {
				
			case 1:
				var now = avr.clockCycleCount;
				clocksPerDisplayUpdate = now - lastDisplayUpdate;
				lastDisplayUpdate = now;
				display.putImageData(frameBuffer, 0, 0);			
			case 0:
				var now = avr.clockCycleCount;
				clocksPerDisplayUpdate = now - lastDisplayUpdate;				
				lastDisplayUpdate = now;
				doubleSize();
				
				display.putImageData(scaleBuffer, 0, 0);
			case 0x80:
				displayGenerator.renderMode0(avr);
			case 0x81:
				displayGenerator.renderMode1(avr,8); 
			case 0x82:
				displayGenerator.renderMode1(avr,4); 
			case 0x83:
				displayGenerator.renderMode1(avr,3); 
			case 0x84:
				displayGenerator.renderMode1(avr,2); 
			}

		}
		var modePort = displayPort + 0x08;
		outPort[modePort + 0x00] = function (value) {	displayGenerator.modeData[0] = value;	}
		outPort[modePort + 0x01] = function (value) {	displayGenerator.modeData[1] = value;	}
		outPort[modePort + 0x02] = function (value) {	displayGenerator.modeData[2] = value;	}
		outPort[modePort + 0x03] = function (value) {	displayGenerator.modeData[3] = value;	}
		outPort[modePort + 0x04] = function (value) {	displayGenerator.modeData[4] = value;	}
		outPort[modePort + 0x05] = function (value) {	displayGenerator.modeData[5] = value;	}
		outPort[modePort + 0x06] = function (value) {	displayGenerator.modeData[6] = value;	}
		outPort[modePort + 0x07] = function (value) {	displayGenerator.modeData[7] = value;	}

		outPort[displayPort + 0x01] = function (value) {
		  displayGenerator.displayShiftX = (value >> 4) & 0xf;
		  displayGenerator.displayShiftY = value & 0xf;
		}

		outPort[displayPort + 0x02] = function (value) {
		  displayGenerator.serialPixelAddress = (displayGenerator.serialPixelAddress & 0xffff00) | (value & 0xff);
		}
		outPort[displayPort + 0x03] = function (value) {
		  displayGenerator.serialPixelAddress = (displayGenerator.serialPixelAddress & 0xff00ff) | ((value & 0xff) << 8);
		}
		outPort[displayPort + 0x04] = function (value) {

		  displayGenerator.serialPixelAddress = (displayGenerator.serialPixelAddress & 0x00ffff) | ((value & 0xff) <<16);
		}
		outPort[displayPort + 0x05] = function (value) {
			displayGenerator.serialSet(value);			
		}
		outPort[displayPort + 0x06] = function (value) {
			displayGenerator.serialMul(value);			
		}
		outPort[displayPort + 0x07] = function (value) {
			displayGenerator.serialAdd(value);			
		} 
		
		var inputsPort = 0x48;   // inputs overlap mode output registers
		
		inPort[inputsPort + 0x00] = function () { return 0; }
		inPort[inputsPort + 0x01] = function () { return 0; }
		inPort[inputsPort + 0x02] = function () { return (mouseX >> 1)& 0xff; }
		inPort[inputsPort + 0x03] = function () { return (mouseY >> 1)& 0xff; }
		inPort[inputsPort + 0x04] = function () { return tickCounter; }
		inPort[inputsPort + 0x05] = function () { return timeCounter>>1; }
	}
	
	public static function makeDiv(inside : Node, className : String = ""):DivElement{
			var div = Browser.document.createDivElement();
			div.className = className;
			div.innerHTML = className;
			inside.appendChild(div);
			return div;
	}
	
	public function setDisassamblyView(memLocation : UInt) {
		var output = "";
		memLocation = memLocation - 4;
		for (i in 0...16) {
			
			output += '<div class="${memLocation==avr.PC?"PC":""}">'+  StringTools.hex(memLocation*2,4) +":\t"+ avr.disassemble(memLocation) +"</div>";
			memLocation += avr.instructionLength(avr.instructionAt(memLocation));
			
		}
		disassemblyView.innerHTML = output;
	}
	
	public function updateRegisterView() {
		function flag(mask, char) {
			return (avr.SREG & mask == 0)?"_":char;
		}
		function flags() {			
			return flag(AVR8.IFLAG, "I")
				 + flag(AVR8.TFLAG, "T")
				 + flag(AVR8.HFLAG, "H")
				 + flag(AVR8.SFLAG, "S")
				 + flag(AVR8.VFLAG, "V")
				 + flag(AVR8.NFLAG, "N")
				 + flag(AVR8.ZFLAG, "Z")
				 + flag(AVR8.CFLAG, "C");
		}
		function hexreg(n) {
			return StringTools.hex(avr.ram[n], 2);
		}
		
		for (i in 0...32) {
			registerDiv[i].textContent = 'r$i : ${hexreg(i)}';
		}
		spDiv.textContent	= 'SP: ${StringTools.hex(avr.SP,4)}';
		pcDiv.textContent	= 'PC: ${StringTools.hex(avr.PC,4)}';
		sregDiv.textContent	= '${flags()}';
        displayClocksDiv.textContent = '$clocksPerDisplayUpdate';
		instructionDiv.textContent	= 'PC->${StringTools.hex(avr.progMem[avr.PC],4)}';
		
		logDiv.textContent = avr.log;
	}
	
	
	function renderMode0() {
		
		/*
		var cellsWide = 160;
		var cellsHigh = 120;
		var cellsPerLine = 160;
		var baseAddress = 0x4000;
		
		var pixelBuffer = new  Uint32Array(frameBuffer.data.buffer);
		
		for (ty in 0...cellsHigh) {
			var lineStart = ty * cellsPerLine *2 + baseAddress;
			var walk = lineStart;
			var outputStart = ty * cellsWide * 3 * 3;
			var outWalk = outputStart;
			for (tx in 0...cellsWide) {
				var cellPixels = avr.ram[walk];
				var cellAttributes = avr.ram[walk + 1];
				walk += 2;
				var a = (cellAttributes >> 4);
				var b = (cellAttributes & 0xf);

				//cellPixels = 0x55;
				var p = cellPixels;
				pixelBuffer[outWalk] = palette[a];
				pixelBuffer[outWalk+1] = palette[(p&1)==0?a:b];
				pixelBuffer[outWalk+2] = palette[(p&2)==0?a:b];

				pixelBuffer[outWalk+480] = palette[(p&4)==0?a:b];
				pixelBuffer[outWalk+480+1] = palette[(p&8)==0?a:b];
				pixelBuffer[outWalk+480+2] = palette[(p&16)==0?a:b];

				pixelBuffer[outWalk+960] = palette[(p&32)==0?a:b];
				pixelBuffer[outWalk+960+1] = palette[(p&64)==0?a:b];
				pixelBuffer[outWalk+960+2] = palette[(p&128)==0?a:b];
				
				outWalk += 3;
			}
		}
		*/
		
		//displayGenerator.renderMode0(avr);
		
		//display.putImageData(frameBuffer, 0, 0);
	}
	
	function doubleSize() {
		var sourceBuffer = new Uint32Array(frameBuffer.data.buffer);
		var destBuffer = new Uint32Array(scaleBuffer.data.buffer); 
		
		for (ty in 0...180) {
			var sourceIndex = (ty + displayGenerator.displayShiftY) *(frameBuffer.width ) + displayGenerator.displayShiftX;
			var destIndex = ty * (scaleBuffer.width * 2);
			for (tx in 0...240) {
				var pixel = sourceBuffer[sourceIndex];
				destBuffer[destIndex] = pixel;
				destBuffer[destIndex + 1] = pixel;
				destBuffer[destIndex+480] = pixel;
				destBuffer[destIndex + 481] = pixel;
				destIndex += 2;
				sourceIndex += 1;
			}
		}
	}
		
	
}