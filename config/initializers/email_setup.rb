ActionMailer::Base.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => 587,
    :user_name => "test.smtp@adventori.com",
    :password => "smtp;test",
    :authentication => "plain",
    :enable_starttls_auto => true
}



ActionMailer::Base.default_url_options[:host] = ENV['HOST'] # Your app URL. E.g: myapp.herokuapp.com