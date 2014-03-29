CLIUtils
====

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

Throughout the life of your application, you will most likely want to give several messages to your user (warnings, errors, info, etc.). Messenging makes this a snap. It, too, is a mixin:

```ruby
include CLIManager::Messenging
```

Once mixed in, you get access to `messenger`, a type of Logger that manages messages to your user. For example, if you'd like to warn your user:

```ruby
messenger.warn('Hey pal, you need to be careful.')
```
![alt text](https://raw.githubusercontent.com/bachya/cli-utils/master/res/readme-images/messenger-warn.png "A Warning from Messenger")

# Contributing

1. Fork it ( http://github.com/bachya/cliutils/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
