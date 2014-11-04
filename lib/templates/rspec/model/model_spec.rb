require 'spec_helper'

<% module_namespacing do -%>
describe <%= class_name %> do
  pending 'Define factory for <%= class_name.downcase %> at /spec/factories/<%= class_name.pluralize.downcase %>.rb'
  #factory :<%= class_name.downcase %> do
<% attributes.each do |attribute| -%>
  #    <%= attribute.column_name %> { Faker::Lorem.characters(10) }
<% end -%>
  #
  #    factory :invalid_<%= class_name.downcase %> do
<% attributes.each do |attribute| -%>
  #      <%= attribute.column_name %> nil
<% end -%>
  #    end
  #end

  it 'has a valid factory' do
    expect(FactoryGirl.build(:<%= class_name.downcase %>)).to be_valid
  end

  it 'has invalid attributes' do
    expect(FactoryGirl.build(:invalid_<%= class_name.downcase %>)).to_not be nil?
  end

<% attributes.each do |attribute| -%>
  describe ':<%= attribute.column_name %>' do
    it 'is invalid without <%= attribute.column_name %>' do
      <%= class_name.downcase %> = FactoryGirl.build(:<%= class_name.downcase %>, <%= attribute.column_name %>: '')
      <%= class_name.downcase %>.valid?
      expect(<%= class_name.downcase %>.errors).to have_key(:<%= attribute.column_name %>)
    end
  end
<% end -%>

end
<% end -%>