class RestController < ApplicationController
    before_action :set_record, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user

    def index
        @limit_records = 10
        @page = params[:page] || 1
        @search = params[:search] || ''
        @by = params[:by] || 'name'
        @dir = params[:dir] || 'asc'

        @records = model_class.all.order("#{@by} #{@dir}")

        ors = []
        search_columns.each { |column_name| ors << "lower(#{column_name}) LIKE :search" }

        @records = @records.where(ors.join(' OR '), { search: "%#{@search.downcase}%" }) if !@search.blank?
        @num_records = @records.count

        @records = @records.limit(@limit_records).offset((@page.to_i - 1) * @limit_records)
        @num_pages = (@num_records.to_f / @limit_records.to_f).ceil

        @list_columns = list_columns

    end

    def show
        @show_columns = show_columns
        if request.xhr?
            render 'rest/_show_ajax', :layout => false
        else
            render :show
        end
    end

    def new
        @record = model_class.new
        if request.xhr?
            render "#{controller_name}/_form_ajax", :layout => false
        else
            render :new
        end
    end

    def edit
        if request.xhr?
            render "#{controller_name}/_form_ajax", :layout => false
        else
            render :edit
        end
    end

    def create
        @record = model_class.new(record_params)

        if @record.save
            flash[:success] = "#{model_name_from_record_or_class(model_class)} created"
            redirect_to users_url
        elsif request.xhr?
            render json: { errors: @record.errors.full_messages }, :status => 422
        else
            render :new
        end
    end

    def update
        if request.xhr?
            if @record.update(record_params)
                flash[:success] = "#{model_name_from_record_or_class(model_class)} updated"
                render json: { success: true }
            else
                render json: { errors: @record.errors.full_messages }, :status => 422
            end
        else
            if @record.update(record_params)
                flash[:success] = "#{model_name_from_record_or_class(model_class)} updated"
                redirect_to users_url
            else
                render :edit
            end

        end
    end

    def destroy
        @record.destroy
        flash[:success] = "#{model_name_from_record_or_class(model_class)} deleted"
        redirect_to :back
    end

    private

    def model_class
        Object.const_get(controller_name.classify)
    end

    def set_record
        @record = model_class.find(params[:id])
    end

    def search_columns
        # return ['id', 'name', etc.] in child class to specify
        column_names = model_class.column_names.dup
        column_names.delete('id')
        column_names.delete('password_digest')
        column_names.delete('created_at')
        column_names.delete('updated_at')
        column_names
    end

    def list_columns
        # return ['id', 'name', etc.] in child class to specify
        column_names = model_class.column_names.dup
        column_names.delete('id')
        column_names.delete('password_digest')
        column_names.delete('created_at')
        column_names.delete('updated_at')
        column_names
    end

    def show_columns
        # return ['id', 'name', etc.] in child class to specify
        column_names = model_class.column_names.dup
        column_names.delete('password_digest')
        column_names
    end

end
