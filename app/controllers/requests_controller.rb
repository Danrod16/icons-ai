class RequestsController < ApplicationController

    def new
        @request = Request.new
        @prompt = Prompt.find(params[:prompt_id])
        @new_prompt = Prompt.new
    end

    def create
        @request = Request.new(request_params)
        @request.user = current_user
        @prompt = Prompt.find(params[:prompt_id])
        @request.prompt = @prompt
        if @request.save!
            redirect_to request_path(@request)
        else
            render :new, unprocessable_entity: @request.errors
        end 
    end

    def show
        @request = Request.find(params[:id])
        @prompt = @request.prompt
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
        
        begin
          image_result = RemoveBg.from_url(url, size: "regular", type: "auto", raw: true, api_key: ENV["REMOVE_BG_API_KEY"])
          image_data = image_result.data 
          image_io = StringIO.new(image_data)
          image_io.class.class_eval do
            attr_accessor :original_filename, :content_type
          end
          image_io.original_filename = "processed_image.png"
          image_io.content_type = "image/png"
          if @request.photo.attached?
            @request.photo.purge
          end
          @request.photo.attach(io: image_io, filename: image_io.original_filename, content_type: image_io.content_type)
          @request.background_removed!
          redirect_to request_path(@request), notice: 'Background removed successfully and image uploaded.'
        rescue RemoveBg::Error => e
          logger.error "RemoveBg error: #{e.message}"
          redirect_to request_path(@request), alert: 'Failed to remove background from the image.'
        rescue => e
          logger.error "Unexpected error: #{e.message}"
          redirect_to request_path(@request), alert: 'An unexpected error occurred.'
        end
      end

    def download
        @request = Request.find(params[:id])
        @request.update(downloaded: true)
        send_data @request.photo.download, filename: "logo-#{@request.id}.png", content_type: @request.photo.content_type
    end

    private

    def request_params
        params.require(:request).permit(:style_id, :color, :topic, :background_color)
    end
end
