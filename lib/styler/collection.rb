class Styler::Collection < SimpleDelegator
  attr_reader :name, :style_names, :collection_names

  def initialize(parent = nil, name = :default)
    super(parent) if parent
    @name = name
    @style_names = []
    @collection_names = []
  end

  def ==(other)
    self.class == other.class && name == other.name
  end

  def style(name, styles = nil, &block)
    @style_names << name

    define_singleton_method(name) do |*args|
      styles ||= block.call(*args)
      Styler::Style.new(self, name, styles)
    end
  end

  def collection(name, &block)
    @collection_names << name

    define_singleton_method(name) do |*args|
      self.class.new(self, name).tap do |c|
        c.instance_exec(*args, &block)
      end
    end
  end

  def collection_alias(name, collection = nil, &block)
    @collection_names << name

    define_singleton_method(name) do |*args|
      if collection
        collection
      else
        instance_exec(*args, &block)
      end
    end
  end

  def copy_styles_from(collection:)
    collection.styles.each do |style|
      style(style.name, style.to_a)
    end
  end

  def repeted_styles
    nested_styles
      .group_by(&:to_a)
      .select { |_, styles| styles.count > 1 }
      .to_h
      .values
  end

  def styles
    style_names.map { |name| send(name) }
  end

  def collections
    collection_names.map { |name| send(name) }
  end

  def nested_styles
    styles + nested_collections.flat_map(&:styles)
  end

  def nested_collections
    if collections.empty?
      []
    else
      collections + collections.flat_map(&:nested_collections)
    end
  end
end
