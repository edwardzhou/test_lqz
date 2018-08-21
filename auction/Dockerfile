FROM node:9.2.0 as web_assets
# RUN mkdir -p /priv/static
# WORKDIR /build
# COPY deps/phoenix /deps/phoenix
# COPY deps/phoenix_html /deps/phoenix_html
# COPY apps/auction_web/assets .
# RUN yarn install \
#  && yarn run deploy

# FROM node:9.2.0 as admin_assets
# RUN mkdir -p /priv/static
# WORKDIR /build
# COPY deps/phoenix /deps/phoenix
# COPY deps/phoenix_html /deps/phoenix_html
# COPY deps/ex_admin /deps/ex_admin
# COPY apps/auction_admin/assets .
# RUN yarn install \
#  && yarn run deploy

FROM bitwalker/alpine-elixir-phoenix:1.6.5

ENV LC_ALL=zh_CN.UTF-8
ARG MIX_ENV

EXPOSE 14000

RUN sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories \
 && sed -i "s/nl.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories \
 && apk add python \
    imagemagick \
    tzdata
#  && apk upgrade \
#  && apk update \
#  && apk add --upgrade apk-tools@edge \
#  && apk upgrade \
#  && apk update \
#  && apk add \
#     bash \
#     openssl \
#     curl \
#     build-base \
#     alpine-sdk \
#     python \
#     coreutils

RUN ln -nfs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
 && sed -i -e "s/bin\/ash/bin\/bash/" /etc/passwd

ADD . /app
WORKDIR /app

# COPY --from=web_assets /priv/static apps/auction_web/priv/static
# COPY --from=admin_assets /priv/static apps/auction_admin/priv/static

RUN export HEX_HTTP_TIMEOUT=120 \
    && export HEX_MIRROR="https://cdn.jsdelivr.net/hex" \
    && mix local.rebar --force \
    && mix local.hex --force \
    && mix deps.get \
    && cd /app/apps/auction_web/assets \
    && npm install \
    && node node_modules/brunch/bin/brunch build \
    && cd /app/apps/auction_admin/assets \
    && npm install \
    && node node_modules/brunch/bin/brunch build \
    && cd /app \
    && mix deps.compile gettext \
    && mix deps.compile \
    && mix compile \
    && mix phx.digest

COPY ./rel/scripts/docker-entrypoint.sh .
COPY ./rel/scripts/migrate-and-run.sh .
RUN ["chmod", "+x", "/app/docker-entrypoint.sh"]
RUN ["chmod", "+x", "/app/migrate-and-run.sh"]

ENTRYPOINT ["/app/docker-entrypoint.sh"]

CMD ["/app/migrate-and-run.sh"]
