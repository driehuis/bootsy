module Bootsy
  module ApplicationHelper
    def refresh_btn
      link_to t('bootsy.action.refresh'),
              '#refresh-gallery',
              class: 'btn btn-default btn-sm refresh-btn'
    end

    def resource_or_nil(resource)
      resource if resource.present? && resource.persisted?
    end

    # These helpers are used to dynamically generated JavaScript
    # (in app/assets/javascripts/bootsy/l10n.js.erb)
    def self.tree_to_js_struct(tree, out=String.new, level=2, parent=[])
      tree.each do |key, value|
        if value.is_a? Hash
          out << '  ' * level + key.to_s + ": {\n"
          tree_to_js_struct(value, out, level + 1, parent+[key])
          out << '  ' * level + "},\n"
        else
          out << "%s%s: \"%s\",\n" % ['  ' * level, key, value]
        end
      end
      out
    end
    def self.tree_to_js(section, structname, locale)
      return "// No translation needed for #{section} in locale '#{locale}'\n" if locale == 'en'
      tree = I18n.t(section, :locale => locale)
      return "// No #{section} for locale #{locale}: #{tree}\n" if tree.is_a? String
      "  %s['%s'] = {\n%s\n  };\n" % [ structname, locale, tree_to_js_struct(tree)]
    end

  end
end
