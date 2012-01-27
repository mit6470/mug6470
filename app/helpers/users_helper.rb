module UsersHelper
  def valid_email?(email)
    email =~ /^[A-Za-z0-9.+_]+@[^@]*\.(\w+)$/
  end

  def filter_error_msg(msg)
    if /(?<m>This e-mail address.+)|(?<m>Password.+)/ =~ msg
      m + '.'
    end
  end
end
