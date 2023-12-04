FROM docker:dind

COPY --from=docker/compose-bin:edge /docker-compose /usr/libexec/docker/cli-plugins/docker-compose

RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache openssh tini && \
    sed -i -e 's/^root:!:/root::/' /etc/shadow && \
    ssh-keygen -A && \
    echo "PasswordAuthentication no" >> /etc/ssh/sshd_config && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    true

COPY --chmod=700 ./bin/dind-entrypoint /bin/dind-entrypoint

COPY --chmod=700 ./bin/docker-with-compose-wrapper /usr/local/sbin/docker

VOLUME /init.d

ENTRYPOINT [ "/sbin/tini", "--", "/bin/dind-entrypoint" ]
