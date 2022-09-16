# Lilypond container Dockerfile
# Platform is forced to amd64 in order to make Dockerfile Apple silicon compatible.
# libwoff-dev has only a bionic package
FROM --platform=linux/amd64 ubuntu:bionic

# install necessary software
RUN apt-get update && \
    apt-get -y install bzip2 wget python3 make curl unzip && \
    # download and install GNU LilyPond
    wget https://gitlab.com/lilypond/lilypond/-/releases/v2.23.12/downloads/lilypond-2.23.12-linux-x86_64.tar.gz && \
    tar -xf lilypond-2.23.12-linux-x86_64.tar.gz && \
    cp /lilypond-2.23.12/bin/* /usr/local/bin && \
    # rm -r /lilypond-2.23.12-linux-x86_64.tar.gz /lilypond-2.23.12 && \
    # # # download and install shell2http
    wget https://github.com/msoap/shell2http/releases/download/1.13/shell2http-1.13.linux.amd64.tar.gz && \
    tar -xf shell2http-1.13.linux.amd64.tar.gz && \
    # # install Node.js (for the svgo package)
    curl -sL https://deb.nodesource.com/setup_12.x | bash && \
    apt-get install -y nodejs && \
    # install svgo
    npm install -g svgo

COPY scripts/* /bin/scripts/
RUN chmod +x /bin/scripts/*

# COPY fonts/*.otf /usr/local/lilypond/usr/share/lilypond/current/fonts/otf/
COPY fonts/*.otf /usr/share/fonts/otf/

WORKDIR /lilywork

RUN adduser --disabled-password --gecos '' lilyponder && \
    chown -R lilyponder /lilywork

USER lilyponder

# ENTRYPOINT /shell2http -form \
#     POST:/make 'TMPDIR=`mktemp XXXX -d` \
#     && cd $TMPDIR \
#     && ln -s /bin/scripts/Makefile \
#     # if the .ly file is not provided, then
#     # quietly unzip the zip file into current directory
#     && (cp $filepath_file_lilypond score.ly || unzip -qq $filepath_file_zip -d .)  \
#     && make $v_recipe > /dev/null; rm Makefile; cd ..; tree $TMPDIR -J -L 1 --noreport' \
#     \
#     GET:/make_test 'TMPDIR=`mktemp XXXX -d` \
#     && cd $TMPDIR \
#     && ln -s /bin/scripts/Makefile \
#     && echo "{ c }" > score.ly \
#     && make $v_recipe > /dev/null; rm Makefile; cd ..; tree $TMPDIR -J -L 1 --noreport' \
#     \
#     GET:/get 'cd $v_dir && cat $v_file' \
#     GET:/del 'rm -r $v_dir && echo "ok" || echo "not deleted"'

COPY test-ly/* /lilywork/test/
