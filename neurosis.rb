require 'hubris'
require 'sinatra/base'

module Neurosis
  class Perceptron
    hubris :source => 'Perceptron.hs', :no_strict => true
  end
  
  class Server < Sinatra::Base
    def perceptron() Perceptron.new end
    
    get '/' do
      options = JSON.parse params[:input]
      if output_nodes = perceptron.hubris_learn(options)
        output_nodes.to_json
      else
        status 400
        "Please specify all correct options for: " +
        "input_patterns, output_patterns, hidden_weights_group, output_weights_group, learning_rate"
      end
    end
  end
end
