class AboutController < ApplicationController
  def index
    flash[:notice] = "You visited the About page and got this notice."
  end
end