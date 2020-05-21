---
title: "Expert Sleepers ES-9 Firmware Update on Linux"
date: 2020-05-21
draft: false
---

_Caveat: I don't represent Expert Sleepers and I cannot say if this voids the warranty. Proceed at your own risk._

Expert Sleepers' [official firmware page](https://expert-sleepers.co.uk/es9firmware.html) only supports Mac and Windows.

As it turns out, though, it's not too hard to run an upgrade on Linux.

First, you need to boot the ES-9 in DU mod. There are two pins in the back of the unit.
You can use two clips to connect them as I did.

Then, download `dfu-util`. This step will be different depending on what
flavor of Linux you use, but this is how I did it on Arch.

```sh
sudo pacman -S dfu-util
```

After booting in DFU mod, it should show up when you run.

```sh
sudo dfu-util -l
```

```text
Found DFU: [2485:50e1] ver=0000, devnum=20, cfg=1, intf=0, path="2-9.1.1", alt=0, name="DFU", serial="UNKNOWN"
```

I then ran this command to flash my firmware.

```sh
sudo dfu-util -a 0 -R -D es9_v1.1.1.dfu
```

Your exact version might be different.

I verified this works by opening the [web utility](https://expert-sleepers.co.uk/webapps/es9%5Fconfig%5Ftool%5F1.1.html) and asking nicely for the version number,
which was `v1.1.1` in my case.
