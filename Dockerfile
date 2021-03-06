FROM python:3

RUN apt-get update && apt-get install -y \
    build-essential \
    gfortran \
    libblas-dev \
    liblapack-dev \
    libxft-dev \
    && rm -rf /var/lib/apt/lists/*

RUN echo 'export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"' >> ~/.bash_profile && \
    . ~/.bash_profile && \
    cd ~ &&\
    git clone https://github.com/taku910/mecab.git && \
    cd mecab/mecab && \
    ./configure  --enable-utf8-only && \
    make && \
    make check && \
    make install && \
    cd ../mecab-ipadic && \
    ./configure --with-charset=utf8 && \
    make && \
    make install &&\
    cd ~ &&\
    git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git && \
    cd mecab-ipadic-neologd && \
    ./bin/install-mecab-ipadic-neologd -n -y

RUN pip3 install --upgrade pyzmq --install-option="--zmq=bundled" && \
    pip3 install --upgrade jupyter && \
    pip3 install --upgrade \
    numpy \
    scipy \
    scikit-learn \
    matplotlib \
    pandas \
    mecab-python3 \
    neologdn

ENV LD_LIBRARY_PATH /usr/local/lib:$LD_LIBRARY_PATH

VOLUME /notebook
WORKDIR /notebook

EXPOSE 8888

ENTRYPOINT jupyter notebook --ip=0.0.0.0 --allow-root --no-browser
