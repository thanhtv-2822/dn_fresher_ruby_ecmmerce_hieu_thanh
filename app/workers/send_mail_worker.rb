class SendMailWorker
  include Sidekiq::Worker

  sidekiq_options queue: "critical"
  sidekiq_options retry: 5

  def perform user_id, order_id
    @user = User.find_by id: user_id
    @order = Order.find_by id: order_id
    UserMailer.checkout(@user, @order).deliver_now if @order && @user
  end
end
