require 'spec_helper'

<% module_namespacing do -%>
describe <%= class_name %> do
  pending 'Define factory for <%= class_name.downcase %> at /spec/factories/<%= class_name.pluralize.downcase %>.rb'
  #factory :<%= class_name.downcase %> do
<% attributes.each do |attribute| -%>
<% if attribute.password_digest? -%>
  #    <%= attribute.column_name %> { 'password' }
  #    <%= attribute.column_name %>_confirmation { 'password' }
<% else -%>
  #    <%= attribute.column_name %> { Faker::Lorem.characters(10) }
<% end -%>
<% end -%>
  #
  #    factory :invalid_<%= class_name.downcase %> do
<% attributes.each do |attribute| -%>
  #      <%= attribute.column_name %> nil
<% if attribute.password_digest? -%>
  #      <%= attribute.column_name %>_confirmation nil
<% end -%>
<% end -%>
  #    end
  #end

  it 'has a valid factory' do
    expect(FactoryGirl.build(:<%= class_name.downcase %>)).to be_valid
  end

  it 'factory has :invalid_<%= class_name.downcase %> method' do
    expect(FactoryGirl.build(:invalid_<%= class_name.downcase %>)).to_not be nil?
  end

<% attributes.each do |attribute| -%>

  describe ':<%= attribute.column_name %>' do
<% if attribute.password_digest? -%>
    it 'is invalid without <%= attribute.column_name %> on create' do
      <%= class_name.downcase %> = FactoryGirl.build(:<%= class_name.downcase %>, <%= attribute.column_name %>: '')
      <%= class_name.downcase %>.valid?
      expect(<%= class_name.downcase %>.errors).to have_key(:<%= attribute.column_name %>)
    end

    it 'is invalid with too short <%= attribute.column_name %> on create' do
      <%= class_name.downcase %> = FactoryGirl.build(:<%= class_name.downcase %>, <%= attribute.column_name %>: Faker::Internet.<%= attribute.column_name %>(6))
      <%= class_name.downcase %>.valid?
      expect(<%= class_name.downcase %>).to_not be_valid
    end

    it 'is valid without <%= attribute.column_name %> on update' do
      <%= class_name.downcase %> = FactoryGirl.create(:<%= class_name.downcase %>)
      <%= class_name.downcase %>.<%= attribute.column_name %> = ''
      <%= class_name.downcase %>.valid?
      expect(<%= class_name.downcase %>).to be_valid
    end

    it 'is invalid with too short <%= attribute.column_name %> on update' do
      <%= class_name.downcase %> = FactoryGirl.create(:<%= class_name.downcase %>)
      <%= class_name.downcase %>.<%= attribute.column_name %> = Faker::Internet.<%= attribute.column_name %>(7)
      <%= class_name.downcase %>.valid?
      expect(<%= class_name.downcase %>).to_not be_valid
    end
<% else -%>
    it 'is invalid without <%= attribute.column_name %>' do
      <%= class_name.downcase %> = FactoryGirl.build(:<%= class_name.downcase %>, <%= attribute.column_name %>: '')
      <%= class_name.downcase %>.valid?
      expect(<%= class_name.downcase %>.errors).to have_key(:<%= attribute.column_name %>)
    end

    subject(:<%= class_name.downcase %>) { FactoryGirl.build(:<%= class_name.downcase %>) }
    it { should accept_values_for(:<%= attribute.column_name %>, '[CHANGE]', '[CHANGE]') }
    it { should_not accept_values_for(:<%= attribute.column_name %>, nil, '', ' ') }
<% end -%>
  end
<% end -%>

end
<% end -%>