#!/usr/bin/env stack
{- stack
    --resolver lts-17.14
    --install-ghc
    runghc
 -}
import Control.Monad;

main = do
  let x = [1,2,3]
  let y = [10.100,200]

  (*) <$> x <*> y

  do {
    x <- thing1 ;
    y <- func1 x ;
    thing2 ;
    z <- func2 y ;
    return z
    }
