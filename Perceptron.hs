module Perceptron where
import Data.List (transpose)

learningRate = 1.0
bias = 1.0
epochsLimit = 4000

pattern :: [Double] -> [Double] -> [[Double]] -> [[Double]] -> 
           ( [[Double]], [[Double]] )
pattern inputNodes desiredOutputs hiddenWeightsGroup outputWeightsGroup =
  (hiddenWeightsGroup', outputWeightsGroup')
    where
      -- forward propogation
      inputNodes' = calculateInputNodes inputNodes
      hiddenNodes = calculateHiddenNodes inputNodes' hiddenWeightsGroup
      outputNodes' = calculateOutputNodes hiddenNodes outputWeightsGroup
      -- backward propogation
      outputErrorTerms = zipWith outputErrorTerm outputNodes' desiredOutputs
      hiddenErrorTerms = zipWith (`hiddenErrorTerm` outputErrorTerms) 
                         hiddenNodes (transpose outputWeightsGroup)
      -- weight change
      hiddenWeightsGroup' = zipWith (\ hiddenWeights hiddenError -> 
                                      zipWith (`changedWeight` hiddenError) hiddenWeights inputNodes')
                           hiddenWeightsGroup (tail hiddenErrorTerms)
      outputWeightsGroup' = zipWith (\ outputWeights outputError -> 
                                     zipWith (`changedWeight` outputError)
                                     outputWeights hiddenNodes)
                           outputWeightsGroup outputErrorTerms
 
calculateOutputNodes :: [Double] -> [[Double]] -> [Double]
calculateOutputNodes hiddenNodes outputWeightsGroup =
  map (actualOutput hiddenNodes) outputWeightsGroup
  
calculateHiddenNodes :: [Double] -> [[Double]] -> [Double]
calculateHiddenNodes inputNodes hiddenWeightsGroup = 
  bias : map (actualOutput inputNodes) hiddenWeightsGroup
  
calculateInputNodes :: [Double] -> [Double]
calculateInputNodes = (bias:) 

changedWeight :: Double -> Double -> Double -> Double
changedWeight weight errorTerm node =
  weight + product [learningRate, errorTerm, node]

hiddenErrorTerm :: Double -> [Double] -> [Double] -> Double
hiddenErrorTerm hiddenNode outputErrorTerms outputWeights =
  actualOutputDerivative hiddenNode * 
  sumOfProducts outputErrorTerms outputWeights

outputErrorTerm :: Double -> Double -> Double
outputErrorTerm outputNode desiredOutput =
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
