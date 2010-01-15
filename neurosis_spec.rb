require File.dirname(__FILE__) + "/neurosis"

Spec::Runner.configure do |config|
  system "rm /var/hubris/cache/Perceptron.so"
  
  def perceptron
    Neurosis::Perceptron.new
  end
end

describe "actualOutputDerivative given the actual-output" do
  it "returns its derivative" do
    perceptron.actualOutputDerivative(0.5250).should be_close(0.2494, 0.0001)
  end
end
