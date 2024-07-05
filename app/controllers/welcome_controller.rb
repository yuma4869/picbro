class WelcomeController < ApplicationController
  def top
  end

  def test
  end

  def test_post
    post = params[:post]
    puts post
    render("welcome/test")
  end
end
