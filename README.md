CLIUtils
====
[![Build Status](https://travis-ci.org/bachya/cliutils.svg?branch=master)](https://travis-ci.org/bachya/cliutils)
[![Gem Version](https://badge.fury.io/rb/cliutils.svg)](http://badge.fury.io/rb/cliutils)

CLIUtils is a library of functionality designed to alleviate common tasks and headaches when developing command-line (CLI) apps in Ruby.

# Why?

It's fairly simple:

1. I love developing Ruby-based CLI apps.
2. I found myself copy/pasting common code from one to another.
3. I decided to do something about it.

# Libraries

CLIUtils offers:

* PrettyIO: nicer-looking CLI messages
* Messaging: a system to display nicely-formatted messages to one or more tagets
* Configuration: a app configuration manager
* Prefs: a preferences prompter and manager

...along with plenty of documentation:

* [Wiki](https://github.com/bachya/cliutils/wiki "CLIUtils Wiki")
* [YARD documentation](http://rubydoc.info/github/bachya/cliutils/master/frames "YARD Documentation")

# Installation

Add this line to your application's Gemfile:

```bash
$ gem 'cliutils'
```

And then execute:

```bash
$ bundle
```

Or install it yourself:

```bash
$ gem install cliutils
```

# Usage

```Ruby
require 'cliutils'
```

If you want to mix in everything that CLIUtils has to offer:

```Ruby
include CLIUtils
```

# Can I use it with...?

I often get asked how nicely CLIUtils plays with other Ruby-based CLI libraries (like Dave Copeland's excellent [Methadone](https://github.com/davetron5000/methadone "Methadone") and [GLI](https://github.com/davetron5000/gli "GLI")). Answer: they play very nicely. I use CLIUtils in [Sifttter Redux](https://github.com/bachya/Sifttter-Redux "Sifttter Redux") (which is built on GLI) and [ExpandSync](https://github.com/bachya/ExpandSync "ExpandSync") (which is built on Methadone).

# Known Issues

* LoggerDelegator doesn't currently know what to do with `messenger.prompt`, so you'll have to manually log a `debug` message if you want that information logged.

# Bugs and Feature Requests

To view my current roadmap and objectives, check out the [Trello board](https://trello.com/b/qXs7Yeir/cliutils "CLIUtils on Trello").

To report bugs with or suggest features/changes for CLIUtils, please use the [Issues Page](http://github.com/bachya/cliutils/issues).

# Contributing

Contributions are welcome and encouraged. To contribute:

1. Fork it (http://github.com/bachya/cliutils/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# License

(The MIT License)

Copyright © 2014 Aaron Bach <bachya1208@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
