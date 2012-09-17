module Bootsy
  module FormHelper
    def bootsy_area object, method, options = {}

      resource = options.delete :resource

      unless resource.kind_of?(MediaContainer) || (resource.nil? && object.kind_of?(MediaContainer))
        raise ArgumentError, 'Bootsy area needs a model or a resource as its option'
      end

      bootsy_options = options.delete :bootsy_options

      unless bootsy_options.nil?
        if bootsy_options[:uploader] == false
          options[:'data-enable-uploader'] = 'false'
        end

        if bootsy_options[:alert_unsaved] == false
          options[:'data-alert-unsaved'] = 'false'
        end
      end

      object_name = object.class.name.underscore
      
      output = self.render 'bootsy/images/modal', {resource: resource || object}
      options[:class] = (options[:class].nil? ? [] : (options[:class].kind_of?(Array) ? options[:class] : [options[:class]])) + [:bootsy_text_area]
      output += self.text_area object_name, method, options
      if resource.nil? || (resource == object)
        output += self.hidden_field object_name, :bootsy_image_gallery_id, :class => 'bootsy_image_gallery_id'
      end
      output
    end
  end
end