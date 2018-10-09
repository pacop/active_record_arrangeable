# ActiveRecord::Arrangeable
![Build Status](https://travis-ci.org/pacop/active_record_arrangeable.svg?branch=master)

Friendly and easy sort

## Installation

Add this line to your application's Gemfile:

    gem 'active_record_arrangeable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_record_arrangeable

## Usage

#### Model

```ruby
class City < ActiveRecord::Base
  include ActiveRecord::Arrangeable

  has_many :provinces

  arrange_by :province_name, (lambda do |direction=:asc|
    includes(:provinces).order("provinces.name #{direction}")
  end)
end
class Province < ActiveRecord::Base
  belongs_to :city
end

City.create(name: 'city2', provinces: [Province.create(name: 'c3'),
                                       Province.create(name: 'd4')])
City.create(name: 'city1', provinces: [Province.create(name: 'a1'),
                                       Province.create(name: 'b2')])
City.create(name: 'city3', provinces: [Province.create(name: 'a1'),
                                       Province.create(name: 'b2')])

City.arrange(:province_name) => [city1, city3, city2]
City.arrange(province_name: :desc) => [city2, city1, city3]
City.arrange(:province_name, :name) => [city1, city3, city2]
City.arrange(:province_name, name: :desc) => [city3, city1, city2]
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/active_record_arrange/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
