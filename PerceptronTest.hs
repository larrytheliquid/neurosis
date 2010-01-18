module PerceptronTest where
import Perceptron
import Test.HUnit
import HUnitExtensions

main = runTestTT (TestList [
                     
  "outputErrorTerm given the desired output and output node " ++
  "returns the product of the the actual output derivative " ++
  "and the difference between the desired output and output node" ~: 
  (-0.1431, 0.0001) @~? outputErrorTerm 0.0 0.5932,                     
                     
  "actualOutputDerivative given the actual output returns its derivative" ~: 
  (0.2494, 0.0001) @~? actualOutputDerivative 0.5250,
                     
  "actualOutput returns the activation of the sum of products" ~:
  (0.5250, 0.0001) @~? actualOutput [1.0, 0.0, 0.0] [0.1, 0.2, -4.0],
  
  "activate applies the sigmoid function" ~:
  (0.5250, 0.0001) @~? activate 0.1,
  
  "sumOfProducts given two lists returns the sum of the products of each element in the lists" ~:
  (0.1, 0.01) @~? sumOfProducts [1.0, 0.0, 0.0] [0.1, 0.2, -4.0]
  
  ])
