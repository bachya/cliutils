# 2.1.1 (2014-04-26)

* Fixed a bug in which older Ruby versions wouldn't load Pref assets correctly

# 2.1.0 (2014-04-20)

* Added ability to register/deregister Pref Actions
* Added ability to register/deregister Pref Behaviors
* Added ability to register/deregister Pref Validators
* Added same "Press enter to continue message" to both pre and post Pref behaviors
* Removed section_block from Messaging (because it was totally not useful)
* Several bugfixes
* Added new Prefs and Pref unit tests

# 2.0.2 (2014-04-16)

* Created backup method in Configurator
* Modified YARD documentation

# 2.0.1 (2014-04-16)

* Modified PrettyIO word wrapping to coerce to String first

# 2.0.0 (2014-04-15)

* Added plugin-based Actions
* Added plugin-based Behaviors
* Added plugin-based Validators
* Large refactorings
* Added Wiki
* Revised README.md

# 1.4.2 (2014-04-14)

* Fixed a bug where pre and post would try to run when not loaded

# 1.4.1 (2014-04-14)

* Added Pref reference to PrefAction

# 1.4.0 (2014-04-14)

* Added PrefAction

# 1.3.1 (2014-04-12)

* Modified version check to include missing current version

# 1.3.0 (2014-04-12)

* Revised Configurator version checking
* Added some documentation

# 1.2.9 (2014-04-09)

* Added time Pref validator
* Added datetime Pref validator
* Added filepath_exists Pref validator
* Pref Validator change: numeric => number
* Pref Behavior change: local_filepath => expand_filepath

# 1.2.8 (2014-04-08)

* Global name changes
* Some cleanup

# 1.2.7 (2014-04-08)

* Added more Behaviors

# 1.2.6 (2014-04-08)

* More documentation
* Small refactorings

# 1.2.5 (2014-04-07)

* Added Configurator version checking

# 1.2.4 (2014-04-06)

* Cleanup and refactoring

# 1.2.3 (2014-04-05)

* Fixed a bug in ingest_prefs
* Fixed a bug in pref prompting
* Fixed a bug with including a Configurator in prefs

# 1.2.2 (2014-04-03)

* Modified loading of configuration values
* Updated documentation

# 1.2.1 (2014-04-03)

* Updated documentation
* Added additional testing

# 1.2.0 (2014-04-03)

* Changed Requirements => Prerequisites in Prefs
* Added Validators to Prefs
* Added Behaviors to Prefs

# 1.1.0 (2014-04-01)

* Added notice of valid options in Prefs
* Added ability for Prefs to use defaults from Configuration values
* Increased default wrapping to 80 characters
* Fixed a bug in which Prefs would not convert answer keys to symbols

# 1.0.7 (2014-03-30)

* Modified Messaging targets to be a Hash for easier lookup/deletion

# 1.0.6 (2014-03-30)

* Added convenience logging constant to Configuration

# 1.0.5 (2014-03-30)

* Fixed a bug with Configuration singleton
* Fixed a bug with Messaging singleton

# 1.0.4 (2014-03-29)

* Fixed several bugs
* Fixed backwards compatibility with Ruby 1.9.2
* Added more YARDdoc
* Cleaned out old directories
* Updated gemspec to reflect new gem versions

# 1.0.3 (2014-03-29)

* Initial release of CLIUtils
