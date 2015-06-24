require 'pony'

Pony.mail({
  :to => 'kld.application@gmail.com',
  :subject => 'whatever',
  :via => :smtp,
  :html_body => "<h1>Health Engine</h1><br><p>This is a test html email, I know it's ugly</p>",
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