#!/bin/bash

. ~/.bashrc

set -e

if [ -z $SPACE ]
then
	echo '$SPACE is undefined.'
	exit 1
fi

if [ -z $1 ]
then
	echo "Usage: $0 space-name [command] [option] ..."
	exit 1
fi

SPACE_NAME="$1"
COMMAND="${@:2}"

export PS1="\[\e[${PROMPT_COLOR:-33}m\]\u@$SPACE_NAME\[\e[0m\]:\[\e[${PROMPT_COLOR:-36}m\]\w\[\e[0;31m\]${?#0}\[\e[0m\]\$ "

if [ -z $2 ]
then
	export COMMAND=bash
fi

bwrap \
	--unshare-user \
	--unshare-pid \
	--unshare-uts \
	--unshare-cgroup \
	--die-with-parent \
	--proc /proc \
	--dev-bind /dev /dev \
	--ro-bind /run/systemd/ /run/systemd/ \
	--ro-bind /opt /opt \
	--ro-bind /usr /usr \
	--ro-bind /etc /etc \
	--ro-bind /sys /sys \
	--ro-bind /tmp/.X11-unix /tmp/.X11-unix \
	--ro-bind $XAUTHORITY $XAUTHORITY \
	--bind $SPACE/home/$SPACE_NAME /home/$USERNAME \
	--bind $SPACE/home/$SPACE_NAME $SPACE/home/$SPACE_NAME \
	--bind $XDG_RUNTIME_DIR/bus $XDG_RUNTIME_DIR/bus \
	--bind $XDG_RUNTIME_DIR/pulse $XDG_RUNTIME_DIR/pulse \
	--bind $XDG_RUNTIME_DIR/pipewire-0 $XDG_RUNTIME_DIR/pipewire-0 \
	--bind $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY \
	--symlink /usr/bin /bin \
	--symlink /usr/lib /lib \
	--symlink /usr/lib64 /lib64 \
	$COMMAND
