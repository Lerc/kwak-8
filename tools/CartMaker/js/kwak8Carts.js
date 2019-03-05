
var Steg = (_=>{
  let fieldBit =[16,0,8,17,1,9,18,2,10].map(a=>1<<a);
  
  function hash18( x)
  {
      x ^= x >> 9;  
      x *= 0x7feb352d;    x&=0x3ffff;
      x ^= x >> 9; 
      x *= 0x846ca68b;    x&=0x3ffff;
      x ^= x >> 9;
      return x;
  }
  
function encode(image,data) {
  let width=image.width;
  let height=image.height;
  let pixelCount=width*height;
  let maxData = pixelCount*9/8 -32768;
  if (data.length > maxData) {
    throw new Error("Not enough pixels in which to store data")
  }
  let pixels=new Uint32Array(image.data.buffer);
  
  function writeBit(index,value=1) {
    value &=1;
    let low18 = index &0x3ffff;
    index -= low18;
    index += hash18(low18);
    let pixelIndex = index % pixelCount;
    let field = Math.floor(index / pixelCount);
    let bit = fieldBit[field];
    if (value === 0) {
      pixels[pixelIndex]&=~bit;
    } else {
      pixels[pixelIndex]|= bit;     
    }
  }
  function writeByte(byteIndex, value) {
    //console.log("value is "+value.toString(2),value )

    let bitIndex = byteIndex*8;
    for (let i=0;i<8;i++) {
      let bit=(value & 0x80) ? 1:0;

      writeBit(bitIndex++,bit);
      value<<=1;
    }
  }

  for (let i=0; i<data.length; i++) {
    writeByte(i,data[i]);
  }
}


function decode(image,start=0,dataLength=256) {
  let width=image.width;
  let height=image.height;
  let pixelCount=width*height;
  let pixels=new Uint32Array(image.data.buffer);
  

  function readBit(index) {
    let low18 = index &0x3ffff;
    index -= low18;
    index += hash18(low18);
    let pixelIndex = index % pixelCount;
    let field = Math.floor(index / pixelCount);
    let bit = fieldBit[field];
    return (pixels[pixelIndex]&bit)!=0?1:0; 
  }

  function readByte(byteIndex) {
    let bitIndex = byteIndex*8;
    let result=0;
    for (let i=0;i<8;i++) {
      let bit =readBit(bitIndex)
      result = (result <<1) + bit;
      bitIndex+=1;
    }
    return result;
  }

  let result = new Uint8Array(dataLength);
  for (let i=0; i<dataLength; i++) {
    result[i]=readByte(i+start);
    
  }
  return result;
}
  
  return {encode,decode};
})();


var Cart = (_=>{
  var cartTemplate = new Image();
  cartTemplate.src="CartTemplate.png";
  
  var screenShotMask = new Image();
  screenShotMask.src="ScreenShotCornerMask.png";
  
  var asciiArray = s=>[...s].map(a=>a.charCodeAt(0))
  
  var Magic = asciiArray("K8_1");
  var ROM_  =  asciiArray("ROM_");
  var END_  =  asciiArray("END_");
  
  var dataBounds = [0,34,512,350];

  function joinChunks(chunkData) {
    let totalLength=8;  //Magic(4) body(...) END_(4)
    let chunks = chunkData.map( ({address,data}) => {
      let result = new Uint8Array(data.length+12);
      result.set(ROM_,0);
      let view = new DataView(result.buffer);
      view.setInt32(4,data.length+4);
      view.setInt32(8,address);
      result.set(data,12)
      totalLength+=result.length;
      return result;       
    });

    let result = new Uint8Array(totalLength);
    let offset=4;
    result.set(Magic,0);
    for (let chunk of chunks) {
      result.set(chunk,offset);
      offset+=chunk.length; 
    }
    result.set(END_,offset);offset+=4;
    return result;
  }

  function masked(image,mask) {
    let result= document.createElement("canvas");
    result.width=mask.width;
    result.height=mask.height;
    let ctx=result.getContext("2d");
    ctx.clearRect(0,0,result.width,result.height);
    ctx.drawImage(mask,0,0);
    ctx.globalCompositeOperation="source-in";
    ctx.drawImage(image,0,0)
    return result;
  }
  function encode (dataChunks,screenShot,label="* Half Life III *",font="29px journal",template=cartTemplate) {
    let result= document.createElement("canvas");
    result.width =512;
    result.height = 446;
    let ctx= result.getContext("2d");
    ctx.drawImage(template,0,0);
    screenShot=masked(screenShot,screenShotMask);

    ctx.drawImage(screenShot,14,34);

    ctx.font = font;
    ctx.textAlign = "center";
    ctx.textBaseline="bottom"
    ctx.fillstyle="black";
    ctx.fillText (label,256,33);

    let dataArea = ctx.getImageData(...dataBounds);
    let data = joinChunks(dataChunks);
    Steg.encode(dataArea,data);

    ctx.putImageData(dataArea,dataBounds[0],dataBounds[1]);
    return result;
  } 

  function decode(image) {
    function sameData(a,b) {
      if (a.length!=b.length) return false;
      for (let i=0;i<a.length; i++) {
        if (a[i]!==b[i]) return false;
      }
      return true;
    }
    let canvas= document.createElement("canvas");
    canvas.width=image.width;
    canvas.height=image.height;
    let ctx=canvas.getContext("2d");
    ctx.drawImage(image,0,0)
    var dataArea = ctx.getImageData(...dataBounds);
    let header = Steg.decode(dataArea,0,4);
    if (!sameData(header,Magic)) {
      throw new Error("No data Detected")
    }

    result = [];
    let offset = 4;
    while (true ) {
      let chunk = Steg.decode(dataArea,offset,8);
      offset+=8;

      let id= chunk.slice(0,4);
      if (!sameData(id,ROM_) ) break;
      let view = new DataView(chunk.buffer);
      let length=view.getInt32(4);      
      let body = Steg.decode(dataArea,offset,length);
      offset+=length;
      view = new DataView(body.buffer);
      let address = view.getInt32(0);
      let data= body.slice(4);
      result.push({address,data});
    }
    return result;
  }
  return {encode,decode};
})();

