class UpdateStatusWorker
  include Sidekiq::Worker

  sidekiq_options retry: 5

  def perform order_id
    @order = Order.find_by id: order_id
    @order.update status: :rejected if @order&.accept?
  end
end
