FROM golang:1.15-alpine3.12

ADD . /go/src/github.com/Lukasa/mkcert

RUN go install github.com/Lukasa/mkcert

ENTRYPOINT /go/bin/mkcert

EXPOSE 8080

ARG VCS_REF
ARG BUILD_DATE

LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/freight-trust/vcs.git"
