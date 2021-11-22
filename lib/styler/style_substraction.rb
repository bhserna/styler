class Styler::StyleSubstraction
  attr_reader :a, :b

  def initialize(a, b)
    @a, @b = a, b
  end

  def -(other)
    self.class.new(self, other)
  end

  def to_a
    if b.is_a? String
      a.to_a - [b.to_s]
    else
      a.to_a - b.to_a
    end
  end

  def to_s
    to_a.join(" ")
  end
end
