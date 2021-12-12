# Styler

A tool for styling html by composing css utility classes, like Tachyons.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "ruby_styler"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ruby_styler

## Usage

### Define styles

You can declare styles with a name and an already defined css class, for example you define a `style`
named `btn`, like this...

```ruby
styles = Styler.new do
  style :btn, ["white", "bg_blue"]
end
```

This will build a `styles` object, which you can then call `btn` on...

```ruby
styles.btn.to_s # => "white bg_blue"
```

You would be able to use it like this in your erb files...

```erb
<button class="<%= styles.btn %>">My button</button>
```

Likewise in haml...

```haml
%button{class: styles.btn} My button
```

Which would output in HTML...

```html
<button class="white bg_blue">My button</button>
```

### Compose styles

You can define many of these styles and compose them...

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

This would output to HTML as...

```html
<button class="padding3 margin3">My button</button>
<button class="padding3 margin3 white bg_blue">My button</button>
```

### Subtract styles

By composing styles, classes can be subtracted from ones previously declared. Below, `bg_blue` is removed from `:default`, and `bg_red` is added, creating `:danger`...

```ruby
styles = Styler.new do
  style :default, ["pa3", "white", "bg_blue"]
  style :danger, [default - "bg_blue", "bg_red"]
end

styles.default.to_s # => "pa3 white bg_blue"
styles.danger.to_s # => "pa3 white bg_red"
```

### Passing arguments to styles

You can also define styles that expect an argument, which will determine the styles to render...

```ruby
styles = Styler.new do
  style :default_color do |project|
    if project[:color] == "blue"
      ["bg_blue", "border_blue", "text_blue"]
    else
      ["bg_white", "border_black", "text_black"]
    end
  end
end

project = { color: "blue" }
styles.default_color(project).to_s # => "bg_blue border_blue text_blue"
```

Styles can be used as a template to build other styles...

```ruby
project = { color: "blue" }

styles = Styler.new do
  style :default_color do |project|
    if project[:color] == "blue"
      ["bg_blue"]
    else
      ["bg_white"]
    end
  end

  style :title, [default_color(project), "pa3"]
end

styles.title(project).to_s # => "bg_blue pa3"
```

Or as a block...

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

Collections can be used as "namespaces" for styles...

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

Nested collections allow the creation of complete themes...

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

### Collections with arguments

Similar to styles, collections can also require arguments...

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
  collection :dark do
    collection :buttons do
      style :default, ["bg_black", "border_gray", "text_white"]
    end
  end

  collection :light do
    collection :buttons do
      style :default, ["bg_white", "border_black", "text_black"]
    end
  end

  collection_alias :theme do |current_version|
    if current_version == "dark"
      dark
    else
      light
    end
  end
end

styles.theme("dark").buttons.default.to_s # => "bg_black border_gray text_white"
styles.theme("light").buttons.default.to_s # => "bg_white border_black text_black"
```

### Select a collection from other styler

```ruby
dark = Styler.new do
  collection :buttons do
    style :default, ["bg_black", "border_gray", "text_white"]
  end
end

light = Styler.new do
  collection :buttons do
    style :default, ["bg_white", "border_black", "text_black"]
  end
end

styles = Styler.new do
  collection_alias :theme do |current_version|
    if current_version == "dark"
      dark
    else
      light
    end
  end
end

styles.theme("dark").buttons.default.to_s # => "bg_black border_gray text_white"
styles.theme("light").buttons.default.to_s # => "bg_white border_black text_black"
```

### Copy styles from collection

Styles from an existing collection can be copied then overidden and modified.

```ruby
styles = Styler.new do
  collection :v1 do
    collection :buttons do
      style :default, ["pa3", "blue"]
      style :danger, [default - "blue", "red"]
    end
  end

  collection :v2 do
    collection :buttons do
      copy_styles_from collection: v1.buttons
      style :danger, [v1.buttons.danger - "red", "orange"]
    end
  end
end

expect(styles.v2.buttons.default.to_s).to eq "pa3 blue"
expect(styles.v2.buttons.danger.to_s).to eq "pa3 orange"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt for experimentation.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bhserna/styler.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
