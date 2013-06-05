lSystemsCrochet
===============

Inspired by http://botanicamathematica.wordpress.com/2013/03/06/introduction-to-l-systems/#more-47 I hacked together this version which uses D3 to connect together layers of nodes, each one being generated from the inner layer pattern based on the LSystem rules. Each layer node is connected to its inner parent. The whole thing has some physics added using D3 force layout.

Have a look at Layout.coffee constructor to change the initial nodes, and the grow methods of Blue.coffee and Red.coffee to change rules.

To recompile (and watch for changes): coffee -o js -cw js

To start a web server to serve up index.html: python -m SimpleHTTPServer
