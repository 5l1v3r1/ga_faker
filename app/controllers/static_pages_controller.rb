require 'net/http'
require 'uri/http'

class StaticPagesController < ApplicationController

  def home
    @dealer = params['dealer']
  end
end
