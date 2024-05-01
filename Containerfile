FROM quay.io/fedora-ostree-desktops/silverblue:40

COPY --from=ghcr.io/radulinux/kmods:40 /rpms /tmp/kmod-rpms

COPY rootfs/ /

COPY install.sh \
  post-install.sh \
  packages.json \
  /tmp/

RUN /tmp/install.sh && \
  /tmp/post-install.sh && \
  rm -rf /tmp/* && \
  ostree container commit