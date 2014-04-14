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

# Can I use it with...?

I often get asked how nicely CLIUtils plays with other Ruby-based CLI libraries (like Dave Copeland's excellent [Methadone](https://github.com/davetron5000/methadone "Methadone") and [GLI](https://github.com/davetron5000/gli "GLI")). Answer: they play very nicely. I use CLIUtils in [Sifttter Redux](https://github.com/bachya/Sifttter-Redux "Sifttter Redux") (which is built on GLI) and [ExpandSync](https://github.com/bachya/ExpandSync "ExpandSync") (which is built on Methadone).

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

```rub
require 'cliutils'
```

If you want to mix in everything that CLIUtils has to offer:

```Ruby
include CLIUtils
```

Alternatively, as described below, mix in only the libraries that you want.

Note that although this README.md is extensive, it may not cover all methods. Check out the [YARD documentation](http://rubydoc.info/github/bachya/cliutils/master/frames) and the [tests](https://github.com/bachya/cliutils/tree/master/test) to see more examples.

# Libraries

CLIUtils offers:

* [PrettyIO](#prettyio): nicer-looking CLI messages
* [Messaging](#messaging): a system to display nicely-formatted messages to one or more tagets
* [Configuration](#configuration): a app configuration manager
* [Prefs](#prefs): a preferences prompter and manager

# PrettyIO

First stop on our journey is better client IO via `PrettyIO`. To activate, simply mix into your project:

```ruby
include CLIUtils::PrettyIO
```

## Colored Strings

To start, `PrettyIO` affords you colorized strings:

```ruby
puts 'A sample string'.red
```
![alt text](https://raw.githubusercontent.com/bachya/cliutils/master/res/readme-images/prettyio-red-text.png "Colored Text via PrettyIO")

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
![alt text](https://raw.githubusercontent.com/bachya/cliutils/master/res/readme-images/prettyio-gnarly-text.png "Complex Colored Text via PrettyIO")

Naturally, memorizing the ANSI color scheme is a pain, so `PrettyIO` gives you a convenient method to look up these color combinations:

```ruby
color_chart
```
![alt text](https://raw.githubusercontent.com/bachya/cliutils/master/res/readme-images/prettyio-color-chart.png "PrettyIO Color Chart")

# Messaging

Throughout the life of your application, you will most likely want to send several messages to your user (warnings, errors, info, etc.). `Messaging` makes this a snap. It, too, is a mixin:

```ruby
include CLIUtils::Messaging
```

Once mixed in, you get access to `messenger`, a type of Logger that uses `PrettyIO` to send nicely-formatted messages to your user. For example, if you'd like to warn your user:

```ruby
messenger.warn('Hey pal, you need to be careful.')
```
![alt text](https://raw.githubusercontent.com/bachya/cliutils/master/res/readme-images/messenger-warn.png "A Warning from Messenger")

## Messaging Methods

`messenger` gives you access to several basic "read-only" methods:

* `messenger.error`: used to show a formatted-red error message.
* `messenger.info`: used to show a formatted-blue infomational message.
* `messenger.section`: used to show a formatted-purple sectional message.
* `messenger.success`: used to show a formatted-green success message.
* `messenger.warn`: used to show a formatted-yellow warning message.

Let's see an example that uses them all:

```Ruby
messenger.section('STARTING ATTACK RUN...')
messenger.info('Beginning strafing run...')
messenger.warn('WARNING: Tie Fighters approaching!')
messenger.error('Porkins died :(')
messenger.success('But Luke still blew up the Death Star!')
```
![alt text](https://raw.githubusercontent.com/bachya/cliutils/master/res/readme-images/messenger-types-1.png "Basic Messenger Types")

`messenger` also includes two "block" methods that allow you to wrap program execution in messages that are "longer-term".

```Ruby
# Outputs 'Starting up...', runs the code in
# `# do stuff here`, and once complete,
# outputs 'Done!' on the same line.
messenger.info_block('Starting up...', 'Done!', multiline = false) {
  # ...do stuff here...
}

# Outputs 'MY SECTION' and then runs
# the code in `# do stuff here` before
# proceeding.
section_block('MY SECTION', multiline = true) {
  # ...do stuff here...
}
```

## Message Wrapping

`PrettyIO` also gives `messenger` the ability to wrap your messages so that they don't span off into infinity. You can even control what the wrap limit (in characters) is:

```Ruby
long_string = 'This is a really long message, okay? ' \
'It should wrap at some point. Seriously. Wrapping is nice.'

CLIUtils::PrettyIO.wrap_char_limit = 50
messenger.info(long_string)
puts ''
CLIUtils::PrettyIO.wrap_char_limit = 20
messenger.info(long_string)
puts ''
CLIUtils::PrettyIO.wrap = false
messenger.info(long_string)
```
![alt text](https://raw.githubusercontent.com/bachya/cliutils/master/res/readme-images/wrapping.png "Text Wrapping")

## Prompting

`messenger` also carries a convenient method to prompt your users to give input (including an optional default). It makes use of `readline`, so you can do cool things like text expansion of paths.

```Ruby
p = messenger.prompt('Are you a fan of Battlestar Galactica?', default = 'Y')
messenger.info("You answered: #{ p }")
```
![alt text](https://raw.githubusercontent.com/bachya/cliutils/master/res/readme-images/prompting.png "Prompting")

When you pass a default to `messaging.prompt`, hitting `Enter` (i.e., leaving the prompt blank) will return the value of the default.

## Logging

Often, it's desirable to log messages as they appear to your user. `Messaging` makes this a breeze by allowing you to attach and detach Logger instances at will.

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

![alt text](https://raw.githubusercontent.com/bachya/cliutils/master/res/readme-images/multi-logger.png "Multi-logging")

...and in `file.txt`:

```
W, [2014-03-29T15:14:34.844406 #4497]  WARN -- : This warning should appear in STDOUT and file.txt
E, [2014-03-29T15:14:34.844553 #4497] ERROR -- : This error should appear in STDOUT and file.txt
D, [2014-03-29T15:14:34.844609 #4497] DEBUG -- : This debug message should only appear in file.txt
```

Since you are attaching Logger objects, each can have it's own format and severity level. Cool!

# Configuration

CLIUtils offers a `Configurator` class and a `Configuration` module (which provides access to a shared instance of `Configurator`) that make managing a user's configuration parameters easy. Although the examples in this README use that shared instance, you should note that you can always use your own `Configurator`.

To use, mix it in!

```Ruby
include CLIUtils::Configuration
```

## Loading a Configuration File

```Ruby
load_configuration('~/.my-app-config')
```

If there's data in there, it will be consumed into the `Configurator`'s `data` property.

## Adding/Removing Sections

Sections are top levels of the configuration file and are managed via the `Configurator` object:

```Ruby
configuration.add_section(:app_data)
configuration.add_section(:user_data)
configuration.add_section(:program_data)
configuration.delete_section(:program_data)
```

## Adding Data to Sections

There are two ways data can be managed in the `Configurator`: via its `@data` property or via some magic methods; your call:

```Ruby
configuration.data[:user_data].merge!({ username: 'bob', age: 45 })
# OR
configuration.user_data.merge!({ username: 'bob', age: 45 })
```

## Saving to a File

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
  age: 45
```

## Checking Configuration Versions

Often, you'll want to check the user's current version of your app against the last version that required some sort of configuration change; moreover, you'll want to run some "re-configuration" steps if the user's version is older than the last version that required a configuration update.

The `Configurator` allows for this via its `compare_version` method.

Assume you have a config file that looks like this:

```YAML
---
app_data:
  # The current version of the app
  APP_VERSION: 0.8.8

  # ...other keys...
```

...and that, somewhere in your app, you store a constant that contains the config version that requires a re-configuration:

```Ruby
LATEST_CONFIG_VERSION = 0.9.5
```

...this will initiate a version check (and give you the option to do something with that information):

```Ruby
# Store the current version of your app in a
# property of the Configurator.
configuration.current_version = configuration.app_data['APP_VERSION']

# Store the last version of your app that required
# a re-configuration in a property of the Configurator.
configuration.last_version = LATEST_CONFIG_VERSION

# Run the check. If the current version is older than
# the "last" version, use a block to tell the Configurator
# what to do.
configuration.compare_version do |c, l|
  puts "We need to update from #{c} to #{l}..."
  # ...do stuff...
end
```

Two items to note:

1. If the `current_version` parameter is `nil`, the Configurator will assume that it the app needs to be updated when `compare_version` is run.
2. Note that if the current version is *later* than the last version that required re-configuration, the whole block is skipped over (allowing your app to get on with its day).

# Prefs

Many times, CLI apps need to ask their users some questions, collect the feedback, validate it, and store it. CLIUtils makes this a breeze via the `Prefs` class.

## Basic Schema

`Prefs` can load preferences information from either a YAML file (via a filepath) or from an Array of preferences. In either case, the schema is the same; each prompt includes the following:

* `prompt_text` (**required**): the string to prompt your user with
* `default` (*optional*): an optional default to offer
* `config_key` (**required**): the Configurator key that this preference will use
* `config_section` (**required**): the Configurator section that this preference applies to

Here's an example YAML preferences file.

```YAML
prompts:
  - prompt_text: What is your name?
    default: Bob Cobb
    config_key: name
    config_section: personal_info
  - prompt_text: What is your age?
    default: 45
    config_key: age
    config_section: personal_info
  - prompt_text: Batman or Superman?
    default: Batman
    config_key: superhero
    config_section: personal_info
```

Assuming the above, `Prefs` is instantiated like so:

```Ruby
prefs = CLIUtils::Prefs.new('path/to/yaml/file')
```

`Prefs` can also be instantiated via a Hash or an Array of prompts; the overall schema remains the same:

```Ruby
# Instantiation through a Hash
h = {
  prompts: [
    {
      prompt_text: 'What is your name?',
      default: 'Bob Cobb',
      config_key: :name,
      config_section: :personal_info
    },
    {
      prompt_text: 'What is your age?',
      default: '45',
      config_key: :age,
      config_section: :personal_info
    },
    {
      prompt_text: 'Batman or Superman?',
      default: 'Batman',
      config_key: :superhero,
      config_section: :personal_info
    }
  ]
}

prefs = CLIUtils::Prefs.new(h)
```
```Ruby
# Instantiation through an Array
a = [
  {
    prompt_text: 'What is your name?',
    default: 'Bob Cobb',
    config_key: :name,
    config_section: :personal_info
  },
  {
    prompt_text: 'What is your age?',
    default: '45',
    config_key: :age,
    config_section: :personal_info
  },
  {
    prompt_text: 'Batman or Superman?',
    default: 'Batman',
    config_key: :superhero,
    config_section: :personal_info
  }
]

prefs = CLIUtils::Prefs.new(a)
```

## Prompting the User

With valid preferences loaded, simply use `ask` to begin prompting your user:

```Ruby
prefs.ask
```
![alt text](https://raw.githubusercontent.com/bachya/cliutils/master/res/readme-images/prefs-ask.png "Prefs.ask")

## Prerequisites

Sometimes, you need to answer certain prompts before others become relevant. `Prefs` allows this via a `prereqs` key, which can contain multiple already-answered key/value pairs to check for. For instance, imagine we want to drill into a user's superhero preference a bit further; using our previously-used YAML prefs file:

```YAML
prompts:
  - prompt_text: Batman or Superman?
    default: Batman
    config_key: superhero
    config_section: personal_info
  - prompt_text: Do you feel smart for preferring Batman?
    default: Y
    config_key: batman_answer
    config_section: personal_info
    prereqs:
      - config_key: superhero
        config_value: Batman
  - prompt_text: Why do you prefer Superman?!
    default: No clue
    config_key: superman_answer
    config_section: personal_info
    prereqs:
      - config_key: superhero
        config_value: Superman
  - prompt_text: Why don't you have a clue?
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
![alt text](https://raw.githubusercontent.com/bachya/cliutils/master/res/readme-images/prefs-ask-prereqs.png "Prerequisities")

Be careful that you don't define any circular prerequisities (e.g., A requires B and B requires A). In that case, both preferences will be ignored by `Prefs.ask`.

## Options

What if you want to limit a preference to a certain set of options? Easy! Imagine we want to expand the previous example and force the user to choose either "Batman" or "Superman":

```YAML
prompts:
  - prompt_text: Batman or Superman?
    default: Batman
    config_key: superhero
    config_section: personal_info
    options: ['Batman', 'Superman']
  - prompt_text: Do you feel smart for preferring Batman?
    default: Y
    config_key: batman_answer
    config_section: personal_info
    prereqs:
      - config_key: superhero
        config_value: Batman
  - prompt_text: Why do you prefer Superman?!
    default: No clue
    config_key: superman_answer
    config_section: personal_info
    prereqs:
      - config_key: superhero
        config_value: Superman
  - prompt_text: Why don't you have a clue?
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
![alt text](https://raw.githubusercontent.com/bachya/cliutils/master/res/readme-images/prefs-ask-options.png "Options")

## Validators

"But," you say, "I want to ensure that my user gives answers that conform to certain specifications!" Not a problem, dear user: `Prefs` gives you Validators. Currently supported Validators are:

```YAML
validators:
  - alphabetic       # Must be made up of letters and spaces
  - alphanumeric     # Must be made up of letters, numbers, and spaces
  - date             # Must be a parsable date (e.g., 2014-04-03)
  - datetime         # Must be a parsable datetime (e.g., 2014-04-03 9:34am)
  - non_nil          # Must be a non-nil value
  - number           # Must be made up of numbers
  - filepath_exists  # Must be a local filepath that exists (e.g., `/tmp/`)
  - time             # Must be a parsable time (e.g., 12:45pm or 21:08)
  - url              # Must be a fully-qualified URL
```

An example:

```YAML
prompts:
  - prompt_text: What is your name?
    config_key: name
    config_section: personal_info
    validators:
      - alphabetic
  - prompt_text: How old are you?
    config_key: age
    config_section: personal_info
    validators:
      - number
```

```Ruby
prefs.ask
```
![alt text](https://raw.githubusercontent.com/bachya/cliutils/master/res/readme-images/prefs-ask-validators.png "Validators")

Note that validators are evaluated in order, from top to bottom. If any validator fails, `messenger` will display an error and prompt the user to try again.

## Behaviors

Finally, a common desire might be to modify the user's answer in some way before storing it. `Prefs` accomplishes this via Behaviors. Currently supported Behaviors are:

```YAML
validators:
  - capitalize      # Turns "answer" into "Answer"
  - expand_filepath # Runs File.expand_path on the answer
  - lowercase       # Turns "AnSwEr" into "answer"
  - prefix: 'test ' # Prepends 'test ' to the answer
  - suffix: 'test ' # Appends 'test ' to the answer
  - titlecase       # Turns "the answer" into "The Answer"
  - uppercase       # Turns "answer" to "ANSWER"
```

An example:

```YAML
prompts:
  - prompt_text: What is your favorite food?
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
![alt text](https://raw.githubusercontent.com/bachya/cliutils/master/res/readme-images/prefs-ask-behaviors.png "Behaviors")

Note that behaviors are executed in order, which might give you different results than you're expecting. Using the YAML above, for example, placing the `uppercase` behavior last in the list will uppercase *the entire string* (including prefix and suffix).

## Pre- and Post-Messages/Actions

`Prefs` allows you to define messages and "action" plugins that can be executed before and after the prompt is given.

For example, imagine that before delivering a prompt, we want to open the user's default browser (notfying the user first, of course) so that they can collect some information before coming back. Once the user puts that information into the prompt, we want to provide a close-out message. We can accomplish this by writing a set of pre- and post-messages/actions on the prompt.

### Defining the Schema

```YAML
prompts:
  - prompt_text: What is the top story on espn.com?
    config_key: top_story
    config_section: app_data
    pre:
      message: 'I will now open espn.com in your default browser.'
      action: open_url
      action_parameters:
        - url: http://www.espn.com
    post:
      message: 'Thanks for inputting!'
    validators:
      - non_nil
```

Both `pre` and `post` keys can contain up to 3 child keys:

* `message` (**required**): the message to display in the pre or post stage
* `action` (*optional*): the name of the action to execute in the pre or post stage
* `action_parameters` (*optional*): an array of key/value pairs to be used in the action

### Creating the Action

`Prefs` actions are simply Ruby classes. A simple `open_url` action might be look like this:

```Ruby
module CLIUtils
  class OpenUrlAction < PrefAction
    def run(parameters)
      `open #{ parameters[:url] }`
    end
  end
end
```

Several items to note:

1. The action class needs to be wrapped in the CLIUtils module.
2. The class name needs to be the camel-case version of the `action` key in the YAML.
3. The class name needs to end with "Action".
4. The class needs to inherit from the PrefAction class.
5. The class needs to implement one method: `method(parameters)`

### Testing

Let's run it!

```Ruby
prefs.ask
```
![alt text](https://raw.githubusercontent.com/bachya/cliutils/master/res/readme-images/actions-1.png "Pre-action")
![alt text](https://raw.githubusercontent.com/bachya/cliutils/master/res/readme-images/actions-2.png "Action")
![alt text](https://raw.githubusercontent.com/bachya/cliutils/master/res/readme-images/actions-3.png "Post-action")

## Adding Pref Responses to a Configurator

Once the user has answered all the preference prompts, you can fold those answers back into a Configurator using the `ingest` method:

```Ruby
# Ingest the Prefs answers into our
# Configurator.
configuration.ingest_prefs(prefs)

# Save it to the filesystem.
configuration.save
```

## Using Configurator Values as Defaults

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
