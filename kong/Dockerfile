FROM sillelien/docker-kong
RUN apt-get install -y bash
COPY build.sh /build.sh
RUN chmod a+x /build.sh
RUN /build.sh
COPY plugins/ /usr/local/share/lua/5.1/kong/plugins/
COPY kong.yml /kong.yml
COPY run.sh /run.sh
RUN chmod +x /run.sh
CMD /run.sh
EXPOSE 8000 8001
