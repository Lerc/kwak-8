var viewScale = 16;

var sprite = {
  widthInBytes : 8,
  height : 16,
  pixelsPerByte : 2,
  data : new Uint8Array(8*16)

}

var mainpen=1;
var altpen=0;

var canvas=$(".workspace>canvas")[0];
var ctx=canvas.getContext("2d");

var exampleCtx=$(".examples>canvas")[0].getContext("2d");

var arnePalette =[
  		0xFF000000, 0xFF9D9D9D, 0xFFFFFFFF, 0xFF3326BE,
		0xFF8B6FE0, 0xFF2B3C49, 0xFF2264A4, 0xFF3189EB,
		0xFF6BE2F7, 0xFF4E482F, 0xFF1A8944, 0xFF27CEA3,
		0xFF32261B, 0xFF845700, 0xFFF2A231, 0xFFEFDCB2];
  
var palette =[
		0x00000000, 0xFF9D9D9D, 0xFFFFFFFF, 0xFF3326BE,
		0xFF8B6FE0, 0xFF2B3C49, 0xFF2264A4, 0xFF3189EB,
		0xFF6BE2F7, 0xFF4E482F, 0xFF1A8944, 0xFF27CEA3,
		0xFF32261B, 0xFF845700, 0xFFF2A231, 0xFFEFDCB2];

$(".popup").on( "click" , 
  function (e) {
    $(e.target).removeClass('showing');
  }
)

$(".popup>.Palette>.PaletteEntry").on( "click" , 
  function (e) { 
    var target=$(e.target);
    var resultTarget = $($(".popup").data('triggeredBy'));
    resultTarget.trigger("popup_result", target.attr("data-color"));
    $(".popup").removeClass('showing');
  } 
);
$(".MicroPalette>.PaletteEntry").on( "mousedown" , 
  function (e) { 
	switch(e.button) {
	  case 1:
		var here=$(e.target).offset();
		here.left+=$(e.target).width();
		here.left+="px";
		here.top+="px";
		$(".Palette").css(here);
		$(".popup").addClass('showing').data({triggeredBy : e.target});
	    break;
	  case 0:
		$(".MicroPalette>.PaletteEntry").removeClass("mainpen");
		$(e.target).addClass("mainpen");
		mainpen=parseInt($(e.target).attr("data-index"));
		break;
	  case 2:
		$(".MicroPalette>.PaletteEntry").removeClass("altpen");
		$(e.target).addClass("altpen");
		altpen=parseInt($(e.target).attr("data-index"));
		e.preventDefault();
		break;
    }
	
  }
).on("popup_result", 
  function (e,color) {
	var index =$(e.target).attr("data-index");
	palette[index]= (index|color)?arnePalette[color]:0;
    $(e.target).attr("data-color",color);
	updateCanvas();
  }
).on("contextmenu", 
  function(){return false;}
);

$("select").on("change", 
  function(e) {
    sprite.pixelsPerByte=parseInt(e.target.value);
	syncCanvasSize();
    $(".PaletteSets").attr("data-pixelsPerByte",e.target.value);
  }
);

$("#SpriteWidth").on("change",
  function (e) {
	setDataSize(e.target.value,sprite.height);
  }	
);
$("#SpriteHeight").on("change",
  function (e) {
	setDataSize(sprite.widthInBytes,e.target.value);
  }	
);


$(".output>button").on("click",
  function (e) {
	var outputText = generateCSource(sprite);
	alert( outputText) ;
  }	
);
  
function generateCSource(sprite) {
  var result = "const uint8_t spriteName_Palette[] PROGMEM = {0x00,0x21,0x23,0x45,0x67,0x89,0xab,0xcd}; \n";
  result+= "const uint8_t spriteName_data[] PROGMEM = { " + [].slice.call(sprite.data) + " };\n";
  
  return result;
}  
function drawExampleImages(image)  {
  var w=image.width;
  var h=image.height;
  
  exampleCtx.clearRect(0,0,1000,1000);
  exampleCtx.putImageData(image,w,h);
  exampleCtx.putImageData(scaleImageData(image,2,2),w*3,h);
  exampleCtx.putImageData(scaleImageData(image,3,3),w*6,h);
  exampleCtx.putImageData(scaleImageData(image,4,4),w*10,h);

  exampleCtx.putImageData(scaleImageData(image,1,2),w,h*6);
  exampleCtx.putImageData(scaleImageData(image,2,4),w*3,h*6);
  exampleCtx.putImageData(scaleImageData(image,3,6),w*6,h*6);
  exampleCtx.putImageData(scaleImageData(image,4,8),w*10,h*6);

  exampleCtx.putImageData(scaleImageData(image,2,1),w,h*16);
  exampleCtx.putImageData(scaleImageData(image,4,2),w*3,h*16);
  exampleCtx.putImageData(scaleImageData(image,6,3),w*6,h*16);
  exampleCtx.putImageData(scaleImageData(image,8,4),w*10,h*16);
  
}
function updateCanvas() {
  var im=generateImageFromsSpriteData(sprite);

  drawExampleImages(im)
  
  ctx.putImageData(scaleImageData(im,viewScale,viewScale),0,0);
  ctx.beginPath();
  for (var i=0; i<sprite.widthInBytes;i++) {
	var x = i * viewScale* sprite.pixelsPerByte;
	ctx.moveTo(x,0);
	ctx.lineTo(x,canvas.height);
  }
  ctx.strokeStyle="rgba(100,0,100,0.15)";
  ctx.stroke();
}
  
function syncCanvasSize() {
   canvas.width=sprite.pixelsPerByte*sprite.widthInBytes*viewScale;
   canvas.height=sprite.height*viewScale;  
   updateCanvas();
}  

function setDataSize(w,h) {
  var newData = new Uint8Array(w*h);  
  for (var ty=0; ty < Math.min(h,sprite.height); ty++) {
	for (var tx=0; tx < Math.min(w,sprite.widthInBytes); tx++) {
	  newData[tx+ty*w] = sprite.data[tx+ty*sprite.widthInBytes];
	}
  }
  //newData.set(sprite.data,0);
  sprite.data=newData;
  sprite.widthInBytes=w;
  sprite.height=h;
  syncCanvasSize();
}

function generateImageFromsSpriteData( sprite ) {
  var w = sprite.widthInBytes * sprite.pixelsPerByte;
  var h = sprite.height;
  
  var image = new ImageData(w,h);
  var imagePixels = new Uint32Array(image.data.buffer);
  
  function write2PixelPerByteSpan(dataStart,imageStart) {
	  for (var tx=0; tx<sprite.widthInBytes; tx++) {
		var data = sprite.data[dataStart+tx];
		imagePixels[imageStart+tx*2]=palette[data>>4];
		imagePixels[imageStart+tx*2+1]=palette[data&0x0f];
	  }
  }
  
  function write3PixelPerByteSpan(dataStart,imageStart) {
	  for (var tx=0; tx<sprite.widthInBytes; tx++) {
		var data = sprite.data[dataStart+tx];
		var microPalette = (data & 0xC0)>>4;
		
		for (tp =0; tp<3;tp++) {
		  var pixel = (data & 0x30)>>4;
		  data <<= 2;
		  imagePixels[imageStart+tx*3+tp]=palette[microPalette+pixel];		  
		}
	  }
  }

  function write4PixelPerByteSpan(dataStart,imageStart) {
	  for (var tx=0; tx<sprite.widthInBytes; tx++) {
		var data = sprite.data[dataStart+tx];		
		for (tp =0; tp<4;tp++) {
		  var pixel = (data & 0xC0)>>6;
		  data <<= 2;
		  imagePixels[imageStart+tx*4+tp]=palette[pixel];		  
		}
	  }
  }

  function write8PixelPerByteSpan(dataStart,imageStart) {
	  for (var tx=0; tx<sprite.widthInBytes; tx++) {
		var data = sprite.data[dataStart+tx];
		for (tp =0; tp<8;tp++) {
		  var pixel = (data & 0x80)>>7;
		  data <<= 1;
		  imagePixels[imageStart+tx*8+tp]=palette[pixel];		  
		}
	  }
  }
  
  for (var ty =0; ty<sprite.height; ty++) {
	switch(sprite.pixelsPerByte) {
	  case 2:
		write2PixelPerByteSpan(ty*sprite.widthInBytes,ty*w);	
		break;
	  case 3:
		write3PixelPerByteSpan(ty*sprite.widthInBytes,ty*w);	
		break;
	  case 4:
		write4PixelPerByteSpan(ty*sprite.widthInBytes,ty*w);	
		break;
	  case 8:
		write8PixelPerByteSpan(ty*sprite.widthInBytes,ty*w);	
		break;
	}
  }
  return image;
}

function scaleImageData(imageData,sx,sy) {
  sy = sy|| sx;
  var w=imageData.width*sx;
  var h=imageData.height*sy;
  
  var image = new ImageData(w,h);
  
  var dstPixels = new Uint32Array(image.data.buffer);
  var srcPixels = new Uint32Array(imageData.data.buffer);
  
  for (var ty =0; ty<imageData.height; ty++) {
    for (var tx=0; tx<imageData.width; tx++) {
       var pixel = srcPixels[tx+ty*imageData.width];
       var topLeft = (tx*sx) + (ty*sy) *w;       
       for (var py=0;py<sy;py++) {
         for (var px=0;px<sx;px++) {
           dstPixels[ topLeft+px + py*w  ] =pixel;
         }
       }
    }
  }
  
 
  return image;  
}

syncCanvasSize();
updateCanvas();

var pixelMasks = {};

pixelMasks[8] = [0x80,0x40,0x20,0x10,0x08,0x04,0x02,0x01];
pixelMasks[4] = [0xC0,0x30,0x0C,0x03];
pixelMasks[3] = [0xf0,0xCC,0xC3];
pixelMasks[2] = [0xf0,0x0f];
  
  
function paint(pixelX,pixelY,button) {
  var byteIndex = pixelY  * sprite.widthInBytes + Math.floor(pixelX/sprite.pixelsPerByte);
	
	var pixelOffset = pixelX % sprite.pixelsPerByte;
	var mask = pixelMasks[sprite.pixelsPerByte][pixelOffset];
	var imask = (~mask) &0xff;
	var byte = sprite.data[byteIndex] & imask;
	
	var color = 0;
	
	switch(dragging) {
	  case 0:
		color= mainpen
	  break;
	  case 2:
		color = altpen
	  break;
	}

	switch(sprite.pixelsPerByte) {
	  case 2:
	    color<<= (4 - (pixelOffset*4));
	  break;
	  case 3:
	    var subColor = color & 3;
 	    subColor<<= (4 - (pixelOffset*2));
		var paletteSet = color >>2;
	    color = paletteSet <<6 | subColor;
	  break;
	  case 4:
 	    color<<= (6 - (pixelOffset*2));
	  break;
	  case 8:
   	    color<<= (7 - (pixelOffset*1));
	  break;
	}  
  	byte |= color &mask;

	
	sprite.data[byteIndex]=byte;
	
	$("#note").text("pixel X:"+pixelX+"    pixelY:"+pixelY +"     ByteIndex:"+byteIndex+"     pixelOffset"+pixelOffset+ "     mask: 0x"+imask.toString(16));
	updateCanvas();
	
} 

var dragging = null;
  
$(canvas).on("mousedown",
  function (e) {
   	if (dragging === null) {
	  dragging = e.button;
	  e.preventDefault();
	  paint(Math.floor(e.offsetX/viewScale),Math.floor(e.offsetY/viewScale),dragging);
	}
  }
).on("mouseup",
  function (e) {
   	if (dragging === e.button) {
	  dragging = null;
	}
  }
)
.on("contextmenu", 
  function(){return false;}  
).on("mousemove",
  function (e) {
	if (dragging === null) {
	  return
	}
	paint(Math.floor(e.offsetX/viewScale),Math.floor(e.offsetY/viewScale),dragging);	
  }
);

