module ProductHelper
  def recently_product
    session[:recent] ||= Array.new
  end

  def new_index_page page
    items = Settings.page.size_5
    page = 1 if page.nil?
    (page.to_i - 1) * items + 1
  end
end
