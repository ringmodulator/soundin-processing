s.boot

// Working through Eli Fieldsteel GUI tutorial at https://www.youtube.com/watch?v=W2D_PzOVfT0

(
SynthDef.new(\simplebpf, {
	arg freq = 440, rq = 0.2;
	var sig;
	sig = PinkNoise.ar(1!2);
	sig = BPF.ar(sig,
		freq.lag(0.5),
		rq.lag(0.5),
		1/rq.sqrt.lag(0.5)
	);
	Out.ar(0, sig)
}).add
)

(
Window.closeAll;
w = Window("gui", Rect.new(750,50,500,200))
.front
.alwaysOnTop_(true);

~slider = Slider(w, Rect(20,20,150,30))
.background_(Color(0.2,0.75,0.95))
.action_({
	arg obj;
	var cf;
	cf = obj.value.linexp(0,1,100,4000).postln;
	if(
		x.isPlaying,
		{x.set(\freq, cf)}
	);
	~numberBox.value_(obj.value.linexp(0,1,100,4000));
});

~numberBox = NumberBox(w, Rect(180,20,80,30))
.value_(100)
.clipLo_(100)
.clipHi_(4000)
.decimals_(2)
.action_({
	arg obj;
	~slider.valueAction_(obj.value.explin(100,4000,0,1));
});

~freqLabel = StaticText(w, Rect(180,50,80,20))
.string_("freq")
.align_(\center);

~knob = Knob(w, Rect(270, 20, 30, 30))
.action_({
	arg obj;
	var qual;
	qual = obj.value.linexp(0,1,1,100).reciprocal;
	if(
		x.isPlaying,
		{x.set(\rq, qual)}
	);
});

~button = Button(w, Rect(430,20,50,30))
.states_([
	["OFF", Color.black, Color.gray(0.8)],
	["ON", Color.white, Color(0.2,0.75,0.95)]
])
.action_({
	arg obj;
	if(
		obj.value == 1,
		{
			x = Synth.new(
				\simplebpf,
				[
					\freq, ~slider.value.linexp(0,1,100,4000),
					\rq, ~knob.value.linexp(0,1,1,100).reciprocal;
				]
			).register;
		},
		{x.free}
	)
});
)

// FlowLayout

(
Window.closeAll;
w = Window("flow", Rect(850, 50, 400, 400))
.front
.alwaysOnTop_(true);

w.view.decorator_(FlowLayout(w.bounds, 15@15, 7@7));
)