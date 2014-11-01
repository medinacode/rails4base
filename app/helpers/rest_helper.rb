module RestHelper
    include Rails.application.routes.url_helpers

    def sortable(field_name, field_label)
        str = '<th>'
        str = '<th class="info">' if @by == field_name
        str += link_to raw("<i class='fa fa-#{@by == field_name ? @dir == 'asc' ? 'sort-asc' : 'sort-desc' : 'sort' } fa-lg'></i>#{field_label}"),
                       params.merge(by: field_name, dir: @dir == 'asc' ? 'desc' : 'asc', page: 1)
        str += '</th>'
        return str.html_safe
    end

    def new_record_path
        send("new_#{controller_name[0..-2]}_path")
    end

    def edit_record_path(record)
        send("edit_#{controller_name[0..-2]}_path", record)
    end

    def show_records_path
        send("#{controller_name}_url")
    end
end
