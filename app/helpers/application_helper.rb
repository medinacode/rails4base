module ApplicationHelper

  def jquery_validation(validators)
    rules = {}
    validators.each do |v|
      field_name = v.attributes.first.to_s
      field_label = field_name.titleize

      if v.options[:on].blank? || v.options[:on].to_s == 'create' && action_name == 'new' || v.options[:on].to_s == 'update' && action_name == 'edit'
        case v.class.name.split('::').last
          when 'EmailValidator'
            rules[:'rule-email'] = 'true'
            rules[:'msg-email'] = "Please enter a valid #{field_label.downcase}"
          when 'LengthValidator'
            if v.options[:maximum].blank?
              rules[:'rule-minlength'] = v.options[:minimum]
              rules[:'msg-minlength'] = "#{field_label} must be at least #{v.options[:minimum]} characters long"
            elsif v.options[:minimum].blank?
              rules[:'rule-maxlength'] = v.options[:maximum]
              rules[:'msg-maxlength'] = "#{field_label} must be at most #{v.options[:maximum]} characters long"
            else
              rules[:'rule-rangelength'] = "[#{v.options[:minimum]}, #{v.options[:maximum]}]"
              rules[:'msg-rangelength'] = "#{field_label} must be between #{v.options[:minimum]} and #{v.options[:maximum]} characters long"
            end
          when 'PresenceValidator'
            rules[:'rule-required'] = 'true'
            rules[:'msg-required'] = "#{field_label} is a required field"
          when 'FormatValidator'
            rules[:'rule-regex'] = v.options[:with].to_s.split(':').last[0..-2].sub!('\A', '').sub!('\Z', '')
            rules[:'msg-regex'] = "#{field_label} has an invalid format"
        end

      end
    end
    return rules
  end
  
  def text_tip(text, tooltip_text)
    "<span class='texttip' data-toggle='tooltip' data-title='#{tooltip_text}'>#{text}</span>".html_safe
  end

end
