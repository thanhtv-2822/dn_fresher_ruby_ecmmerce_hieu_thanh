module CartsHelper
  def current_cart
    session[:cart] ||= Array.new
  end

  def get_all_item_in_cart
    current_cart.each do |item|
      product = Product.find_by(id: item["product"]["id"])
      current_cart.delete(item) if product.nil?
    end
  end

  def find_product_in_cart product
    current_cart.find{|item| item["product"]["id"] == product.id}
  end

  def total_price item
    item["product"]["price"] * item["quantity"]
  end

  def total_all_price
    current_cart.reduce(0){|a, e| a + total_price(e)}
  end
end
