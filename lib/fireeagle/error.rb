module FireEagle
  class Error
    include HappyMapper

    tag "/rsp/err"
    attribute :code, String
    attribute :message, String, :tag => "msg"
  end
end