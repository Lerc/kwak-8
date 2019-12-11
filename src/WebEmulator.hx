package ;

import haxe.crypto.Base64;
import js.lib.Uint8Array;
import js.lib.Uint16Array;
import HexFile.Chunk;
import haxe.Timer;
import js.Browser;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.DivElement;
import js.html.DragEvent;
import js.html.FileReader;
import js.html.KeyboardEvent;
import js.html.MouseEvent;
import js.lib.Uint32Array;
import js.html.Window;


using StringTools;

/**
 * ...
 * @author Lerc
 */
@:expose
@:keep 
class WebEmulator extends Emulator
{
	public var displayCanvas : CanvasElement;
 	public var display : CanvasRenderingContext2D;

	var rawKeymap : Array<Bool> = [];
	var mouseButtonState : Array<Bool> = [false, false, false];
	var buttonMap : Array<Int> = [37, 38, 39, 40, 13, 27, 17, 32, 65, 87, 68, 83, 16, 90, 88, 8];
	var keyBuffer : List<Int> = new List<Int>();

	var buttonsA : Int = 0;
	var buttonsB : Int = 0;
	var mouseX : Int;
	var mouseY : Int;
	var tickCounter : Int = 0;
	var timeCounter : Int = 0;

    var inBootRom = false;
	public var useBootRom=true;

	
	var bootRom = new Uint8Array(
		Base64.decode(
			"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"
			).getData()
		);
	var rom = new Uint8Array(65536*2);

	public var debugInfo(default,null) : Dynamic = null;

    public var playerDiv : DivElement;

	var cartImage : js.html.Image = new js.html.Image();

	public function new() 
	{
		super();
		buttonsA=0;
		buttonsB=0;
		var containerElement = Browser.document.querySelector(".emulator.host");

		playerDiv =  Browser.document.createDivElement();
		containerElement.appendChild(playerDiv);
		displayCanvas = Browser.document.createCanvasElement();
		displayCanvas.addEventListener('mousemove', function(e:MouseEvent){
			mouseX = e.offsetX;
			mouseY = e.offsetY;
			mouseButtonState[0] = (e.buttons&1) == 1;
			mouseButtonState[1] = (e.buttons&2) == 2;
			mouseButtonState[2] = (e.buttons&4) == 4;
			
		});
		displayCanvas.addEventListener('mousedown', function(e:MouseEvent){ mouseButtonState[e.button] = true;});
		displayCanvas.addEventListener('mouseup', function(e:MouseEvent){ mouseButtonState[e.button] = false;});
		displayCanvas.addEventListener('contextmenu', function(e:MouseEvent){ e.preventDefault(); });
		
		playerDiv.appendChild(displayCanvas);

    	display = displayCanvas.getContext2d();
		displayCanvas.width = 480;
		displayCanvas.height = 360;
	
	    installPortIOFunctions();
	
		var halfsecondTimer = new Timer(500);

		halfsecondTimer.run = function() { 
			timeCounter = (timeCounter + 1) & 0x1ff;
		};

        displayCanvas.addEventListener("drop", handleFileDrop);
		displayCanvas.addEventListener("dragover",  function (evt) {
			evt.stopPropagation();
			evt.preventDefault();
			evt.dataTransfer.dropEffect = 'copy'; 
		});

        Browser.window.addEventListener("keydown", function (e : KeyboardEvent) {
            var code = e.keyCode;
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
		});
			
    }


    override function initialize() {
        super.initialize();
        Browser.window.requestAnimationFrame(handleAnimationFrame); 
    }

    function handleAnimationFrame(time:Float) : Void {
		tickCounter = (tickCounter + 1) & 0xff;		
		var elapsed = time-lastFrameTimeStamp;
		lastFrameTimeStamp = time;
		var clockCyclesToEmulate = Math.floor(8000 * elapsed);
		if (clockCyclesToEmulate > 400000) clockCyclesToEmulate = 400000;
		
		if (!halted) {
			var start = Browser.window.performance.now(); 
		 	avr.tick(clockCyclesToEmulate);
			var finish = Browser.window.performance.now(); 
		}
		if (avr.breakPoints[avr.PC] != 0 ){
			halted = true;
		}
		Browser.window.requestAnimationFrame(handleAnimationFrame);
		
	}
    override function installPortIOFunctions() {
		super.installPortIOFunctions();

		var inPort = avr.inPortFunctions;
		var outPort = avr.outPortFunctions;
	
		var inputsPort = 0x30;   // inputs overlap mode output registers
		
		inPort[inputsPort + 0x00] = function () { return read8Buttons(0) | buttonsA; }
		inPort[inputsPort + 0x01] = function () { return read8Buttons(8) | buttonsB | (mouseButtonState[0] ? 0x20:0) | (mouseButtonState[1] ? 0x40:0) | (mouseButtonState[2] ? 0x80:0) ; }
		inPort[inputsPort + 0x02] = function () { return (mouseX >> 1)& 0xff; }
		inPort[inputsPort + 0x03] = function () { return (mouseY >> 1)& 0xff; }
		inPort[inputsPort + 0x04] = function () { return tickCounter; }
		inPort[inputsPort + 0x05] = function () { return timeCounter >> 1; }
		inPort[inputsPort + 0x06] = function () { if (keyBuffer.isEmpty()) return 0 else return keyBuffer.pop();} 

		outPort[0x37]=function(value:Int) {
			if (value==0) return;
			inBootRom=false;
			avr.writeProgMem(0,rom);
			avr.clearRam();
			avr.nextPC=0;
		}
	}
	
	function read8Buttons(startingAt) {		
		var result = 0;
		for (i in 0...8) {
			var bit = rawKeymap[buttonMap[startingAt + i]]?1:0;
			result += bit << i;
		}
		return result;
	}

    public function reset() {
		avr.clearProgMem();
		if (useBootRom) {
			avr.writeProgMem(0,new Uint8Array(bootRom));	
			inBootRom=true;
		} else {
			avr.writeProgMem(0,rom);
		}
		avr.reset();
		displayGenerator.reset();
    }

    public function loadHexFile(text : String,debugData : Dynamic=null) {
		var hexFile = new HexFile(text);
		hexFile.merge();
		loadCodeChunks(Lambda.array(hexFile.data),debugData);
	}
	
	public function loadCodeChunks(chunks : Array<Chunk>,debugData : Dynamic=null) {
		rom.fill(0);
		currentProgram=chunks;
		debugInfo=debugData;
		var totalData = 0;
		for (chunk in chunks) {
			rom.set(chunk.data,chunk.address);					
			totalData += chunk.data.length;
			//trace('loaded ${chunk.data.length} bytes at ${chunk.address}');

		}
		trace('loaded ${totalData} bytes in total');
		reset();
		halted = false;
	}

    function handleFileDrop(e : DragEvent) {
        e.stopPropagation();
        e.preventDefault();
		
		var files = e.dataTransfer.files;
		if (files.length == 1) {
			var file = files[0];
			var name = file.name.toLowerCase();
			if (name.endsWith('.hex')) {
				var reader = new FileReader();
				reader.onload = function () {loadHexFile(reader.result); };
				reader.readAsText(file);
			} else if (name.endsWith('.png')) {
				var cartLoader = untyped (Browser.window.Cart);
				trace (cartLoader);
				if (cartLoader != null) {
					cartImage.onload = function() {
						var decoded = cartLoader.decode(cartImage);
						loadCodeChunks(decoded);
					}
					var reader = new FileReader();
					reader.onload = function () {
						cartImage.src=reader.result;	
					};
					reader.readAsDataURL(file);
				}

			}	
		}
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

    override function handleHaltStateChange() {
        super.handleHaltStateChange();
        if (!halted) {
			displayCanvas.focus();
		}
    }


}