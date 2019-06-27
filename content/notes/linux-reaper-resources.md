---
title: "Resources for Using REAPER on Linux"
author: ["Carl Colglazier"]
date: 2019-03-14
draft: false
---

I have been a REAPER user for years and lately I've been using
the unofficial Linux release.


## Getting Started {#getting-started}

Here are a few links to get started:

-   <https://wiki.cockos.com/wiki/index.php/REAPER%5Ffor%5FLinux>
-   <https://bcacciaaudio.com/2018/10/16/reaper-using-linux-native-vsts/>
-   <https://distrho.sourceforge.io/>


## Running LV2 and LADSPA Plugins {#running-lv2-and-ladspa-plugins}

The best way I have found to integrate these Linux-native formats into
my workflow has been to use [Carla](http://kxstudio.linuxaudio.org/Applications:Carla). It's a program that hosts other
plugins and can be imported as a VST or VSTi (important because REAPER
does not directly support LV2 and LADSPA plugins).