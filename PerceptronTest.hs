module PerceptronTest where
import Perceptron
import Test.HUnit
import HUnitExtensions

main = runTestTT (TestList [
                     
  "learn given the XOR problem returns its definition (caveat: with learningRate 1.0)" ~:
  [[0], [1], [1], [0]] @=? (learn 0.5
                            [[0.0, 0.0], [0.0, 1.0], [1.0, 0.0], [1.0, 1.0]] 
                            [[0.0], [1.0], [1.0], [0.0]]
                            [[0.0923, 0.1958, -0.4049], [0.2904, 0.1946, -0.1057]]
                            [[0.0276, 0.1621, 0.2559]]),
                     
  "epoch given input and output patterns, and hidden and output weights groups" ~:
  let (hiddenWeights, outputWeights) = epoch 1.0
                                       [[0.0, 0.0], [0.0, 1.0], [1.0, 0.0], [1.0, 1.0]] 
                                       [[0.0], [1.0], [1.0], [0.0]]
                                       [[0.1, 0.2, -0.4], [0.3, 0.2, -0.1]] 
                                       [[0.1, 0.2, 0.3]]
  in
    mapM_ (\(x,y) -> assertClose "returns the new hidden & output weights groups" (x, 0.0001) y)
      (zip [0.0923, 0.1958, -0.4049,
            0.2904, 0.1946, -0.1057,
            0.0276, 0.1621, 0.2559] 
       (concat (hiddenWeights ++ outputWeights))),
                     
  "pattern given input and output nodes, and hidden and output weights groups" ~:
  let (hiddenWeights, outputWeights) = pattern 1.0
                                       [0.0, 0.0] 
                                       [0.0] 
                                       [[0.1, 0.2, -0.4], [0.3, 0.2, -0.1]] 
                                       [[0.1, 0.2, 0.3]]
  in
    mapM_ (\(x,y) -> assertClose "returns the new hidden & output weights groups" (x, 0.0001) y)
      (zip [0.0929, 0.2, -0.4, 
            0.2895, 0.2, -0.1,
            -0.0431, 0.1249, 0.2178] 
       (concat (hiddenWeights ++ outputWeights))),
                     
  "averageError given input and output patterns, and hidden and output weights groups " ++ 
  "returns the sum of squared errors" ~:
  (0.1416, 0.0001) @~? (averageError
                        [[0.0, 0.0], [0.0, 1.0], [1.0, 0.0], [1.0, 1.0]] 
                        [[0.0], [1.0], [1.0], [0.0]]
                        [[0.0923, 0.1958, -0.4049], [0.2904, 0.1946, -0.1057]]
                        [[0.0276, 0.1621, 0.2559]]),                     
  
  "calculateError given input and output nodes, and hidden and output weights groups " ++ 
  "returns the sum of squared errors" ~:
  (0.2366, 0.0001) @~? (calculateError [0.0, 1.0] [1.0]
                        [[0.0923, 0.1958, -0.4049], [0.2904, 0.1946, -0.1057]]
                        [[0.0276, 0.1621, 0.2559]]),                     
  
  "changedWeight given weight, error term, and node " ++ 
  "returns the sum of the weight and the product of the " ++
  "learning rate, error term, and node" ~:
  (0.1249, 0.0001) @~? changedWeight 1.0 (-0.1431) 0.5250 0.2,
                     
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
