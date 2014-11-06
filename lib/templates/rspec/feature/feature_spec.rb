require 'rails_helper'
<% column_names = Object.const_get(class_name).column_names.reject { |cn| ['id', 'password_digest', 'created_at', 'updated_at', 'deleted_at'].include? cn } %>
feature '<%= class_name %> Management' do

<% column_names.each do |column_name| -%>
  sample_<%= column_name %> = Faker::Lorem.characters(10)
<% end -%>
<% if Object.const_get(class_name).column_names.include? 'password_digest' -%>
  sample_password = Faker::Internet.password(10)
<% end -%>

  scenario 'adds a new <%= class_name.downcase %>' do
    expect {
      visit new_<%= class_name.downcase %>_path
<% column_names.each do |column_name| -%>
      fill_in '<%= class_name.downcase %>_<%= column_name %>', with: sample_<%= column_name %>
<% end -%>
<% if Object.const_get(class_name).column_names.include? 'password_digest' -%>
      fill_in '<%= class_name.downcase %>_password', with: sample_password
      fill_in '<%= class_name.downcase %>_password_confirmation', with: sample_password
<% end -%>
      click_button 'Save'
    }.to change(<%= class_name %>, :count).by 1
    expect(current_path).to eq <%= class_name.pluralize.downcase %>_path
  end

  scenario 'updates an existing <%= class_name.downcase %>' do
    <%= class_name.downcase %> = FactoryGirl.create(:<%= class_name.downcase %>)
    visit edit_<%= class_name.downcase %>_path <%= class_name.downcase %>
    fill_in '<%= class_name.downcase %>_<%= column_names.first %>', with: sample_<%= column_names.first %>
    click_button 'Save'
    expect(current_path).to eq <%= class_name.pluralize.downcase %>_path
    updated_<%= class_name.downcase %> = <%= class_name %>.find(<%= class_name.downcase %>.id)
    expect(updated_<%= class_name.downcase %>.<%= column_names.first %>).to eq sample_<%= column_names.first %>
  end

  scenario 'deletes a <%= class_name.downcase %>' do
    <%= class_name.downcase %> = FactoryGirl.create(:<%= class_name.downcase %>)
    expect {
      visit <%= class_name.pluralize.downcase %>_path
      click_link "delete_<%= class_name.downcase %>_#{<%= class_name.downcase %>.id}"
    }.to change(<%= class_name %>, :count).by -1
    expect(current_path).to eq <%= class_name.pluralize.downcase %>_path
  end
  
  scenario 'shows a <%= class_name.downcase %> (AJAX)', js: true do
    <%= class_name.downcase %> = FactoryGirl.create(:<%= class_name.downcase %>)
    visit <%= class_name.pluralize.downcase %>_path
    click_link "show_<%= class_name.downcase %>_#{<%= class_name.downcase %>.id}"
    expect(page).to have_content 'Show <%= class_name %>'
    click_button 'Done'
    expect(current_path).to eq <%= class_name.pluralize.downcase %>_path
  end

  scenario 'adds a new <%= class_name.downcase %> (AJAX)', js: true do
    expect {
      visit <%= class_name.pluralize.downcase %>_path
      click_link 'new_<%= class_name.downcase %>'
<% column_names.each do |column_name| -%>
      fill_in '<%= class_name.downcase %>_<%= column_name %>', with: sample_<%= column_name %>
<% end -%>
<% if Object.const_get(class_name).column_names.include? 'password_digest' -%>
      fill_in '<%= class_name.downcase %>_password', with: sample_password
      fill_in '<%= class_name.downcase %>_password_confirmation', with: sample_password
<% end -%>
      click_button 'Save'
    }.to change(<%= class_name %>, :count).by 1
    expect(current_path).to eq <%= class_name.pluralize.downcase %>_path
  end

  scenario 'edits an existing <%= class_name.downcase %> (AJAX)', js: true do
    <%= class_name.downcase %> = FactoryGirl.create(:<%= class_name.downcase %>)
    visit <%= class_name.pluralize.downcase %>_path
    click_link "edit_<%= class_name.downcase %>_#{<%= class_name.downcase %>.id}"
    fill_in '<%= class_name.downcase %>_<%= column_names.first %>', with: sample_<%= column_names.first %>
    click_button 'Save'
    expect(current_path).to eq <%= class_name.pluralize.downcase %>_path
    updated_<%= class_name.downcase %> = <%= class_name %>.find(<%= class_name.downcase %>.id)
    expect(updated_<%= class_name.downcase %>.<%= column_names.first %>).to eq sample_<%= column_names.first %>
  end

end