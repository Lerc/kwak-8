
@:expose
class Voice {
    static inline var TWOPI = 6.2831853071795862; // Math.PI * 2;
    public var sampleRate(default,null) : Int;
    var sampleStep : Float;

    public var volume : Int;
    public var frequency(default,set) : Int;
    public var waveBase : Int;
    public var waveShift : Int;
    public var bendDuration(default,set) : Int;
    public var bendPhase : Int ;
    public var bendAmplitude : Int; 
    public var noise : Int ;
    public var hold(default,set) : Int;
    public var attack(default,set) : Int;
    public var release(default,set) : Int;     
    public var modulator:Bool = false;

    var position : Float =0.0;
    var soundAge : Float =0.0;
    var step : Float =0.0; 

    var bendHz : Float;
    var bendStep : Float;
    var attackDuration : Float;
    var releaseDuration : Float;
    var holdDuration : Float;
    var amplitude : Float =1.0;

    var waveGenerator = Math.sin;
    var shiftFunction : Float->Float;

    var filter: Float->Float;

    var lastNoisePos :Float =0.0;
    var noiseValue :Float =0.0;

    public function new(outputRate : Int = 44100) { 
        sampleRate=outputRate;
        sampleStep = 1.0/sampleRate;
        frequency=2504;
        hold=0;
        attack=0;
        release=0;
        bendPhase=0;
        bendDuration=0;
        bendAmplitude=0;

        waveBase=8;
        waveShift=0;
        bendAmplitude=0;
        noise=0;
        volume=0;
        position = 0;        

        filter=makeBandPassFilter(100,8000);
    }

    function makeSigmoidFunction (weight=0.5, low=0.0, high=1.0) : Float->Float{
      var range = high-low;
      if (weight==0) return function(a) {return a*range+low;};      
      var w = 0.4999/weight-0.5; //just a tad below |1| at the ends
      var mid = (high+low)/2;
      var xlate = function (a:Float) return {Math.min(1,Math.max(-1,(a*2-1)));};   
      return function(a:Float) {return (xlate(a) * w / (w - Math.abs(xlate(a)) +1) ) / 2 * range + mid;};
    }

    function triangleWave(v) {
        return Math.asin(Math.sin(v))*2/Math.PI;
    } 
    function chain(a: Float->Float, b: Float->Float) : Float->Float {
        return function (v:Float) {return a(b(v));}
    }

    function makeLowPassFilter(belowFrequency : Float)  {
        var dt = 1.0/sampleRate;
        var rc = 1.0/belowFrequency;
        var alpha = dt/(rc+dt);
        var lastValue = 0.0;
        return function (sample:Float) {
            var result = lastValue + alpha * (sample-lastValue);
            lastValue=result;
            return result;
        }
    }

    function makeHighPassFilter(aboveFrequency : Float)  {
        var dt = 1.0/sampleRate;
        var rc = 1.0/aboveFrequency;
        var alpha = dt/(rc+dt);
        var lastValue = 0.0;
        return function (sample:Float) {
            lastValue+= alpha * (sample-lastValue);
            return sample-lastValue;
        }
    }
    
    function makeBandPassFilter(aboveFrequency :Float, belowFrequency : Float) : Float->Float {
        var high = makeHighPassFilter(aboveFrequency);
        var low = makeLowPassFilter(belowFrequency);
        return chain(high,low);
    }

    function makeRadianFunction(fn :Float->Float): Float->Float {
        return function (a) {return fn( (a/TWOPI)%1 )*TWOPI; };
    }

    function makeWaveShiftFunction(value:Int) : Float->Float {        
        return makeRadianFunction( makeSigmoidFunction( (value/8)*1.95));
    /*    
        if (value>7) {
            var v=((value-8)/8);
            var x=v*v*16+1;
            return function(a) {return  Math.pow(a/TWOPI,x) * TWOPI;};
        } else {
            var v=1-((value)/8);
            var x=v*v*16+1;
            return function(a) { return 1-Math.pow(1-(a/TWOPI),x) * TWOPI;};
        } 
      */    
    }

    function makeWaveGenerator() : Float->Float {
        var w = (waveBase/15-0.5) * 2;
        if (w < 0) {
            w=-w;
            return sineSquare(w);
        } else  {
            return weightedFunction(triangleWave,Math.sin,w*1.2,1-w);
        }
    }

    function noiseWave(pos:Float) {
        var d = (lastNoisePos-pos);
        if (Math.abs(d) > 2 ) {
            lastNoisePos = pos;
            noiseValue= Math.random()*2-1;
        }
        return noiseValue;
    }

    public function update() {
        shiftFunction = makeWaveShiftFunction(waveShift);
        waveGenerator = makeWaveGenerator();
        amplitude = volume / 255;
    }

    inline function lerp(a:Float,b:Float,weight:Float) {
        return (1.0-weight) * a + weight*b;
    }

    function weightedFunction(fnA :Float->Float ,fnB :Float->Float, weighta:Float, weightb:Float) : Float->Float {
        return function (a) {return fnA(a)*weighta + fnB(a)*weightb; };
    }

    function squarishFunction(weight : Float) : Float->Float{        
        return function(a){return Math.atan(Math.sin(a) * (2+300*weight))*2/Math.PI*(1+(1-weight)*0.2);};  
    }

    function sineSquare(weight : Float) : Float->Float {
        return weightedFunction(sigmoidToSquare(weight*15+2),Math.sin, weight/(Math.PI/2),1-weight);
    }

    inline function shiftSigmoid(x:Float,shift:Float,scale:Float) :Float {
         return 1.0/ (1.0+ Math.exp((x-shift) * (scale*scale)));
    }

    function sigmoidToSquare(weight) :Float->Float {
        return function(a) {  var p:Float= (a+Math.PI/2)%(Math.PI*2); 
                 return ( (1-shiftSigmoid((p/Math.PI),0.5,weight))  *   shiftSigmoid(((p/Math.PI)),1.5,weight))*2-1;
            }
    }

    public function nextSample() {
        soundAge+=sampleStep;
        var bendShift= 0.0;
        if (bendHz!=0.0) bendShift=Math.cos(bendPhase * 0.25 * Math.PI + (soundAge/bendStep) ) * (bendAmplitude/31.0);
        position+= step + (bendShift * (step/2));
        var wavePhase = position % TWOPI;

        var envelope = 1.0;
        if (attackDuration > 0) {
            envelope*= Math.min(soundAge/attackDuration,1.0);
        }
        if (releaseDuration >0) {
            var releasePosition = soundAge-holdDuration;
            if (releasePosition > 0 ) {
                envelope*= 1.0- Math.min(releasePosition/releaseDuration,1);
            }
        }
        var baseSound = waveGenerator(shiftFunction(wavePhase));
        var withNoise = lerp(baseSound, noiseWave(position), noise/16.0);
        return filter(withNoise * amplitude * envelope);
    }

    function set_frequency(value) : Int {
        frequency=value;
        var f = value * 0.0596;
        step=Math.PI*2*f/sampleRate;
        return value;
    }

    function set_bendDuration(value) : Int {
        bendDuration = value;
        var v = (bendDuration+1) / 8.0;
        trace(v);
        bendHz = Math.pow(v,2)*0.5;
        bendStep= 1.0/ (bendHz * Math.PI * 2);
        return value;
    }

    function set_hold(value) : Int {
        hold = value;
        var v = value / 8.0;
        holdDuration = Math.pow(v,2);
        return value;
    }

    function set_attack(value) : Int {
        attack = value;
        var v = value / 8.0;
        attackDuration = Math.pow(v,2);
        soundAge=0;
        return value;
    }

    function set_release(value) : Int {
        release = value;
        var v = value / 8.0;
        releaseDuration = Math.pow(v,2);
        return value;
    }
    
}