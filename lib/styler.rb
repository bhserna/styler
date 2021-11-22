require_relative "styler/collection"

module Styler
  def inspect
    "<Styler>"
  end

  def self.new(&block)
    Collection.new(self, :default).tap do |c|
      c.instance_eval(&block)
    end
  end
end
