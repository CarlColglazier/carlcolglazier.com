---
title: "Mapping MIDI Channels to Multiple Instruments in SuperCollider"
author: ["Carl Colglazier"]
aliases: ["acoustics/midi-channels-multiple-instruments-supercollider"]
draft: false
---

Being able to [control a polyphonic instrument in MIDI](/notes/midi-instrument-control-supercollider/) is
good, but being able to control multiple instruments is even
better. SuperCollider offers a lot of flexibility when it comes to
timbre. For my personal workflow, I like to try out a lot of different
sounds to see what best in the mix. Thus when thinking about how I
want to use the MIDI controller in connection with SuperCollider, it
makes sense to me to be able to switch between instruments fluidly.


## Finding some sounds {#finding-some-sounds}

If you do not want to start from scratch, there are a number of excellent
resources for finding SuperCollider =SynthDef=s:

-   [GitHub](http://github.com/) is a service that hosts millions of software projects created
    and maintained by developers around the world. The source code for
    [SuperCollider](https://github.com/supercollider/supercollider) itself is hosted on GitHub in addition to [hundreds of
    other projects](https://github.com/search?utf8=%E2%9C%93&q=language%3ASuperCollider&type=Repositories&ref=advsearch&l=SuperCollider&l=) written in the SuperCollider language.
-   [SuperCollider Code](http://sccode.org/) is a community-driven website which allows users
    to post snippets of their SuperCollider code. These snippets use
    tagging, which makes it easy to search for specific timbres.  The
    website also hosts the [SuperCollider documentation](http://doc.sccode.org/).
-   [patchstorage](https://patchstorage.com/platform/supercollider/) has a few SuperCollider patches, but seems to have
    rather limited activity currently.

To start, I copied a few `SynthDefs`:

-   The first channel is for the simple sine wave `SynthDef`.
-   I attached the second channel to a [piano](http://sccode.org/1-51p) `SynthDef` which uses
    `MdaPiano`, a generator provided by [`sc3-plugins`](https://github.com/supercollider/sc3-plugins).
-   The third channel provides an Electric Piano timber found on
    [sccode.org](http://sccode.org/1-522).
-   The fourth channel is used for an [organ instrument](https://github.com/patrickmcminn/beatles/blob/2f6119165f51f8d3f885aca22b332133d010d234/source/system/SynthDefs/Synth%20SynthDefs/additive.scd) meant to emulate
    a classic Hammond organ.

I considered these sounds to be a good starting point for emulating
many classic keyboard instruments.


## Switching instruments {#switching-instruments}

To allow these different timbres to be selected, I made a few changes
to the function defined in the [previous post](https://carlcolglazier.com/notes/starting-supercollider/). First, I created a second array with sixteen elements to hold
the names of the different \`SynthDef\`s.

```sc
// https://gist.github.com/umbrellaprocess/973d2aa16e95bf329ee2
var keys, instruments;
keys = Array.newClear(128);

instruments = Array.newClear(16);
instruments.put(0, \sinpk);
instruments.put(1, \piano);
instruments.put(2, \rhodey_sc);
instruments.put(3, \hammond);
```

I then modified the `NoteOn` function such that the correct instrument
is selected based on its position in the \`instruments\` array.

```sc
~noteOnFunc = {arg val, num, chan, src;
	var node;
	node = keys.at(num);
	if (node.notNil, {
		node.release;
		keys.put(num, nil);
	});
	node = Synth(instruments.at(chan), [\freq, num.midicps, \vel, val]);
	[num, chan].postln;
	keys.put(num, node);
};
```

Now I could select the appropriate instrument by simply changing the MIDI
channel on my controller.


## A quick demo {#a-quick-demo}

Putting it all together, I created a simple track to demonstrate these
different timbers (accompanied with some mandolin):

<audio src="/audio/sc-demo.mp3" controls class="scope">
</audio>
<script type="text/javascript" src="/js/oscilloscope.min.js"></script>

---

The [past](/notes/starting-supercollider/) [few](/notes/midi-in-supercollider/) [posts](/notes/midi-instrument-control-supercollider/) have worked through some building blocks for using
SuperCollider as a platform for creativity. As I wrote in ["The Paradox
of Creativity"](/notes/acoustics/paradox-of-creativity/), I find the creative process to be best when applied to
areas that are challenging. I believe it is for this reason that I
find SuperCollider to be such an interesting platform: it provides the
pieces for expansive sonic possibilities, but it takes a bit of effort
and curiosity to make the most of it.