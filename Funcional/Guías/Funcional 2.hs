doble :: Int -> Int
doble x = 2*x

cuadruple :: Int -> Int
cuadruple = doble . doble

siguiente :: Int -> Int
siguiente n = n+1

mitad :: Float -> Float
mitad n = n/2

inversa :: Float -> Float
inversa = (1/)


triple :: Int -> Int
triple n = 3*n

esNumeroPositivo :: Int -> Bool
esNumeroPositivo n
    | n > 0 = True
    | otherwise = False

esMultiploDe :: Int -> Int -> Bool
esMultiploDe x = (== 0) . mod x

esBisiesto :: Int -> Bool
esBisiesto x = esMultiploDe x 4 || esMultiploDe x 400

inversaRaizCuadrada :: Float -> Float
inversaRaizCuadrada = inversa . sqrt


incrementMCuadradoN :: Int -> Int -> Int
incrementMCuadradoN m n= (+ n) . (^2)$m

esResultadoPar :: Int -> Int -> Bool
esResultadoPar n m = even . (^m)$n