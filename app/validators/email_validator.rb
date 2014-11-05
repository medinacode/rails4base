class EmailValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
        unless value =~ /\A\S+@.+\.\S+\z/i
            record.errors[attribute] << (options[:message] || 'must be a valid email address')
        end
    end
end
