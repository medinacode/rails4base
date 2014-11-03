<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  before_action :set_<%= singular_table_name %>, only: [:show, :edit, :update, :destroy]

  def index
    @limit_records = 10
    @page = params[:page].to_i || 1
    @search = params[:search] || ''
    @by = list_columns.include?(params[:by]) ? params[:by] : 'id'
    @dir = ['asc', 'desc'].include?(params[:dir]) ? params[:dir] : 'asc'

    @<%= plural_table_name %> = <%= class_name %>.all.order("#{@by} #{@dir}")
    @<%= plural_table_name %> = @<%= plural_table_name %>.where(search_columns.dup.map { |c| "lower(#{c}) LIKE :search" }.join(' OR '),
              { search: "%#{@search.downcase}%" }) if !@search.blank?

    @num_records = @<%= plural_table_name %>.count

    @<%= plural_table_name %> = @<%= plural_table_name %>.limit(@limit_records).offset((@page.to_i - 1) * @limit_records)

    @num_pages = (@num_records.to_f / @limit_records.to_f).ceil

    @list_columns = list_columns
  end

  def show
    @show_columns = show_columns
    if request.xhr?
      render '_show_ajax', :layout => false
    else
      render :show
    end
  end

  def new
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
    if request.xhr?
      render '_form_ajax', :layout => false
    else
      render :new
    end
  end

  def edit
    if request.xhr?
      render '_form_ajax', :layout => false
    else
      render :edit
    end
  end

  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>
    if @<%= orm_instance.save %>
      flash[:success] = '<%= human_name %> created'
      redirect_to <%= plural_table_name %>_url
    elsif request.xhr?
      render json: { errors: @<%= singular_table_name %>.errors.full_messages }, :status => 422
    else
      render :new
    end
  end

  def update
    if request.xhr?
      if @<%= orm_instance.update("#{singular_table_name}_params") %>
        flash[:success] = '<%= human_name %> updated'
        render json: { success: true }
      else
        render json: { errors: @<%= singular_table_name %>.errors.full_messages }, :status => 422
      end
    else
      if @<%= orm_instance.update("#{singular_table_name}_params") %>
        flash[:success] = '<%= human_name %> updated'
        redirect_to <%= plural_table_name %>_url
      else
        render :edit
      end
    end
  end

  def destroy
    @<%= orm_instance.destroy %>
    flash[:success] = '<%= human_name %> deleted'
    redirect_to :back
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_<%= singular_table_name %>
  @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    end

  # Only allow a trusted parameter "white list" through.
  def <%= "#{singular_table_name}_params" %>
  <%- if attributes_names.empty? -%>
    params[:<%= singular_table_name %>]
  <%- else -%>
    params.require(:<%= singular_table_name %>).permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>)
  <%- end -%>
  end

  def search_columns
    column_names = <%= class_name %>.column_names.dup
    column_names.delete('id')
    column_names.delete('password_digest')
    column_names.delete('created_at')
    column_names.delete('updated_at')
    column_names
  end

  def list_columns
    column_names = <%= class_name %>.column_names.dup
    column_names.delete('id')
    column_names.delete('password_digest')
    column_names.delete('created_at')
    column_names.delete('updated_at')
    column_names
  end

  def show_columns
    column_names = <%= class_name %>.column_names.dup
    column_names.delete('password_digest')
    column_names
  end

end
<% end -%>