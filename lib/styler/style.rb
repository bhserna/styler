require_relative "style_substraction"

class Styler::Style
  attr_reader :collection, :name, :styles

  def initialize(collection, name, styles = [])
    @collection = collection
    @name = name
    @styles = styles
  end

  def ==(other)
    self.class == other.class &&
      name == other.name &&
      to_a == other.to_a
  end

  def -(other)
    Styler::StyleSubstraction.new(self, other)
  end

  def to_a
    styles.map(&:to_s)
  end

  def to_s
    to_a.join(" ")
  end
end
