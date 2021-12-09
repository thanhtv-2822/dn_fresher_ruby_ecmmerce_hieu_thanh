module OrderDetailsHelper
  def detail_product order_details
    order_details.joins(:product).pluck(:quantity, :price, "products.name" , "products.image" )
      .map{|quantity, price, name, image| {quantity: quantity, price: price, name: name, img: image} }
  end
end
