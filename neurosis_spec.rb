require File.dirname(__FILE__) + "/neurosis"
require "rack/test"
require "json"

Spec::Runner.configure do |config|
  system "rm /var/hubris/cache/Perceptron.so" rescue nil
  include Rack::Test::Methods
  
  def app
    Neurosis::Server
  end
end

describe Neurosis::Server, "GET /" do
  it "responds with output nodes when given all options" do
    get "/", :input => {
      "input_patterns" =>
      [[0.0, 0.0], [0.0, 1.0], [1.0, 0.0], [1.0, 1.0]],
      "output_patterns" =>
      [[0.0], [1.0], [1.0], [0.0]],
      "hidden_weights_group" =>
      [[0.0923, 0.1958, -0.4049], [0.2904, 0.1946, -0.1057]],
      "output_weights_group" =>
      [[0.0276, 0.1621, 0.2559]],
      "learning_rate" => [[0.5]]
    }.to_json
    
    last_response.should be_successful
    JSON.parse(last_response.body).should ==
      [[0], [1], [1], [0]]
  end

  it "responds with error message when missing options" do
    get "/", :input => {
      "output_patterns" =>
      [[0.0], [1.0], [1.0], [0.0]],
      "output_weights_group" =>
      [[0.0276, 0.1621, 0.2559]]
    }.to_json

    last_response.should be_client_error
  end
end
