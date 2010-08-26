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

To install Melomel for Ruby simply use RubyGems:

    $ [sudo] gem install melomel

Melomel needs to be embedded and running in the application you're trying to
connect to. Please see the Melomel repository for instructions on installation.


## GETTING STARTED



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