ActionMailer::Base.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => 587,
    :user_name => "test.smtp@adventori.com",
    :password => "smtp;test",
    :authentication => "plain",
    :enable_starttls_auto => true
}


ActionMailer::Base.default_url_options = {:host => ENV['HOST'], :locale => I18n.locale} # Your app URL. E.g: myapp.herokuapp.com

if Rails.env.development?
  class OverrideMailRecipient
    def self.delivering_email(mail)
      mail.to = "jin@novacodex.net"
    end
  end
  AdminMailer.register_interceptor(OverrideMailRecipient)
end