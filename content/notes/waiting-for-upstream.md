---
title: "Waiting for Upstream"
author: ["Carl Colglazier"]
date: 2019-06-20
draft: false
---

This is a post about this website. It's also a small reflection on software development. Enjoy.

---

This website has always relied on JavaScript in some way. At the moment, very little runs on the site itself outside specialty pages, but JavaScript always been central to the build process. Gulp, grunt, just plain npm---I think I've tried all of them at some point.
But as of this note, JavaScript is no longer a part of the build process. Here is how I did it.

Software with a large community of contributors brings further advantages. I obviously was not the only person using JavaScript for my minification workflow. On the Hugo repository, the ["Support for minification of generated HTML files"](https://github.com/gohugoio/hugo/issues/1251) issue was first started in 2015, around the same time I switched to Hugo. It was implemented in 2018 after a pretty extensive discussion. I should emphasize that I played absolutely no part in this process. I had a need shared with some others and I got to completely ride free off of their upstream contributions to the software I use. Others also wrote up the documentation that alerted me to this feature in the first place.

This is why popular software brings several advantages beyond their feature set. With a dedicated community, you get expanded documentation and more spaces to find help without any additional effort on your part. Your unusual workflow or edge-cases are more likely to be shared with someone else.

Software should not be evaluated on popularity alone; however, I do think it should be a factor. After all, it would seem quite the waste to throw out the fruits of popular collaboration.