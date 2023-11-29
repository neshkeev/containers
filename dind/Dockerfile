FROM docker:dind

COPY --from=docker/compose-bin:edge /docker-compose /usr/libexec/docker/cli-plugins/docker-compose

COPY --chmod=700 bin/dind-entrypoint /bin/dind-entrypoint

RUN apk update && apk add --no-cache openrc openssh && \
    sed -i -e 's/^root:!:/root::/' /etc/shadow && \
    ssh-keygen -A && \
    echo "PasswordAuthentication no" >> /etc/ssh/sshd_config && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    # touch softlevel because system was initialized without openrc
    mkdir -p /run/openrc && \
    touch /run/openrc/softlevel && \
    ln -sf /usr/local/bin/docker /bin/docker && \
    mkdir -p /init.d && \
    true

ENTRYPOINT [ "/bin/dind-entrypoint" ]
