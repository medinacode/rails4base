<% module_namespacing do -%>
class <%= class_name %> < <%= parent_class_name.classify %>
<% attributes.select(&:reference?).each do |attribute| -%>
  belongs_to :<%= attribute.name %><%= ', polymorphic: true' if attribute.polymorphic? %><%= ', required: true' if attribute.required? %>
<% end -%>
<% if attributes.any?(&:password_digest?) -%>
  has_secure_password
<% end -%>
<% attributes.each do |attribute| -%>
<% if attribute.password_digest? -%>
  validates :<%= attribute.column_name %>, presence: true, :on => :create
  validates :<%= attribute.column_name %>, :length => { :minimum => 8 }, :allow_blank => false, :on => :create
  validates :<%= attribute.column_name %>, :length => { :minimum => 8 }, :allow_blank => true, :on => :update
<% else -%>
  validates :<%= attribute.column_name %>, presence: true
<% end -%>
<% end -%>
end
<% end -%>