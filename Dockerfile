FROM ubuntu:14.04

ENV BROWSER Firefox
ENV DISPLAY :99

#================================================
# Installations
#================================================

RUN apt-get update && apt-get install -y $BROWSER \
        build-essential libssl-dev \
        vim xvfb xz-utils zlib1g-dev

RUN wget --quiet
https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O
/miniconda.sh

RUN bash /miniconda.sh -b -p /opt/conda &&

ENV PATH /opt/conda/bin:$PATH

RUN conda install pip

RUN pip install selenium pyvirtualdisplay requests unittest-xml-reporting

#==================
# Vim highlight
#==================

RUN echo "syntax on" >> /etc/vim/vimrc

#==================
# Xvfb + init scripts
#==================
ADD libs/xvfb_init /etc/init.d/xvfb
RUN chmod a+x /etc/init.d/xvfb

ADD libs/xvfb-daemon-run /usr/bin/xvfb-daemon-run
RUN chmod a+x /usr/bin/xvfb-daemon-run

#============================
# Clean up
#============================
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

