esMultiploDeTres :: Int -> Bool
esMultiploDeTres x = mod x 3 == 0

esMultiploDe :: Int -> Int -> Bool
esMultiploDe x y = mod y x == 0

cubo :: Int -> Int
cubo x = x ^ 3

area :: Int -> Int -> Int
area base altura = base * altura

esBisiesto :: Int -> Bool
esBisiesto anio
    | esMultiploDe 400 anio = True
    | esMultiploDe 4 anio = True
    | esMultiploDe 100 anio = False
    | otherwise = False

celsiusToFahr :: Float -> Float
celsiusToFahr x = (x * 9/5) + 32

fahrToCelsius :: Float -> Float
fahrToCelsius x = (x - 32) * 5/9

haceFrioF :: Float -> Bool
haceFrioF x = x < celsiusToFahr 8


mcm :: Int -> Int -> Int
mcm x y = (x * y) `div` gcd x y


dispersion :: Int -> Int -> Int -> Int
dispersion x y z = max x (max y z) `div` min x (min y z)

