---
date: 2017-09-18T18:51:29-04:00
title: Starting SuperCollider
image: emacs-sc.jpg
notes: 
  - "acoustics"
---

Over the next few posts, I will be documenting the process of creating
a software synthesis system which interfaces with hardware MIDI
devices. The goal of this project is to bring together the powerful
expressiveness of software synthesis with the intuition of hardware
interaction.

This first post describes some of the software used in the
project.

Motivation
----------

I have a MIDI controller that I would like to bring into the mix more
(so to speak) in my music workflow. The great thing about hardware
designed to work with software on a computer is that it offers a lot
of flexibility; however, that comes with the price of requiring a bit
of effort and creativity on the software end to take full advantage of
the hardware.

When it comes to digital sound synthesis, there is perhaps no program
more powerful than [SuperCollider](http://supercollider.github.io/).
SuperCollider runs as a server which can be sent commands from
clients. The server is usually are controlled using the `sclang`
programming language. The program and language are designed specifically
for electroacoustics and generative music. See the video below for an
example of a project that used SuperCollider for both of these functions.

{{< youtube Xh0mXrPRuqw >}}

The
[laptop as an instrument](https://www.jstor.org/stable/42578951?seq=1)
is a rather new concept, but the techniques used in digital synthesis
and generative music are decades old. With this project, I aim to tap
into and expand upon that legacy.

Development Tools
-----------------

![Emacs interfacing with SuperCollider](/images/emacs-sc.jpg)

SuperCollider has its own IDE called `scide`, but I will be working in
the Emacs development environment. Emacs is a general purpose text
editor which I use for most of my work that involves plain text.
Emacs is well suited for SuperCollider development because Emacs
itself runs with
a
[REPL](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop) (Read--eval--print
loop). This encourages a workflow of writing small chucks of code,
sending them to the server to be evaluated, and then analyzing the
results.

![JACK server connections](/images/jack-cadence.jpg)

SuperCollider works by interfacing with
the [JACK Audio Connection Kit](http://jackaudio.org/). Like
SuperCollider itself, JACK works as a server that directs signals from
many different sources. It is designed for real-time audio
applications and thus tends to have very low latency. I use a suite of
tools
called [Cadence](http://kxstudio.linuxaudio.org/Applications:Cadence)
to control and connect my JACK applications. The figure above shows
how I have wired together the SuperCollider server with my system
capture (microphone) and system playback (speakers or headphones).
Using JACK allows SuperCollider to interact with other audio
programs such as a DAW (digital audio workstation).

Making Some Sounds
------------------

Now that I have all the tools needed to run SuperCollider set up,
let's start making some noise. I first needed to boot up Emacs running
the SuperCollider environment.

```sh
emacs -sclang
```

I then booted the SuperCollider server.

```sc
s = Server.local.boot;
```

`s` is a special variable that is used exclusively for the `Server`.
The other letters of the alphabet can be used as global variables.  It
is best to attach functions or any other sound generator to a variable
so that they can be stopped or modified when needed. To start, I used
a function that combined a sine oscillator with pink noise. The
arguments for
the [sine oscillator](http://doc.sccode.org/Classes/SinOsc.html)
indicate frequency, phase, and amplitude. The argument for the
`PinkNoise` generator indicates volume.

```sc
g = { SinOsc.ar(440, 0, 0.1) + PinkNoise.ar(0.01) }.play;
```

This sound will play indefinitely until we free the function.

```
g.free;
```

Running and then freeing the function produces the following output:

<script>
var Oscilloscope=function(){"use strict";var t=function(t,i){if(void 0===i&&(i={}),!(t instanceof window.AudioNode))throw new Error("Oscilloscope source must be an AudioNode");t instanceof window.AnalyserNode?this.analyser=t:(this.analyser=t.context.createAnalyser(),t.connect(this.analyser)),i.fftSize&&(this.analyser.fftSize=i.fftSize),this.timeDomain=new Uint8Array(this.analyser.frequencyBinCount),this.drawRequest=0};return t.prototype.animate=function(t,i,e,a,n){var s=this;if(this.drawRequest)throw new Error("Oscilloscope animation is already running");this.ctx=t;var o=function(){t.clearRect(0,0,t.canvas.width,t.canvas.height),s.draw(t,i,e,a,n),s.drawRequest=window.requestAnimationFrame(o)};o()},t.prototype.stop=function(){window.cancelAnimationFrame(this.drawRequest),this.drawRequest=0,this.ctx.clearRect(0,0,this.ctx.canvas.width,this.ctx.canvas.height)},t.prototype.draw=function(t,i,e,a,n){var s=this;i=i||0,e=e||0,a=a||t.canvas.width-i,n=n||t.canvas.height-e,this.analyser.getByteTimeDomainData(this.timeDomain);var o=a/this.timeDomain.length;t.beginPath();for(var r=0;r<this.timeDomain.length;r+=2){var c=i+r*o,h=e+n*(s.timeDomain[r]/256);t.lineTo(c,h)}t.stroke()},t}();
</script>



<audio src="/audio/startingsc.mp3" controls id="sinaudio">
</audio>
<style>
canvas {
  width: 100%;
  height: 100px;
}
</style>

<script>
var audioContext = new window.AudioContext()
var canvas = document.createElement('canvas')
// setup audio element
var audioElement = document.getElementById('sinaudio')
audioElement.before(canvas)
// create source from html5 audio element
var source = audioContext.createMediaElementSource(audioElement)
// attach oscilloscope
var scope = new Oscilloscope(source)
// reconnect audio output to speakers
source.connect(audioContext.destination)
// customize drawing options
var ctx = canvas.getContext('2d')
ctx.lineWidth = 2
ctx.strokeStyle = '#000'
// start default animation loop
scope.animate(ctx)
</script>

We now have sound being generated by SuperCollider. In the
next post, I will be setting up MIDI input.
