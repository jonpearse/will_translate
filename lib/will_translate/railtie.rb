require 'will_translate'

module WillTranslate
  require 'rails'
  
  class Railtie < Rails::Railtie
    initializer 'will_translate.insert_into_active_record' do |app|
      ActiveSupport.on_load :active_record do
        WillTranslate::Railtie.insert
      end
    end
  end
  
  class Railtie
    def self.insert
      if defined?(ActiveRecord)
        ActiveRecord::Base.send :include, WillTranslate::Glue
      end
    end
  end
end