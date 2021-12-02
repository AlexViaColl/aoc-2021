#!/usr/bin/runhaskell

diff x = zipWith (-) (drop 1 x) x
sums3 x = zipWith (+) (drop 2 x) (zipWith (+) (drop 1 x) x)

main = do
    contents <- getContents
    putStr "Part 1: "
    print $ length $ filter (>0) $ diff $ map (read :: String -> Int) $ lines contents

    putStr "Part 2: "
    print $ length $ filter (>0) $ diff $ sums3 $ map (read :: String -> Int) $ lines contents
