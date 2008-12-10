module FireEagle
  class Response
    include HappyMapper

    tag "/rsp"
    attribute :status,  String, :tag => "stat"
    element   :querystring, String
    has_one   :error, Error
    has_one   :locations, Locations
    has_many  :users, User

    def self.parse(xml, opts = {})
      rsp = super(xml, { :single => true }.merge(opts))

      raise FireEagleException, rsp.error.message if rsp.fail?

      rsp
    end

    def fail?
      status == "fail"
    end

    # does the response indicate success?
    def success?
      status == "ok"
    end

    def user
      users[0]
    end
  end
end