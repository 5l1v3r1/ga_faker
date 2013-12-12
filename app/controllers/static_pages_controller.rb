require 'net/http'
require 'uri/http'

class StaticPagesController < ApplicationController

  def home
  end

  def fake
    fetch("http://staging.seo-platform.haystak.com/")

    url = URI.parse("http://staging.seo-platform.haystak.com/")
    req = Net::HTTP::Get.new(url.path)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    puts res.body
    render 'home'
  end

  private
  def fetch(uri_str, limit = 10)
    # You should choose better exception.
    raise ArgumentError, 'HTTP redirect too deep' if limit == 0

    url = URI.parse(uri_str)
    req = Net::HTTP::Get.new(url.path)
    response = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
    puts response.inspect
    case response
      when Net::HTTPSuccess     then response
      when Net::HTTPRedirection then fetch(response['location'], limit - 1)
      else
        response.error!
    end
  end
end
