module PerceptronTest where
import Perceptron
import Test.HUnit
import HUnitExtensions

tests = test [
  "actual-output-derivative given the actual-output returns its derivative" ~: 
  (0.2494, 0.0001) @~? actualOutputDerivative 0.5250,
  
  "sum-of-products given two collections returns the sum of the products of each element in the collections" ~:
  (0.1, 0.01) @~? sumOfProducts [1.0, 0.0, 0.0] [0.1, 0.2, -4.0]
  ]

main :: IO Counts
main = runTestTT tests
