FROM hadoop-base

# DataNode Web UI 응답 여부를 통해 healthcheck
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD curl -f http://localhost:50075 || exit 1

RUN mkdir /opt/hadoop/dfs/data
VOLUME /opt/hadoop/dfs/data

ADD start.sh /start.sh
RUN chmod a+x /start.sh

# WebUI, 데이터 전송
EXPOSE 50075 50010

CMD ["/start.sh", "/etc/init.d/ssh restart"]