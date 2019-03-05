Sugar.extend();

var template = new Image();

$(init);

function suppressDefault(e) {
	e.preventDefault();
}

function blobToData(blob,method="readAsArrayBuffer") {
	return new Promise( (resolve,reject) => {
		var reader = new FileReader();
		reader.onerror = _=>reader.abort();
		reader.onabort = _=>reject();
		reader.onload = _=>resolve(reader.result);
		reader[method](blob);
	});
}

function blobToText(blob) {
	return blobToData(blob,"readAsText");
}

function blobToURL(blob) {
	return blobToData(blob,"readAsDataURL");
}

function blobToBinaryString(blob) {
	return blobToData(blob,"readAsBinaryString");
}

function loadedImage(url) {
	return new Promise( (resolve,reject)=>{
		var image = new Image();
		image.onload=_=>resolve(image);
		image.onerror=e=>reject(e.error);
		image.src=url;
	})
}

function onFileDrop(selector,callback) {
	let jq = $(selector);
	jq.on("dragenter",suppressDefault);
	jq.on("dragover",suppressDefault);
	jq.on("drop", e=>{
		e.preventDefault();
		let data=e.originalEvent.dataTransfer;
		if (data.items) {
			if (data.items.length !== 1) {
				throw new Error("Only one file at a time permitted");
			}
			if (data.items[0].kind === 'file') {
				var file = data.items[0].getAsFile();
				console.log('... file.name = ' + file.name);
				callback(file)
			}
		} else {
			if (data.files.length !== 1) {
				throw new Error("Only one file at a time permitted");
			}
			callback(data.files[0])
		}
	})

}
var screenshotCtx;
var cornerMask = new Image();
cornerMask.src="ScreenShotCornerMask.png";
var programData = [];

function assembleCart() {

	let ctx = $("#cart canvas")[0].getContext("2d");
	let template=$("#template img")[0];
	let screenshot=$("#screenshot canvas")[0];
	let title = $("#title").val();
	let titleFont = $("#title-font").val();

	var cartImage=Cart.encode(programData,screenshot,title,titleFont,template);
	ctx.drawImage(cartImage,0,0);

}

function init() {
	screenshotCtx = $("#screenshot canvas")[0].getContext("2d");
	$("input").on("keydown", e=>{if (e.keyCode === 13) assembleCart()});
	cornerMask.onload = _=>{
		screenshotCtx.drawImage(cornerMask,0,0);
		screenshotCtx.font="24px sans-serif";
		screenshotCtx.textAlign="center";
		screenshotCtx.fillStyle="white"
		screenshotCtx.fillText("Drop cartridge label here", 240,100);
		screenshotCtx.font="16px sans-serif";
		screenshotCtx.fillText("Image will be scaled to 480x360", 240,200);
		screenshotCtx.fillText("Corners will be trimmed automatically", 240,230);

	}

	$("#cart").on("dragenter", e=>{
		console.log("cart drag enter", e);
		e.preventDefault();
	});

	function setCodeChunks(chunks) {
		programData=chunks;
		let totalLength=0;
		let s="";
		for (let chunk of chunks) {
			var len = chunk.data.length;
			totalLength+=len;
			s+="<p>chunk of size "+len+" at 0x"+chunk.address.toString(16)+"</p>"
		}
		s="<h3>loaded  "+chunks.length+" chunks totaling " +totalLength+ " bytes</h3>" + s;
		$("#code").html(s);
	}

	onFileDrop("#code",blob=>{
		blobToText(blob).then(text=>{
			let hex = new HexFile(text);
			hex.merge();
			setCodeChunks(hex.data)			
			assembleCart();
		});
	})


	$("#template").on("dragenter", e=>{
		console.log("template drag enter", e);
		e.preventDefault();

	});

	onFileDrop("#screenshot",blob=>{
		blobToURL(blob).then(loadedImage).then(image => {
			screenshotCtx.clearRect(0,0,480,360);
			screenshotCtx.drawImage(cornerMask,0,0);
			screenshotCtx.globalCompositeOperation="source-in";
			screenshotCtx.drawImage(image,0,0,480,360);			
			screenshotCtx.globalCompositeOperation="source-over";
			assembleCart();
		 });
	});

	onFileDrop("#cart",blob=>{
		blobToURL(blob).then(loadedImage).then(image => {
			let ctx = $("#cart canvas")[0].getContext("2d");
			ctx.drawImage(image,0,0);
			let chunks = Cart.decode(image);
			screenshotCtx.clearRect(0,0,480,360);
			screenshotCtx.drawImage(cornerMask,0,0);
			screenshotCtx.globalCompositeOperation="source-in";
			screenshotCtx.drawImage(image,14,34,480,360,0,0,480,360);
			screenshotCtx.globalCompositeOperation="source-over";
			console.log(chunks);
			setCodeChunks(chunks);
		})
	});
}