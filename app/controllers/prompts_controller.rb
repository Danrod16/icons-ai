class PromptsController < ApplicationController

    def create
        @prompt = Prompt.new(prompt_params)
        @prompt.user = current_user
        if @prompt.save!
            redirect_to new_prompt_request_path(@prompt)
        else
            render "pages/home"
        end
    end

    private

    def prompt_params
        params.require(:prompt).permit(:description)
    end
end
