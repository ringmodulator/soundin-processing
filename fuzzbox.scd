s.boot

/*

Very ugly guitar processor. The intention for this project is to make a GUI to control the following parameters:

- Distortion amp, smooth, and mul
- Oscillator freq multiplier (maybe do presets for fifth and octave, or even multiple oscs) and mul
- Noise gate theshold

*/

(
SynthDef.new(\fuzzbox, {
	| thresh = 0.1, freqMul = 1, oscMul = 1, distAmp = 0.2, distSmooth = 0.3, distMul = 1.0 |
	var dist,freq, gate, in, osc, out, vol;
	in = SoundIn.ar(0);
	freq = Pitch.kr(in);
	vol = Amplitude.kr(in, 0.5, 0.5);
	osc = SinOsc.ar(freq: freq * freqMul, mul: vol * oscMul);
	gate = Compander.ar(in, in, thresh: thresh, slopeBelow: 10, relaxTime: 0.1);
	dist = CrossoverDistortion.ar(gate, amp: distAmp, smooth:distSmooth, mul: distMul, add: 0);
	out = osc + dist;
	Out.ar ([0, 1], out);
}).add
)


x = Synth.new(\fuzzbox);
