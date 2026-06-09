FROM flink:1.17.1

ENV SEATUNNEL_VERSION=2.3.11
ENV SEATUNNEL_HOME=/opt/seatunnel

# Download and unpack the SeaTunnel distribution.
RUN wget -q "https://dlcdn.apache.org/seatunnel/${SEATUNNEL_VERSION}/apache-seatunnel-${SEATUNNEL_VERSION}-bin.tar.gz" \
    && tar -xzf "apache-seatunnel-${SEATUNNEL_VERSION}-bin.tar.gz" \
    && mv "apache-seatunnel-${SEATUNNEL_VERSION}" "${SEATUNNEL_HOME}" \
    && rm "apache-seatunnel-${SEATUNNEL_VERSION}-bin.tar.gz"

# Install only the connectors this demo uses. The distribution ships without
# connector jars, so install-plugin.sh downloads the ones listed in plugin_config.
COPY plugin_config "${SEATUNNEL_HOME}/config/plugin_config"
RUN cd "${SEATUNNEL_HOME}" && sh bin/install-plugin.sh "${SEATUNNEL_VERSION}"

WORKDIR ${SEATUNNEL_HOME}
