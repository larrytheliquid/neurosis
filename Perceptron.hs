module Perceptron where
import qualified Data.Map as M
import qualified Data.ByteString.Char8 as B
import Data.List (transpose, foldl')

learningRate = 1.0
bias = 1.0
epochsLimit = 4000

hubris_learn :: M.Map B.ByteString [[Double]] -> Maybe [[Int]]
hubris_learn m = result 
                 (M.lookup (B.pack "input_patterns") m)
                 (M.lookup (B.pack "output_patterns") m)
                 (M.lookup (B.pack "hidden_weights_group") m)
                 (M.lookup (B.pack "output_weights_group") m)
  where
    result (Just a) (Just b) (Just c) (Just d) =
      Just (learn a b c d)
    result _ _ _ _ = Nothing
  
learn :: [[Double]] -> [[Double]] -> [[Double]] -> [[Double]] ->
         [[Int]]
learn inputPatterns outputPatterns hiddenWeightsGroup outputWeightsGroup =
  map finalOutput inputPatterns 
    where 
      (hiddenWeightsGroup', outputWeightsGroup') = 
        learnWeights 0 inputPatterns outputPatterns hiddenWeightsGroup outputWeightsGroup
      finalOutput inputNodes = map (round . fromRational . toRational) outputNodes
        where inputNodes' = calculateInputNodes inputNodes
              hiddenNodes = calculateHiddenNodes inputNodes' hiddenWeightsGroup'
              outputNodes = calculateOutputNodes hiddenNodes outputWeightsGroup'

learnWeights :: Integer -> [[Double]] -> [[Double]] -> [[Double]] -> [[Double]] ->
                ( [[Double]], [[Double]] )
learnWeights i inputPatterns outputPatterns hiddenWeightsGroup outputWeightsGroup
  | i < epochsLimit = 
    let (hiddenWeightsGroup', outputWeightsGroup') = 
          epoch inputPatterns outputPatterns hiddenWeightsGroup outputWeightsGroup
    in
     learnWeights (succ i) inputPatterns outputPatterns
     hiddenWeightsGroup' outputWeightsGroup'
  | otherwise = (hiddenWeightsGroup, outputWeightsGroup)

epoch :: [[Double]] -> [[Double]] -> [[Double]] -> [[Double]] ->
         ( [[Double]], [[Double]] )
epoch inputPatterns outputPatterns hiddenWeightsGroup outputWeightsGroup =
  foldl' (\ (hiddenWeights, outputWeights) (inputPattern, outputPattern) ->
          pattern inputPattern outputPattern hiddenWeights outputWeights)
  (hiddenWeightsGroup, outputWeightsGroup)
  (zip inputPatterns outputPatterns)

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
                                      zipWith (`changedWeight` hiddenError)
                                      hiddenWeights inputNodes')
                           hiddenWeightsGroup (tail hiddenErrorTerms)
      outputWeightsGroup' = zipWith (\ outputWeights outputError -> 
                                     zipWith (`changedWeight` outputError)
                                     outputWeights hiddenNodes)
                           outputWeightsGroup outputErrorTerms
 
averageError :: [[Double]] -> [[Double]] -> [[Double]] -> [[Double]] -> Double
averageError inputPatterns outputPatterns hiddenWeightsGroup outputWeightsGroup = 
  (foldr (\(x, y) result -> result + calculateError x y hiddenWeightsGroup outputWeightsGroup)
   0.0 inputAndOutputPatterns) / patternLength
    where inputAndOutputPatterns = zip inputPatterns outputPatterns
          patternLength = fromIntegral (length outputPatterns)

calculateError :: [Double] -> [Double] -> [[Double]] -> [[Double]] -> Double
calculateError inputNodes outputNodes hiddenWeightsGroup outputWeightsGroup =
  (foldr (\ (x, y) result -> result + squaredError x y) 
   0.0 actualOutputsAndNodes) / 2.0
    where inputNodes' = calculateInputNodes inputNodes
          hiddenNodes = calculateHiddenNodes inputNodes' hiddenWeightsGroup
          outputNodes' = calculateOutputNodes hiddenNodes outputWeightsGroup
          actualOutputsAndNodes = zip outputNodes' outputNodes
          squaredError x y = (x^2 - y^2)^2

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
