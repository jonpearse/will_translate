require 'will_translate/schema'

module WillTranslate
  module Glue
    def self.included base
      base.extend ClassMethods
      base.send :include, Schema if defined? ActiveRecord
      
      base.class_attribute :localised_fields
    end
  end
end