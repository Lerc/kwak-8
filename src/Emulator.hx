package ;

import HexFile.Chunk;
import js.html.ImageData;

import haxe.io.Bytes;
import haxe.zip.Compress;

class Emulator {

	var avr : AVR8;
	var displayGenerator : Display;
	var audioGenerator : Audio;

	var frameBuffer : ImageData; 
	var scaleBuffer : ImageData;

	var clocksPerDisplayUpdate : Int = 0;
	var lastFrameTimeStamp : Float = 0;

	var selectedVoice : Voice;

	public var currentProgram : Array<Chunk> =[];

  var started : Bool = false;

	var halted(default,set) : Bool = true;
	var muted(default,set) : Bool = false;

	public function new() 
	{
		avr = new AVR8();

		frameBuffer = new ImageData(Display.frameBufferWidth, Display.frameBufferHeight);
		scaleBuffer = new ImageData(480, 360);
		displayGenerator = new Display(frameBuffer);

		audioGenerator=new Audio();
		selectedVoice=audioGenerator.voices[0];
	}

	public function start () {
		if (started) {
			halted=false;
		} else {
			initialize();
			started=true;
		}
	}

	public function stop() {
		halted=true;
	}
	
	public function initialize() {
		audioGenerator.start(); 
	}

	public function showLowRes() {

	}

	public function showHighRes() {

	}
	public function installPortIOFunctions() {
			
		var inPort = avr.inPortFunctions;
		var outPort = avr.outPortFunctions;


		var lastDisplayUpdate = avr.clockCycleCount;

		var displayWritePort = 0x20;

		outPort[displayWritePort + 0x00] = function (value) {
			displayGenerator.serialPixelAddress = (displayGenerator.serialPixelAddress & 0xffff00) | (value & 0xff);
		}

		outPort[displayWritePort + 0x01] = function (value) {
			displayGenerator.serialPixelAddress = (displayGenerator.serialPixelAddress & 0xff00ff) | ((value & 0xff) << 8);
		}

		outPort[displayWritePort + 0x02] = function (value) {
			displayGenerator.serialPixelAddress = (displayGenerator.serialPixelAddress & 0x00ffff) | ((value & 0xff) <<16);
		}

		outPort[displayWritePort + 0x03] = function (value) {
			displayGenerator.serialPixelControl = value;			
		}

		outPort[displayWritePort + 0x04] = function (value) {
			displayGenerator.serialBaseColor = value;			
		}

		outPort[displayWritePort + 0x05] = function (value) {
			displayGenerator.serialAdd(value);			
		}

		outPort[displayWritePort + 0x06] = function (value) {
			displayGenerator.serialSub(value);			
		}

		outPort[displayWritePort + 0x07] = function (value) {
			displayGenerator.serialMul(value);			
		} 

		outPort[0x28] = function (value) {
			var now = avr.clockCycleCount;
			clocksPerDisplayUpdate = now - lastDisplayUpdate;
			lastDisplayUpdate = now;
			if ( (value & 1) == 1) {
				showHighRes();
			} else {
				showLowRes();
			}
		}

		outPort[0x29] = function (value) {
			displayGenerator.displayShiftX = value;
		}

		outPort[0x2a] = function (value) {
			displayGenerator.displayShiftY = value;
		}


		outPort[0x2b] = function (value) {
		switch (value) {			
			case 0x01:
				displayGenerator.blitImage(avr,8); 
			case 0x02:
				displayGenerator.blitImage(avr,4); 
			case 0x03:
				displayGenerator.blitImage(avr,3); 
			case 0x04:
				displayGenerator.blitImage(avr,2); 

			case 0x10:
				displayGenerator.renderMode0(avr);
			case 0x11:
				displayGenerator.renderMode1(avr);
			}
		}

		var blitConfigPort = 0x48;
		outPort[blitConfigPort + 0x00] = function (value) {	displayGenerator.blitConfig[0] = value;	}
		outPort[blitConfigPort + 0x01] = function (value) {	displayGenerator.blitConfig[1] = value;	}
		outPort[blitConfigPort + 0x02] = function (value) {	displayGenerator.blitConfig[2] = value;	}
		outPort[blitConfigPort + 0x03] = function (value) {	displayGenerator.blitConfig[3] = value;	}
		outPort[blitConfigPort + 0x04] = function (value) {	displayGenerator.blitConfig[4] = value;	}
		outPort[blitConfigPort + 0x05] = function (value) {	displayGenerator.blitConfig[5] = value;	}
		outPort[blitConfigPort + 0x06] = function (value) {	displayGenerator.blitConfig[6] = value;	}
		outPort[blitConfigPort + 0x07] = function (value) {	displayGenerator.blitConfig[7] = value;	}

		outPort[0x2c]  = function (value) {selectedVoice = audioGenerator.voices[value & 0x07]; }
		outPort[0x2d]  = function (value) {selectedVoice = audioGenerator.voices[value & 0x07]; }

		var voicePort= 0x50;
		outPort[voicePort + 0x00] = function (value)  {selectedVoice.frequency = (selectedVoice.frequency&0xff00) | value; }
		outPort[voicePort + 0x01] = function (value)  {selectedVoice.frequency = (selectedVoice.frequency&0x00ff) | (value << 8); }
		outPort[voicePort + 0x02] = function (value)  {selectedVoice.volume=value; }
		outPort[voicePort + 0x03] = function (value)  {selectedVoice.waveBase = value&0x0f; selectedVoice.waveShift=(value>>4) & 7; selectedVoice.modulator = value&0x80 == 80; }
		outPort[voicePort + 0x04] = function (value)  {selectedVoice.bendAmplitude = value & 0x1f; selectedVoice.bendPhase=value>>5; }
		outPort[voicePort + 0x05] = function (value)  {selectedVoice.bendDuration=value; }
		outPort[voicePort + 0x06] = function (value)  {selectedVoice.noise= value & 0x0f; selectedVoice.hold=value>>4; }
		outPort[voicePort + 0x07] = function (value)  {selectedVoice.attack= value & 0x0f; selectedVoice.release=value>>4; }
		
		var palettePort = 0x60;

		var paletteMapper = function(index) {return function (value){ displayGenerator.setPaletteMapping(index,value);}}

		for (i in 0...16) {
			outPort[palettePort+i] = paletteMapper(i); 
		}

	}

	function set_muted(newValue : Bool) : Bool {
		if (newValue != muted) {
			muted = newValue;
			handleMuteStateChange();
		}
		return newValue;		
	}

	function set_halted(newValue : Bool) : Bool {
		if (newValue != halted) {
			halted = newValue;
			handleHaltStateChange();
		}
		return newValue;
	}
	
	public function handleHaltStateChange() {
	}

	public function handleMuteStateChange() {
		if (muted) {
			audioGenerator.stop();
		} else {
			audioGenerator.start();	
		}

	}

}

