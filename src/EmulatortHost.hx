package ;

import HexFile.Chunk;
import haxe.io.Bytes;
import haxe.zip.Compress;

import haxe.Timer;
import js.Browser;
import js.html.ButtonElement;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.DivElement;
import js.html.DragEvent;
import js.html.Event;
import js.html.FileReader;
import js.html.ImageData;
import js.html.InputElement;
import js.html.KeyboardEvent;
import js.html.MouseEvent;
import js.html.Node;
import js.html.OptionElement;
import js.html.Uint32Array;


using StringTools;

/**
 * ...
 * @author Lerc
 */
class EmulatortHost extends Emulator
{
	var displayCanvas : CanvasElement;
	var infoBox : DivElement;
 	var display : CanvasRenderingContext2D;
	var registerBox : DivElement;
	var disassemblyView : DivElement;

	var halted(default,set) : Bool = true;
	var muted(default,set) : Bool = false;
	
	var registerDiv = new Array<DivElement>();
	var xDiv:DivElement;
	var yDiv:DivElement;
	var zDiv:DivElement;
	var pcDiv:DivElement;
	var spDiv:DivElement;
	var sregDiv:DivElement;
	var instructionDiv:DivElement;
	var clockSpeedDiv:DivElement;
	var outputDiv:DivElement;
	var displayClocksDiv:DivElement;
	var ttyCharacters:String="";
	var logDiv:DivElement;
	var logText: String = "";
	
	var runButton : ButtonElement;
	var stepButton : ButtonElement;
	var muteButton : ButtonElement;
	
	var breakpointInput : InputElement;
	
	//var testProgram0 = ":020000020000FC\n:0C00000001E0100EFDCF603100000895FB\n:00000001FF";
	//var testProgram = ":020000020000FC\n:10000000E4E2F0E00590002011F002B8FBCFE0E060\n:10001000F0E401E00193100E112091F3FACF60316A\n:100020000000089520202068656C6C6F20776F7247\n:0E0030006C64202020000F00000D0000000076\n:00000001FF";
	//var testProgram1 = ":020000020000FC\n:10000000EEE2F0E00590002011F002B8FBCFE0E056\n:10001000F0E401E015E5212D10FC229511932193C8\n:10002000100E112069F3F5CF6031000008952020F3\n:100030002068656C6C6F20776F726C6420202000E4\n:080040000F00000D000000009C\n:00000001FF";
	//var testProgram = ":020000020000FC\n:100000000FEF0DBF0FEF0EBFEAEAF0E013E02AE0BA\n:100010000590002031F002B8002D0E9421001395B8\n:10002000F7CFE0E0F0E401E015E5212D10FC22958A\n:1000300011932193100E112039F3F5CF6031000098\n:1000400008950F921F920F931F932F934F93CF9367\n:10005000DF93EF93FF93005246E0049FE4ECF0E05F\n:10006000E00DF11D40EA249FC0E0D0E4C00DD11D99\n:10007000C00DD11DC00DD11D42E0149FC00DD11D7A\n:1000800043E005900882059009824A9519F0C05610\n:10009000D040F7CFFF91EF91DF91CF914F912F910A\n:1000A0001F910F911F900F90089520202068656C7C\n:1000B0006C6F20776F726C64202020000F00000DA1\n:1000C000000000000000000000009000920082008C\n:1000D000484800000000E8E8E9E9010150AC11647B\n:1000E0008876C050032552D5504491A089710024D0\n:1000F0000000000080044900112000440092002A02\n:100100008850183C0A1180009E0C0200000000007C\n:1001100052000000180C00000000180C0000000045\n:100120000000020000480025920080444996112AF0\n:10013000D0009200D22050448005C9605044104540\n:100140008A290068CAE90049580C1144C029504462\n:1001500059448929184C0025920050445145892959\n:10016000504489698829000000040004000000044C\n:100170008004800445000204C060C06000004400A8\n:1001800082040500508C002A0004508C49B789E392\n:10019000508C599E4992508C598EC972508C49008E\n:1001A000897058444992C92A581C5904C9E0581CFE\n:1001B00059044900508C49C089724890599E49920F\n:1001C00098049200D220005C0049C4294890592527\n:1001D000499148004900C9E0C8D04BB74992C8903E\n:1001E0004BB6499B508C49928972588C590E4900E4\n:1001F000508C499289AA588CC9724992508C1144EA\n:1002000088729C0C920092004890499289724890A2\n:1002100089520225489049B65B9B489002254A9135\n:1002200048901172C005189C0025CAE0580C49007E\n:10023000C96089000224000980200101000000003B\n:040240000000E0E0FA\n:00000001FF\n";
	//var testProgram = haxe.Resource.getString("test3");
	//var testProgram = haxe.Resource.getString("minimalc"); 
	//var testProgram = haxe.Resource.getString("hello");  

	var testProgram = haxe.Resource.getString("inputTest");   

	var buttonsA : Int = 0;
	var buttonsB : Int = 0;
	var mouseX : Int;
	var mouseY : Int;
	var tickCounter : Int = 0;
	var timeCounter : Int = 0;
	
	var rawKeymap : Array<Bool> = [];
	var mouseButtonState : Array<Bool> = [false, false, false];
	var buttonMap : Array<Int> = [37, 38, 39, 40, 13, 27, 17, 16, 65, 87, 68, 83, 32, 90, 88, 8];
	var keyBuffer : List<Int> = new List<Int>();
	var magicPasteBufferindex = 0;
	var magicPasteBuffer:String = "(defun mid (a b) (if (and (listp a) (listp b)) (mapcar mid a b) (/ (+ a b) 2)))"
		+ "(defun tri (a b c d) (if (> d 1) (progn (tri (mid a b) (mid b c) (mid a b) (- d 1)) (tri a (mid a b) (mid a c) (- d 1) ) (tri b (mid b a) (mid b c) (- d 1) ) (tri c (mid c a) (mid c b) (- d 1)) ) ) (progn (lin a b) (lin b c) (lin c a)))" 
		+ "(defun lin (a b) (moveto a) (lineto b) ) (tri '(100 70) '(50 180) '(150 180) 4)";

	var debugContext : Dynamic = null;
	public var onUpdateDebugInfo: Dynamic -> Void = function (debug){};
	public function new() 
	{
		super();

		untyped Browser.window.breakPoint = 0xffff00;
		var combo = Browser.document.createSelectElement();
		buttonsA=0;
		buttonsB=0;
		combo.add(resourceCombo("audioTest", "Audio test"));
		combo.add(resourceCombo("blitTest", "Blit Mode test"));
		combo.add(resourceCombo("inputTest", "Input Test"));
		combo.add(resourceCombo("pixelTest", "Pixel rendering test"));
		combo.add(resourceCombo("Lisp", "uLisp"));
		
		var containerElement = Browser.document.querySelector(".emulator.host");
		containerElement.appendChild(combo);

		combo.onchange = function (e:Event) {
			loadHexFile(combo.value);
			combo.blur();
		}
		
		var playerDiv =  Browser.document.createDivElement();
		containerElement.appendChild(playerDiv);
		displayCanvas = Browser.document.createCanvasElement();
		displayCanvas.addEventListener('mousemove', function(e:MouseEvent){mouseX = e.offsetX; mouseY = e.offsetY; });
		displayCanvas.addEventListener('mousedown', function(e:MouseEvent){ mouseButtonState[e.button] = true;});
		displayCanvas.addEventListener('mouseup', function(e:MouseEvent){ mouseButtonState[e.button] = false;});
		displayCanvas.addEventListener('contextmenu', function(e:MouseEvent){ e.preventDefault(); });
		
		playerDiv.appendChild(displayCanvas);
		
		var controlPanel = Browser.document.createDivElement();
		controlPanel.className = "control panel";
		playerDiv.appendChild(controlPanel);
		
		display = displayCanvas.getContext2d();
		displayCanvas.width = 480;
		displayCanvas.height = 360;
		
		
		infoBox = Browser.document.createDivElement();
		infoBox.className = "diagnostics";
		containerElement.appendChild(infoBox);
		
		registerBox = Browser.document.createDivElement();
		registerBox.className = "registerbox";
		infoBox.appendChild(registerBox);
		
		disassemblyView = makeDiv(infoBox, "disassembly");
		
		
		for (i in 0...32) {
			registerDiv[i] = makeDiv(registerBox,"register r"+i);
		}
		registerDiv[26].classList.add("x");
		registerDiv[27].classList.add("x");
		registerDiv[28].classList.add("y");
		registerDiv[29].classList.add("y");
		registerDiv[30].classList.add("z");
		registerDiv[31].classList.add("z");
		
		xDiv = makeDiv(registerBox, "register sys sp x");
		yDiv = makeDiv(registerBox, "register sys sp y");
		zDiv = makeDiv(registerBox, "register sys sp z");
		
		spDiv =makeDiv(registerBox,"register sys sp");
		pcDiv = makeDiv(registerBox, "register sys pc");
		sregDiv = makeDiv(registerBox, "register sys sreg");
		instructionDiv = makeDiv(registerBox, "register sys instruction");
		clockSpeedDiv = makeDiv(registerBox, "register sys clockSpeed");
		displayClocksDiv = makeDiv(registerBox, "register sys displayclocks");
		outputDiv = makeDiv(registerBox, "ttyoutput");
		outputDiv.textContent = "";
		clockSpeedDiv.textContent = "halted";
		runButton = Browser.document.createButtonElement();
		runButton.textContent = "Run";
		runButton.className = "run button";
		controlPanel.appendChild(runButton);

		stepButton = Browser.document.createButtonElement();
		stepButton.textContent = "Step";
		stepButton.className = "step button";
		controlPanel.appendChild(stepButton);

		var resetButton = Browser.document.createButtonElement();
		resetButton.textContent = "Reset";
		resetButton.className = "reset button";
		controlPanel.appendChild(resetButton);
		
		breakpointInput = Browser.document.createInputElement();
		breakpointInput.placeholder = "breakpoint";
		breakpointInput.type = "text";
		breakpointInput.className = "breakpoint";
		breakpointInput.value = "";		
		registerBox.appendChild(breakpointInput);
		breakpointInput.addEventListener("input", function (e) {
			var candidate = Std.parseInt('0x' + StringTools.trim(breakpointInput.value));
			if (candidate != null) {
				untyped Browser.window.breakPoint = candidate;
			}
		});
		
		muteButton = Browser.document.createButtonElement();
		muteButton.textContent="🔈"; 
		muteButton.onclick= function() { muted= !muted; };
		controlPanel.appendChild(muteButton);

		logDiv = makeDiv(containerElement, "log");
		logDiv.textContent = "Log\nStarted...\n ";
		updateRegisterView();

		runButton.onclick = function(e) { halted = !halted; e.preventDefault(); };
		stepButton.onclick = function() { if (halted) avr.exec(); updateDebugInfo(); };
		resetButton.onclick = function (){ reset(); if (halted) {updateDebugInfo();} }; 
		loadHexFile(testProgram);
		
		displayCanvas.addEventListener("drop", handleFileDrop);
		displayCanvas.addEventListener("dragover",  function (evt) {
			evt.stopPropagation();
			evt.preventDefault();
			evt.dataTransfer.dropEffect = 'copy'; 
		});
		
		installPortIOFunctions();
		
		var halfsecondTimer = new Timer(500);
		var lastTime = avr.clockCycleCount;
		
		function floatText(f:Float) {
			var a = Math.round(f * 1000.0);
			var b = "" + a / 1000;
			return b.substr(0, 5);
		}
		halfsecondTimer.run = function() { 
			var clocksPassed = avr.clockCycleCount - lastTime;
			lastTime = avr.clockCycleCount;
			timeCounter = (timeCounter + 1) & 0x1ff;
			if (!halted) updateRegisterView();
			clockSpeedDiv.innerHTML = floatText(Math.round(clocksPassed / 500) / 1000) + "<small> MHz</small>";	
		};

		Browser.window.addEventListener("keydown", function (e : KeyboardEvent) {
			var code = e.keyCode;
			if (e.key == "PageDown") {
				magicPaste();
				e.preventDefault();
			}
			rawKeymap[code] = true;
		});

		Browser.window.addEventListener("keyup", function (e : KeyboardEvent) {
			var code = e.keyCode;
			rawKeymap[code] = false;
		});

		Browser.window.addEventListener("keypress", function (e : KeyboardEvent) {
			var code = e.keyCode;
			if (code == 0) code = e.charCode;
			
			keyBuffer.add(code);
			while (keyBuffer.length > 10) {
				keyBuffer.pop();
			}
			
			//if (e.keyCode == 0) e.preventDefault();

		});
		
	  var hexURL = getQueryVariable("hex");
		trace("hex url is : ", hexURL);
		if (hexURL != "") {
			var request=new haxe.Http(hexURL);
			request.onData = function(data) { loadHexFile(data); halted = false; };
			request.request();
		}

		Browser.window.requestAnimationFrame(handleAnimationFrame);
		
		var win : Dynamic = Browser.window;
		win.emulatorHost = this;
		
	}
  
	function getQueryVariable(variable)   {
       var query = Browser.window.location.search.substring(1);
       var vars = query.split("&");
       for (v in vars) {
               var pair = v.split("=");
               if(pair[0] == variable){return pair[1];}
       }
       return("");
}
	function resourceCombo(resource, caption):OptionElement  {		
		var result = Browser.document.createOptionElement();
		result.textContent = caption;
		result.value = haxe.Resource.getString(resource);	
		return result;
	}
	
	function magicPaste() {
		if (magicPasteBufferindex < magicPasteBuffer.length) {
			var code = magicPasteBuffer.charCodeAt(magicPasteBufferindex++);
			keyBuffer.add(code);			
		}
		
	}
	function set_muted(newValue : Bool) : Bool {
		if (newValue != muted) {
			muted = newValue;
			muteButton.textContent = muted?"🔇":"🔈"; 
			if (muted) {
				audioGenerator.stop();
			} else {
				audioGenerator.start();	
			}
		}
		return newValue;
		
	}
	function set_halted(newValue : Bool) : Bool {
		if (newValue != halted) {
			halted = newValue;
			runButton.textContent = halted?"Run":"Stop"; 
			if (halted) {
				updateDebugInfo();
				flushLog();
			} else {
				displayCanvas.focus();
			}
		}
		return newValue;
	}
	
	function handleAnimationFrame(time:Float) : Void {
		tickCounter = (tickCounter + 1) & 0xff;		
		var elapsed = time-lastFrameTimeStamp;
		lastFrameTimeStamp = time;
		var clockCyclesToEmulate = Math.floor(8000 * elapsed);
		if (clockCyclesToEmulate > 400000) clockCyclesToEmulate = 400000;


		
	//	var clockCyclesToEmulate = Math.floor(18000000);

		avr.breakPoint = untyped Browser.window.breakPoint / 2;
		
		if (!halted) {
			var start = Browser.window.performance.now(); 
		 	avr.tick(clockCyclesToEmulate);
			var finish = Browser.window.performance.now(); 
			outputDiv.textContent = "time "+(finish-start);		
		}
		if (avr.PC == avr.breakPoint) {
			halted = true;
			
		}
		Browser.window.requestAnimationFrame(handleAnimationFrame);
		
	}
	
	override function installPortIOFunctions() {
		super.installPortIOFunctions();

		var inPort = avr.inPortFunctions;
		var outPort = avr.outPortFunctions;
		
		
		outPort[0x22] = function (value) {
			if (value == 0) {
				ttyCharacters = "";
				flushLog();
				return;
			}
			logText += String.fromCharCode(value);			
			ttyCharacters += String.fromCharCode(value);
			//trace("received value of ", value);
			outputDiv.textContent = ttyCharacters.substr( -40);			
		}
		
		
		var inputsPort = 0x48;   // inputs overlap mode output registers
		
		inPort[inputsPort + 0x00] = function () { return read8Buttons(0) | buttonsA; }
		inPort[inputsPort + 0x01] = function () { return read8Buttons(8) | buttonsB | (mouseButtonState[0] ? 0x20:0) | (mouseButtonState[1] ? 0x40:0) | (mouseButtonState[2] ? 0x80:0) ; }
		inPort[inputsPort + 0x02] = function () { return (mouseX >> 1)& 0xff; }
		inPort[inputsPort + 0x03] = function () { return (mouseY >> 1)& 0xff; }
		inPort[inputsPort + 0x04] = function () { return tickCounter; }
		inPort[inputsPort + 0x05] = function () { return timeCounter >> 1; }
		inPort[inputsPort + 0x06] = function () { if (keyBuffer.isEmpty()) return 0 else return keyBuffer.pop();} 

	}
	
	function read8Buttons(startingAt) {
		
		var result = 0;
		for (i in 0...8) {
			var bit = rawKeymap[buttonMap[startingAt + i]]?1:0;
			result += bit << i;
		}
		return result;
	}

	public function flushLog() {
		if (logText != '') {					
			//trace(logText);
			logText = '';
		}

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
		for (i in 0...21) {
			var len = avr.instructionLength(avr.instructionAt(memLocation));
			
			var asHex = "";
			for (w in 0...len) {
				asHex+=  StringTools.hex(avr.instructionAt(memLocation+w),4)+" ";
			}
			output += '<div class="${memLocation==avr.PC?"PC":""}"  tooltip="${asHex}">'+  StringTools.hex(memLocation*2,4) +":\t"+ avr.disassemble(memLocation) +"</div>";
			memLocation += len;
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
		function setDivText(div:DivElement, newValue) {
			var current = div.textContent;
			if (newValue != current) div.classList.add("changed") else div.classList.remove("changed"); 
			div.textContent	= newValue;
		}
		for (i in 0...32) {
			setDivText(registerDiv[i],'r$i : ${hexreg(i)}');
		}
		
		setDivText(xDiv,'X: ${StringTools.hex(avr.X,4)}');
		setDivText(yDiv,'Y: ${StringTools.hex(avr.Y,4)}');
		setDivText(zDiv,'Z: ${StringTools.hex(avr.Z,4)}');

		setDivText(spDiv, 'SP: ${StringTools.hex(avr.SP,4)}');

		setDivText(spDiv, 'SP: ${StringTools.hex(avr.SP,4)}');
		setDivText(pcDiv, 'PC: ${StringTools.hex(avr.PC,4)}');
		setDivText(sregDiv, '${flags()}');
    
		displayClocksDiv.textContent = '$clocksPerDisplayUpdate';
		instructionDiv.textContent	= 'PC->${StringTools.hex(avr.progMem[avr.PC],4)}';
		
		logDiv.textContent = avr.log;
	}
	
	function updateDebugInfo() {
		setDisassamblyView(avr.PC);
		updateRegisterView();
		onUpdateDebugInfo(debugContext);
	}
	
	function reset() {
		avr.reset();
		displayGenerator.reset();
		
		magicPasteBufferindex = 0;
		outputDiv.textContent = "[reset]";
		trace("[Hay! reset]");
		logText = "Start of log:";		
		//compress();
	}
	
	function loadHexFile(text : String,debugData : Dynamic=null) {
		var hexFile = new HexFile(text);
		hexFile.merge();
		loadCodeChunks(Lambda.array(hexFile.data),debugData);
		/*
		avr.clearProgMem();
		var totalData = 0;
		for (mem in hexFile.data) {
			avr.writeProgMem(mem.address, mem.data);
			totalData += mem.data.length;
		  //trace('added ${mem.data.length} bytes at ${mem.address}');
		}
		trace('loaded ${totalData} bytes from hex file');
		reset();
		halted = false;
		*/
	}
	public function loadCodeChunks(chunks : Array<Chunk>,debugData : Dynamic=null) {
		reset();
		avr.clearProgMem();
		currentProgram=chunks;
		debugContext=debugData;
		var totalData = 0;
		for (chunk in chunks) {
			avr.writeProgMem(chunk.address,chunk.data);			
			totalData += chunk.data.length;
			//trace('loaded ${chunk.data.length} bytes at ${chunk.address}');

		}
		trace('loaded ${totalData} bytes in total');

		halted = false;
	}

	function handleFileDrop(e : DragEvent) {
		e.stopPropagation();
        e.preventDefault();
		
		var files = e.dataTransfer.files;
		if (files.length == 1) {
			var file = files[0];
			var reader = new FileReader();
			reader.onload = function () {loadHexFile(reader.result); };
			reader.readAsText(file);
		}
	}
	
	public function compress() {
		
		//var zip = Compress.run(avr.progMem.view.buffer, 7);
		//trace(zip);
	}


	override function showLowRes() {

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

		display.putImageData(scaleBuffer, 0, 0);
	}

	override function showHighRes() {
    display.putImageData(frameBuffer, -displayGenerator.displayShiftX, -displayGenerator.displayShiftY);			
	}
}