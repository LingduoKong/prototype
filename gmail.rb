require 'pony'

email = File.read("email.html")


Pony.mail({
  :to => 'kld.application@gmail.com',
  :subject => 'whatever',
  :via => :smtp,
  :html_body => email.to_s,
  :via_options => {
    :address              => 'smtp.gmail.com',
    :port                 => '587',
    :enable_starttls_auto => true,
    :user_name            => 'user',
    :password             => 'password',
    :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
    :domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
  }
})