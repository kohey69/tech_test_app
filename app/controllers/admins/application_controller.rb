class Admins::ApplicationController < ActionController::Base
  before_action :authenticate_administrator!
end
