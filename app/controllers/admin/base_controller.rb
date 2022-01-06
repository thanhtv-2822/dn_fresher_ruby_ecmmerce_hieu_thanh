class Admin::BaseController < ApplicationController
  include Pagy::Backend
  layout "admin/layouts/application"
  before_action :authenticate_user!
end
