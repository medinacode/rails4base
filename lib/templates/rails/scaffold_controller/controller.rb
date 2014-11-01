<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"
<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < RestController
    private
    def record_params
    <%- if attributes_names.empty? -%>
        params[:<%= singular_table_name %>]
    <%- else -%>
        params.require(:<%= singular_table_name %>).permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>)
    <%- end -%>
   end
end
<% end -%>
