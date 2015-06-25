
@mail = Mail.new do
  to      'lingduokong@gmail.com'
  from    'kld.application@gmail.com'
  subject 'email sent by ruby gem'

  text_part do
    body 'Here is the attachment you wanted'
  end
end

@mail.delivery_method :sendmail

@mail.deliver