# bootstrap
if [ "XXX$HOME" = "XXX/home" ]
then
  uname -a

  # redis
  pgrep redis-server || (redis-server &)

  # node
  cd /home/firstchart
  pgrep node || (node server.js &)
  cd /home

  # php-fpm
  pgrep php-fpm || php-fpm

  # NGINX
  pgrep nginx || nginx
else
  # chroot if not in root environment
  termux-chroot
fi
