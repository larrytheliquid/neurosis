module HUnitExtensions where
import Test.HUnit
import Control.Monad (unless)

assertClose :: (Fractional a, Ord a, Eq a, Show a) => String -> (a, a) -> a -> Assertion
assertClose preface (expected, delta) actual = unless withinDelta (assertFailure msg)
  where withinDelta = (expected + delta) >= actual && (expected - delta) < actual
        msg = (if null preface then "" else preface ++ "\n") ++
              "expected (within " ++ show delta ++ "): " ++ show expected ++ 
              "\n but got: " ++ show actual

infix 1 @~?, @?~

(@~?) :: (Fractional a, Ord a, Eq a, Show a) => (a, a) -> a -> Assertion
(expected, delta) @~? actual = assertClose "" (expected, delta) actual

(@?~) :: (Fractional a, Ord a, Eq a, Show a) => a -> (a, a) -> Assertion
actual @?~ (expected, delta) = assertClose "" (expected, delta) actual
