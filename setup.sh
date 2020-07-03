useradd -m -p "$1" "user"
cp -r /root/ /home/user/
chsh -s /bin/bash user

## TODO add plex claim option and mount gdrive (optimally give url) (use rclone or google-drive-ocamlfuse)
/bin/su -c "/path/to/start_docker.sh argument" - user
