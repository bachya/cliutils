CLIUtils
====
[![Build Status](https://travis-ci.org/bachya/cliutils.png?branch=master)](https://travis-ci.org/bachya/cliutils)
[![Gem Version](https://badge.fury.io/rb/cliutils.png)](http://badge.fury.io/rb/cliutils)

CLIUtils is a library of functionality designed to alleviate common tasks and headaches when developing command-line (CLI) apps in Ruby.

# Why?

It's fairly simple:

1. I love developing Ruby-based CLI apps.
2. I found myself copy/pasting common code from one to another.
3. I decided to do something about it.

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

```ruby
require 'cliutils'
```

If you want to mix in everything that CLIUtils has to offer:

```Ruby
include CLIUtils
```

Alternatively, as described below, mix in only the libraries that you want.

Note that although this README.md is extensive, it may not cover all methods. Check out the [YARD documentation](http://rubydoc.info/github/bachya/cli-utils/master/frames) and the [tests](https://github.com/bachya/cli-utils/tree/master/test) to see more examples.

# Libraries

CLIUtils offers:

* [PrettyIO](#prettyio): nicer-looking CLI messages
* [Messenging](#messenging): a full-featured Logger
* [Configuration](#configuration): a app configuration manager
* [Prefs](#prefs): a preferences prompter and manager

## PrettyIO

First stop on our journey is better client IO. To activate, simply mix into your project:

```ruby
include CLIUtils::PrettyIO
```

PrettyIO affords you colorized strings:

```ruby
puts 'A sample string'.red
```
![alt text](https://raw.githubusercontent.com/bachya/cli-utils/master/res/readme-images/prettyio-red-text.png "Colored Text via PrettyIO")

PrettyIO gives you utility methods for the common ANSI color codes:

```ruby
String.blue
String.cyan
String.green
String.purple
String.red
String.white
String.yellow
```

You also get the `colorize` method, which allows you to define more complex color combinations. For example, to get some nice purple text on a gnarly green background:

```ruby
puts 'A sample string'.colorize('35;42')
```
![alt text](https://raw.githubusercontent.com/bachya/cli-utils/master/res/readme-images/prettyio-gnarly-text.png "Complex Colored Text via PrettyIO")

Naturally, memorizing the ANSI color scheme is a pain, so PrettyIO gives you a convenient method to look up these color combinations:

```ruby
color_chart
```
![alt text](https://raw.githubusercontent.com/bachya/cli-utils/master/res/readme-images/prettyio-color-chart.png "PrettyIO Color Chart")

## Messenging

Throughout the life of your application, you will most likely want to send several messages to your user (warnings, errors, info, etc.). Messenging makes this a snap. It, too, is a mixin:

```ruby
include CLIUtils::Messenging
```

Once mixed in, you get access to `messenger`, a type of Logger that uses PrettyIO to send nicely-formatted messages to your user. For example, if you'd like to warn your user:

```ruby
messenger.warn('Hey pal, you need to be careful.')
```
![alt text](https://raw.githubusercontent.com/bachya/cli-utils/master/res/readme-images/messenger-warn.png "A Warning from Messenger")

### Messenging Methods

`messenger` gives you access to several basic methods:

* `messenger.error`: used to show a formatted-red error message.
* `messenger.info`: used to show a formatted-blue infomational message.
* `messenger.section`: used to show a formatted-purple sectional message.
* `messenger.success`: used to show a formatted-green success message.
* `messenger.yellow`: used to show a formatted-yellow warning message.

Let's see an example that uses them all:

```Ruby
messenger.section('STARTING ATTACK RUN...')
messenger.info('Beginning strafing run...')
messenger.warn('WARNING: Tie Fighters approaching!')
messenger.error('Porkins died :(')
messenger.success('But Luke still blew up the Death Star!')
```
![alt text](https://raw.githubusercontent.com/bachya/cli-utils/master/res/readme-images/messenger-types-1.png "Basic Messenger Types")

`messenger` also includes two "block" methods that allow you to wrap program execution in messages that are "longer-term".

```Ruby
messenger.info_block('Starting up...', 'Done!', multiline = false) { # do stuff here }
```

`messenger` outputs 'Starting up...', runs the code in `# do stuff here`, and once complete, outputs 'Done!' on the same line. Note that `section_block` is the same exact signature (except for the method name, of course!).

### Message Wrapping

PrettyIO also gives `messenger` the ability to wrap your messages so that they don't span off into infinity. You can even control what the wrap limit (in characters) is:

```Ruby
CLIUtils::PrettyIO.wrap_char_limit = 50
messenger.info('This is a really long message, okay? It should wrap at some point. Seriously. Wrapping is nice.')
puts ''
CLIUtils::PrettyIO.wrap_char_limit = 20
messenger.info('This is a really long message, okay? It should wrap at some point. Seriously. Wrapping is nice.')
puts ''
CLIUtils::PrettyIO.wrap = false
messenger.info('This is a really long message, okay? It should wrap at some point. Seriously. Wrapping is nice.')
```
![alt text](https://raw.githubusercontent.com/bachya/cli-utils/master/res/readme-images/wrapping.png "Text Wrapping")

### Prompting

`messenger` also carries a convenient method to prompt your users to give input (including an optional default). It makes use of `readline`, so you can do cool things like text expansion of paths.

```Ruby
p = messenger.prompt('Are you a fan of Battlestar Galactica?', default = 'Y')
messenger.info("You answered: #{ p }")
```
![alt text](https://raw.githubusercontent.com/bachya/cli-utils/master/res/readme-images/prompting.png "Prompting")

### Logging

Often, it's desirable to log messages as they appear to your user. `messenging` makes this a breeze by allowing you to attach and detach Logger instances at will.

For instance, let's say you wanted to log a few messages to both your user's STDOUT and to `file.txt`:

```Ruby
file_logger = Logger.new('file.txt')

messenger.info('This should only appear in STDOUT.')

messenger.attach(file_logger)

messenger.warn('This warning should appear in STDOUT and file.txt')
messenger.error('This error should appear in STDOUT and file.txt')
messenger.debug('This debug message should only appear in file.txt')

messenger.detach(file_logger)

messenger.section('This section message should appear only in STDOUT')
```

In STDOUT:

![alt text](https://raw.githubusercontent.com/bachya/cli-utils/master/res/readme-images/multi-logger.png "Multi-logging")

...and in `file.txt`:

```
W, [2014-03-29T15:14:34.844406 #4497]  WARN -- : This warning should appear in STDOUT and file.txt
E, [2014-03-29T15:14:34.844553 #4497] ERROR -- : This error should appear in STDOUT and file.txt
D, [2014-03-29T15:14:34.844609 #4497] DEBUG -- : This debug message should only appear in file.txt
```

Since you can attach Logger objects, each can have it's own format and severity level. Cool!

## Configuration

CLIUtils offers two "things" -- a `Configurator` class and a `Configuration` module that provides access to a shared instance of `Configurator` -- that make managing a user's configuration parameters easy. Mix it in!

```Ruby
include CLIUtils::Configuration
```

### Loading a Configuration File

```Ruby
load_configuration('~/.my-app-config')
```

If there's data in there, it will be consumed into `configuration`'s `data` property.

### Adding/Removing Sections

Sections are top levels of the configuration file and are managed via the `configuration` object:

```Ruby
configuration.add_section(:user_data)
configuration.add_section(:program_data)
configuration.delete_section(:program_data)
```

### Adding Data to Sections

There are two ways data can be managed in `configuration`: via its `@data` property or via some magic methods; your call:

```Ruby
configuration.data[:user_data].merge!(username: 'bob')
# OR
configuration.user_data.merge!(username: 'bob')
```

### Saving to a File

When you're ready to save your configuration data to a YAML file:

```Ruby
configuration.save
```

Note that all your keys are converted to strings before saving (and, likewise, are converted to symbols, when loading). Assuming we used the commands above, we could expect this to be the contents of `~/.my-app-config`:

```YAML
---
user_data:
  username: bob
```

## Prefs

Many times, CLI apps need to ask their users some questions, collect the feedback, validate it, and store it. CLIUtils makes this a breeze via the `Prefs` class.

`Prefs` can load preferences information from either a YAML file (via a filepath) or from an array of preferences. In either case, the schema is the same; each prompt includes the following:

* prompt (**required**): the string to prompt your user with
* default (*optional*): an optional default to offer
* key (**required**): the key that refers to this preference
* section (**required**): the Configuration section that this preference applies to
* options (*optional*): an optional array of values; the user's choice must be in this array
* requirements (*optional*): an optional list of key/value pairs that must exist for this preference to be displayed

Here's an example YAML preferences file.

```YAML
prompts:
  - prompt: What is the hostname of your DD-WRT router?
    default: 192.168.1.1
    key: hostname
    section: ssh_info
  - prompt: What is the SSH username of your DD-WRT router?
    default: root
    key: username
    section: ssh_info
  - prompt: What SSH port does your DD-WRT router use?
    default: 22
    key: port
    section: ssh_info
  - prompt: Do you use password or key authentication?
    default: password
    key: auth_method
    section: ssh_info
    options: ['password', 'key']
  - prompt: Where is your key located?
    default: ~/.ssh
    key: key_location
    section: ssh_info
    requirements:
      - key: auth_method
        value: key
  - prompt: What is your password?
    key: password
    section: ssh_info
    requirements:
      - key: auth_method
        value: password
```

Assuming the above, `Prefs` is instantiated like so:

```Ruby
prefs = CLIUtils::Prefs.new('path/to/yaml/file')
```

With valid preferences loaded, simply use `ask` to begin prompting your user:

```Ruby
prefs.ask
```
![alt text](https://raw.githubusercontent.com/bachya/cli-utils/master/res/readme-images/prefs-ask.png "Prefs.ask")

Once the user has answered all the preference prompts, you can fold those answers back into a Configurator using the `ingest` method:

```Ruby
configuration.ingest(prefs)
configuration.save
```

### Why a Prefs Class?

I've written apps that need to request user input at various times for multiple different things; as such, I thought it'd be easier to have those scenarios chunked up. You can always wrap `Prefs` into a module singleton if you wish.

# Known Issues

* LoggerDelegator doesn't currently know what to do with `messenger.prompt`, so you'll have to manually log a `debug` message if you want that information logged.

# Bugs and Feature Requests

To report bugs with or suggest features/changes for CLIUtils, please use the [Issues Page](http://github.com/bachya/cli-utils/issues).

# Contributing

Contributions are welcome and encouraged. To contribute:

1. Fork it ( http://github.com/bachya/cliutils/fork )
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


