FROM docker.elastic.co/elasticsearch/elasticsearch:5.6.9
USER 0
RUN yum -y install openssl
USER 1000
RUN echo "===> Installing search-guard..." \
   && /usr/share/elasticsearch/bin/elasticsearch-plugin install -b "com.floragunn:search-guard-5:5.6.9-19"
