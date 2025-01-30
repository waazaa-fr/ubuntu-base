FROM ubuntu:24.04

LABEL org.opencontainers.image.authors="waazaa <waazaa@waazaa.fr>"
LABEL version="ubuntu-base:24.04"
LABEL desc="Ubuntu Linux base image"

ENV TZ=Europe/Paris
ENV PUID=99
ENV PGID=100

ARG DEBIAN_FRONTEND=noninteractive

#######################################################################################################################################################################
##### PAQUETS UTILES
#######################################################################################################################################################################
RUN apt-get update && apt-get install -y --no-install-recommends curl wget gpg tree lsb-release sudo locales ca-certificates cron nano python3-pip librsync-dev
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


#######################################################################################################################################################################
##### USER
#######################################################################################################################################################################
# Créer un utilisateur nommé waazaa et définir son mot de passe
RUN useradd -m -s /bin/bash waazaa && \
    echo "waazaa:waazaa" | chpasswd
# Ajouter l'utilisateur waazaa au groupe sudo
RUN usermod -aG sudo waazaa
RUN touch /etc/profile.d/bash_completion.sh \
    && echo "exec /bin/bash" > /home/waazaa/.profile \
    && echo "source /etc/profile.d/bash_completion.sh" > /home/waazaa/.bashrc \
    && echo "alias dir='ls --color=never -alh'" >> /home/waazaa/.bashrc \
    && echo "alias lsa='ls -alh'" >> /home/waazaa/.bashrc \
    && echo "alias mkdir='mkdir --verbose'" >> /home/waazaa/.bashrc \
    && echo 'export PS1="\[\e[31m\][\[\e[m\]\[\e[38;5;172m\]\u\[\e[m\]@\[\e[38;5;153m\]\h\[\e[m\] \[\e[38;5;214m\]\W\[\e[m\]\[\e[31m\]]\[\e[m\]\$ "' >> /home/waazaa/.bashrc \
    && echo 'export EDITOR="nano"' >> /home/waazaa/.bashrc \
    && echo 'export PATH=$PATH:/home/waazaa/.local/bin' >> /home/waazaa/.bashrc

RUN mkdir -m 0777 -p /home/waazaa/.config/pip && echo "[global]" > /home/waazaa/.config/pip/pip.conf && echo "break-system-packages = true" >> /home/waazaa/.config/pip/pip.conf


COPY root/ /
RUN chmod a+x /start/*.sh


CMD ["/start/start.sh"]
