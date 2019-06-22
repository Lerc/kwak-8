package;
import haxe.io.UInt8Array;
import js.html.ImageData;
import js.lib.Uint32Array;


/**
 * ...
 * @author Lerc
 */


class Display
{
	public inline static var frameBufferWidth = 512;
	public inline static var frameBufferHeight = 392;
	var imageData : ImageData;
	var pixelData : Uint32Array; 

	
	public var blitConfig : UInt8Array = new UInt8Array(8);
	
	public var displayShiftX : Int = 0;
	public var displayShiftY : Int = 0;
	
	public var serialPixelAddress: Int = 0; 
	
	public var serialPixelControl(null,set) : Int;

	public var serialBaseColor : Int =0;

	var smallPalette : UInt8Array = new UInt8Array(64); 
	var kwak8Colors : Uint32Array = new Uint32Array( [0xff000000,0xff9d9d9d,0xffffffff,0xff3326be,0xff8b6fe0,0xff2b3c49,0xff2264a4,0xff3189eb,0xff6be2f7,0xff4e482f,0xff1a8944,0xff27cea3,0xff32261b,0xff845700,0xfff2a231,0xffefdcb2,0xff212121,0xff363636,0xff484848,0xff585858,0xff676767,0xff767676,0xff838383,0xff909090,0xffa9a9a9,0xffb4b4b4,0xffc0c0c0,0xffcbcbcb,0xffd6d6d6,0xffe0e0e0,0xffebebeb,0xfff5f5f5,0xfffb8400,0xffd06d45,0xffa53100,0xff900008,0xffde1319,0xffff0000,0xfffa4f00,0xffff7992,0xffff9ea5,0xffffa77d,0xff743c3c,0xff5b3800,0xff310009,0xff451f33,0xff250037,0xff26005c,0xff641e00,0xffab4f4e,0xffd36275,0xffae0461,0xffef3875,0xffff4ea4,0xffff6fc9,0xffff9bd8,0xffc7709d,0xffd58873,0xff996a61,0xff55423a,0xff1a0200,0xff1b0019,0xff322547,0xff00004f,0xff5b0038,0xff772c5b,0xffa74c7c,0xffc0009c,0xffdb00cd,0xffff00ff,0xfff374ff,0xfff4afff,0xffd099ae,0xffb08185,0xff8a5f77,0xff5b3e52,0xff362930,0xff00001a,0xff04002e,0xff001e68,0xff4e205c,0xff734179,0xff9c4ca5,0xff80008b,0xff9500dc,0xffb652ff,0xffc35ccb,0xffc787cd,0xff7a5b95,0xff957694,0xff6e585c,0xff464255,0xff1c233b,0xff001421,0xff002341,0xff00376c,0xff0000ff,0xff4224ff,0xff5300e5,0xff8106ff,0xff4c0087,0xff6c31ab,0xffbb8afc,0xff986bbc,0xff524075,0xff4e5277,0xff626b80,0xff3d5050,0xff3c4932,0xff21332f,0xff002730,0xff003b53,0xff0b5aff,0xff0046c7,0xff0100a9,0xff656eff,0xff160083,0xff3a009f,0xff7054bd,0xff50499a,0xff2d2d63,0xff2a3c5f,0xff44596a,0xff3e666b,0xff3a5e49,0xff12413e,0xff00210f,0xff0f1600,0xff00a5ff,0xff0066d1,0xff003b98,0xff658dff,0xff4361d4,0xff988fff,0xff6769c7,0xff4759a8,0xff2e3d86,0xff3a5784,0xff1e5777,0xff00545d,0xff00532f,0xff023a00,0xff262f00,0xff312a00,0xff007bc2,0xff006b93,0xff58a0d5,0xff74adff,0xff5982ca,0xff808cc9,0xff8e82b5,0xff6b699b,0xff6275a3,0xff4c6f8b,0xff3d7b89,0xff1f6e55,0xff0d6f00,0xff2a5900,0xff51632d,0xff555400,0xff27a9cf,0xff0087ad,0xff6fc6ff,0xff96bde2,0xffaac1ff,0xffacade2,0xffb99fca,0xff9b9ab3,0xff829bc0,0xff5585ad,0xff527d6e,0xff48997b,0xff6b9466,0xff4a773d,0xff6d8118,0xffa1a700,0xff00c9ff,0xff34949b,0xff45b7ba,0xffade3ff,0xffcfe2f9,0xffd3b4b6,0xffa9939e,0xff827d92,0xff768698,0xff79a3b7,0xff7ab1a0,0xff9ddab8,0xff8ab57b,0xff80a416,0xffa9c800,0xffd9fc00,0xff00ffff,0xff008271,0xff80efd2,0xffbdffff,0xffc7dace,0xffd0bba8,0xffb4998c,0xff887477,0xff647a7f,0xff679292,0xff8ecbd0,0xffd8ffe3,0xffdfffb1,0xffd0d878,0xfffbf035,0xffffff00,0xff00ffaf,0xff00b06c,0xff9effaa,0xffc0ffc0,0xffb9d3a5,0xffcbb87f,0xffaa936c,0xff8d7967,0xff5c6c61,0xff7b8c7e,0xffaac2cb,0xffe1faff,0xffffffe4,0xfffdffb5,0xffffe96b,0xffcfc200,0xff00d019,0xff36aa00,0xff68c480,0xffaae272,0xffa8b37c,0xffa2953c,0xff937c3c,0xff715e4d,0xff818067,0xff98aca2,0xffb0bad2,0xffd8daff,0xffffefff,0xffffe1d8,0xffffcc00,0xffd2a600,0xff00ff00,0xff75eb00,0xff77c300,0xff4e9100,0xff87915f,0xff7b7600,0xff776200,0xff67654c,0xff9e9e85,0xffc0c2a9,0xffcdc0d6,0xffd3b8ff,0xffffd7ff,0xffffc0d7,0xffffc989,0xffb37500]);
	
	var incOnBase : Bool=false;
	var incOnAdd : Bool=true;
	var incOnSub : Bool=true;
	var incOnMul : Bool=true;

	
	var baseAdd : Bool=true;
	var baseSub : Bool=true;
	var baseMul : Bool=true;
	
	var palette : Uint32Array = new Uint32Array(
		[0xff000000,0xff9d9d9d,0xffffffff,0xff3326be,0xff8b6fe0,0xff2b3c49,0xff2264a4,0xff3189eb,0xff6be2f7,0xff4e482f,0xff1a8944,0xff27cea3,0xff32261b,0xff845700,0xfff2a231,0xffefdcb2,0xff212121,0xff363636,0xff484848,0xff585858,0xff676767,0xff767676,0xff838383,0xff909090,0xffa9a9a9,0xffb4b4b4,0xffc0c0c0,0xffcbcbcb,0xffd6d6d6,0xffe0e0e0,0xffebebeb,0xfff5f5f5,0xfffb8400,0xffd06d45,0xffa53100,0xff900008,0xffde1319,0xffff0000,0xfffa4f00,0xffff7992,0xffff9ea5,0xffffa77d,0xff743c3c,0xff5b3800,0xff310009,0xff451f33,0xff250037,0xff26005c,0xff641e00,0xffab4f4e,0xffd36275,0xffae0461,0xffef3875,0xffff4ea4,0xffff6fc9,0xffff9bd8,0xffc7709d,0xffd58873,0xff996a61,0xff55423a,0xff1a0200,0xff1b0019,0xff322547,0xff00004f,0xff5b0038,0xff772c5b,0xffa74c7c,0xffc0009c,0xffdb00cd,0xffff00ff,0xfff374ff,0xfff4afff,0xffd099ae,0xffb08185,0xff8a5f77,0xff5b3e52,0xff362930,0xff00001a,0xff04002e,0xff001e68,0xff4e205c,0xff734179,0xff9c4ca5,0xff80008b,0xff9500dc,0xffb652ff,0xffc35ccb,0xffc787cd,0xff7a5b95,0xff957694,0xff6e585c,0xff464255,0xff1c233b,0xff001421,0xff002341,0xff00376c,0xff0000ff,0xff4224ff,0xff5300e5,0xff8106ff,0xff4c0087,0xff6c31ab,0xffbb8afc,0xff986bbc,0xff524075,0xff4e5277,0xff626b80,0xff3d5050,0xff3c4932,0xff21332f,0xff002730,0xff003b53,0xff0b5aff,0xff0046c7,0xff0100a9,0xff656eff,0xff160083,0xff3a009f,0xff7054bd,0xff50499a,0xff2d2d63,0xff2a3c5f,0xff44596a,0xff3e666b,0xff3a5e49,0xff12413e,0xff00210f,0xff0f1600,0xff00a5ff,0xff0066d1,0xff003b98,0xff658dff,0xff4361d4,0xff988fff,0xff6769c7,0xff4759a8,0xff2e3d86,0xff3a5784,0xff1e5777,0xff00545d,0xff00532f,0xff023a00,0xff262f00,0xff312a00,0xff007bc2,0xff006b93,0xff58a0d5,0xff74adff,0xff5982ca,0xff808cc9,0xff8e82b5,0xff6b699b,0xff6275a3,0xff4c6f8b,0xff3d7b89,0xff1f6e55,0xff0d6f00,0xff2a5900,0xff51632d,0xff555400,0xff27a9cf,0xff0087ad,0xff6fc6ff,0xff96bde2,0xffaac1ff,0xffacade2,0xffb99fca,0xff9b9ab3,0xff829bc0,0xff5585ad,0xff527d6e,0xff48997b,0xff6b9466,0xff4a773d,0xff6d8118,0xffa1a700,0xff00c9ff,0xff34949b,0xff45b7ba,0xffade3ff,0xffcfe2f9,0xffd3b4b6,0xffa9939e,0xff827d92,0xff768698,0xff79a3b7,0xff7ab1a0,0xff9ddab8,0xff8ab57b,0xff80a416,0xffa9c800,0xffd9fc00,0xff00ffff,0xff008271,0xff80efd2,0xffbdffff,0xffc7dace,0xffd0bba8,0xffb4998c,0xff887477,0xff647a7f,0xff679292,0xff8ecbd0,0xffd8ffe3,0xffdfffb1,0xffd0d878,0xfffbf035,0xffffff00,0xff00ffaf,0xff00b06c,0xff9effaa,0xffc0ffc0,0xffb9d3a5,0xffcbb87f,0xffaa936c,0xff8d7967,0xff5c6c61,0xff7b8c7e,0xffaac2cb,0xffe1faff,0xffffffe4,0xfffdffb5,0xffffe96b,0xffcfc200,0xff00d019,0xff36aa00,0xff68c480,0xffaae272,0xffa8b37c,0xffa2953c,0xff937c3c,0xff715e4d,0xff818067,0xff98aca2,0xffb0bad2,0xffd8daff,0xffffefff,0xffffe1d8,0xffffcc00,0xffd2a600,0xff00ff00,0xff75eb00,0xff77c300,0xff4e9100,0xff87915f,0xff7b7600,0xff776200,0xff67654c,0xff9e9e85,0xffc0c2a9,0xffcdc0d6,0xffd3b8ff,0xffffd7ff,0xffffc0d7,0xffffc989,0xffb37500]
	);
    
	function set_serialPixelControl(value:Int) : Int {
		incOnAdd = (value & 0x10 !=0);
		incOnSub = (value & 0x20 !=0);
		incOnMul = (value & 0x40 !=0);

		baseAdd = (value & 0x01 !=0);
		baseSub = (value & 0x02 !=0);
		baseMul = (value & 0x04 !=0);

		return value;
	}

	public function new(frameBuffer:ImageData) 
	{
		if (frameBuffer.width != frameBufferWidth) throw 'frame buffer has wrong width wanted $frameBufferWidth got ${frameBuffer.width}';
		if (frameBuffer.height != frameBufferHeight) throw 'frame buffer has wrong height wanted $frameBufferHeight got ${frameBuffer.height}';
		
		imageData = frameBuffer;
		pixelData = new Uint32Array(frameBuffer.data.buffer);
		
	}
	public function clear() {
		
		for (i in  0...pixelData.length) pixelData[i]=0xff000010;
	}

	public function reset() {
		clear();
		serialBaseColor=0;
		serialPixelControl=0x11;
		serialPixelAddress=0;
		for (i in 0...16) {
			setPaletteMapping(i,i);
		}
	}

	inline function incSerialPixelAddress(amt : Int = 1) {
			serialPixelAddress += amt;
			if (serialPixelAddress >= frameBufferWidth * frameBufferHeight) {
				serialPixelAddress = 0;
			}
	}

	public function setBaseColor(value : Int) {
		serialBaseColor=value &0xff;
		if (incOnBase) {
			incSerialPixelAddress(1);
		}
	}

	public function setPaletteMapping(index16 : Int,index256 : Int) {
		palette[index16&0x0f] = kwak8Colors[index256 & 0x0f];
	}

	inline public function serialSet(value) {
		pixelData[serialPixelAddress] = palette[value];
	}
	
	inline public function serialMul(value) {
		if (baseMul) {
			pixelData[serialPixelAddress] = palette[serialBaseColor];
		}
		var byteAddress = serialPixelAddress * 4;
		var color = palette[value];
		imageData.data[byteAddress] = (imageData.data[byteAddress] * (color & 0xff))>>8;
		imageData.data[byteAddress+1] = (imageData.data[byteAddress+1] * ((color>>8) & 0xff))>>8;
		imageData.data[byteAddress+2] = (imageData.data[byteAddress+2] * ((color>>16) & 0xff))>>8;
		if (incOnMul) {
			incSerialPixelAddress(1);
		} 		
	}

	inline public function serialAdd(value) {
		if (baseAdd) {
			pixelData[serialPixelAddress] = palette[serialBaseColor];
		}
		var byteAddress = serialPixelAddress * 4;
		var color = palette[value];
		imageData.data[byteAddress] += color & 0xff;
		imageData.data[byteAddress+1] += (color>>8) & 0xff;
		imageData.data[byteAddress+2] += (color>>16) & 0xff; 
		if (incOnAdd) {
			incSerialPixelAddress(1);
		} 		
	}

	inline public function serialSub(value) {
		if (baseSub)  {
			pixelData[serialPixelAddress] = palette[serialBaseColor];
		}
		var byteAddress = serialPixelAddress * 4;
		var color = palette[value];
		imageData.data[byteAddress] -= color & 0xff;
		imageData.data[byteAddress+1] -= (color>>8) & 0xff;
		imageData.data[byteAddress+2] -= (color>>16) & 0xff; 
		if (incOnAdd) {
			incSerialPixelAddress(1);
		} 		
	}

	public function renderMode0(avr:AVR8) {
		var pixelData_displayStart : Int = blitConfig[0] + (blitConfig[1] << 8);
		var colorData_displayStart : Int = pixelData_displayStart + 1;
		var pixelData_increment : Int = 2;
		var colorData_increment : Int = 2; 
  	
		var pixelData_lineIncrement : Int = blitConfig[4]<<1;
		var colorData_lineIncrement : Int = pixelData_lineIncrement;

		
		var cellsWide = blitConfig[2];
		var cellsHigh = blitConfig[3];
		
		 
		
		for (ty in 0...cellsHigh) {
			var pixelData_lineStart = pixelData_displayStart + pixelData_lineIncrement * ty;
			var colorData_lineStart = colorData_displayStart + colorData_lineIncrement * ty;
			
			var pixelWalk = pixelData_lineStart;
			var colorWalk = colorData_lineStart;

			var outputStart = serialPixelAddress + ty * frameBufferWidth  * 3;  //3 bytes per pixel, 3 scanlines per cell
			if (outputStart > 0x30000) return;
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
				pixelData[outWalk] = palette[(p&1)==0?a:b];
				pixelData[outWalk+1] = palette[(p&2)==0?a:b];
				pixelData[outWalk+2] = palette[(p&4)==0?a:b];

				pixelData[outWalk+frameBufferWidth] = palette[(p&8)==0?a:b];
				pixelData[outWalk+frameBufferWidth+1] = palette[(p&16)==0?a:b];
				pixelData[outWalk+frameBufferWidth+2] = palette[(p&32)==0?a:b];

				pixelData[outWalk+frameBufferWidth*2] = palette[(p&64)==0?a:b];
				pixelData[outWalk+frameBufferWidth*2+1] = palette[(p&128)==0?a:b];
				pixelData[outWalk+frameBufferWidth*2+2]= palette[a];
				outWalk += 3;
			}
		}
	}	

	public function renderMode1(avr:AVR8) {
		var tileData_start : Int = blitConfig[6] + (blitConfig[7] << 8);
		var mapData_start  : Int = blitConfig[0] + (blitConfig[1] << 8);
		var paletteData_start  : Int = blitConfig[4] + (blitConfig[5] << 8);
		//var shiftX : Int = blitConfig[7]>>4;
		//var shiftY : Int = blitConfig[7]&0x0f;
		var mapData_lineIncrement : Int = blitConfig[3]<<1;

		var tilesWide :Int = ((blitConfig[2] >> 4) & 0x0f)*2;
		var tilesHigh :Int = (blitConfig[2] & 0x0f)*2;

		if (tilesWide==0) tilesWide=1;
		if (tilesHigh==0) tilesHigh=1;
		

		function drawTile(x,y,tileptr,tileAttribute ) {
			function renderTileSpan(lineStart : Int, databytes : Int) {
				var destWalk = lineStart;
				var nextPixel = 1;

				if ( (tileAttribute & 0x80) ==0 ) {  // flipX 
					destWalk += 7;
					nextPixel =-nextPixel;
				}
							
				var microPalette = (tileAttribute << 2) & 0x3C;
				for (i in 0...8) {
					var pix = (databytes & 3);
					databytes = databytes >> 2;   
					var mainPaletteIndex = smallPalette[microPalette+pix];
					
					if ( (pix | mainPaletteIndex)  != 0 ) {
						pixelData[destWalk] =  palette[mainPaletteIndex];
					} 
					destWalk += nextPixel;
				}
			}
			
			var flipY = (tileAttribute & 0x40) != 0;
			
			var displayoffset = y * frameBufferWidth + x + serialPixelAddress;
			if (displayoffset > 0x30000) return;
			var nextLine = frameBufferWidth;
			var dataWalk = tileptr;
			var nextByte = 2;			
			if (flipY) {
				dataWalk += 14;
				nextByte = -2;
			}
			for (i in 0...8)  {
				renderTileSpan(displayoffset, (avr.ram[dataWalk] <<8 )+ (avr.ram[dataWalk + 1] ));
				dataWalk += nextByte;
				displayoffset += nextLine;
			}
	}
		for (p in 0...32) {
			smallPalette[p*2]=avr.ram[paletteData_start + p] >> 4; 
			smallPalette[p*2+1]=avr.ram[paletteData_start + p] &0x0f; 
		}

		var mapLine = mapData_start;
		for (ty in 0...tilesHigh) {
			var mapWalk = mapLine;
			for (tx in 0...tilesWide) {
				var tileIndex = avr.ram[mapWalk];
				var tileAttribute = avr.ram[mapWalk + 1];
				var tilePointer = tileData_start + tileIndex * 16;
				drawTile(tx * 8 , ty * 8 , tilePointer, tileAttribute);
				mapWalk += 2;
				
			}
			mapLine+= mapData_lineIncrement;
		}
	}
	
	public function blitImage(avr:AVR8, pixelsPerByte : Int = 3) {
		function render2PixelPerByteSpan(lineStart : Int, bytesWide:Int, srcLine:Int, flipX : Bool,doubleX :Bool) {
			var destWalk = lineStart;
			var srcWalk = srcLine;
			var nextPixel = doubleX ? 2:1;

			if (flipX) {
				destWalk += nextPixel * (bytesWide * 2 -1);
				nextPixel =-nextPixel;
			}
			
			for (b in 0...bytesWide) {
				var byte = avr.ram[srcWalk++];
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


		function render3PixelPerByteSpan(lineStart : Int, bytesWide:Int, srcLine:Int, flipX : Bool,doubleX :Bool) {
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

		function render4PixelPerByteSpan(lineStart : Int, bytesWide:Int, srcLine:Int, flipX : Bool,doubleX :Bool) {
			var destWalk = lineStart;
			var srcWalk = srcLine;
			var nextPixel = doubleX ? 2:1;

			if (flipX) {
				destWalk += nextPixel * (bytesWide * 4 -1);
				nextPixel =-nextPixel;
			}
			
			for (b in 0...bytesWide) {
				var byte = avr.ram[srcWalk++];
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

		function render8PixelPerByteSpan(lineStart : Int, bytesWide:Int, srcLine:Int, flipX : Bool,doubleX :Bool) {
			var destWalk = lineStart;
			var srcWalk = srcLine;
			var nextPixel = doubleX ? 2:1;

			if (flipX) {
				destWalk += nextPixel * (bytesWide * 8 -1);
				nextPixel =-nextPixel;
			}
			
			for (b in 0...bytesWide) {
				var byte = avr.ram[srcWalk++];
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
			

		var displayStart : Int = blitConfig[0] + (blitConfig[1] << 8);
		var bytesWide : Int = blitConfig[2];
		var height : Int = blitConfig[3];
		var lineIncrement : Int = blitConfig[4];
		var paletteStart : Int = blitConfig[5] + (blitConfig[6] << 8);
		var flags : Int = blitConfig[7];
		
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
		//var pixelsWide = (bytesWide * pixelsPerByte) << (doubleX?1:0);
		var nextLine = frameBufferWidth * (flipY? -1:1); 
		
		for (ty in 0...height) { 
			
			switch (pixelsPerByte) {
			 case 2: render2PixelPerByteSpan(lineStart, bytesWide, srcLine, flipX, doubleX);
			 case 3: render3PixelPerByteSpan(lineStart, bytesWide, srcLine, flipX, doubleX);
			 case 4: render4PixelPerByteSpan(lineStart, bytesWide, srcLine, flipX, doubleX);
			 case 8: render8PixelPerByteSpan(lineStart, bytesWide, srcLine, flipX, doubleX);
			}

			lineStart += nextLine;
			
			if (doubleY) {
				switch (pixelsPerByte) {
				 case 2: render2PixelPerByteSpan(lineStart, bytesWide, srcLine, flipX, doubleX);
				 case 3: render3PixelPerByteSpan(lineStart, bytesWide, srcLine, flipX, doubleX);
				 case 4: render4PixelPerByteSpan(lineStart, bytesWide, srcLine, flipX, doubleX);
				 case 8: render8PixelPerByteSpan(lineStart, bytesWide, srcLine, flipX, doubleX);
				}
				lineStart += nextLine;			

			}
			
			srcLine+= lineIncrement;
		}
		
		

	}


}