# LilyPond renderer server

Update: now this server also supports rendering MusicXML files via Verovio renderer. More info coming soon.

This is a specification of a simple HTTP API wrapper for the LilyPond CLI.
It runs in a standalone Docker container. This repo contains three *.otf fonts,
in the `fonts` folder. 
If you wish to add your own fonts, feel free to add them to this folder and re-build the image.

Building the image:
~~~
docker build . -t lilypond-server
~~~

Running the server on a port 3100:
~~~
docker run -dp 3100:8080 lilypond-server
~~~

Navigating to localhost:3100 will output the API specification.
Available "recipes" are defined in scripts/Makefile.


A reference implementation is available in [LilyPond client library](https://github.com/proscholy/lilypond-renderer-client).