docker build . -t lilypond-server

docker run -dp 3100:8080 lilypond-server