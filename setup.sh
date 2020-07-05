#! /bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

user_not_yet_created=$(id -u ayyy > /dev/null 2>&1; echo $?)

if [ $# -eq 0 ]; then
  echo "No arguments supplied"
  exit
fi


if [ user_not_yet_created = 1 ]; then
  /bin/read -p "Password: " -s password
  /bin/useradd -m -p "$password" "$1"
  /bin/cp -r /root/ /home/$1/
  /bin/chown -R "$1" /home/$1/
  /bin/chsh -s /bin/bash "$1"
fi

# get user id and group id
if !(/bin/grep -q "PGID=$(id -g $1)" $DIR/docker/.env); then
  /bin/echo "PGID=$(id -g $1)" >> $DIR/docker/.env
fi

if !(/bin/grep -q "PGID=$(id -g $1)" $DIR/docker/.env); then
  /bin/echo "PGID=$(id -g $1)" >> $DIR/docker/.env
fi


# get a plex claim token
if !(/bin/grep -q -E "PLEX_CLAIM=" $DIR/docker/.env); then
  /bin/read -p "Enter Plex Claim Token from https://www.plex.tv/claim/: " plex_claim
  /bin/echo "PLEX_CLAIM=$plex_claim" >> $DIR/docker/.env
fi

# install docker and docker-compose
if [ -x "$(command -v docker)" ]; then
  /bin/su -c "/bin/bash $DIR/scripts/install_docker.sh" - "$1"
fi

if [ -x "$(command -v docker-compose)" ]; then
  /bin/su -c "/bin/bash $DIR/scripts/install_docker-compose.sh" - "$1"
fi

# TODO do rclone stuff
# sudo apt install fuse rclone
# https://bytesized-hosting.com/pages/rclone-gdrive
# https://github.com/animosity22/homescripts
# start all containers
/bin/su -c "$DIR/start_stack.sh" - "$1"
