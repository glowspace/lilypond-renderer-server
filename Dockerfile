# Lilypond container Dockerfile
# Platform is forced to amd64 in order to make Dockerfile Apple silicon compatible.
# libwoff-dev has only a bionic package
FROM --platform=linux/amd64 ubuntu:bionic

# install necessary software
RUN apt-get update && \
    apt-get -y install bzip2 wget ghostscript xmlstarlet python3 make tree pdf2svg curl unzip && \
    # download and install GNU LilyPond
    wget https://lilypond.org/download/binaries/linux-64/lilypond-2.22.1-1.linux-64.sh && \
    sh lilypond-2.22.1-1.linux-64.sh && rm lilypond-2.22.1-1.linux-64.sh && \
    # download and install shell2http
    wget https://github.com/msoap/shell2http/releases/download/1.13/shell2http-1.13.linux.amd64.tar.gz && \
    tar -xf shell2http-1.13.linux.amd64.tar.gz && \
    # install Node.js (for the svgo package)
    curl -sL https://deb.nodesource.com/setup_12.x | bash && \
    apt-get install -y nodejs && \
    # install svgo
    npm install -g svgo

# RUN apt-get -y install inkscape

COPY scripts/* /bin/scripts/
RUN chmod +x /bin/scripts/*

COPY fonts/*.otf /usr/local/lilypond/usr/share/lilypond/current/fonts/otf/
# COPY fonts/*.woff /usr/local/lilypond/usr/share/lilypond/current/fonts/svg/

WORKDIR /lilywork

RUN adduser --disabled-password --gecos '' lilyponder && \
    chown -R lilyponder /lilywork

USER lilyponder

ENTRYPOINT /shell2http -form \
    POST:/make 'TMPDIR=`mktemp XXXX -d` \
    && cd $TMPDIR \
    && ln -s /bin/scripts/Makefile \
    # if the .ly file is not provided, then
    # quietly unzip the zip file into current directory
    && (cp $filepath_file_lilypond score.ly || unzip -qq $filepath_file_zip -d .)  \
    && make $v_recipe > /dev/null; rm Makefile; cd ..; tree $TMPDIR -J -L 1 --noreport' \
    \
    GET:/make_test 'TMPDIR=`mktemp XXXX -d` \
    && cd $TMPDIR \
    && ln -s /bin/scripts/Makefile \
    && echo "{ c }" > score.ly \
    && make $v_recipe > /dev/null; rm Makefile; cd ..; tree $TMPDIR -J -L 1 --noreport' \
    \
    GET:/get 'cd $v_dir && cat $v_file' \
    GET:/del 'rm -r $v_dir && echo "ok" || echo "not deleted"'