require 'httparty'
require 'active_support/core_ext/array/extract_options'

class Posterrrrous
  include HTTParty

  base_uri 'http://posterous.com/api'

  class << self
    attr_accessor :email, :password
  end

  def self.method_missing(method_sym, *arguments, &block)
    attributes = arguments.pop

    options = {
      :query => attributes,
      :basic_auth  =>  {
        :username => email,
        :password => password
      }
    }

    response = get "/#{method_sym}", options
    response = response["rsp"]

    status = response.delete('stat')
    if status != "ok"
      error = response['err']
      raise "Posterous Error #{error['code']}: #{error['msg']}"
    else
      response.values.first
    end
  end


end
