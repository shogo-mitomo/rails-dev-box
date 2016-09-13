# The output of all these installation steps is noisy. With this utility
# the progress report is nice and concise.
function install {
    echo installing $1
    shift
    apt-get -y install "$@" >/dev/null 2>&1
}

echo adding swap file
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap defaults 0 0' >> /etc/fstab

echo updating package information
apt-add-repository -y ppa:brightbox/ruby-ng >/dev/null 2>&1
apt-get -y update >/dev/null 2>&1

install 'development tools' build-essential

install 'ruby-build dependencies' autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev

readonly RBENV_PATH=/usr/local/rbenv
readonly RBENV_CONF=/etc/profile.d/rbenv.conf.sh

git clone 'https://github.com/rbenv/rbenv.git' $RBENV_PATH
git clone 'https://github.com/sstephenson/ruby-build.git' "$RBENV_PATH/plugins/ruby-build"

printf 'export RBENV_ROOT=/usr/local/rbenv\n' >> $RBENV_CONF
printf 'export PATH=$RBENV_ROOT/bin:$PATH\n'  >> $RBENV_CONF
printf 'eval "$(rbenv init -)"\n'             >> $RBENV_CONF

readonly RUBY_VERSION=2.3.1

source $RBENV_CONF

rbenv install $RUBY_VERSION
rbenv global $RUBY_VERSION

gem i bundler

install Git git
install SQLite sqlite3 libsqlite3-dev
# install memcached memcached
# install Redis redis-server
# install RabbitMQ rabbitmq-server

install PostgreSQL postgresql postgresql-contrib libpq-dev
sudo -u postgres createuser --superuser vagrant
sudo -u postgres createdb -O vagrant activerecord_unittest
sudo -u postgres createdb -O vagrant activerecord_unittest2

# debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
# debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
# install MySQL mysql-server libmysqlclient-dev
# mysql -uroot -proot <<SQL
# CREATE USER 'rails'@'localhost';
# CREATE DATABASE activerecord_unittest  DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
# CREATE DATABASE activerecord_unittest2 DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
# GRANT ALL PRIVILEGES ON activerecord_unittest.* to 'rails'@'localhost';
# GRANT ALL PRIVILEGES ON activerecord_unittest2.* to 'rails'@'localhost';
# GRANT ALL PRIVILEGES ON inexistent_activerecord_unittest.* to 'rails'@'localhost';
# SQL

printf "\nexport NOKOGIRI_USE_SYSTEM_LIBRARIES=1\n" >> $RBENV_CONF
install 'Nokogiri dependencies' libxml2 libxml2-dev libxslt1-dev
install 'Blade dependencies' libncurses5-dev
install 'ExecJS runtime' nodejs

# Needed for docs generation.
update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

echo 'all set, rock on!'
