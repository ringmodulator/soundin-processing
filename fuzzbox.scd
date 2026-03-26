s.boot

/*

Very ugly guitar processor. The intention for this project is to make a GUI to control the following parameters:

- Distortion amp, smooth, and mul
- Oscillator freq multiplier (maybe do presets for fifth and octave, or even multiple oscs) and mul
- Noise gate theshold

*/

(
SynthDef.new(\fuzzbox, {
	| thresh = 0.1, oscFreq = 1, oscMul = 1, distAmp = 0.2, distSmooth = 0.3, distMul = 1.0 |
	var dist,freq, gate, in, osc, out, vol;
	in = SoundIn.ar(0);
	freq = Pitch.kr(in);
	vol = Amplitude.kr(in, 0.5, 0.5);
	osc = SinOsc.ar(freq: freq * oscFreq, mul: vol * oscMul);
	gate = Compander.ar(in, in, thresh: thresh, slopeBelow: 10, relaxTime: 0.1);
	dist = CrossoverDistortion.ar(gate, amp: distAmp, smooth:distSmooth, mul: distMul, add: 0);
	out = osc + dist;
	Out.ar ([0, 1], out);
}).add
)

(
Window.closeAll;
w = Window("fuzzbox", Rect(850, 50, 300, 250))
.front
.alwaysOnTop_(true);

~thresh = Slider(w, Rect(20,20,150,30))
.action_({
	arg obj;
	var thresh;
	thresh = obj.value;
	if(
		x.isPlaying,
		{x.set(\thresh, thresh)}
	)
});
~threshLabel = StaticText(w, Rect(180,25,80,20))
.string_("Threshold");

~distAmp = Slider(w, Rect(20,55,150,30))
.action_({
	arg obj;
	var distAmp;
	distAmp = obj.value;
	if(
		x.isPlaying,
		{x.set(\distAmp, distAmp)}
	)
});
~distAmpLabel = StaticText(w, Rect(180,60,80,20))
.string_("Amp");

~distSmooth = Slider(w, Rect(20,90,150,30))
.action_({
	arg obj;
	var distSmooth;
	distSmooth = obj.value;
	if(
		x.isPlaying,
		{x.set(\distSmooth, distSmooth)}
	)
});
~smoothLabel = StaticText(w, Rect(180,95,80,20))
.string_("Smoothing");

~distMul = Slider(w, Rect(20,125,150,30))
.action_({
	arg obj;
	var distMul;
	distMul = obj.value;
	if(
		x.isPlaying,
		{x.set(\distMul, distMul)}
	)
});
~distMulLabel = StaticText(w, Rect(180,130,80,20))
.string_("Fuzz Volume");

~oscFreq = PopUpMenu(w, Rect(20,165,150,30))
.items_(["Unison", "Fifth", "Octave"])
.action_({
	arg obj;
	if(x.isPlaying,
	{
			if(
				obj.value == "Unison",
				{x.set(\oscFreq, 1)}
			);
			if(
				obj.value == "Fifth",
				{x.set(\oscFreq, 1.5)}
			);
			if(
				obj.value == "Octave",
				{x.set(\oscFreq, 2)}
			);
		}
	);
});
~oscFreqLabel = StaticText(w, Rect(180,170,80,20))
.string_("Osc Freq");

~oscMul = Slider(w, Rect(20,200,150,30))
.action_({
	arg obj;
	var oscMul;
	oscMul = obj.value;
	if(
		x.isPlaying,
		{x.set(\oscMul, oscMul)}
	)
});
~oscMulLabel = StaticText(w, Rect(180,205,80,20))
.string_("Osc Volume");

x = Synth.new(
	\fuzzbox,
	[
		\thresh, ~thresh.value,
		\distAmp, ~distAmp.value,
		\distSmooth, ~distSmooth.value,
		\distMul, ~distMul.value,
		\oscFreq, ~oscFreq.value,
	    \oscMul, ~oscMul.value;
	]
).register;
)

