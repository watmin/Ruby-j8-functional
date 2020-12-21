# J8::Streams

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/j8/functional`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'j8-functional'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install j8-functional

## Usage

This project is partially complete, tests are half written and docs aren't written yet.

Needs to be filled in. Demos

```ruby
def demo(values)
  values
    &.j8_stream
    &.map { |o| o + 5 }
    &.filter { |o| o % 3 == 0 }
    &.to_a
end

[18] pry(main)> demo([6,54,3,1,3,5,6,90,85])
=> [6, 90]
[19] pry(main)>

class Mod3Predicate < J8::Predicate
  def initialize; end

  def test(o)
    o % 3 == 0
  end
end

def demo2(values)
  values
    &.j8_stream
    &.map { |o| o + 5 }
    &.filter(Mod3Predicate.new)
    &.to_a
end

[19] pry(main)> demo2([6,54,3,1,3,5,6,90,85])
=> [6, 90]
[20] pry(main)>

class ModPredicate < J8::Predicate
  def initialize(mod)
    @mod = mod
  end

  def test(o)
    o % @mod == 0
  end
end

def demo3(values)
  values
    &.j8_stream
    &.map { |o| o + 5 }
    &.filter(ModPredicate.new(3))
    &.to_a
end

[20] pry(main)> demo3([6,54,3,1,3,5,6,90,85])
=> [6, 90]
[21] pry(main)>

class Add5Function < J8::Function
  def initialize; end

  def apply(o)
    o + 5
  end
end

def demo4(values)
  values
    &.j8_stream
    &.map(Add5Function.new)
    &.filter(ModPredicate.new(3))
    &.to_a
end

[21] pry(main)> demo4([6,54,3,1,3,5,6,90,85])
=> [6, 90]
[22] pry(main)>

class AddFunction < J8::Function
  def initialize(amount)
    @amount = amount
  end

  def apply(o)
    o + @amount
  end
end

def demo5(values)
  values
    &.j8_stream
    &.map(AddFunction.new(5))
    &.filter(ModPredicate.new(3))
    &.to_a
end

[22] pry(main)> demo5([6,54,3,1,3,5,6,90,85])
=> [6, 90]
[23] pry(main)>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/watmin/Ruby-j8-functional. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/j8-functional/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the J8::Functional project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/j8-functional/blob/master/CODE_OF_CONDUCT.md).
