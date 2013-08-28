if  Rails.env.production?
  ActionMailer::Base.smtp_settings = {
      :address => "127.0.0.1",
      :port => 25,
      :enable_starttls_auto => false,
  }
else
  ActionMailer::Base.smtp_settings ={
      :address => "smtp.gmail.com",
      :port => 587,
      :user_name => "test.smtp@adventori.com",
      :password => "smtp;test",
      :authentication => "plain",
      :enable_starttls_auto => true
  }
end

if Rails.env.development?
  class OverrideMailRecipient
    def self.delivering_email(mail)
      mail.to = "htaidirt+tc_admin@gmail.com"
    end
  end
  AdminMailer.register_interceptor(OverrideMailRecipient)
end

ActionMailer::Base.default_url_options = {:host => ENV['HOST'], :locale => I18n.locale} # Your app URL. E.g: myapp.herokuapp.com
