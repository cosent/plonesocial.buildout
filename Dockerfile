from ubuntu:14.04
maintainer guido.stevens@cosent.net
run apt-get update
run apt-get install -y python-dev gcc make zlib1g-dev libjpeg-dev python-virtualenv git-core
run apt-get install -y libfreetype6-dev gettext python-pip libxslt1-dev python-lxml
run apt-get install -y firefox python-tk
run apt-get install -y jed
run useradd -m -d /app app
run echo plonesocial.buildout > /etc/debian_chroot
cmd ["/bin/bash"]
