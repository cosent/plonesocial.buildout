PROJECT=plonesocial.buildout
default: all

all: bin/buildout
	bin/buildout

fast: bin/buildout
	bin/buildout -N

docker-build:
	docker build -t $(PROJECT) .

# re-uses ssh agent
# presupposes your buildout cache is in /var/tmp as configured in .buildout
# also loads your standard .bashrc
docker-run:
	docker run -i -t \
		--net=host \
		-v $(SSH_AUTH_SOCK):/tmp/auth.sock \
		-v $(HOME)/.gitconfig:/.gitconfig \
		-v $(HOME)/.gitignore:/.gitignore \
		-v /var/tmp:/var/tmp \
		-v $(HOME)/.bashrc:/.bashrc \
		-v $(HOME)/.buildout:/.buildout \
		-e SSH_AUTH_SOCK=/tmp/auth.sock \
		-v $(PWD):/app -w /app -u app $(PROJECT)


robot-server:
	bin/robot-server plonesocial.suite.testing.PLONESOCIAL_ROBOT_TESTING

robot-predepends:
	sudo apt-get install -y firefox python-tk

clean:
	@rm -f bin/* .installed.cfg .mr.developer.cfg
#	@echo "To recompile PIL: remove all PIL* eggs from your eggs cache."
#	@find src -type d -name "Paste*" | xargs rm -rf
#	@echo "If you keep having problems, purge /var/tmp/dist/* and your eggs cache"

predepends: robot-predepends

lucid: _check_root _check_apt
	apt-get install make gcc python2.6-dev libjpeg62-dev zlib1g-dev python-setuptools
	easy_install virtualenv
	apt-get install jed git-core openssh-client
#       # for python tests
	apt-get install python-profiler
#	# for cmmi compilation - soelim
#	apt-get install groff-base

start:
	bin/supervisord

stop:
	bin/supervisorctl shutdown


### development targets ###

pull: update
update: 
	@echo "=================== $@ ======================="
	@echo -n "buildout... "
	@git pull
	@for p in plonesocial.suite plonesocial.microblog plonesocial.activitystream plonesocial.network plonesocial.messaging plonesocial.theme ploneintranet.theme plonesocial.core ; \
		do ( echo '---'; echo -n "$$p... " && cd src/$$p && git pull; ); \
	done

status: fetch localstatus

localstatus:
	@echo "=================== $@ ======================="
	@for p in plonesocial.suite plonesocial.microblog plonesocial.activitystream plonesocial.network plonesocial.messaging plonesocial.theme ploneintranet.theme plonesocial.core ; \
		do ( echo '---'; echo -n "$$p... " && cd src/$$p && git status; ); \
	done
	@echo '---'
	@echo -n "buildout... "
	@git status

push:
	@echo "=================== $@ ======================="
	@for p in plonesocial.suite plonesocial.microblog plonesocial.activitystream plonesocial.network plonesocial.messaging plonesocial.theme ploneintranet.theme plonesocial.core ; \
		do ( echo '---'; echo -n "$$p... " && cd src/$$p && git push && git push --tags ); \
	done
	@echo '---'
	@echo -n 'buildout... '
	@git push
	@git push --tags

test: flake8
	@echo "=================== $@ ======================="
	bin/test -s plonesocial.suite -s plonesocial.microblog -s plonesocial.activitystream -s plonesocial.network -s plonesocial.messaging -s plonesocial.theme -s plonesocial.core

flake8:
	bin/flake8 src/plonesocial.suite/src/plonesocial
	bin/flake8 src/plonesocial.microblog/plonesocial
	bin/flake8 src/plonesocial.activitystream/plonesocial
	bin/flake8 src/plonesocial.core/src/plonesocial
	bin/flake8 src/plonesocial.network/plonesocial
	bin/flake8 src/plonesocial.messaging/src/plonesocial
	bin/flake8 src/plonesocial.theme/plonesocial
	bin/flake8 src/ploneintranet.theme/src/ploneintranet

rc: noploneintranet
	bin/release -c cook
	bin/release -c dist

release: noploneintranet
	bin/release cook
	bin/release dist

noploneintranet:
	@bin/develop ls | grep ploneintranet && (echo "ERROR: DO NOT RELEASE ploneintranet.theme!"; exit 1)

# branches
ls: 
	@echo "=================== $@ ======================="
	@for p in plonesocial.suite plonesocial.microblog plonesocial.activitystream plonesocial.messaging plonesocial.network ploneintranet.theme plonesocial.core ; \
		do ( echo '---'; echo "$$p... " && cd src/$$p && git branch -a -v; ); \
	done
	@echo '---'
	@echo -n 'buildout... '
	@git branch -a -v

# read remote
fetch: 
	@echo "=================== $@ ======================="
	@for p in plonesocial.suite plonesocial.microblog plonesocial.activitystream plonesocial.messaging plonesocial.network ploneintranet.theme plonesocial.core ; \
		do ( echo '---'; echo "$$p... " && cd src/$$p && git $@; ); \
	done
	@echo '---'
	@echo -n 'buildout... '
	@git $@
	@echo



### helper targets ###

bin/buildout: bin/python2.7
	@bin/pip install -r requirements.txt

bin/python2.7:
	@virtualenv --clear --no-site-packages .

precise: _check_apt
	sudo apt-get install -y make gcc python2.7-dev libjpeg-dev zlib1g-dev python-setuptools wget jed git-core openssh-client
	sudo easy_install virtualenv

_check_apt:
	@grep 'restricted' /etc/apt/sources.list || ( echo 'Add to /etc/apt/sources.list: restricted universe multiverse'; exit 1 )
	@grep 'universe' /etc/apt/sources.list || ( echo 'Add to /etc/apt/sources.list: restricted universe multiverse'; exit 1 )
	@grep 'multiverse' /etc/apt/sources.list || ( echo 'Add to /etc/apt/sources.list: restricted universe multiverse'; exit 1 )

