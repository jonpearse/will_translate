module WillTranslate
  module InstanceMethods
    
    attr_accessor :localised_fields
    
    private 
    
    # Loads translations for this object. Called automatically by +after_initialize+ hook.
    def load_translations
            
      unless @translations
        @translations = {}
        
        # set out blanks
        I18n.available_locales.each do |locale|
          @translations[locale] ||= {}
        end
        
        # load actual data
        wt_translations.each do |translation|
          @translations[translation.locale.to_sym] ||= {}
          @translations[translation.locale.to_sym][translation.field.to_sym] = translation
        end        
      end
      
      @translations            
    end
    
    # Saves translations for this object. Called automatically by +after_save+ hook.
    def save_translations    

      @translations.each do |locale,fields|
        fields.each do |field,tx|
          if tx.content.nil?
            tx.delete
            @translations[locale.to_sym][field.to_sym] = nil
          else
            tx.save
          end
        end
      end
      
    end
    
    # Returns the translated content for the specified field. By default this returns the translation for the current
    # locale, but this can be overridden using the +options+ parameter.
    #
    # === Parameters
    #
    # [field]   the field for which return localised content
    # [options] see below _(optional)_
    #
    # === Options
    #
    # [:fallback] whether or not to fall back to another locale, as defined by +I18n.fallbacks+ configuration 
    #             _(default:false)_
    # [:locale]   the locale to return. This must be one defined in +I18n.available_locales+ _(defaults to current locale)_
    #
    def get_translated_content( field, options = {} )
      load_translations unless defined? @translations
      
      # default
      options[:locale]    ||= I18n.locale
      options[:fallback]  ||= false
    
      # fallbacks?
      locales = options[:fallback] && I18n.respond_to?(:fallbacks) ? I18n.fallbacks[options[:locale]] : [options[:locale]]
      
      # orf we go
      content = nil
      locales.each do |l|
        if tx = @translations[l][field]
          content = tx.content
        end
      end
      
      # return
      content
    end
    
    # Sets localised content for the specified field. Content may either be specified as a string, in which case it is
    # set for the current locale; or as a hash of locale => localisation pairs, in which case content is set for all
    # specified locales.
    #
    # === Parameters
    #
    # [field]       the field to set content for
    # [new_content] the new content, either as a String or Hash
    def set_translated_content( field, new_content )
      
      load_translations unless defined? @translations
      
      # normalise translations
      unless new_content.is_a? Hash
        new_content = { :"#{I18n.locale}" => new_content }
      end
            
      # save out
      new_content.each_pair do |locale, content|          
        if @translations[locale.to_sym][field.to_sym].nil?
          @translations[locale.to_sym][field.to_sym] = wt_translations.new :field => field, :locale => locale.to_s, :content => content unless content.nil?
        else
          @translations[locale.to_sym][field.to_sym].content = content
        end
      end
    end
  end
end