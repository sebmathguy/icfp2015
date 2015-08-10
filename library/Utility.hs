-- | General utility functions
module Utility where

--------------------------------------------------------------------------------
------------------------------------ Header ------------------------------------
--------------------------------------------------------------------------------


-- Imports
import           Data.Foldable (foldl')

-- HLint pragmas
{-# ANN module ("HLint: ignore Redundant bracket" :: String) #-}


--------------------------------------------------------------------------------
------------------------------- Public functions -------------------------------
--------------------------------------------------------------------------------


(<.>) :: Functor f => (a -> b) -> (c -> f a) -> (c -> f b)
f <.> g = \x -> f <$> (g x)
infixr 9 <.>

compose :: Foldable f => f (a -> a) -> a -> a
compose = foldl' (flip (.)) id