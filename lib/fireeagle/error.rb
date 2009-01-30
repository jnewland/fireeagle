module FireEagle
  class Error
    include HappyMapper

    tag "err"
    attribute :code, String
    attribute :message, String, :tag => "msg"
  end
end