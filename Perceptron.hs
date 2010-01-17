module Perceptron where

sumOfProducts :: [Double] -> [Double] -> Double
sumOfProducts xs ys = sum (zipWith (*) xs ys)

actualOutputDerivative :: Double -> Double
actualOutputDerivative n = n * (1-) n
