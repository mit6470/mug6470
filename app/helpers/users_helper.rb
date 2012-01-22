module UsersHelper
  def valid_email?(email)
    email =~ /^[A-Za-z0-9.+_]+@[^@]*\.(\w+)$/
  end
end
