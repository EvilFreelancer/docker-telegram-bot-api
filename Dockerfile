FROM alpine:3.17.2 as build

ENV CXXFLAGS=""
WORKDIR /usr/src

ARG TELEGRAM_API_REF=master

RUN set -xe \
 && apk add --no-cache --update alpine-sdk linux-headers git zlib-dev openssl-dev gperf cmake git \
 && git clone --recursive https://github.com/tdlib/telegram-bot-api.git \
 && cd telegram-bot-api \
 && git checkout ${TELEGRAM_API_REF}

WORKDIR /usr/src/telegram-bot-api/build
RUN set -xe \
 && cmake -DCMAKE_BUILD_TYPE=Release .. \
 && cmake --build . --target install -j $(nproc) \
 && strip /usr/local/bin/telegram-bot-api

FROM alpine:3.17.2

ENV TELEGRAM_WORK_DIR="/var/lib/telegram-bot-api" \
    TELEGRAM_TEMP_DIR="/tmp/telegram-bot-api"

RUN apk add --no-cache --update openssl libstdc++
COPY --from=build /usr/local/bin/telegram-bot-api /usr/local/bin/telegram-bot-api
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN addgroup -g 1000 -S telegram-bot-api \
 && adduser -S -D -H -u 1000 -h ${TELEGRAM_WORK_DIR} -s /sbin/nologin -G telegram-bot-api -g telegram-bot-api telegram-bot-api \
 && chmod +x /docker-entrypoint.sh \
 && mkdir -p ${TELEGRAM_WORK_DIR} ${TELEGRAM_TEMP_DIR} \
 && chown telegram-bot-api:telegram-bot-api ${TELEGRAM_WORK_DIR} ${TELEGRAM_TEMP_DIR}

EXPOSE 8081/tcp 8082/tcp
ENTRYPOINT ["/docker-entrypoint.sh"]
