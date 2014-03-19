module WillTranslate
  module Schema
    
    def self.included base      
      ActiveRecord::ConnectionAdapters::Table.send :include, TableDefinition
      ActiveRecord::ConnectionAdapters::TableDefinition.send :include, TableDefinition
      ActiveRecord::ConnectionAdapters::AbstractAdapter.send :include, Statements

      if defined?(ActiveRecord::Migration::CommandRecorder) # Rails 3.1+
        ActiveRecord::Migration::CommandRecorder.send :include, CommandRecorder
      end
    end
    
    module Statements
      
      # Adds wt_translations table to database unless it already exists
      def add_will_translate
        
        unless ActiveRecord::Base.connection.table_exists? 'wt_translation'
          
          create_table :wt_translations do |t|
            t.string    :translateable_type,    :limit => 32,   :null => false
            t.integer   :translateable_id,                      :null => false
            t.string    :locale,                :limit => 8,    :null => false
            t.string    :field,                 :limit => 32,   :null => false
            t.text      :content
          end
          add_index :wt_translations, [ :translateable_type, :translateable_id, :locale, :field ], :unique => true, :name => 'lookup'
          
        end
        
      end      
    end
    
    module TableDefinition
      # nothing
    end

    module CommandRecorder
      def add_will_translate *args
        record(:add_will_translate, args)
      end
    end
  end
end