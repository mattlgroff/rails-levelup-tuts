class AboutController < ApplicationController
  def index
    flash[:notice] = "Your profile has been updated."
  end
end