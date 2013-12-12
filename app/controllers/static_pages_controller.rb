require 'net/http'
require 'uri/http'

class StaticPagesController < ApplicationController

  def home
    puts request.env['HTTP_REFERER']
  end

  def fake
    fetch("http://staging.seo-platform.haystak.com/")

    #url = URI.parse("http://staging.seo-platform.haystak.com/")
    #req = Net::HTTP::Get.new(url.path, {
    #    'Referer' => "http://www.haystak.com?q='haystack'",
    #    'User-Agent' => "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)"
    #})
    #res = Net::HTTP.start(url.host, url.port) {|http|
    #  http.request(req)
    #}
    render 'home'
  end

  private
  def fetch(uri_str, limit = 10)
    raise ArgumentError, 'HTTP redirect too deep' if limit == 0

    url = URI.parse(uri_str)
    req = Net::HTTP::Get.new(url.path, {
        'Referer' => "http://www.haystak-search.com?q='haystack'"
    })
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
