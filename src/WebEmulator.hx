package ;

import HexFile.Chunk;
import js.Browser;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.DivElement;
import js.html.DragEvent;
import js.html.FileReader;
import js.html.KeyboardEvent;
import js.html.MouseEvent;
import js.lib.Uint32Array;


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
	var buttonMap : Array<Int> = [37, 38, 39, 40, 13, 27, 17, 16, 65, 87, 68, 83, 32, 90, 88, 8];
	var keyBuffer : List<Int> = new List<Int>();

	var buttonsA : Int = 0;
	var buttonsB : Int = 0;
	var mouseX : Int;
	var mouseY : Int;
	var tickCounter : Int = 0;
	var timeCounter : Int = 0;

	var debugContext : Dynamic = null;

    public var playerDiv : DivElement;
	public function new() 
	{
		super();
		buttonsA=0;
		buttonsB=0;
		var containerElement = Browser.document.querySelector(".emulator.host");

		playerDiv =  Browser.document.createDivElement();
		containerElement.appendChild(playerDiv);
		displayCanvas = Browser.document.createCanvasElement();
		displayCanvas.addEventListener('mousemove', function(e:MouseEvent){mouseX = e.offsetX; mouseY = e.offsetY; });
		displayCanvas.addEventListener('mousedown', function(e:MouseEvent){ mouseButtonState[e.button] = true;});
		displayCanvas.addEventListener('mouseup', function(e:MouseEvent){ mouseButtonState[e.button] = false;});
		displayCanvas.addEventListener('contextmenu', function(e:MouseEvent){ e.preventDefault(); });
		
		playerDiv.appendChild(displayCanvas);

    	display = displayCanvas.getContext2d();
		displayCanvas.width = 480;
		displayCanvas.height = 360;
	
	    installPortIOFunctions();
	

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
		if (avr.PC == avr.breakPoint) {
			halted = true;
		}
		Browser.window.requestAnimationFrame(handleAnimationFrame);
		
	}
    override function installPortIOFunctions() {
		super.installPortIOFunctions();

		var inPort = avr.inPortFunctions;
	
		var inputsPort = 0x30;   // inputs overlap mode output registers
		
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

    public function reset() {
		avr.reset();
		displayGenerator.reset();
    }

    public function loadHexFile(text : String,debugData : Dynamic=null) {
		var hexFile = new HexFile(text);
		hexFile.merge();
		loadCodeChunks(Lambda.array(hexFile.data),debugData);
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