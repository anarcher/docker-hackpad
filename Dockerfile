FROM williamyeh/scala:2.11.6
MAINTAINER Ilya Stepanov <dev@ilyastepanov.com>

RUN apt-get update && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -d /home/hackpad hackpad
RUN mkdir /home/hackpad
RUN chown hackpad:hackpad /home/hackpad

WORKDIR /home/hackpad

#RUN git clone --depth 1 https://github.com/dropbox/hackpad.git && rm -rf hackpad/.git
RUN git clone --depth 1 https://github.com/spikeekips/hackpad.git && rm -rf hackpad/.git

ADD exports.sh hackpad/bin/exports.sh

RUN mkdir -p lib/ data/logs/
RUN wget https://cdn.mysql.com/archives/mysql-connector-java-5.1/mysql-connector-java-5.1.34.tar.gz && \
    tar -xzvf mysql-connector-java-5.1.34.tar.gz && \
    mv mysql-connector-java-5.1.34/mysql-connector-java-5.1.34-bin.jar lib/ && \
    rm mysql-connector-java-5.1.34.tar.gz && \
    rm -rf mysql-connector-java-5.1.34/

RUN ./hackpad/bin/build.sh

ADD start.sh start.sh
RUN chmod +x start.sh

EXPOSE 9000

CMD '/home/hackpad/start.sh'
