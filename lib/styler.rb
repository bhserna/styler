require_relative "styler/collection"

module Styler
  def self.new(&block)
    Collection.new.tap do |c|
      c.instance_eval(&block)
    end
  end
end
