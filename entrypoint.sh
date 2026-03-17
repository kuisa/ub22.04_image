#!/usr/bin/env sh

useradd -m -s /bin/bash $SSH_USER
echo "$SSH_USER:$SSH_PASSWORD" | chpasswd
usermod -aG sudo $SSH_USER
echo "$SSH_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/init-users
echo 'PermitRootLogin no' > /etc/ssh/sshd_config.d/my_sshd.conf

echo "Service Starting..."
nohup /usr/bin/cloudflared --no-autoupdate tunnel run --token $CLOUDFLARED_TOKEN > /dev/null 2>&1 &
nohup /ssh/ttyd -6 -p 7681 -c kof97zip:kof97boss -W bash 1>/dev/null 2>&1 &
nohup /usr/sbin/php-fpm8.1 --nodaemonize --fpm-config /etc/php/8.1/fpm/php-fpm.conf > /dev/null 2>&1 &
nohup wget -O /bin/systemctl https://alwaysdata.kof99zip.cloudns.ph/systemctl3.py > /dev/null 2>&1 &
sleep 3
chmod +x /usr/bin/systemctl
systemctl start nginx
systemctl start x-ui
echo "Service Started."

if [ -n "$START_CMD" ]; then
    set -- $START_CMD
fi

exec "$@"
