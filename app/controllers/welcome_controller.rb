class WelcomeController < ApplicationController
  before_action :authenticate_participant!
  layout 'end_user'

  def index
  end

  def home
  end

  def participants
  end
end
