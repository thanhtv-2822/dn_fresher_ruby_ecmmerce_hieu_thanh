class RemoveOrderPending
  include Sidekiq::Worker
  sidekiq_options queue: "critical"
  sidekiq_options retry: false

  def perform order_id
    @order = Order.find_by id: order_id
    @order&.destroy
  end
end
