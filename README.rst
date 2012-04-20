.. contents::

Introduction
============

This is a developer's buildout to work on the Plonesocial suite of packages.


Plonesocial
===========

Plonesocial consists of:

`plonesocial.microblog`_
 Status updates

`plonesocial.activitystream`_
 Lists content changes, discussion replies, and status updates

plonesocial.network
 Follow/unfollow of users

plonesocial.like
 Favoriting of content

`plonesocial.suite`_
 An out-of-the-box social business experience integrating all of the above.
 If you're an end user, this is what you're looking for.

`plonesocial.buildout`_
 This buildout. Not a Python package. Intended for Plonesocial developers only.


This is a work in progress and not suitable for general release yet.


Using this buildout
===================

You can ignore the Makefile and just use buildout. You'll have to bootstrap
it first though. YMMV. See the Makefile for scripts.


Makefile
--------

The included Makefile is optimized for use on Ubuntu Lucid::

  make lucid
  make



Github sources
--------------

By default, the buildout clones read-only sources of the various plonesocial.* components
into ./src/. To enable push to github, use::

  cd ./src/plonesocial.microblog
  git remote set-url --push origin git@github.com:cosent/plonesocial.microblog.git

You'll have to to that for each src package you want to push.

This only works if you have push rights, which you get by sending a mail to
guido.stevens@cosent.net with your github user id. 
Alternatively, you can fork the sources on github and
use your own push repositories. Please don't forget submit merge requests in that case!


.. _plonesocial.microblog: https://github.com/cosent/plonesocial.microblog
.. _plonesocial.activitystream: https://github.com/cosent/plonesocial.activitystream
.. _plonesocial.suite: https://github.com/cosent/plonesocial.suite
.. _plonesocial.buildout: https://github.com/cosent/plonesocial.buildout
