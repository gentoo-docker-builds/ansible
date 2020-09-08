# ------------------- builder stage
FROM gentoo/stage3-amd64 as builder
ENV FEATURES="-mount-sandbox -ipc-sandbox -network-sandbox -pid-sandbox -sandbox -usersandbox"

# ------------------- portage tree
COPY --from=gentoo/portage:latest /var/db/repos/gentoo /var/db/repos/gentoo

# ------------------- emerge
RUN echo '=dev-lang/python-3.7.8-r2:3.7 sqlite' >> /etc/portage/package.use/ansible
RUN echo '=net-libs/zeromq-4.3.2 drafts' >> /etc/portage/package.use/ansible
RUN echo '=dev-libs/openssl-1.1.1g bindist' >> /etc/portage/package.use/ansible
RUN echo '=net-misc/openssh-8.1_p1-r4 bindist' >> /etc/portage/package.use/ansible
RUN emerge -C sandbox
RUN ROOT=/ansible FEATURES='-usersandbox' emerge ansible


# ------------------- shrink
#RUN ROOT=/ansible emerge --quiet -C \
#      app-admin/*\
#      sys-apps/* \
#      sys-kernel/* \
#      virtual/* 

# ------------------- empty image
FROM scratch
COPY --from=builder /ansible /
