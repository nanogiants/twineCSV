# TwineCSV

[![Gem Version](https://badge.fury.io/rb/twineCSV.svg)](https://badge.fury.io/rb/twineCSV)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'twineCSV'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install twineCSV

## Usage

This micro gem converts twine formatted txt files to csv or xlsx and vice versa. The reason for this is that the localisation 
information is often provided by external services, which do not want to deal with restricted file formats but rather
want to work with Excel or similar programs. Thus this gem was created to create csv or xlsx files from your twine files. 
After you get your finalized csv or xlsx files back you can convert them to a txt file, with the proper twine formatting. 
To get more information about twine in general visit their [github page](https://github.com/mobiata/twine).

Support for xlsx files since version 1.1.0.

### Convert to csv

```
twineCSV tocsv localisation.txt converted.csv
```

### Convert to xlsx

```
twineCSV toxlsx localisation.txt converted.xlsx
```

You have to provide at least the input file. When omitting the output file the filename is created based on the inputs filename.

### Convert to twine file

```
twineCSV totwine converted.csv localisation.txt
```

```
twineCSV totwine converted.xlsx localisation.txt
```

You have to provide at least the input file. When omitting the output file the filename is created based on the inputs filename.

### Help

```
twineCSV help
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/appcom-interactive/twineCSV. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

