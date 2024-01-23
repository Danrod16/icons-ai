class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @prompt = Prompt.new
    @requests = Request.all
  end
end
