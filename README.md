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
* [Messenging](#messenging): a system to display nicely-formatted messages to one or more tagets
* [Configuration](#configuration): a app configuration manager
* [Prefs](#prefs): a preferences prompter and manager

## PrettyIO

First stop on our journey is better client IO via `PrettyIO`. To activate, simply mix into your project:

```ruby
include CLIUtils::PrettyIO
```

To start, `PrettyIO` affords you colorized strings:

```ruby
puts 'A sample string'.red
```
![alt text](https://raw.githubusercontent.com/bachya/cli-utils/master/res/readme-images/prettyio-red-text.png "Colored Text via PrettyIO")

You get a stable of utility methods for the common ANSI color codes:

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

Naturally, memorizing the ANSI color scheme is a pain, so `PrettyIO` gives you a convenient method to look up these color combinations:

```ruby
color_chart
```
![alt text](https://raw.githubusercontent.com/bachya/cli-utils/master/res/readme-images/prettyio-color-chart.png "PrettyIO Color Chart")

## Messenging

Throughout the life of your application, you will most likely want to send several messages to your user (warnings, errors, info, etc.). Messenging makes this a snap. It, too, is a mixin:

```ruby
include CLIUtils::Messenging
```

Once mixed in, you get access to `messenger`, a type of Logger that uses `PrettyIO` to send nicely-formatted messages to your user. For example, if you'd like to warn your user:

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

`PrettyIO` also gives `messenger` the ability to wrap your messages so that they don't span off into infinity. You can even control what the wrap limit (in characters) is:

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

When you pass a default to `messenging.prompt`, hitting `Enter` (i.e., leaving the prompt blank) will return the value of the default.

### Logging

Often, it's desirable to log messages as they appear to your user. `messenging` makes this a breeze by allowing you to attach and detach Logger instances at will.

For instance, let's say you wanted to log a few messages to both your user's STDOUT and to `file.txt`:

```Ruby
# By default, messenger only outputs to STDOUT.
messenger.info('This should only appear in STDOUT.')

# messenger.attach takes a Hash of string/symbol keys
# and Logger values (so you can refer to them later on).
messenger.attach(MY_FILE_LOGGER: Logger.new('file.txt'))

messenger.warn('This warning should appear in STDOUT and file.txt')
messenger.error('This error should appear in STDOUT and file.txt')
messenger.debug('This debug message should only appear in file.txt')

# messenger.detach takes the string/symbol key
# defined earlier.
messenger.detach(:MY_FILE_LOGGER)

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

CLIUtils offers a `Configurator` class and a `Configuration` module (which provides access to a shared instance of `Configurator`) that make managing a user's configuration parameters easy. Mix it in!

```Ruby
include CLIUtils::Configuration
```

### Loading a Configuration File

```Ruby
load_configuration('~/.my-app-config')
```

If there's data in there, it will be consumed into the `configurator`'s `data` property.

### Adding/Removing Sections

Sections are top levels of the configuration file and are managed via the `configurator` object:

```Ruby
configuration.add_section(:app_data)
configuration.add_section(:user_data)
configuration.add_section(:program_data)
configuration.delete_section(:program_data)
```

### Adding Data to Sections

There are two ways data can be managed in `configurator`: via its `@data` property or via some magic methods; your call:

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
app_data:
user_data:
  username: bob
```

### Checking Configuration Versions

Often, you'll want to check the user's current version of your app against the last version that required some sort of configuration change. `configurator` allows for this via its `compare_version` method.

Assume you have a config file that looks like this:

```YAML
---
app_data:
  # The current version of the app
  APP_VERSION: 1.0.0

  # The last version that required
  # a configuration change
  NEWEST_CONFIG_VERSION: 1.8.0

  # ...other keys...
```

...this will initiate a version check (and give you the option to do something with that information):

```Ruby
# Tell your configurator the name of the key that
# stores the app's version in its configuration file.
# NOTE that you don't have to specify the section.
configuration.cur_version_key = :APP_VERSION

# Tell your configurator the name of the key that
# stores the last version that needed a configuration
# change.
# NOTE that you don't have to specify the section.
configuration.last_version_key = :NEWEST_CONFIG_VERSION

# Run the check and use a block to get
# the current and "last-needing-changes"
# versions (and do something about it).
configuration.compare_version do |c, l|
  if c < l
    puts "You need to update your app; here's how:"
    # ...do stuff...
  else
    puts "No need to update your app's config file!"
  end
end
```

## Prefs

Many times, CLI apps need to ask their users some questions, collect the feedback, validate it, and store it. CLIUtils makes this a breeze via the `Prefs` class.

### Basic Schema

`Prefs` can load preferences information from either a YAML file (via a filepath) or from an array of preferences. In either case, the schema is the same; each prompt includes the following:

* `prompt` (**required**): the string to prompt your user with
* `default` (*optional*): an optional default to offer
* `config_key` (**required**): the Configurator key that this preference will use
* `config_section` (**required**): the Configurator section that this preference applies to

Here's an example YAML preferences file.

```YAML
prompts:
  - prompt: What is your name?
    default: Bob Cobb
    config_key: name
    config_section: personal_info
  - prompt: What is your age?
    default: 45
    config_key: age
    config_section: personal_info
  - prompt: Batman or Superman?
    default: Batman
    config_key: superhero
    config_section: personal_info
```

Assuming the above, `Prefs` is instantiated like so:

```Ruby
prefs = CLIUtils::Prefs.new('path/to/yaml/file')
```

`Prefs` can also be instantiated via a Hash or an array of prompts; the overall schema remains the same:

```Ruby
# Instantiation through a Hash
h = {
  prompts: [
    {
      prompt: 'What is your name?',
      default: 'Bob Cobb',
      config_key: :name,
      config_section: :personal_info
    },
    {
      prompt: 'What is your age?',
      default: '45',
      config_key: :age,
      config_section: :personal_info
    },
    {
      prompt: 'Batman or Superman?',
      default: 'Batman',
      config_key: :superhero,
      config_section: :personal_info
    }
  ]
}

prefs = CLIUtils::Prefs.new(h)

# Instantiation through an Array

a = [
  {
    prompt: 'What is your name?',
    default: 'Bob Cobb',
    config_key: :name,
    config_section: :personal_info
  },
  {
    prompt: 'What is your age?',
    default: '45',
    config_key: :age,
    config_section: :personal_info
  },
  {
    prompt: 'Batman or Superman?',
    default: 'Batman',
    config_key: :superhero,
    config_section: :personal_info
  }
]

prefs = CLIUtils::Prefs.new(a)
```

### Prompting the User

With valid preferences loaded, simply use `ask` to begin prompting your user:

```Ruby
prefs.ask
```
![alt text](https://raw.githubusercontent.com/bachya/cli-utils/master/res/readme-images/prefs-ask.png "Prefs.ask")

### Prerequisites

Sometimes, you need to answer certain prompts before others become relevant. `Prefs` allows this via a `prereqs` key, which can contain multiple already-answered key/value pairs to check for. For instance, imagine we want to drill into a user's superhero preference a bit further; using our previously-used YAML prefs file:

```YAML
prompts:
  - prompt: Batman or Superman?
    default: Batman
    config_key: superhero
    config_section: personal_info
  - prompt: Do you feel smart for preferring Batman?
    default: Y
    config_key: batman_answer
    config_section: personal_info
    prereqs:
      - config_key: superhero
        config_value: Batman
  - prompt: Why do you prefer Superman?!
    default: No clue
    config_key: superman_answer
    config_section: personal_info
    prereqs:
      - config_key: superhero
        config_value: Superman
  - prompt: Why don't you have a clue?
    config_key: no_clue
    config_section: personal_info
    prereqs:
      - config_key: superhero
        config_value: Superman
      - config_key: superman_answer
        config_value: No clue
```

`prereqs` checks for already-answered preferences (based on a Configurator key and value); assuming everything checks out, the subsequent preferences are collected:

```Ruby
prefs.ask
```
![alt text](https://raw.githubusercontent.com/bachya/cli-utils/master/res/readme-images/prefs-ask-prereqs.png "Prerequisities")

Be careful that you don't define any circular prerequisities (e.g., A requires B and B requires A). In that case, both preferences will be ignored by `Prefs.ask`.

### Options

What if you want to limit a preference to a certain set of options? Easy! Imagine we want to expand the previous example and force the user to choose either "Batman" or "Superman":

```YAML
prompts:
  - prompt: Batman or Superman?
    default: Batman
    config_key: superhero
    config_section: personal_info
    options: ['Batman', 'Superman']
  - prompt: Do you feel smart for preferring Batman?
    default: Y
    config_key: batman_answer
    config_section: personal_info
    prereqs:
      - config_key: superhero
        config_value: Batman
  - prompt: Why do you prefer Superman?!
    default: No clue
    config_key: superman_answer
    config_section: personal_info
    prereqs:
      - config_key: superhero
        config_value: Superman
  - prompt: Why don't you have a clue?
    config_key: no_clue
    config_section: personal_info
    prereqs:
      - config_key: superhero
        config_value: Superman
      - config_key: superman_answer
        config_value: No clue
```

Once in place:

```Ruby
prefs.ask
```
![alt text](https://raw.githubusercontent.com/bachya/cli-utils/master/res/readme-images/prefs-ask-options.png "Options")

### Validators

"But," you say, "I want to ensure that my user gives answers that conform to certain specifications!" Not a problem, dear user: `Prefs` gives you Validators. Currently supported Validators are:

```YAML
validators:
  - alphabetic   # Must be made up of letters and spaces
  - alphanumeric # Must be made up of letters, numbers, and spaces
  - date         # Must be a parsable date (e.g., 2014-04-03)
  - non_nil      # Must be a non-nil value
  - numeric      # Must be made up of numbers
  - url          # Must be a fully-qualified URL
```

An example:

```YAML
prompts:
  - prompt: What is your name?
    config_key: name
    config_section: personal_info
    validators:
      - alphabetic
  - prompt: How old are you?
    config_key: age
    config_section: personal_info
    validators:
      - numeric
```

```Ruby
prefs.ask
```
![alt text](https://raw.githubusercontent.com/bachya/cli-utils/master/res/readme-images/prefs-ask-validators.png "Validators")

Note that validators are evaluated in order, from top to bottom. If any validator fails, `messenger` will display an error and prompt the user to try again.

### Behaviors

Finally, a common desire might be to modify the user's answer in some way before storing it. `Prefs` accomplishes this via Behaviors. Currently supported Behaviors are:

```YAML
validators:
  - capitalize      # Turns "answer" into "Answer"
  - local_filepath  # Runs File.expand_path on the answer
  - lowercase       # Turns "AnSwEr" into "answer"
  - prefix: 'test ' # Prepends 'test ' to the answer
  - suffix: 'test ' # Appends 'test ' to the answer 
  - titlecase       # Turns "the answer" into "The Answer"
  - uppercase       # Turns "answer" to "ANSWER"
```

An example:

```YAML
prompts:
  - prompt: What is your favorite food?
    config_key: food
    config_section: personal_info
    validators:
      - non_nil
    behaviors:
      - uppercase
      - prefix: 'My favorite food: '
      - suffix: ' (soooo good!)'
```

```Ruby
prefs.ask
```
![alt text](https://raw.githubusercontent.com/bachya/cli-utils/master/res/readme-images/prefs-ask-behaviors.png "Behaviors")

Note that behaviors are executed in order, which might give you different results than you're expecting. In the example above, for example, placing the `uppercase` behavior last in the list will uppercase *the entire string* (including prefix and suffix).

### Adding Pref Responses to a Configurator

Once the user has answered all the preference prompts, you can fold those answers back into a Configurator using the `ingest` method:

```Ruby
# Ingest the Prefs answers into our
# Configurator.
configuration.ingest_prefs(prefs)

# Save it to the filesystem.
configuration.save
```

### Using Configurator Values as Defaults

Note that you can also initialize a `Prefs` object with a Configurator:

```Ruby
# Scans my_configurator for values to the
# questions posed by prefs; if found, use
# them as defaults.
prefs = CLIUtils::Prefs.new('path/to/yaml/file', my_configurator)
```

In this case, `Prefs` will look to see if any values already exist for a specific prompt; if so, that value will be used as the default, rather than the default specified in the YAML.

# Known Issues

* LoggerDelegator doesn't currently know what to do with `messenger.prompt`, so you'll have to manually log a `debug` message if you want that information logged.

# Bugs and Feature Requests

To view my current roadmap and objectives, check out the [Trello board](https://trello.com/b/qXs7Yeir/cliutils "CLIUtils on Trello").

To report bugs with or suggest features/changes for CLIUtils, please use the [Issues Page](http://github.com/bachya/cli-utils/issues).

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
