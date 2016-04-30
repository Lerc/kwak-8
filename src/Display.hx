package;
import haxe.io.UInt8Array;
import js.html.Image;
import js.html.ImageData;
import js.html.Uint32Array;


/**
 * ...
 * @author Lerc
 */

using StringTools;

class Display
{
	public inline static var frameBufferWidth = 512;
	public inline static var frameBufferHeight = 392;
	var imageData : ImageData;
	var pixelData : Uint32Array; 

	
	public var modeData : UInt8Array = new UInt8Array(8);
	
	/*
	public var pixelData_displayStart : Int = 0x4000;
	public var colorData_displayStart : Int = 0x4001;

	public var pixelData_increment : Int = 2;
	public var colorData_increment : Int = 2; 
  	
	public var pixelData_lineIncrement : Int = 320;
	public var colorData_lineIncrement : Int = 320;
	*/
	public var displayShiftX : Int = 0;
	public var displayShiftY : Int = 0;
	
	public var serialPixelAddress: Int = 0; 
	
	var smallPalette : UInt8Array = new UInt8Array(16); 
	
	var palette : Uint32Array = new Uint32Array([
		0xFF000000, 0xFF9D9D9D, 0xFFFFFFFF, 0xFF3326BE,
		0xFF8B6FE0, 0xFF2B3C49, 0xFF2264A4, 0xFF3189EB,
		0xFF6BE2F7, 0xFF4E482F, 0xFF1A8944, 0xFF27CEA3,
		0xFF32261B, 0xFF845700, 0xFFF2A231, 0xFFEFDCB2, 
		
		0xFF141414, 0xFF1E1E1E, 0xFF282828, 0xFF323232, 0xFF3C3C3C, 0xFF464646, 0xFF505050, 0xFF5a5a5a,
		0xFF646464, 0xFF6E6E6E, 0xFF787878, 0xFF828282, 0xFF8C8C8C, 0xFF969696, 0xFFA0A0A0, 0xFFAAAAAA,
		0xFFB4B4B4, 0xFFBEBEBE, 0xFFC8C8C8, 0xFFD2D2D2, 0xFFDCDCDC, 0xFFE6E6E6, 0xFFF0F0F0, 0xFFFAFAFA,

		0xFF0A0A0A, 0xFF3E0000, 0xFF6B0000, 0xFF990000, 0xFFCB0000, 0xFFFF0000,
		0xFF002F00, 0xFF3E2F00, 0xFF6B2F00, 0xFF992F00, 0xFFCB2F00, 0xFFFF2F00, 
		0xFF006000, 0xFF3E6000, 0xFF6B6000, 0xFF996000, 0xFFCB6000, 0xFFFF6000,
		0xFF009000, 0xFF3E9000, 0xFF6B9000, 0xFF999000, 0xFFCB9000, 0xFFFF9000,
		0xFF00C800, 0xFF3EC800, 0xFF6BC800, 0xFF99C800, 0xFFCBC800, 0xFFFFC800,
		0xFF00FF00, 0xFF3EFF00, 0xFF6BFF00, 0xFF99FF00, 0xFFCBFF00, 0xFFFFFF00,

		0xFF000056, 0xFF3E0056, 0xFF6B0056, 0xFF990056, 0xFFCB0056, 0xFFFF0056,
		0xFF002F56, 0xFF3E2F56, 0xFF6B2F56, 0xFF992F56, 0xFFCB2F56, 0xFFFF2F56,
		0xFF006056, 0xFF3E6056, 0xFF6B6056, 0xFF996056, 0xFFCB6056, 0xFFFF6056,
		0xFF009056, 0xFF3E9056, 0xFF6B9056, 0xFF999056, 0xFFCB9056, 0xFFFF9056,
		0xFF00C856, 0xFF3EC856, 0xFF6BC856, 0xFF99C856, 0xFFCBC856, 0xFFFFC856,
		0xFF00FF56, 0xFF3EFF56, 0xFF6BFF56, 0xFF99FF56, 0xFFCBFF56, 0xFFFFFF56,

		0xFF000085, 0xFF3E0085, 0xFF6B0085, 0xFF990085, 0xFFCB0085, 0xFFFF0085,
		0xFF002F85, 0xFF3E2F85, 0xFF6B2F85, 0xFF992F85, 0xFFCB2F85, 0xFFFF2F85,
		0xFF006085, 0xFF3E6085, 0xFF6B6085, 0xFF996085, 0xFFCB6085, 0xFFFF6085,
		0xFF009085, 0xFF3E9085, 0xFF6B9085, 0xFF999085, 0xFFCB9085, 0xFFFF9085,
		0xFF00C885, 0xFF3EC885, 0xFF6BC885, 0xFF99C885, 0xFFCBC885, 0xFFFFC885,
		0xFF00FF85, 0xFF3EFF85, 0xFF6BFF85, 0xFF99FF85, 0xFFCBFF85, 0xFFFFFF85,
		
		0xFF0000AA, 0xFF3E00AA, 0xFF6B00AA, 0xFF9900AA, 0xFFCB00AA, 0xFFFF00AA,
		0xFF002FAA, 0xFF3E2FAA, 0xFF6B2FAA, 0xFF992FAA, 0xFFCB2FAA, 0xFFFF2FAA,
		0xFF0060AA, 0xFF3E60AA, 0xFF6B60AA, 0xFF9960AA, 0xFFCB60AA, 0xFFFF60AA,
		0xFF0090AA, 0xFF3E90AA, 0xFF6B90AA, 0xFF9990AA, 0xFFCB90AA, 0xFFFF90AA,
		0xFF00C8AA, 0xFF3EC8AA, 0xFF6BC8AA, 0xFF99C8AA, 0xFFCBC8AA, 0xFFFFC8AA,
		0xFF00FFAA, 0xFF3EFFAA, 0xFF6BFFAA, 0xFF99FFAA, 0xFFCBFFAA, 0xFFFFFFAA,

		0xFF0000D4, 0xFF3E00D4, 0xFF6B00D4, 0xFF9900D4, 0xFFCB00D4, 0xFFFF00D4,
		0xFF002FD4, 0xFF3E2FD4, 0xFF6B2FD4, 0xFF992FD4, 0xFFCB2FD4, 0xFFFF2FD4,
		0xFF0060D4, 0xFF3E60D4, 0xFF6B60D4, 0xFF9960D4, 0xFFCB60D4, 0xFFFF60D4,
		0xFF0090D4, 0xFF3E90D4, 0xFF6B90D4, 0xFF9990D4, 0xFFCB90D4, 0xFFFF90D4,
		0xFF00C8D4, 0xFF3EC8D4, 0xFF6BC8D4, 0xFF99C8D4, 0xFFCBC8D4, 0xFFFFC8D4,
		0xFF00FFD4, 0xFF3EFFD4, 0xFF6BFFD4, 0xFF99FFD4, 0xFFCBFFD4, 0xFFFFFFD4,
		
		0xFF0000FF, 0xFF3E00FF, 0xFF6B00FF, 0xFF9900FF, 0xFFCB00FF, 0xFFFF00FF,
		0xFF002FFF, 0xFF3E2FFF, 0xFF6B2FFF, 0xFF992FFF, 0xFFCB2FFF, 0xFFFF2FFF,
		0xFF0060FF, 0xFF3E60FF, 0xFF6B60FF, 0xFF9960FF, 0xFFCB60FF, 0xFFFF60FF,
		0xFF0090FF, 0xFF3E90FF, 0xFF6B90FF, 0xFF9990FF, 0xFFCB90FF, 0xFFFF90FF,
		0xFF00C8FF, 0xFF3EC8FF, 0xFF6BC8FF, 0xFF99C8FF, 0xFFCBC8FF, 0xFFFFC8FF,
		0xFF00FFFF, 0xFF3EFFFF, 0xFF6BFFFF, 0xFF99FFFF, 0xFFCBFFFF, 0xFFFFFFFF
		
	]);

	public function new(frameBuffer:ImageData) 
	{
		if (frameBuffer.width != frameBufferWidth) throw 'frame buffer has wrong width wanted $frameBufferWidth got ${frameBuffer.width}';
		if (frameBuffer.height != frameBufferHeight) throw 'frame buffer has wrong height wanted $frameBufferHeight got ${frameBuffer.height}';
		
		imageData = frameBuffer;
		pixelData = new Uint32Array(frameBuffer.data.buffer);
		
	}
	
	inline public function serialSet(value) {
		pixelData[serialPixelAddress] = palette[value];
		serialPixelAddress += 1;
		if (serialPixelAddress >= frameBufferWidth * frameBufferHeight) serialPixelAddress = 0;
	}
	
	inline public function serialMul(value) {
		var byteAddress = serialPixelAddress * 4;
		var color = palette[value];
		imageData.data[byteAddress] = (imageData.data[byteAddress] * (color & 0xff))>>8;
		imageData.data[byteAddress+1] = (imageData.data[byteAddress+1] * ((color>>8) & 0xff))>>8;
		imageData.data[byteAddress+2] = (imageData.data[byteAddress+2] * ((color>>16) & 0xff))>>8;
		serialPixelAddress += 1;
		if (serialPixelAddress >= frameBufferWidth * frameBufferHeight) serialPixelAddress = 0;
	}

	inline public function serialAdd(value) {
		var byteAddress = serialPixelAddress * 4;
		var color = palette[value];
		imageData.data[byteAddress] += color & 0xff;
		imageData.data[byteAddress+1] += (color>>8) & 0xff;
		imageData.data[byteAddress+2] += (color>>16) & 0xff; 
		serialPixelAddress += 1;
		if (serialPixelAddress >= frameBufferWidth * frameBufferHeight) serialPixelAddress = 0;
	}
	
	public function renderMode0(avr:AVR8) {
		var pixelData_displayStart : Int = modeData[0] + (modeData[1] << 8);
		var colorData_displayStart : Int = modeData[2] + (modeData[3] << 8); 
		var pixelData_increment : Int = modeData[4];
		var colorData_increment : Int = modeData[5]; 
  	
		var pixelData_lineIncrement : Int = modeData[6]<<3;
		var colorData_lineIncrement : Int = modeData[7]<<3;

		
		var cellsWide = 160+6;
		var cellsHigh = 120 + 6;
		
		 
		
		for (ty in 0...cellsHigh) {
			var pixelData_lineStart = pixelData_displayStart + pixelData_lineIncrement * ty;
			var colorData_lineStart = colorData_displayStart + colorData_lineIncrement * ty;
			
			var pixelWalk = pixelData_lineStart;
			var colorWalk = colorData_lineStart;

			var outputStart = ty * frameBufferWidth  * 3;  //3 bytes per pixel, 3 scanlines per cell
			var outWalk = outputStart;
			pixelWalk &= 0xffff;
			colorWalk &= 0xffff;
			for (tx in 0...cellsWide) {
				var cellPixels = avr.ram[pixelWalk];
				var cellAttributes = avr.ram[colorWalk];
				pixelWalk += pixelData_increment;
				colorWalk += colorData_increment;
				pixelWalk &= 0xffff;
				colorWalk &= 0xffff;
	
				var a = (cellAttributes >> 4);
				var b = (cellAttributes & 0xf);

				//cellPixels = 0x55;
				var p = cellPixels;
				pixelData[outWalk] = palette[a];
				pixelData[outWalk+1] = palette[(p&1)==0?a:b];
				pixelData[outWalk+2] = palette[(p&2)==0?a:b];

				pixelData[outWalk+frameBufferWidth] = palette[(p&4)==0?a:b];
				pixelData[outWalk+frameBufferWidth+1] = palette[(p&8)==0?a:b];
				pixelData[outWalk+frameBufferWidth+2] = palette[(p&16)==0?a:b];

				pixelData[outWalk+frameBufferWidth*2] = palette[(p&32)==0?a:b];
				pixelData[outWalk+frameBufferWidth*2+1] = palette[(p&64)==0?a:b];
				pixelData[outWalk+frameBufferWidth*2+2] = palette[(p&128)==0?a:b];
				
				outWalk += 3;
			}
		}
	}	
	
	public function renderMode1(avr:AVR8, pixelsPerByte : Int = 3) {
		function render2PixelPerByteScan(lineStart : Int, bytesWide:Int, srcLine:Int, flipX : Bool,doubleX :Bool) {
			var destWalk = lineStart;
			var srcWalk = srcLine;
			var nextPixel = doubleX ? 2:1;

			if (flipX) {
				destWalk += nextPixel * (bytesWide * 2 -1);
				nextPixel =-nextPixel;
			}
			
			for (b in 0...bytesWide) {
				var byte = avr.ram[srcWalk++];
				var microPalette = (byte >> 4) & 0x0C;
				for (i in 0...2) {
					var pix = (byte & 0xF0) >> 4;
					byte = byte << 4;   
					var mainPaletteIndex = smallPalette[pix];
					if ( (pix | mainPaletteIndex)  != 0 ) {
						pixelData[destWalk] = palette[mainPaletteIndex];
						if (doubleX) {
							pixelData[destWalk+1] = palette[mainPaletteIndex];
						}
					}
					destWalk += nextPixel;
				}
			}
		}


		function render3PixelPerByteScan(lineStart : Int, bytesWide:Int, srcLine:Int, flipX : Bool,doubleX :Bool) {
			var destWalk = lineStart;
			var srcWalk = srcLine;
			var nextPixel = doubleX ? 2:1;

			if (flipX) {
				destWalk += nextPixel * (bytesWide * 3 -1);
				nextPixel =-nextPixel;
			}
			
			for (b in 0...bytesWide) {
				var byte = avr.ram[srcWalk++];
				var microPalette = (byte >> 4) & 0x0C;
				for (i in 0...3) {
					var pix = (byte & 0x30) >> 4;
					byte = byte << 2;   
					var mainPaletteIndex = smallPalette[microPalette+pix];
					if ( (pix | mainPaletteIndex)  != 0 ) {
						pixelData[destWalk] = palette[mainPaletteIndex];
						if (doubleX) {
							pixelData[destWalk+1] = palette[mainPaletteIndex];
						}
					}
					destWalk += nextPixel;
				}
				
			}
		}

		function render4PixelPerByteScan(lineStart : Int, bytesWide:Int, srcLine:Int, flipX : Bool,doubleX :Bool) {
			var destWalk = lineStart;
			var srcWalk = srcLine;
			var nextPixel = doubleX ? 2:1;

			if (flipX) {
				destWalk += nextPixel * (bytesWide * 4 -1);
				nextPixel =-nextPixel;
			}
			
			for (b in 0...bytesWide) {
				var byte = avr.ram[srcWalk++];
				var microPalette = (byte >> 4) & 0x0C;
				for (i in 0...4) {
					var pix = (byte & 0xC0) >> 6;
					byte = byte << 2;   
					var mainPaletteIndex = smallPalette[pix];
					if ( (pix | mainPaletteIndex)  != 0 ) {
						pixelData[destWalk] = palette[mainPaletteIndex];
						if (doubleX) {
							pixelData[destWalk+1] = palette[mainPaletteIndex];
						}
					}
					destWalk += nextPixel;
				}
			}
		}

		function render8PixelPerByteScan(lineStart : Int, bytesWide:Int, srcLine:Int, flipX : Bool,doubleX :Bool) {
			var destWalk = lineStart;
			var srcWalk = srcLine;
			var nextPixel = doubleX ? 2:1;

			if (flipX) {
				destWalk += nextPixel * (bytesWide * 8 -1);
				nextPixel =-nextPixel;
			}
			
			for (b in 0...bytesWide) {
				var byte = avr.ram[srcWalk++];
				var microPalette = (byte >> 4) & 0x0C;
				for (i in 0...8) {
					var pix = (byte & 0x80) >> 7;
					byte = byte << 1;   
					var mainPaletteIndex = smallPalette[pix];
					if ( (pix | mainPaletteIndex)  != 0 ) {
						pixelData[destWalk] = palette[mainPaletteIndex];
						if (doubleX) {
							pixelData[destWalk+1] = palette[mainPaletteIndex];
						}
					}
					destWalk += nextPixel;
				}
			}
		}
			

		var displayStart : Int = modeData[0] + (modeData[1] << 8);
		var bytesWide : Int = modeData[2];
		var height : Int = modeData[3];
		var lineIncrement : Int = modeData[4];
		var paletteStart : Int = modeData[5] + (modeData[6] << 8);
		var flags : Int = modeData[7];
		
		var flipX = (flags & 0x80) != 0;
		var flipY = (flags & 0x40) != 0;
		var doubleX = (flags & 0x20) != 0;
		var doubleY = (flags & 0x10) != 0;

		for (p in 0...16) {
			smallPalette[p*2]=avr.ram[paletteStart + p] >> 4; 
			smallPalette[p*2+1]=avr.ram[paletteStart + p] &0x0f; 
		}
		
		var topLeft = serialPixelAddress; 
		var scanlinesHigh = (height-1) << (doubleY?1:0);		
		var lineStart = topLeft + (flipY?frameBufferWidth * scanlinesHigh:0);  
		var srcLine = displayStart;   
		var pixelsWide = (bytesWide * pixelsPerByte) << (doubleX?1:0);
		var nextLine = frameBufferWidth * (flipY? -1:1); 
		
		for (ty in 0...height) { 
			
			switch (pixelsPerByte) {
			 case 2: render2PixelPerByteScan(lineStart, bytesWide, srcLine, flipX, doubleX);
			 case 3: render3PixelPerByteScan(lineStart, bytesWide, srcLine, flipX, doubleX);
			 case 4: render4PixelPerByteScan(lineStart, bytesWide, srcLine, flipX, doubleX);
			 case 8: render8PixelPerByteScan(lineStart, bytesWide, srcLine, flipX, doubleX);
			}
			
			if (doubleY) {
				for (tx in 0...pixelsWide) {
					pixelData[lineStart + frameBufferWidth + tx] = pixelData[lineStart + tx];
				}
				lineStart += nextLine * 2;
			} else {				
				lineStart += nextLine;
			}
			
			srcLine+= lineIncrement;
		}
		
		

	}


}