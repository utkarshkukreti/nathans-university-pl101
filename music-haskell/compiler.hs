import Data.Char

data Expression =
    Seq { left :: Expression, right :: Expression }
  | Note { pitch :: String, pitchNumber :: Integer, duration :: Integer, start :: Integer }
  | Par { left :: Expression, right :: Expression }
  | Rest { duration :: Integer }
  | Repeat { section :: Expression, count :: Integer }
  deriving (Show)

defaultNote = Note { pitch = "a0", pitchNumber = 0, duration = 0, start = 0 }

endTime :: Expression -> Integer -> Integer
endTime (Note { duration = duration }) start = duration + start
endTime (Seq { left = left, right = right }) start = endTime right (endTime left start)
endTime (Par { left = left, right = right }) start = max (endTime left start) (endTime right start)
endTime (Rest { duration = duration }) start = duration + start
endTime (Repeat { count = count, section = section }) start = start + count * endTime section 0

convertPitch :: String -> Integer
convertPitch (letter:number) = 12 + 12 * octave + letterPitch letter
  where
    octave = read number :: Integer
    letterPitch letter = [9,11,0,2,4,5,7] !! (ord letter - ord 'a')

compile :: Expression -> [Expression]
compile expression = compile' expression 0
  where
    compile' :: Expression -> Integer -> [Expression]
    compile' (Seq { left = left, right = right }) start = compile' left start ++ compile' right (endTime left start)
    compile' (Par { left = left, right = right }) start = compile' left start ++ compile' right start
    compile' (Note { pitch = pitch, duration = duration }) start = [Note { pitch = pitch, pitchNumber = convertPitch pitch, duration = duration, start = start }]
    compile' (Rest r) start = []
    compile' (Repeat { count = count, section = section }) start = foldl (++) [] $ map rep [0..count - 1]
      where
        rep i = compile' section (start + i * endTime section 0)

playNote :: [Expression] -> [Expression]
playNote expression = expression

playMusic :: Expression -> [Expression]
playMusic = playNote . compile

toCompileSeq = Seq {
    left = Seq {
        left = defaultNote { pitch = "a4", duration = 250 },
        right = defaultNote { pitch = "b4", duration = 250 }
      },
    right = Seq {
        left = Seq {
          left = defaultNote { pitch = "c4", duration = 500 },
          right = Rest { duration = 250 }
        },
        right = Repeat {
          count = 3,
          section = defaultNote { pitch = "d4", duration = 500 }
        }
      }
  }

toCompilePar = Seq {
    left = Par {
        left = defaultNote { pitch = "c3", duration = 250 },
        right = defaultNote { pitch = "g4", duration = 500 }
      },
    right = Par {
        left = defaultNote { pitch = "d3", duration = 500 },
        right = defaultNote { pitch = "f4", duration = 250 }
      }
  }

main = do
  putStrLn $ show toCompileSeq
  putStrLn $ show $ compile toCompileSeq
  putStrLn $ show toCompilePar
  putStrLn $ show $ compile toCompilePar
