package;
import js.html.audio.AudioContext;
import js.html.audio.AudioBufferSourceNode;
import js.html.audio.AudioBuffer;
import js.html.audio.ScriptProcessorNode;
import js.html.audio.AudioProcessingEvent;
/**
 * ...
 * @author Lerc
 */
class Audio 
{
	var ctx : AudioContext;
	var source : AudioBufferSourceNode;
	var sourceBuffer : AudioBuffer;
	var scriptNode : ScriptProcessorNode;

	var wave : Float;
	var tone : Float;

	public var voices : Array<Voice>;

	
	static var sine= Math.sin;
	static var square = function (x) {return Math.sin(x)>0?1:-1;};
	static var triangle = function (x) {return Math.asin(Math.sin(x));};
	var waveForm = sine;

	public function new() 
	{
		ctx = new AudioContext();
		
		sourceBuffer = ctx.createBuffer(1, 20480, 44100);
		
		voices = [for (i in 0...8) new Voice()];

		for (channel in 0...sourceBuffer.numberOfChannels) {
			var data = sourceBuffer.getChannelData(channel);
			
			for (i in 0...data.length){
				data[i] = Math.random() * 0.1 - 0.05;
			}
		}		
		source = ctx.createBufferSource();
		source.buffer = sourceBuffer;
		source.loop=true;


		scriptNode=ctx.createScriptProcessor(1024,1,1);
		trace("buffer size of script node is "+scriptNode.bufferSize);
	    scriptNode.onaudioprocess=generateAudioData;

		source.connect(scriptNode);
		scriptNode.connect(ctx.destination);

		tone=stepForFrequency(856);
		wave=0;
		waveForm=square;
	}
	
	public function start() {
		ctx.resume();
	}
	
	public function stop() {
		ctx.suspend();
	}

	function stepForFrequency(freq : Float) : Float {
		return 2*Math.PI*freq/sourceBuffer.sampleRate;
	}

	function generateAudioData(e :AudioProcessingEvent) {
		for (v in voices) {
			v.update();
		}
		var out = e.outputBuffer;

		var data = out.getChannelData(0);			
		for (i in 0...data.length){
			var voiceSample=0.0;
			for (v in 0...8) { 	
				voiceSample+=voices[v].nextSample();
			};
			data[i] = voiceSample;
		}
/*
		data = out.getChannelData(1);			
		for (i in 0...data.length){
			var voiceSample=0.0;
			for (v in 4...8) { 	
				voiceSample+=voices[v].nextSample();
			};
			data[i] = voiceSample;
		}
*/
	}
}