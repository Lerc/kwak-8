package;
import haxe.io.UInt8Array;
import js.html.ImageData;
import js.html.Uint32Array;


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
	
	var smallPalette : UInt8Array = new UInt8Array(64); 
	
	var palette : Uint32Array = new Uint32Array(
		//[0xff000000, 0xff9d9d9d, 0xffffffff, 0xff3326be, 0xff8b6fe0, 0xff2b3c49, 0xff2264a4, 0xff3189eb, 0xff6be2f7, 0xff4e482f, 0xff1a8944, 0xff27cea3, 0xff32261b, 0xff845700, 0xfff2a231, 0xffefdcb2, 0xff111111, 0xff222222, 0xff333333, 0xff444444, 0xff555555, 0xff666666, 0xff777777, 0xff888888, 0xffa5a5a5, 0xffbebebe, 0xffc8c8c8, 0xffd2d2d2, 0xffdcdcdc, 0xffe6e6e6, 0xfff0f0f0, 0xfffafafa, 0xfff80406, 0xfffe1783, 0xffa5031c, 0xff780061, 0xff460158, 0xff5b376c, 0xff3b2e73, 0xff220051, 0xff000164, 0xff003281, 0xff00519a, 0xff0083b4, 0xff02abff, 0xff0079ff, 0xff3265ff, 0xff0707ff, 0xfffe4925, 0xffff5b8f, 0xffb02a67, 0xff5e000d, 0xff60273b, 0xff3f2540, 0xff272944, 0xff000635, 0xff2a376e, 0xff004a71, 0xff276f93, 0xff63acff, 0xff1f8bdc, 0xff0169bf, 0xff0251d6, 0xff010ccb, 0xfff96a01, 0xffff7c72, 0xffc1596d, 0xff8b3001, 0xff401400, 0xff1d001c, 0xff00001a, 0xff1e2a30, 0xff093341, 0xff123459, 0xff5081b3, 0xff3e65ab, 0xff628ee4, 0xff30469d, 0xff010197, 0xff5250ff, 0xffff8a30, 0xffb75005, 0xff89464e, 0xff694500, 0xff3d2600, 0xff190000, 0xff001600, 0xff002821, 0xff2a4d4e, 0xff395e70, 0xff3b547c, 0xff6f7dcb, 0xff8798ff, 0xff4254c9, 0xff3103a0, 0xff3605d6, 0xfffea607, 0xffa86a01, 0xffaf7260, 0xff7a5a5e, 0xff573a31, 0xff2c2925, 0xff2d2e14, 0xff2d402f, 0xff3d6a66, 0xff56718e, 0xff3b4658, 0xff65709e, 0xff6a60c6, 0xff8d62ff, 0xff6109d1, 0xff5e01ff, 0xffffab7e, 0xffc18700, 0xffbb8e80, 0xff927675, 0xff785e4b, 0xff423841, 0xff424a4a, 0xff5e6c68, 0xff5b7a83, 0xff5b646f, 0xff504964, 0xff515487, 0xff61459a, 0xff560191, 0xff8408bc, 0xff8b04fb, 0xffffd4a9, 0xffcfb788, 0xffaa926f, 0xff8c7753, 0xff51473b, 0xff5e575a, 0xff78726e, 0xff7c8780, 0xff7d93a1, 0xff787e89, 0xff746b7d, 0xff79699e, 0xff986acb, 0xffcc8bfe, 0xffc24dff, 0xffbb0eda, 0xffffc904, 0xffc7a428, 0xff958206, 0xff7e6402, 0xff544802, 0xff646250, 0xff8e8e66, 0xffa09e90, 0xffa5afb2, 0xffa6a3b2, 0xff8a84a1, 0xff9489ce, 0xff9057a6, 0xffbf67c1, 0xfffe77ff, 0xffff06fe, 0xffffe76e, 0xffd4c101, 0xffa59e01, 0xff64630d, 0xff3c4800, 0xff6c7653, 0xffa0ab88, 0xffbfd9c2, 0xffb2cfd4, 0xffabbcd4, 0xff7d8eb2, 0xffb6a7ff, 0xfffdb5ff, 0xffff9cd2, 0xffff6ec5, 0xfffe04c5, 0xfffffd02, 0xffb0bc3a, 0xff7c8602, 0xff567003, 0xff456047, 0xff768f62, 0xff6c9387, 0xff8cb7a4, 0xff5693ab, 0xff79a4ce, 0xffa2a9d8, 0xffbba7ce, 0xffc68fc6, 0xfffe9ca1, 0xffbc509d, 0xffa9039f, 0xffdfff60, 0xffc8d593, 0xff85a102, 0xff2c5601, 0xff003601, 0xff49835f, 0xff3a8380, 0xff53aba5, 0xff7ab9ce, 0xffa4d0ff, 0xffcfd8ff, 0xffe1cfff, 0xffffd3eb, 0xfff9c0bb, 0xffcf7894, 0xff894478, 0xffa9d404, 0xffa8db93, 0xff8bb372, 0xff538a01, 0xff00533a, 0xff007453, 0xff006972, 0xff00929d, 0xff6bceff, 0xffb1eaff, 0xffd7ebff, 0xffffefff, 0xffffe9dd, 0xffd1bcc5, 0xffc19ba5, 0xff9d657f, 0xff76d325, 0xff62ac00, 0xff59a776, 0xff086906, 0xff0f8811, 0xff009368, 0xff04b682, 0xff1bd5bc, 0xff19b4cd, 0xff8ad6cb, 0xffe5ffff, 0xfff7ffe7, 0xfffeedc3, 0xffd1cfd0, 0xffc3aca1, 0xff9f7c98, 0xffadff2f, 0xff96ffa5, 0xff6ccf92, 0xff0ca919, 0xff05d028, 0xff2fff33, 0xff2affb5, 0xff1dfefc, 0xff02dbfe, 0xff99fffe, 0xffc5ffe4, 0xffe2ffc5, 0xffffffb6, 0xffcacaae, 0xff988c8d, 0xff75587b]
		[0xff000000,0xff9d9d9d,0xffffffff,0xff3326be,0xff8b6fe0,0xff2b3c49,0xff2264a4,0xff3189eb,0xff6be2f7,0xff4e482f,0xff1a8944,0xff27cea3,0xff32261b,0xff845700,0xfff2a231,0xffefdcb2,0xff212121,0xff363636,0xff484848,0xff585858,0xff676767,0xff767676,0xff838383,0xff909090,0xffa9a9a9,0xffb4b4b4,0xffc0c0c0,0xffcbcbcb,0xffd6d6d6,0xffe0e0e0,0xffebebeb,0xfff5f5f5,0xfffb8400,0xffd06d45,0xffa53100,0xff900008,0xffde1319,0xffff0000,0xfffa4f00,0xffff7992,0xffff9ea5,0xffffa77d,0xff743c3c,0xff5b3800,0xff310009,0xff451f33,0xff250037,0xff26005c,0xff641e00,0xffab4f4e,0xffd36275,0xffae0461,0xffef3875,0xffff4ea4,0xffff6fc9,0xffff9bd8,0xffc7709d,0xffd58873,0xff996a61,0xff55423a,0xff1a0200,0xff1b0019,0xff322547,0xff00004f,0xff5b0038,0xff772c5b,0xffa74c7c,0xffc0009c,0xffdb00cd,0xffff00ff,0xfff374ff,0xfff4afff,0xffd099ae,0xffb08185,0xff8a5f77,0xff5b3e52,0xff362930,0xff00001a,0xff04002e,0xff001e68,0xff4e205c,0xff734179,0xff9c4ca5,0xff80008b,0xff9500dc,0xffb652ff,0xffc35ccb,0xffc787cd,0xff7a5b95,0xff957694,0xff6e585c,0xff464255,0xff1c233b,0xff001421,0xff002341,0xff00376c,0xff0000ff,0xff4224ff,0xff5300e5,0xff8106ff,0xff4c0087,0xff6c31ab,0xffbb8afc,0xff986bbc,0xff524075,0xff4e5277,0xff626b80,0xff3d5050,0xff3c4932,0xff21332f,0xff002730,0xff003b53,0xff0b5aff,0xff0046c7,0xff0100a9,0xff656eff,0xff160083,0xff3a009f,0xff7054bd,0xff50499a,0xff2d2d63,0xff2a3c5f,0xff44596a,0xff3e666b,0xff3a5e49,0xff12413e,0xff00210f,0xff0f1600,0xff00a5ff,0xff0066d1,0xff003b98,0xff658dff,0xff4361d4,0xff988fff,0xff6769c7,0xff4759a8,0xff2e3d86,0xff3a5784,0xff1e5777,0xff00545d,0xff00532f,0xff023a00,0xff262f00,0xff312a00,0xff007bc2,0xff006b93,0xff58a0d5,0xff74adff,0xff5982ca,0xff808cc9,0xff8e82b5,0xff6b699b,0xff6275a3,0xff4c6f8b,0xff3d7b89,0xff1f6e55,0xff0d6f00,0xff2a5900,0xff51632d,0xff555400,0xff27a9cf,0xff0087ad,0xff6fc6ff,0xff96bde2,0xffaac1ff,0xffacade2,0xffb99fca,0xff9b9ab3,0xff829bc0,0xff5585ad,0xff527d6e,0xff48997b,0xff6b9466,0xff4a773d,0xff6d8118,0xffa1a700,0xff00c9ff,0xff34949b,0xff45b7ba,0xffade3ff,0xffcfe2f9,0xffd3b4b6,0xffa9939e,0xff827d92,0xff768698,0xff79a3b7,0xff7ab1a0,0xff9ddab8,0xff8ab57b,0xff80a416,0xffa9c800,0xffd9fc00,0xff00ffff,0xff008271,0xff80efd2,0xffbdffff,0xffc7dace,0xffd0bba8,0xffb4998c,0xff887477,0xff647a7f,0xff679292,0xff8ecbd0,0xffd8ffe3,0xffdfffb1,0xffd0d878,0xfffbf035,0xffffff00,0xff00ffaf,0xff00b06c,0xff9effaa,0xffc0ffc0,0xffb9d3a5,0xffcbb87f,0xffaa936c,0xff8d7967,0xff5c6c61,0xff7b8c7e,0xffaac2cb,0xffe1faff,0xffffffe4,0xfffdffb5,0xffffe96b,0xffcfc200,0xff00d019,0xff36aa00,0xff68c480,0xffaae272,0xffa8b37c,0xffa2953c,0xff937c3c,0xff715e4d,0xff818067,0xff98aca2,0xffb0bad2,0xffd8daff,0xffffefff,0xffffe1d8,0xffffcc00,0xffd2a600,0xff00ff00,0xff75eb00,0xff77c300,0xff4e9100,0xff87915f,0xff7b7600,0xff776200,0xff67654c,0xff9e9e85,0xffc0c2a9,0xffcdc0d6,0xffd3b8ff,0xffffd7ff,0xffffc0d7,0xffffc989,0xffb37500]
/*
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
		
	]*/
	
	);
    
		
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
		var tileData_start : Int = modeData[0] + (modeData[1] << 8);
		var mapData_start  : Int = modeData[2] + (modeData[3] << 8);
		var paletteData_start  : Int = modeData[5] + (modeData[6] << 8);
		var shiftX : Int = modeData[7]>>4;
		var shiftY : Int = modeData[7]&0x0f;
		var mapData_lineIncrement : Int = modeData[4]<<3;

		var tilesWide :Int = 480 >>3;
		var tilesHigh :Int = 360 >>3;

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
			
			var displayoffset = y * frameBufferWidth + x;
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
				drawTile(tx * 8 + shiftX, ty * 8 + shiftY, tilePointer, tileAttribute);
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