---
date: 2017-04-16T14:46:28-04:00
draft: true
title: "Simple Hugo VPS Deployment"
---

I recently moved hosting to virtual private server and NGINX. Since I use git
and Hugo to update my website, I wanted to be able to have the website build
simply by pushing to the server.

I had previously used Gulp and FTP for this, but I wanted a simpler system
which requires less dependencies.

To start, I set up the repository on the server. I cloned my website code by
running

```
git clone git@github.com:CarlColglazier/carlcolglazier.com.git
```

To be able to push to the server repository from my computer, I needed to change
the way things are set up. Git does not allow pushing directly to the current
branch by default. To change this, I ran

```
git config receive.denyCurrentBranch updateInstead
```

inside the repository to allow the current branch (master) to be updated from
an external source. Now I could push directly to the server.

I needed to do the following when building the website:

1. Run the `hugo` command to build the website.
2. Compile LESS files to CSS.
3. Minify the public content.

I ended up using the following npm packages to achieve these goals:

+ [less](https://www.npmjs.com/package/less)
+ [less-plugin-clean-css](https://www.npmjs.com/package/less-plugin-clean-css)
+ [html-minifier](https://www.npmjs.com/package/html-minifier)
+ [rimraf](https://www.npmjs.com/package/rimraf)

This gave me the following scripts in `package.json`:

```json
  ...
  "scripts": {
    "prebuild": "echo Building...",
    "build": "npm run-script prepare && hugo && npm run-script minify",
    "prepare": "./node_modules/.bin/rimraf public && npm run-scrip less",
    "less": "./node_modules/.bin/lessc --clean-css ./static/css/style.less ./static/css/style.css",
    "minify": "./node_modules/.bin/html-minifier --input-dir public --output-dir public -c html-minify.conf --file-ext html",
    "postbuild": "./node_modules/.bin/rimraf ./public/css/style.less",
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  ...
```

For all installed `npm` packages, I chose to use local installs.

My first step in building the website is removing the previous
build. This ensures that deleted files do not stick around by
mistake. To do this, I use `rimraf`, which is supported on multiple
operating systems. I then ran the command line script to process the
LESS files. After this, I ran the `hugo` command to build the website
in the `public` directory. I ran `html-minifier` on each of the HTML
files and finally removed the LESS file from the public-facing
website.

With the build script written, I then added the following script to
`.git/hooks/pre-receive`:

```sh
#!/bin/sh
npm run build
```

Now I could update my website by committing and running

```
git push <remote> <branch>
```
