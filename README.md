# Styler

A tool for styling html by composing css utility classes, like Tachyons.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "styler", github: "bhserna/styler"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install styler

## Usage

### Define styles

You can declare styles with a name and an already defined css class, for example if you define a `style`
named `btn`, like this...

```ruby
styles = Styler.new do
  style :btn, ["white", "bg_blue"]
end
```

That will build and `styles` object where you can call `btn` on it...

```ruby
styles.btn.to_s # => "white bg_blue"
```

You would be able to use it like this in your erb files...

```erb
<button class="<%= styles.btn %>">My button</button>
```

or in haml...

```haml
%button{class: styles.btn} My button
```

To output...

```html
<button class="white bg_blue">My button</button>
```

### Compose styles

You can define many of this styles and compose them...

```ruby
styles = Styler.new do
  style :btn, ["padding3", "margin3"]
  style :blue_btn, [btn, "white", "bg_blue"]
end
```

```haml
%button{class: styles.btn} My button
%button{class: styles.blue_btn} My button
```

And the output would be...

```html
<button class="padding3 margin3">My button</button>
<button class="padding3 margin3 white bg_blue">My button</button>
```

### Substract styles

By composing your styles you can also substract classes from previous styles, like this...

```ruby
styles = Styler.new do
  style :default, ["pa3", "white", "bg_blue"]
  style :danger, [default - "bg_blue", "bg_red"]
end

styles.default.to_s # => "pa3 white bg_blue"
styles.danger.to_s # => "pa3 white bg_red"
```

### Passing arguments to styles

You can also define styles that expect an argument, to help you decide which styles to display, like this...

```ruby
styles = Styler.new do
  style :default_color do |project|
    if project[:color] == "blue"
      ["bg_blue"]
    else
      ["bg_red"]
    end
  end
end

project = { color: "blue" }
styles.default_color(project).to_s # => "bg_blue"
```

And you can use this styles to build other styles, like this...

```ruby
project = { color: "blue" }

styles = Styler.new do
  style :default_color do |project|
    if project[:color] == "blue"
      ["bg_blue"]
    else
      ["bg_red"]
    end
  end

  style :title, [default_color(project), "pa3"]
end

styles.title(project).to_s # => "bg_blue pa3"
```

Or like this...

```ruby
styles = Styler.new do
  style :default_color do |project|
    if project[:color] == "blue"
      ["bg_blue"]
    else
      ["bg_red"]
    end
  end

  style :title do |project|
    [default_color(project), "pa3"]
  end
end

project = { color: "blue" }
styles.title(project).to_s # => "bg_blue pa3"
```

### Define collections

You can define collections as "namespaces" for your styles...

```ruby
styles = Styler.new do
  collection :buttons do
    style :default, ["pa3", "blue"]
    style :danger, [default - "blue", "red"]
  end
end

styles.respond_to?(:default) # => false
styles.respond_to?(:danger) # => false
styles.buttons.default.to_s # => "pa3 blue"
styles.buttons.danger.to_s # => "pa3 red"
```

### Nested collections

You can define nested collections to build complete themes...

```ruby
styles = Styler.new do
  collection :v1 do
    collection :buttons do
      style :default, ["pa3", "blue"]
    end
  end

  collection :v2 do
    collection :buttons do
      style :default, ["pa3", "red"]
    end
  end
end

styles.v1.buttons.default.to_s # => "pa3 blue"
styles.v2.buttons.default.to_s # => "pa3 red"
```

### Define collection with arguments

Like with the styles, you can define collections that require arguments, like this..

```ruby
styles = Styler.new do
  collection :buttons do |project|
    if project[:color] == "blue"
      style :default, ["pa3", "blue"]
    else
      style :default, ["pa3", "red"]
    end
  end
end

project = { color: "blue" }
styles.buttons(project).default.to_s # => "pa3 blue"
```

### Select a collection with an alias

```ruby
styles = Styler.new do
  collection :v1 do
    collection :buttons do
      style :default, ["pa3", "blue"]
    end
  end

  collection :v2 do
    collection :buttons do
      style :default, ["pa3", "red"]
    end
  end

  collection_alias :theme, v1
end

styles.theme.buttons.default.to_s # => "pa3 blue"
```

### Collection alias with a block

```ruby
styles = Styler.new do
  collection :v1 do
    collection :buttons do
      style :default, ["pa3", "blue"]
    end
  end

  collection :v2 do
    collection :buttons do
      style :default, ["pa3", "red"]
    end
  end

  collection_alias :theme do |current_version|
    if current_version == "v1"
      v1
    else
      v2
    end
  end
end

styles.theme("v1").buttons.default.to_s # => "pa3 blue"
styles.theme("v2").buttons.default.to_s # => "pa3 red"
```

### Select a collection from other styler

```ruby
v1 = Styler.new do
  collection :buttons do
    style :default, ["pa3", "blue"]
  end
end

v2 = Styler.new do
  collection :buttons do
    style :default, ["pa3", "red"]
  end
end

subject = Styler.new do
  collection_alias :theme do |current_version|
    if current_version == "v1"
      v1
    else
      v2
    end
  end
end

styler.theme("v1").buttons.default.to_s # => "pa3 blue"
styler.theme("v2").buttons.default.to_s # => "pa3 red"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bhserna/styler.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
