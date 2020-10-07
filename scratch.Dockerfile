FROM scratch

ADD certs.pem /etc/pki/tls/certs/ca-bundle.crt
ADD out/mkcertd /

ENTRYPOINT ["/mkcertd"]
