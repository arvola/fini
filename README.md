# Fini

Fini is a performance-optimized ini parser that supports strings, booleans, integers and floats.

## Syntax for ini files

* A section is marked with [section]
* Key-value pairs are separated by an equals sign, eg. "key = value"
* Quotations for strings are optional
* Lines beginning with ; are comments
* Literal "true" and "false" (without quotes) as the value will be converted to boolean
* A number without a period will be converted into an integer
* A number with one period will be converted into a float
* Keys can be any arbitrary string as long as it doesn't contain an equals sign, and are kept as strings

Sections can also have sub-sections by appending the sub-section's name to the section with a
period, eg: [section.subsection]

Subsections will be hashes in the section with the sub-section name as the key (symbol).

### Sample ini content

A basic ini might look like this:

```ini
[section]
string = some text
boolean = true
number = 1

[section.subsection]
key = value
```

## Installation

Add this line to your application's Gemfile:

    gem 'fini'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fini

## Usage

The quickest way to use Fini is to invoke the module method `parse`:

```ruby
require 'fini'

data = Fini.parse(ini)
```

The `data` variable will now contain an `IniObject` where each section is a method. If using the sample ini from
above, you might access data like this:

```ruby
data.section 'string'
# => "some text"

# Array notation works as well
data.section['string']
# => "some text"
```

You can also supply a default value as a second argument, which is `nil` by default:

```ruby
data.section 'does not exist', 'none'
# => "none"

data.section 'does not exist'
# => nil
```

### Subsections

Fini also supports subsections. Here's an ini file with a use case:

```ini
[server.testing]
database = foo
user = fooman
password = foopass

[server.staging]
database = stagefoo
user = foomanstage
password = foopassstage
```

Subsections are added as symbol keys to the section, and are just basic hashes from there on:

```ruby
data.server[:testing]
# => {'database' => 'foo', 'user' => 'fooman', 'password' => 'foopass'}

data.server[:testing]['database']
# => "foo"
```

### Instance usage

If an instance object is needed, Fini has `Fini::Ini` with the methods `parse` and `load`. `load` is a
convenience method for loading an ini file instead of a string.

```ruby
require 'fini'

parser = Fini::Ini.new
data = parser.parse(ini)

data2 = parser.load('path/to/ini.ini')
```

## Planned features

* An option to convert all keys to symbols
* Support for escape characters in quoted strings
* Support for symbol values

## License
[MIT license](http://www.opensource.org/licenses/MIT).