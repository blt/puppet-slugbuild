# Puppet module for Slug Builder setup

As documented at [blog.troutwine.us](http://blog.troutwine.us)'s series on
Puppet, this module installs and manages the 'slugbuilder' user and related
tools, meant to provide source code compilation and packaging--per commit--into
[squashfs](http://en.wikipedia.org/wiki/SquashFS) read-only slugs suitable for
deployment to production systems.

## Installation

In the root of your puppet configuration

    $ git submodule add git://github.com/blt/puppet-slugbuilder.git modules/slugbuilder

## Quickstart

It is recommended that slugbuilder be hosted on only a single machine type: that
is, do not enable it for all machines. I, personally, run it on the same machine
as that which hosts my [gitolite rig](https://github.com/blt/puppet-gitolite).
