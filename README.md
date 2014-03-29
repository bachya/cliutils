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

    gem 'cliutils'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cliutils

# PrettyIO

First stop on our journey is better client IO. To activate, simply mix into your project:

```
include CLIUtils::PrettyIO
```

## Colorized Strings

The first feature that PrettyIO affords you is colorized strings:

```
puts 'A sample string'.red
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/cliutils/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
