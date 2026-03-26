s.options.blockSize = 1; // Can be set to any power of 2. 64 is the default.
s.options.hardwareBufferSize = 64;
s.options.sampleRate = 96000;
s.boot;

// Experiments with guitar and SoundIn. Ultimately I might like some kind of GUI effects processor where I can switch effects on and off and combine them.

// Direct guitar playthrough. I can hear a slight latency I'd like to reduce as much as possible
(
{
	var in = SoundIn.ar(0);
	Out.ar ([0, 1], in);
}.play
)

// Crossover distortion. This sounds kind of cool but out of control and if I turn the volume knob down I get a wall of static
(
{
	var in = SoundIn.ar(0),
	dist = CrossoverDistortion.ar(in, amp: 0.5, smooth: 0.5, mul: 1.0, add: 0);
	Out.ar ([0, 1], dist);
}.play
)

// Decimator
(
{
	var in = SoundIn.ar(0),
	dist = Decimator.ar(in, rate: 5625.0, bits: 8, mul: 1.0, add: 0);
	Out.ar ([0, 1], dist);
}.play
)

// Sine Shaper
(
{
	var in = SoundIn.ar(0),
	dist = SineShaper.ar(in, limit: 0.1, mul: 1.0, add: 0);
	Out.ar ([0, 1], dist);
}.play
)

// Fold
(
{
	var in = SoundIn.ar(0),
	dist = Fold.ar(in: in, lo: 0.0, hi: 0.25);
	Out.ar ([0, 1], dist);
}.play
)

// Clip
(
{
	var in = SoundIn.ar(0),
	dist = Clip.ar(in: in, lo: 0.0, hi: 0.25);
	Out.ar ([0, 1], dist);
}.play
)