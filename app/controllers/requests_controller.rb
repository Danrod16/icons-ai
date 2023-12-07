class RequestsController < ApplicationController

    def create
        @request = Request.new(request_params)
        @request.user = current_user
        if @request.save
            redirect_to request_path(@request)
        else
            redirect :back
        end 
    end

    def show
        @request = Request.find(params[:id])
    end


    private

    def request_params
        params.require(:request).permit(:style_id, :color, :topic)
    end
end
