module WillTranslate
  module ClassMethods
    
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