default: fast

all: bin/buildout
	bin/buildout

fast: bin/buildout
	bin/buildout -N

async: bin/buildout
	bin/buildout -N -c async.cfg

#production: bin/buildout
#	bin/buildout -c production.cfg

clean:
	@rm -f bin/* .installed.cfg .mr.developer.cfg
#	@echo "To recompile PIL: remove all PIL* eggs from your eggs cache."
#	@find src -type d -name "Paste*" | xargs rm -rf
#	@echo "If you keep having problems, purge /var/tmp/dist/* and your eggs cache"

predepends: lucid

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
	git pull
	bin/develop update 'plonesocial.*'

status: fetch localstatus

localstatus:
	@echo "=================== $@ ======================="
	@for p in plonesocial.suite plonesocial.microblog plonesocial.activitystream ; \
		do ( echo '---'; echo -n "$$p... " && cd src/$$p && git status; ); \
	done
	@echo '---'
	@echo -n "buildout... "
	@git status

rebase:
	@echo "=================== $@ ======================="
	@for p in plonesocial.suite plonesocial.microblog plonesocial.activitystream ; \
		do ( \
			echo '---'; \
			echo -n "$$p... "; \
			cd src/$$p && git fetch; \
			b=`git branch|grep '^\*'|cut -f2 -d' '`; \
			git $@ origin/$$b; \
		); \
	done
	@echo -n "buildout... "
	b=`git branch|grep '^\*'|cut -f2 -d' '`; \
	git $@ origin/$$b

push:
	@echo "=================== $@ ======================="
	@for p in plonesocial.suite plonesocial.microblog plonesocial.activitystream ; \
		do ( echo '---'; echo -n "$$p... " && cd src/$$p && git push; ); \
	done
	@for p in plonesocial.suite plonesocial.microblog plonesocial.activitystream ; \
		do ( echo '---'; echo -n "$$p... " && cd src/$$p && git push --tags; ); \
	done
	@echo '---'
	@echo -n 'buildout... '
	@git push
	@git push --tags

test:
	@echo "=================== $@ ======================="
	bin/test -s plonesocial.suite -s plonesocial.microblog -s plonesocial.activitystream

# branches
ls: 
	@echo "=================== $@ ======================="
	@for p in plonesocial.suite plonesocial.microblog plonesocial.activitystream ; \
		do ( echo '---'; echo "$$p... " && cd src/$$p && git branch -a -v; ); \
	done
	@echo '---'
	@echo -n 'buildout... '
	@git branch -a -v

# read remote
fetch: 
	@echo "=================== $@ ======================="
	@for p in plonesocial.suite plonesocial.microblog plonesocial.activitystream ; \
		do ( echo '---'; echo "$$p... " && cd src/$$p && git $@; ); \
	done
	@echo '---'
	@echo -n 'buildout... '
	@git $@
	@echo



### helper targets ###

bin/buildout: bin/python2.6
	@wget http://svn.zope.org/repos/main/zc.buildout/trunk/bootstrap/bootstrap.py
	@bin/python2.6 bootstrap.py
	@rm bootstrap.*
##	bin/easy_install distribute==0.6.19
##	bin/easy_install zc.buildout==1.5.2

bin/python2.6:
	@virtualenv --clear -p python2.6 --no-site-packages --distribute .

_check_root:
	@test "$$USER" = "root" || ( echo "Run that as root"; exit 1 )

_check_apt:
	@grep 'restricted' /etc/apt/sources.list || ( echo 'Add to /etc/apt/sources.list: restricted universe multiverse'; exit 1 )
	@grep 'universe' /etc/apt/sources.list || ( echo 'Add to /etc/apt/sources.list: restricted universe multiverse'; exit 1 )
	@grep 'multiverse' /etc/apt/sources.list || ( echo 'Add to /etc/apt/sources.list: restricted universe multiverse'; exit 1 )

