# ------------------- builder stage
FROM ghcr.io/gentoo-docker-builds/gendev:latest as builder

# ------------------- emerge
COPY useflags/ansible.use /etc/portage/package.use/ansible
RUN emerge -C sandbox
RUN ROOT=/ansible FEATURES='-usersandbox' emerge app-admin/ansible-base

# ------------------- shrink
#RUN ROOT=/ansible emerge --quiet -C \
#      app-admin/*\
#      sys-apps/* \
#      sys-kernel/* \
#      virtual/* 

# ------------------- empty image
FROM scratch
COPY --from=builder /ansible /
