FROM neshkeev/dind

COPY --from=golang:1.21-alpine3.18 /usr/local/go/ /usr/local/go/

COPY --chmod=777 ./bin/kind-setup /init.d/100-kind-setup

RUN /usr/local/go/bin/go install sigs.k8s.io/kind@v0.20.0 && \
    ln -sf /root/go/bin/kind /bin/kind && \
    wget -O /bin/kubectl "https://dl.k8s.io/release/$(wget -qO- https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x /bin/kubectl && \
    rm -rf /usr/local/go/ && \
    mkdir -p /etc/kubernetes && \
    printf "kind: Cluster\napiVersion: kind.x-k8s.io/v1alpha4" > /etc/kubernetes/config.yml && \
    true
