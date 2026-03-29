(
s.options.blockSize = 1; // Can be set to any power of 2. 64 is the default.
s.options.hardwareBufferSize = 64;
s.options.sampleRate = 96000;
s.boot;
)

/*

Very ugly guitar processor. The intention for this project is to make a GUI to control the following parameters:

- Distortion amp, smooth, and mul
- Oscillator freq multiplier (maybe do presets for fifth and octave, or even multiple oscs) and mul
- Noise gate theshold

*/

(
SynthDef.new(\fuzzbox, {
	| thresh = 0.1, oscFreq = 1, oscMul = 1, distAmp = 0.2, distSmooth = 0.3, distMul = 1.0 |
	var dist,freq, hasFreq, gate, in, osc, out, vol;
	in = SoundIn.ar(0);
	//#freq, hasFreq = Pitch.kr(in);
	#freq, hasFreq = Tartini.kr(in);
	vol = Amplitude.kr(in, 0.5, 0.5);
	osc = SinOsc.ar(freq: freq * oscFreq, mul: vol * oscMul);
	gate = Compander.ar(in, in, thresh: thresh, slopeBelow: 10, relaxTime: 0.1);
	dist = CrossoverDistortion.ar(gate, amp: distAmp, smooth:distSmooth, mul: distMul, add: 0);
	out = osc + dist;
	Out.ar ([0, 1], out);
}).add
)

(
w = Window("fuzzbox", Rect(850, 50, 300, 250))
.front
.alwaysOnTop_(true);
v = View(w, Rect(20, 20, w.bounds.width - 20, w.bounds.height - 20));
f = v.addFlowLayout();

~ampSpec = ControlSpec(0.0, 1.0, 4);
~thresh = Slider(v, 150@30)
.action_({
	arg obj;
	var thresh;
	thresh = obj.value;
	if(
		x.isPlaying,
		{x.set(\thresh, thresh)}
	)
})
.value_(0.1);
~threshLabel = StaticText(v, 80@20)
.string_("Threshold");
f.nextLine;

~distAmp = Slider(v, 150@30)
.action_({
	arg obj;
	var distAmp;
	distAmp = ~ampSpec.map(obj.value);
	if(
		x.isPlaying,
		{x.set(\distAmp, distAmp)}
	)
})
.value_(~ampSpec.unmap(0.2));
~distAmpLabel = StaticText(v, 80@20)
.string_("Amp");
f.nextLine;

~distSmooth = Slider(v, 150@30)
.action_({
	arg obj;
	var distSmooth;
	distSmooth = obj.value;
	if(
		x.isPlaying,
		{x.set(\distSmooth, distSmooth)}
	)
})
.value_(0.3);
~smoothLabel = StaticText(v, 80@20)
.string_("Smoothing");
f.nextLine;

~distMul = Slider(v, 150@30)
.action_({
	arg obj;
	var distMul;
	distMul = ~ampSpec.map(obj.value);
	if(
		x.isPlaying,
		{x.set(\distMul, distMul)}
	)
})
.value_(~ampSpec.unmap(1));
~distMulLabel = StaticText(v, 80@20)
.string_("Fuzz Volume");
f.nextLine;

~oscFreq = PopUpMenu(v, 150@30)
.items_(["Unison", "Fifth", "Octave"])
.action_({
	arg obj;
	var sel = obj.items[obj.value];
	if(x.isPlaying,
	{
			if(
				sel == "Unison",
				{x.set(\oscFreq, 1)}
			);
			if(
				sel == "Fifth",
				{x.set(\oscFreq, 1.5)}
			);
			if(
				sel == "Octave",
				{x.set(\oscFreq, 2)}
			);
		}
	);
})
.value_(0);
~oscFreqLabel = StaticText(v, 80@20)
.string_("Osc Freq");
f.nextLine;

~oscMul = Slider(v, 150@30)
.action_({
	arg obj;
	var oscMul;
	oscMul = obj.value;
	if(
		x.isPlaying,
		{x.set(\oscMul, oscMul)}
	)
})
.value_(1);
~oscMulLabel = StaticText(v, 80@20)
.string_("Osc Volume");

CmdPeriod.doOnce({ w.close });

x = Synth.new(
	\fuzzbox,
	[
		\thresh, ~thresh.value,
		\distAmp, ~ampSpec.map(~distAmp.value),
		\distSmooth, ~distSmooth.value,
		\distMul, ~ampSpec.map(~distMul.value),
		\oscFreq, 1,
	    \oscMul, ~oscMul.value
	]
).register;
)

// Experimenting with HLayout and Vlayout
(
w = Window("fuzzbox", Rect(850, 100, 600, 250))
.front
.alwaysOnTop_(true);

~thresh = Slider()
.action_({
	arg obj;
	var thresh;
	thresh = obj.value;
	if(
		x.isPlaying,
		{x.set(\thresh, thresh)}
	)
})
.value_(0.1);
~threshLabel = StaticText()
.string_("Threshold")
.minWidth_(50);

h = VLayout([
	HLayout([~thresh, ~threshLabel])
]);
w.layout = h;
)