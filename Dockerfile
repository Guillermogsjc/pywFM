# Docker image to pywFM development
FROM jfloff/alpine-python:2.7

# install needed packages
RUN apk add --update \
              py-numpy@testing \
              py-numpy-dev@testing \
              py-scipy@testing \
    && rm /var/cache/apk/*

# Due to dependencies scipy and scikit-learn have to be in different commands
# Also due to that, we can't have a requirements.txt file
RUN pip install numpy \
    && pip install scipy \
                   pandas \
    && pip install scikit-learn \
                   wheel

# clone repo and set envorinment variable to libfm PATH
RUN git clone https://github.com/srendle/libfm /home/libfm \
    && cd /home/libfm/ && make all
ENV LIBFM_PATH /home/libfm/bin/

# since we will be "always" mounting the volume, we can set this up
WORKDIR /home/pywFM

# install package in development mode at the begining
CMD pip install -e . && /bin/bash
