# libwoff-dev has only a bionic package
FROM ubuntu:bionic

# RUN locale-gen en_US.UTF-8 && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
# ENV LANG en_US.UTF-8
# ENV LANGUAGE en_US:en
# ENV LC_ALL en_US.UTF-8

# install the lilypond package

RUN apt-get update
RUN apt-get -y install bzip2 
RUN apt-get update
RUN apt-get -y install wget

RUN wget https://lilypond.org/download/binaries/linux-64/lilypond-2.22.0-1.linux-64.sh
RUN sh lilypond-2.22.0-1.linux-64.sh && rm lilypond-2.22.0-1.linux-64.sh

RUN apt-get -y install ghostscript

RUN wget https://github.com/msoap/shell2http/releases/download/1.13/shell2http-1.13.linux.amd64.tar.gz && \
    tar -xf shell2http-1.13.linux.amd64.tar.gz

RUN apt-get -y install xmlstarlet
RUN apt-get -y install python3
RUN apt-get -y install make
RUN apt-get -y install tree
RUN apt-get -y install pdf2svg
RUN apt-get -y install curl

# Node.js 12 (for svgo)
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash
RUN apt-get install -y nodejs

# svg optimalization module
RUN npm install -g svgo

RUN apt-get -y install unzip

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
    && cp /scoresl/template.ly score.ly \
    && make $v_recipe > /dev/null; rm Makefile; cd ..; tree $TMPDIR -J -L 1 --noreport' \
    \
    GET:/get 'cd $v_dir && cat $v_file' \
    GET:/del 'rm -r $v_dir && echo "ok" || echo "not deleted"'