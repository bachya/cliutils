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

### Colorized Strings

The first feature that PrettyIO affords you is colorized strings:

```ruby
puts 'A sample string'.red
```
![alt text](https://github.com/bachya/cli-utils/blob/master/res/readme-images/prettyio-red-text.png "Colored Text via PrettyIO")

# Contributing

1. Fork it ( http://github.com/bachya/cliutils/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
