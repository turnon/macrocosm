# Macrocosm

Graph = iView + Echarts

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'macrocosm'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install macrocosm

## Usage

```
s = Macrocosm.new(curveness: 0.1)

s.add_node('p1', 'category E')
s.add_node('p2', 'category D')
s.add_node('p3', 'category F')
s.add_node('p4', 'category F')
s.add_node('p5', 'category G')
s.add_node('p6', 'category G')
s.add_node('p7', 'category G')

s.add_link('p1', 'p2')
s.add_link('p1', 'p3')
s.add_link('p2', 'p3', relation_in_list: 'has_one', relation_in_graph: '1 -> 1')
s.add_link('p4', 'p5')
s.add_link('p5', 'p6')
s.add_link('p6', 'p7')
s.add_link('p5', 'p7')

File.open(path, 'w'){ |f| f.puts s.to_s }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/turnon/macrocosm. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Macrocosm project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/turnon/macrocosm/blob/master/CODE_OF_CONDUCT.md).
