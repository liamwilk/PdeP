esMultiploDeTres :: Int -> Bool
esMultiploDeTres x
    | mod x 3 == 0 = True
    | otherwise = False

esMultiploDe :: Int -> Int -> Bool
esMultiploDe x y = mod x y == 0

cubo :: Int -> Int
cubo x = x*x*x

area :: Int -> Int -> Int
area base altura = div (base*altura) 2

esBisiesto :: Int -> Bool
esBisiesto x
    | esMultiploDe x 4 = True
    | esMultiploDe x 400 = True
    | otherwise = False

celsiusToFahr :: Float -> Float
celsiusToFahr x = (x * 9/5) + 32

fahrToCelsius :: Float -> Float
fahrToCelsius x = (x - 32) * 5/9

haceFrioF :: Float -> String
haceFrioF x
    | fahrToCelsius x < 8 = "Hace frio"
    | otherwise = "No hace frio"

mcm :: Int -> Int -> Int
mcm = gcd

pesoPino :: Int -> Int
pesoPino altura
    | altura <= 300 = altura * 3
    | otherwise = 900 + (altura - 300) * 2

esPesoUtil :: Int -> Bool
esPesoUtil peso
    | peso <= 400 && peso >= 1000 = True
    | otherwise = False

sirvePino :: Int -> Bool
sirvePino = esPesoUtil . pesoPino