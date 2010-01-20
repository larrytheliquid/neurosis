module PerceptronTest where
import Perceptron
import Test.HUnit
import HUnitExtensions

main = runTestTT (TestList [
                     
  "pattern given input and output nodes, and hidden and output weights groups" ~:
  let (hiddenWeights, outputWeights) = pattern [0.0, 0.0] [0.0] 
                                       [[0.1, 0.2, -0.4], [0.3, 0.2, -0.1]] 
                                       [[0.1, 0.2, 0.3]]
  in do
    mapM (\(x,y) -> assertClose "returns the new hidden weights groups" (x, 0.0001) y)
      (zip [0.0929, 0.2, -0.4, 0.2895, 0.2, -0.1] (concat hiddenWeights))
    assertClose "returns the new output weights groups"
      (1.0, 0.0001) 1.0,
                     
  "changedWeight given weight, error term, and node " ++ 
  "returns the sum of the weight and the product of the " ++
  "learning rate, error term, and node" ~:
  (0.1249, 0.0001) @~? changedWeight 0.2 (-0.1431) 0.5250,
                     
  "hiddenErrorTerm given the hidden node, output error terms, and " ++
  "output weights of the hidden node multiplies the actual output derivative " ++ 
  "by the sum of products of the output error terms and output weights" ~:
  (-0.0071, 0.0001) @~? hiddenErrorTerm 0.5250 [-0.1431] [0.2],
                     
  "outputErrorTerm given the desired output and output node " ++
  "returns the product of the the actual output derivative " ++
  "and the difference between the desired output and output node" ~: 
  (-0.1431, 0.0001) @~? outputErrorTerm 0.5932 0.0,
                     
  "actualOutputDerivative given the actual output returns its derivative" ~: 
  (0.2494, 0.0001) @~? actualOutputDerivative 0.5250,
                     
  "actualOutput returns the activation of the sum of products" ~:
  (0.5250, 0.0001) @~? actualOutput [1.0, 0.0, 0.0] [0.1, 0.2, -4.0],
  
  "activate applies the sigmoid function" ~:
  (0.5250, 0.0001) @~? activate 0.1,
  
  "sumOfProducts given two lists returns the sum of the products of each element in the lists" ~:
  (0.1, 0.01) @~? sumOfProducts [1.0, 0.0, 0.0] [0.1, 0.2, -4.0]
  
  ])
