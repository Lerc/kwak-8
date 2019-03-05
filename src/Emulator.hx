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

	public function new() 
	{
        avr = new AVR8();
		
        frameBuffer = new ImageData(Display.frameBufferWidth, Display.frameBufferHeight);
		scaleBuffer = new ImageData(480, 360);
		displayGenerator = new Display(frameBuffer);
	
  		audioGenerator=new Audio();
		selectedVoice=audioGenerator.voices[0];
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
		var displayPort = 0x40;		
		outPort[displayPort + 0x00] = function (value) {
			switch (value) {
				
			case 1:{
				var now = avr.clockCycleCount;
				clocksPerDisplayUpdate = now - lastDisplayUpdate;
				lastDisplayUpdate = now;
                showHighRes();
			}
			case 0:{
				var now = avr.clockCycleCount;
				clocksPerDisplayUpdate = now - lastDisplayUpdate;				
				lastDisplayUpdate = now;
                showLowRes();
			}	
			case 0x80:
				displayGenerator.renderMode0(avr);
			case 0x81:
				displayGenerator.renderMode1(avr);
			case 0x71:
				displayGenerator.blitImage(avr,8); 
			case 0x72:
				displayGenerator.blitImage(avr,4); 
			case 0x73:
				displayGenerator.blitImage(avr,3); 
			case 0x74:
				displayGenerator.blitImage(avr,2); 
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
		
        var audioPort = 0x80;
		var voicePort= audioPort+8;

		outPort[audioPort + 0x00]  = function (value) {selectedVoice = audioGenerator.voices[value & 0x07]; }

		outPort[voicePort + 0x00] = function (value)  {selectedVoice.frequency = (selectedVoice.frequency&0xff00) | value; }
		outPort[voicePort + 0x01] = function (value)  {selectedVoice.frequency = (selectedVoice.frequency&0x00ff) | (value << 8); }
		outPort[voicePort + 0x02] = function (value)  {selectedVoice.volume=value; }
		outPort[voicePort + 0x03] = function (value)  {selectedVoice.waveBase = value&0x0f; selectedVoice.waveShift=value>>4;}
		outPort[voicePort + 0x04] = function (value)  {selectedVoice.bendDuration = value & 0x1f; selectedVoice.bendPhase=value>>5; }
		outPort[voicePort + 0x05] = function (value)  {selectedVoice.bendAmplitude=value; }
		outPort[voicePort + 0x06] = function (value)  {selectedVoice.noise= value & 0x0f; selectedVoice.hold=value>>4; }
		outPort[voicePort + 0x07] = function (value)  {selectedVoice.attack= value & 0x0f; selectedVoice.release=value>>4; }
		
		var palettePort = 0x90;

        var paletteMapper = function(index) {return function (value){ displayGenerator.setPaletteMapping(index,value);}}

		for (i in 0...16) {
			outPort[palettePort+i] = paletteMapper(i); 
		}

    }
}

