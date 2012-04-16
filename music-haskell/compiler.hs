data Expression =
    Seq { left :: Expression, right :: Expression }
  | Note { pitch :: String, duration :: Integer, start :: Integer }
  | Par { left :: Expression, right :: Expression }
  deriving (Show)

endTime :: Expression -> Integer -> Integer
endTime (Note { duration = duration }) start = duration + start
endTime (Seq { left = left, right = right }) start = endTime right (endTime left start)
endTime (Par { left = left, right = right }) start = max (endTime left start) (endTime right start)

compile :: Expression -> [Expression]
compile expression = compile' expression 0
  where
    compile' :: Expression -> Integer -> [Expression]
    compile' (Seq { left = left, right = right }) start = compile' left start ++ compile' right (endTime left start)
    compile' (Par { left = left, right = right }) start = compile' left start ++ compile' right start
    compile' (Note { pitch = pitch, duration = duration }) start = [Note { pitch = pitch, duration = duration, start = start }]

playNote :: [Expression] -> [Expression]
playNote expression = expression

playMusic :: Expression -> [Expression]
playMusic = playNote . compile

toCompileSeq = Seq {
    left = Seq {
        left = Note { pitch = "a4", duration = 250, start = 0 },
        right = Note { pitch = "b4", duration = 250, start = 0 }
      },
    right = Seq {
        left = Note { pitch = "c4", duration = 500, start = 0 },
        right = Note { pitch = "d4", duration = 500, start = 0 }
      }
  }

toCompilePar = Seq {
    left = Par {
        left = Note { pitch = "c3", duration = 250, start = 0 },
        right = Note { pitch = "g4", duration = 500, start = 0 }
      },
    right = Par {
        left = Note { pitch = "d3", duration = 500, start = 0 },
        right = Note { pitch = "f4", duration = 250, start = 0}
      }
  }

main = do
  putStrLn $ show toCompileSeq
  putStrLn $ show $ compile toCompileSeq
  putStrLn $ show toCompilePar
  putStrLn $ show $ compile toCompilePar
