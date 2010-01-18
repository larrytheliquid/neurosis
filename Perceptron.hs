module Perceptron where

learningRate = 1.0

changedWeight :: Double -> Double -> Double -> Double
changedWeight weight errorTerm node =
  weight + product [learningRate, errorTerm, node]

hiddenErrorTerm :: Double -> [Double] -> [Double] -> Double
hiddenErrorTerm hiddenNode outputErrorTerms outputWeights =
  actualOutputDerivative hiddenNode * 
  sumOfProducts outputErrorTerms outputWeights

outputErrorTerm :: Double -> Double -> Double
outputErrorTerm desiredOutput outputNode =
  actualOutputDerivative outputNode * (desiredOutput - outputNode)

actualOutputDerivative :: Double -> Double
actualOutputDerivative actualOutput' = 
  actualOutput' * (1 - actualOutput')

actualOutput :: [Double] -> [Double] -> Double
actualOutput ns = activate . sumOfProducts ns

sumOfProducts :: [Double] -> [Double] -> Double
sumOfProducts ns ms = sum (zipWith (*) ns ms)

activate :: Double -> Double
activate n = 1  / succ (exp (-n))
