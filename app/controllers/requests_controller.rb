class RequestsController < ApplicationController

    def create
        @request = Request.new(request_params)
        @request.user = current_user
        if @request.save
            redirect_to request_path(@request)
        else
            render "pages/home"
        end 
    end

    def show
        @request = Request.find(params[:id])
    end

    def index
        @requests = Request.all
    end

    def history
        @requests = Request.where(user: current_user)
    end

    def remove_bg
        @request = Request.find(params[:id])
        url = @request.photo.url
        image = RemoveBg.from_url(url, size: "regular", type: "auto", raw: true, api_key: ENV["REMOVE_BG_API_KEY"])
        image_path = "#{Rails.root}/app/assets/images/user_images/#{@request.id}-#{@request.topic}.png"
        image.save(image_path, overwrite: true)      
        @request.photo.purge if @request.photo.attached?
        @request.photo.attach(io: File.open(image_path), filename: "#{@request.topic.split(" ").join("-")}.jpg", content_type: "image/png")
        File.delete(image_path)
        @request.background_removed!
        redirect_to request_path(@request)
    end

    def download
        @request = Request.find(params[:id])
        send_data @request.photo.download, filename: @request.topic, content_type: @request.photo.content_type
    end

    private

    def request_params
        params.require(:request).permit(:style_id, :color, :topic, :background_color)
    end
end
