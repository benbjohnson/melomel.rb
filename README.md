melomel.rb -- A Ruby interface to Melomel
=========================================

## DESCRIPTION

Melomel.rb is a library that allows Ruby to communicate with an application
running within the Flash virtual machine. For more information on Melomel,
visit the Melomel repository:

http://github.com/benbjohnson/melomel

Melomel.rb follows the rules of [Semantic Versioning](http://semver.org/) and
uses [TomDoc](http://tomdoc.org/) for inline documentation.


## INSTALLATION

To install Melomel.rb simply use RubyGems:

    $ [sudo] gem install melomel

Melomel needs to be embedded and running in the application you're trying to
connect to. Please see the Melomel repository for instructions on installation.


## GETTING STARTED

The first step to using Melomel is to install the Flash SWC in your application.
Once the SWC is in your application, setup in your Ruby project is simple.

In your Ruby file, simply call the `connect()` method on `Melomel`:

	require 'melomel'
	Melomel.connect()

The `connect()` method is a blocking method so it won't proceed until it's done.
After it's connected, there are several actions you can perform:

1. Create Object
1. Get Class
1. Get Property
1. Set Property
1. Invoke Method

## API

### Overview

Melomel communicates to the Flash virtual machine over a socket connection
using XML. The protocol is simple and is meant to proxy all data access calls
to the Flash virtual machine. This means that only primitives (strings, numbers
and booleans) are copied but all objects are accessed by reference. By proxying
objects, all data stays in the Flash virtual machine and there are no syncing
issues.

### Create Object

To create an object, use the `create_object()` method on `Melomel`:

    point = Melomel.create_object('flash.geom.Point')

The object returned is a proxy object so any actions performed on it in Ruby
will be performed on the ActionScript object in the Flash virtual machine.

### Get Class

You can retrieve a class to call static methods and properties. Since classes
are objects in ActionScript, they work identically in Melomel.

    app = Melomel.get_class('mx.core.FlexGlobals')
    app.topLevelApplication.name  = 'Melomel App!'

This Flex 4 example updates the name of the application to "Melomel App!".

### Get Property & Set Property

Getting and setting properties is handled transparently when using the object
proxies.

    point = Melomel.create_object('flash.geom.Point')
    point.x = 30
    point.set_property('y') = 40
	p "pos: #{point.x}, #{point.y}"
	p "length: #{point.get_property('length')}"

Property accessors on an object proxy are automatically used to retrieve the
property value of the Flash object. You can also use the `get_property()`
method when accessing properties and the `set_property()` method when mutating
properties.

### Invoke Method

Invoking methods is also handled transparently when using object proxies.

_IMPORTANT: There a catch! Methods without any parameters must have a bang
(`!`) character appended to their method name when calling directly on an
object proxy._

	clipboard = Melomel.get_class('flash.desktop.Clipboard').generalClipboard
	data = clipboard.getData('air:text')
	data = clipboard.invoke_method('getData', 'air:text')
	clipboard.clear!()
	clipboard.invoke_method('clear')

In this example, the `getData` method could be called on the object directly
because it had more than one argument. The `clear` method, however, required
that a bang character be appended to the name or that the `invoke_method` be
used.


## HACKING

To get started with working with the source, start by running Bundler to get all
your dependencies:

	[sudo] bundle install

If you are adding new features, please add test coverage to all code that you
write. Run the test suite with `rake`:

	rake test


## CONTRIBUTE

If you'd like to contribute to Melomel.rb, please fork the repo on GitHub:

http://github.com/benbjohnson/melomel.rb

To get all of the dependencies, install the gem first. The best way to get
your changes merged back into core is as follows:

1. Clone your fork locally
1. Create a named topic branch to contain your change
1. Code
1. All code must have RSpec test coverage. Run `rake` to ensure everything
   passes.
1. If you are adding new functionality, document it in the README
1. If necessary, rebase your commits into logical chunks, without errors
1. Push the branch up to GitHub
1. Send me a pull request for your branch