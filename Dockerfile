FROM ubuntu:24.04

LABEL org.opencontainers.image.authors="waazaa <waazaa@waazaa.fr>"
LABEL version="ubuntu-base"
LABEL desc="Ubuntu Linux base image"

ENV TZ=Europe/Paris
ARG DEBIAN_FRONTEND=noninteractive

#######################################################################################################################################################################
##### PAQUETS UTILES
#######################################################################################################################################################################
RUN apt-get update && apt-get install -y --no-install-recommends curl wget gpg tree lsb-release sudo locales ca-certificates cron nano python3-pip librsync-dev supervisor
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN mkdir -m 0777 -p /root/.config/pip && echo "[global]" > /root/.config/pip/pip.conf && echo "break-system-packages = true" >> /root/.config/pip/pip.conf

#######################################################################################################################################################################
##### BASH
#######################################################################################################################################################################
RUN touch /etc/profile.d/bash_completion.sh \
    && echo "exec /bin/bash" > /root/.profile \
    && echo "source /etc/profile.d/bash_completion.sh" > /root/.bashrc \
    && echo "alias dir='ls --color=never -alh'" >> /root/.bashrc \
    && echo "alias lsa='ls -alh'" >> /root/.bashrc \
    && echo "alias mkdir='mkdir --verbose'" >> /root/.bashrc \
    && echo 'export PS1="\[\e[31m\][\[\e[m\]\[\e[38;5;172m\]\u\[\e[m\]@\[\e[38;5;153m\]\h\[\e[m\] \[\e[38;5;214m\]\W\[\e[m\]\[\e[31m\]]\[\e[m\]\$ "' >> /root/.bashrc \
    && echo 'export EDITOR="nano"' >> /root/.bashrc \
    && mkdir -p /etc/profile.d/ 


COPY root/ /
RUN chmod a+x /start/*.sh


CMD ["/start/start.sh"]
