---
title: "A Fast from Electron: Streaming Music through MPD"
author: ["Carl Colglazier"]
date: 2019-06-13
draft: false
aliases:
  - "/notes/electron-fast/"
---

Enough has been written on Electron's shortfalls that I feel no need to add my own gripes. Generally, I try to avoid it as much as possible. I'm sure the Discord desktop client is nice, but it also works just fine in my web browser. Slack? Okay, but you're only allowed on the work computer!

Despite my hesitations, one Electron app has constantly followed me around for years: the unofficial Google Play Music desktop player. Before you ask, no, I don't use Spotify. I do think it's the better-designed service, but GPM has a good family plan though and it comes with YouTube Red, which is a nice bonus.

Because of this setup, I basically have had a Chromium browser open on my computer at all times just to play music. What's the point of having 20 GB of RAM if I'm not trying to minimize its use at all times?

Here's what I'm using now instead:

-   [gmusicproxy](https://github.com/gmusicproxy/gmusicproxy)
-   [Music Player Daemon (MPD)](https://www.musicpd.org/)
-   [mpdscribble](https://github.com/MusicPlayerDaemon/mpdscribble)
-   [NCurses Music Player Client (Plus Plus)](https://rybczak.net/ncmpcpp/)

The only real pain point in my workflow is searching for new albums which are not already in my playlists. I might write a simple program for that at some point.

Bonus: my scrobbles now cache if there is ever a connectivity issue.