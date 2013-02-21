require "tayler/engine"
require "tayler/soap_action"
require "tayler/faults"

module Tayler
  def self.available_actions
    ObjectSpace.each_object(Class).select { |klass| klass < SoapAction }
  end

  def self.find_action(name)
    available_actions.detect { |klass| klass.handles?(name) } or raise Tayler::Faults::ActionNotFound.new(name)
  end
end
