data Expression =
    Seq { left :: Expression, right :: Expression }
  | Note { pitch :: String, duration :: Integer }
  deriving (Show)

compile :: Expression -> [Expression]
compile (Seq { left = left, right = right }) = compile left ++ compile right
compile (Note { pitch = pitch, duration = duration }) = [Note { pitch = pitch, duration = duration }]

toCompile = Seq {
    left = Seq {
        left = Note { pitch = "a4", duration = 250 },
        right = Note { pitch = "b4", duration = 250 }
      },
    right = Seq {
        left = Note { pitch = "c4", duration = 500 },
        right = Note { pitch = "d4", duration = 500 }
      }
  }

playNote :: [Expression] -> [Expression]
playNote expression = expression

playMusic :: Expression -> [Expression]
playMusic = playNote . compile

main = do
  putStrLn $ show toCompile
  putStrLn $ show $ compile toCompile
