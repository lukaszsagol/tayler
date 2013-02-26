module Tayler
  module Server
    def self.available_actions
      ObjectSpace.each_object(Class).select { |klass| klass < Tayler::Server::SoapAction }
    end

    def self.find_action(name)
      available_actions.detect { |klass| klass.handles?(name) } or raise Tayler::Faults::ActionNotFound.new(name)
    end
  end
end
