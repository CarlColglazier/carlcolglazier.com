---
title: "Using Org-mode and Babel with Hugo"
author: ["Carl Colglazier"]
date: 2017-04-25
draft: false
---

I have been a consistent user of Org-mode for a couple of years. I
like it for a few reasons. It is very versatile; I can use it for
everything from class notes to papers to writing documentation. It
is very extendable; it can perform almost every operation I need
in a text program. Most importantly it saves time.

My main attraction to using Org-mode with Hugo is to pursue a
form of literate programming. [Babel](http://orgmode.org/worg/org-contrib/babel/) provides an excellent tool
for literate programming such that both the source code
and output can be included in the same document.

I use this technique frequently to dynamically generate adaptable
reports. I can write both the code and my write-up inside Org-mode
and any changes are automatically reflected in the next export.

For this reason, I was excited to hear that Hugo added support for
Org mode in [v0.19](https://github.com/spf13/hugo/releases/tag/v0.19). The native go parser, [goorgeous](https://github.com/chaseadamsio/goorgeous), does not support
every part of the Org-mode syntax at the moment, but it is certainly
good enough to work with for now.


## Getting Started {#getting-started}

Hugo can generate Org-mode files in the same way it creates markdown
files

```sh
cd ../../
rm content/notes/post.org
hugo new notes/post.org
```

```text
/home/carl/programs/web/carlcolglazier.com/content/notes/post.org created
```

The contents of the file will look like the following:

```yaml
---
date: 2017-04-25T14:47:30-04:00
draft: true
title: post
---
```

This front matter is formatted using YAML. Currently Org-mode is not
supported as a `metaDataFormat`, so we will not be able to have hugo
create an Org-mode header by defualt; however, everything still works
if we create the header manually.


## Examples {#examples}

First I created a simple "Hello, World" program written in C inside
an Org-mode source block.

```C
#include <stdlib.h>
#include <stdio.h>

int main() {
	printf("Hello, World!\n");
	return 0;
}
```

```text
Hello, World!
```

I then ran the program in Babel, producing the above result.