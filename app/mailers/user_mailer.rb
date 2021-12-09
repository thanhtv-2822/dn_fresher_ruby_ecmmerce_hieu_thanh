class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.checkout.subject
  #
  def checkout user, order
    @user = user
    @order = order
    mail to: user.email, subject: "Order successfully"
  end
end
