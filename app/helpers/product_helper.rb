module ProductHelper
  def recently_product
    session[:recent] ||= Array.new
  end
end
