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

`plonesocial.network`_
 Follow/unfollow of users

plonesocial.like
 Favoriting of content

`plonesocial.suite`_
 An out-of-the-box social business experience integrating all of the above.
 If you're an end user, this is what you're looking for.

`plonesocial.buildout`_
 This buildout. Not a Python package. Intended for Plonesocial developers only.

This is a work in progress and not suitable for general release yet.

.. _plonesocial.microblog: https://github.com/cosent/plonesocial.microblog
.. _plonesocial.activitystream: https://github.com/cosent/plonesocial.activitystream
.. _plonesocial.network: https://github.com/cosent/plonesocial.network
.. _plonesocial.suite: https://github.com/cosent/plonesocial.suite
.. _plonesocial.buildout: https://github.com/cosent/plonesocial.buildout


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
into ./src/. To enable push, create a fork on github and then::

  cd ./src/plonesocial.microblog
  git remote set-url --push origin git@github.com:YOUR_GITHUB_ID/plonesocial.microblog.git

You'll have to to that for each src package you want to push, and/or for the buildout itself.

Please don't forget to submit pull requests :-)


