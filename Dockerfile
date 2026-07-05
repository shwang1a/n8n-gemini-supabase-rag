FROM n8nio/n8n:latest

USER root

RUN apk add --no-cache \
    bash \
    curl \
    git \
    tzdata \
    python3 \
    py3-pip

ENV TZ=Asia/Taipei

USER node

EXPOSE 5678

CMD ["n8n"]