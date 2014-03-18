# AVETMISS Validations

[![Build Status](https://travis-ci.org/jobready/avetmiss_validations.png?branch=develop)](https://travis-ci.org/jobready/avetmiss_validations)
[![Code Climate](https://codeclimate.com/repos/5327c267e30ba02d8800120e/badges/ae467a0bb02c1a157a99/gpa.png)](https://codeclimate.com/repos/5327c267e30ba02d8800120e/feed)

This gem supports the parsing and exporting of AVETMISS (http://www.ncver.edu.au/) data.

AVETMISS stands for the Australian Vocational Education and Training Management Information Statistical Standard. It is a national data standard that ensures consistent and accurate capture and reporting of VET information about students.

## Installation

Add this line to your application's Gemfile:

    gem 'avetmiss_data'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install avetmiss_data

## Usage

    package = Avetmiss::Package.new('package.zip')

## Contributing

1. Fork it ( http://github.com/jobready/avetmiss_data/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

