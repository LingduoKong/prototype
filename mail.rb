require 'mail'

@mail = Mail.new do
  to      'lingduokong@gmail.com'
  from    'adriana.lcs316@gmail.com'
  subject 'email sent by ruby gem'

  text_part do
    body 'Here is the attachment you wanted'
  end
end

@mail.delivery_method :sendmail

@mail.deliver