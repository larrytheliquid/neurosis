module PerceptronTest where
import Perceptron
import Test.HUnit
import HUnitExtensions

  -- run tests where
main = runTestTT (TestList [
                     
  "actualOutputDerivative given the actualOutput returns its derivative" ~: 
  (0.2494, 0.0001) @~? actualOutputDerivative 0.5250,
  
  "activate applies the sigmoid function" ~:
  (0.5250, 0.0001) @~? activate 0.1,
  
  "sumOfProducts given two lists returns the sum of the products of each element in the lists" ~:
  (0.1, 0.01) @~? sumOfProducts [1.0, 0.0, 0.0] [0.1, 0.2, -4.0]
  
  ])
