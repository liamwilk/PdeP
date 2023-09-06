siguiente :: Int -> Int
siguiente = (+1)

mitad :: Float -> Float
mitad = (/2)

inversa :: Float -> Float
inversa x = 1/x

triple :: Int -> Int
triple = (*3)

esNumeroPositivo :: Float -> Bool
esNumeroPositivo = (>= 0)


{- utilizando aplicación parcial y composición. -}
esMultiploDe :: Int -> Int -> Bool
esMultiploDe x y = mod x y == 0

esBisiesto' :: Int -> Bool
esBisiesto' id = esMultiploDe 4 id || esMultiploDe 400 id || not (esMultiploDe 100 id)

inversaRaizCuadrada :: Float -> Float
inversaRaizCuadrada = inversa . sqrt

incrementMCuadradoN :: Int -> Int -> Int
incrementMCuadradoN m n = (+n) . (^2) $ m

esResultadoPar :: Int -> Int -> Bool
esResultadoPar x y = even . (^y) $ x


