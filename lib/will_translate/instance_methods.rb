module WillTranslate
  module InstanceMethods
    
    attr_accessor :localised_fields
    
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
    
    def get_translated_content( field, options = nil )
      load_translations unless defined? @translations
      
      real_options = {}    
      
      # switch
      if options.is_a? String
        real_options[:locale] = options.to_sym
      elsif options.is_a? Symbol
        real_options[:locale] = options
      elsif [TrueClass,FalseClass].include?(options.class)
        real_options[:fallback] = options
      elsif options.is_a? Hash
        real_options = options
      end
      
      # fill in
      real_options[:fallback] ||= false
      real_options[:locale]   ||= I18n.locale
      
      # fallbacks?
      locales = real_options[:fallback] && I18n.respond_to?(:fallbacks) ? I18n.fallbacks[real_options[:locale]] : [real_options[:locale]]
      
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