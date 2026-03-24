s.boot

(
SynthDef("shep",{
	arg amp=0.8, freq=440;
	var sig;
	sig = SinOsc.ar([freq, freq]);
	sig = sig * amp;
	out.ar(0, sig);
}).store;

~playShep = {
	arg speed = 0.015,
	volume = 0.5,
	direction = 0,
	centerFreqShift = 0;
}
)