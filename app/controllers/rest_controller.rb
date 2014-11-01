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

        @records = @records.where("lower(name) LIKE ? OR lower(email) LIKE ? OR lower(active) LIKE ?",
              "%#{@search.downcase}%", "%#{@search.downcase}%", "%#{@search.downcase}%") if !@search.blank?
        @num_records = @records.count

        @records = @records.limit(@limit_records).offset((@page.to_i - 1) * @limit_records)
        @num_pages = (@num_records.to_f / @limit_records.to_f).ceil

    end

    def show
    end

    def new
        @record = model_class.new
    end

    def edit
    end

    def create
        @record = model_class.new(record_params)

        if @record.save
            redirect_to users_url
        else
            render :new
        end
    end

    def update
        if @record.update(record_params)
            redirect_to users_url
        else
            render :edit
        end
    end

    def destroy
        @record.destroy
        redirect_to :back
    end


    private

    def model_class
        Object.const_get(controller_name.capitalize[0..-2])
    end

    def set_record
        @record = model_class.find(params[:id])
    end

end
