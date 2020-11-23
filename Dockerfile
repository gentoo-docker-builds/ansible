# ------------------- builder stage
FROM ghcr.io/gentoo-docker-builds/gendev:latest as builder

# ------------------- emerge
COPY useflags/ansible.use /etc/portage/package.use/ansible
RUN emerge -C sandbox
RUN ROOT=/ansible FEATURES='-usersandbox' emerge app-admin/ansible-base

# ------------------- shrink
RUN ROOT=/ansible emerge --quiet -C \
      app-admin/select \
      app-admin/metalog \
      sys-apps/* \
      sys-kernel/* \
      sys-apps/coreutils \
      sys-apps/file \
      sys-apps/sed \
      sys-apps/shadow \
      virtual/* \
      sys-libs/ncurses

# ------------------- detox
RUN rm -rf \
        /ansible/var/db/pkg \
        /ansible/usr/share/doc \
        /ansible/usr/share/eselect \
        /ansible/usr/share/info \
        /ansible/usr/share/man \
        /ansible/var/lib/gentoo \
        /ansible/var/lib/portage \
        /ansible/var/cache/edb

# ------------------- empty image
FROM scratch
COPY --from=builder /ansible /
