module ProductHelper
  include Pagy::Frontend
  def filtering_params params
    params.slice(:category, :price, :rate, :name)
  end
end
