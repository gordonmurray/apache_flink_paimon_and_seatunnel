FROM flink:1.17

ENV SEATUNNEL_VERSION="2.3.2"
ENV SEATUNNEL_HOME="/opt/seatunnel"

RUN wget https://dlcdn.apache.org/seatunnel/${SEATUNNEL_VERSION}/apache-seatunnel-${SEATUNNEL_VERSION}-bin.tar.gz
RUN tar -xzvf apache-seatunnel-${SEATUNNEL_VERSION}-bin.tar.gz
RUN mv apache-seatunnel-${SEATUNNEL_VERSION} ${SEATUNNEL_HOME}

RUN cd ${SEATUNNEL_HOME}||sh bin/install-plugin.sh ${SEATUNNEL_VERSION}
