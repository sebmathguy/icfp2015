module GameState ( CellState (..)
                 , BoardState
                 , accessCell
                 , lock
                 , CWRotation
                 , cwRot
                 , GameSetup (..)
                 , BoardDimensions (..)
                 , GameState (..)
                 , PieceId
                 , fromCWRot
                 ) where

import           Data.AffineSpace
import           Types            (Point (..), Vect)

data GameSetup = GameSetup { getDimensions :: BoardDimensions
                           , getPieces :: [Piece]
                           , getSeed :: Int
                           , getLayout :: BoardState
                           }
data BoardDimensions = BDim { getWidth :: Int, getHeight :: Int }

newtype Piece = Piece [Vect]

data CellState = Empty | Full
               deriving (Eq, Enum, Show, Read)

newtype BoardState = BState [[CellState]]
                   deriving (Eq, Show, Read)

data GameState = GState { getBoardState :: BoardState
                        , getPieceCount :: Int
                        , getPieceId :: PieceId
                        , getPieceLoc :: Point
                        , getPieceOrientation :: CWRotation
                        }

newtype PieceId = PieceId Int

newtype CWRotation = CWRot Int
cwRot :: Int -> CWRotation
cwRot x = CWRot $ x `mod` 6
fromCWRot :: Integral a => CWRotation -> a
fromCWRot (CWRot x) = fromIntegral x

accessCell :: BoardState -> Point -> CellState
accessCell _ _ = undefined

lock :: BoardDimensions -> BoardState -> Piece -> Point -> Maybe BoardState
lock dims st piece loc
  | not $ checkBounds  dims loc piece = Nothing
  | not $ checkOverlap st   loc piece = Nothing
  | True = undefined

checkOverlap :: BoardState -> Point -> Piece -> Bool
checkOverlap st loc (Piece [])     = accessCell st loc == Empty
checkOverlap st loc (Piece (v:vs)) = accessCell st loc == Empty &&
                                     checkOverlap st (loc .+^ v) (Piece vs)

checkBounds dims loc (Piece [])     = insideBounds dims loc
checkBounds dims loc (Piece (v:vs)) = insideBounds dims loc &&
                                      checkBounds dims (loc .+^ v) (Piece vs)

pointMin :: BoardDimensions -> Point
pointMin _          = Point 0 0

pointMax :: BoardDimensions -> Point
pointMax (BDim w h) = Point w h

insideBounds dims loc = not $ pointOutside (boardBounds dims) loc

boardBounds :: BoardDimensions -> (Point, Point)
boardBounds dims = (pointMin dims, pointMax dims)

pointOutside :: (Point, Point) -- ^ Rectangular region
             -> Point          -- ^ Point to determine if contained with area
             -> Bool           -- ^ Result
pointOutside (Point x1 y1, Point x2 y2) (Point c1 c2)
  | not (within x1 x2 c1) = True
  | not (within y1 y2 c2) = True
  | otherwise             = False
  where
    within mn mx val = (mn < val) && (val < mx)
