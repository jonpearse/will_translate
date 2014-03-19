module WillTranslate
  module ClassMethods
    
    # Adds localisable fields to an ActiveRecord object. This will automatically create getters and setters for these
    # fields.
    #
    # === Parameters
    #
    # [fields]  an array containing field names (as strings or symbols) that you wish to be localised.
    def will_translate( *fields )
      include InstanceMethods
      
      # add new relations
      has_many :wt_translations, :as => :translateable, :dependent => :destroy
      
      # hooks
      after_initialize  :load_translations
      after_save        :save_translations
      
      # define getters and setters for each field
      fields.each do |field|
        
        # getter
        define_method "#{field}" do |args = nil|          
          get_translated_content field.to_sym, args
        end
        
        define_method "#{field}?" do
          !send("#{field}").blank?
        end
        
        # setter
        define_method "#{field}=" do |args = nil|
          set_translated_content field.to_sym, args
        end
                
        self.localised_fields = fields
      end      
    end
  end
end