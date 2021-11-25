require "delegate"

require "styler/version"

require "styler/collection"
require "styler/style"
require "styler/style_substraction"

module Styler
  def self.new(&block)
    Collection.new.tap do |c|
      c.instance_eval(&block)
    end
  end
end
