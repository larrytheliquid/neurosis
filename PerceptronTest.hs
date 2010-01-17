module PerceptronTest where
import Perceptron
import Test.HUnit
import HUnitExtensions

tester = "actual-output-derivative given the actual-output returns its derivative" ~: 
         (3.0, 0.001) @~? (1.0+2.0)

main :: IO Counts
main = runTestTT tester
