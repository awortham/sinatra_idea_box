require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'
require 'sinatra/base'
require 'rack/test'
require 'nokogiri'

require_relative '../lib/app'

describe IdeaBoxApp do
  include Rack::Test::Methods

  def app
    IdeaBoxApp.new
  end

  it "has a get" do
    get '/'
    assert last_response.ok?
  end

  it "is a post" do
    post '/', idea: {title: "Test idea", description: "Test description"}
    follow_redirect!
    assert last_response.ok?
  end

  it "has a put" do
    put '/:id', idea: {title: "Test idea", description: "Test description"}
    follow_redirect!
    assert last_response.ok?
  end

  it "has text on details page" do
    get '/:id/details'
    html = Nokogiri::HTML(last_response.body)

    assert last_response.ok?
    assert_equal "Details", html.css('h1').text
  end
end
