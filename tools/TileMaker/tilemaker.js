
var ui = {};

var imageData;

var pixelScale=4;
var tiles = [];

var arnePalette = [
		0xFF000000, 0xFF9D9D9D, 0xFFFFFFFF, 0xFF3326BE,
		0xFF8B6FE0, 0xFF2B3C49, 0xFF2264A4, 0xFF3189EB,
		0xFF6BE2F7, 0xFF4E482F, 0xFF1A8944, 0xFF27CEA3,
		0xFF32261B, 0xFF845700, 0xFFF2A231, 0xFFEFDCB2 ];
var arnePaletteCSS = []
for (let p of arnePalette) {
  let r=((p)&0xff).toString(16).padLeft(2,"0");
  let g=((p>>8)&0xff).toString(16).padLeft(2,"0");
  let b=((p>>16)&0xff).toString(16).padLeft(2,"0");
  arnePaletteCSS.push("#"+r+g+b);
}

function rgbDistance(a,b) {
  dr = ((a & 0x0000ff) - (b & 0x0000ff));
  dg = ((a & 0x00ff00) - (b & 0x00ff00)) >> 8;
  db = ((a & 0xff0000) - (b & 0xff0000)) >> 16;
  
  return Math.sqrt(dr*dr + dg*dg + db*db);  
}

var paletteList = [];  // list of palette sets.

function findCompatiblePalette(colours) {
  if (colours.length >4) return null; //  palette sets may only have up to 4 colours.
  for (var i=0; i<paletteList.length; i++) {
	var both = paletteList[i].union(colours);
	if (both.length <= 4) {
	  if (paletteList[i].length < both.length) {
		paletteList[i]=both;
	  }
	  return i;
	}
  }
  //if we get here there is no compatible palette yet
  var result = new Array(colours);
  paletteList.add(result);
  return paletteList.length-1;
}

function closestPaletteColour(colour) {
  var smallestDifference = 999999999;
  var best = 0;
  for (var i in arnePalette) {
	var current=rgbDistance(arnePalette[i],colour);
	if (current < smallestDifference) {
	  best=i;
	  smallestDifference=current;
	}
  }
  return best;
}  

function makeTile(x,y,data) {
  result = {"x":x,"y":y,"imageData" : data};
  var colours = [];  
  result.pixels = new Uint32Array(data.data.buffer);
  result.indexedImage = new Uint8Array(result.pixels.length);
  for (var i=0;i<result.pixels.length;i++) {
	var index = closestPaletteColour(result.pixels[i]);
	result.indexedImage[i]=index;
	colours[index]=1;
  }
  result.colours=[];
  for (var c in colours) {
	result.colours.push(parseInt(c));  // because for...in variable is a string
  }
  result.microPalette=findCompatiblePalette(result.colours);
  console.log(result);
  return result;
} 

function drawRemappedTile(tile) {
  var image = new ImageData(8,8);
  var pixels = new Uint32Array(image.data.buffer);
  var microPalette = paletteList[tile.microPalette];

  
  if (!microPalette) {
	microPalette = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];
  }
  
  var falseColour = [0xff00ff00,0xffffffff,0xff000000,0xffff00ff];
  
  for (var i=0; i<tile.indexedImage.length;i++) {
	var index = microPalette.indexOf(tile.indexedImage[i]);	
	
	//pixels[i] = arnePalette[microPalette[index]];
	pixels[i] = falseColour[index];
  }
    
  createImageBitmap(image).then(
	bitmap => ui.remapctx.drawImage(bitmap,tile.x*pixelScale,tile.y*pixelScale,8*pixelScale,8*pixelScale)
  );
}

function bswap(x) {
	return ((x>>8) &0xff) | ( (x&0xff) <<8)
}
  
function palettesAsCode() {

  var code = "uint16_t tileset_palettes[] = {\n\t";
  for (let p of paletteList) {	
	let value = 0;
	for (let c of p) {
	  value = (value<<4) + (c); 
	}
	
	let hex =bswap(value).toString(16).padLeft(4,"0");
	code += "0x"+hex+",";	
  }
  code+="\n};\n";
  return code;
}
function tileAsWords(tile) {
  var code = "";
  var microPalette = paletteList[tile.microPalette];
  if (!microPalette) return "Tile does not have a matching 4 colour palette"; 
  
  for (ty=0; ty<8; ty++) {
	var word =0;
	for (tx=0; tx<8; tx++) {
	  var bits = microPalette.indexOf(tile.indexedImage[ty*8+tx]);
	  word = (word<<2) + bits;
	}
	let hex =bswap(word).toString(16).padLeft(4,"0");
	code+= "0x"+hex+",";
  }
  
  return code;
}

function tilesAsCode() {
  var code = "uint16_t tileset[] = { \n";
  

  for (t of tiles) {
	code+= "\t"+tileAsWords(t) + "\n";
  }
  code+="\n};\n";
  return code;
}
function generateSource() {
  code = palettesAsCode() + tilesAsCode();
  
  ui.code.text(code);
}
  
$( document ).ready(function() {
"use strict"
  
  ui.sourceImage = $('<img>').appendTo("#main")[0];
  
  ui.canvas = $('<canvas width="512" height="384"></canvas>').appendTo("#main")[0];
  ui.ctx=ui.canvas.getContext("2d");
  
  ui.remappedcanvas = $('<canvas width="512" height="384"></canvas>').appendTo("#main")[0];
  ui.remapctx=ui.remappedcanvas.getContext("2d");

  ui.palettes = $('<div class="palettelist"></div>').appendTo("#main");
  
  ui.button = $('<button>Generate Source</button>').appendTo("#main").on("click",generateSource)
  ui.code= $('<div class="code">').appendTo("#main");
  
  $(ui.sourceImage).on("load",function(e) {
	console.log("meep");
	paletteList=[];
	ui.canvas.width=ui.sourceImage.width*pixelScale;
	ui.canvas.height=ui.sourceImage.height*pixelScale;
	ui.remappedcanvas.width=ui.sourceImage.width*pixelScale;
	ui.remappedcanvas.height=ui.sourceImage.height*pixelScale;

  
	ui.ctx.drawImage(ui.sourceImage,0,0);
	
	//ui.ctx.getImageData(0,0,ui.sourceImage.width,ui.sourceImage.height);
	for (var ty=0; ty<ui.sourceImage.height;ty+=8) {
	  for (var tx=0; tx<ui.sourceImage.width;tx+=8) {
		tiles.push(makeTile(tx,ty,ui.ctx.getImageData(tx,ty,8,8)));
	  }
	}

	tiles.forEach(drawRemappedTile);

	ui.ctx.drawImage(ui.sourceImage,0,0,ui.sourceImage.width*pixelScale,ui.sourceImage.height*pixelScale);

	for (var tile of tiles) {
		//console.log(tile,tile.colours.length);
	}
	
	ui.palettes.empty();
	for (var pal of paletteList) {
	  var box = $('<div class="micropalette"></div>');
	  for (var colour of pal) {
		$('<img class="colourbox" style="background-color:'+arnePaletteCSS[colour]+'">').appendTo(box);
	  }
	  ui.palettes.append(box);
	}
  });
  
  $("#main").on("dragover", function(e) {
	e.stopPropagation();
	e.preventDefault();
	e.originalEvent.dataTransfer.dropEffect = 'copy';
	console.log("dragover");
  })
  .on ("drop", function(e) {
	e.stopPropagation();
	e.preventDefault();
	console.log("drop", e.originalEvent.dataTransfer);
	var files = e.originalEvent.dataTransfer.files; 
	if (files.length === 1) {
	  var file = files[0];
	  if (file.type.match(/image.*/)) {
		  var reader = new FileReader();
		  reader.onload = function(e2) {
			  
			  ui.sourceImage.src =  e2.target.result;
		  }
		  reader.readAsDataURL(file);
	  }
	}
  });

	
});

