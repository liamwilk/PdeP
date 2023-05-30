fst3 :: (Int, Int, Int) -> Int
fst3 (x, _, _) = x

snd3 :: (Int, Int, Int) -> Int
snd3 (_, x, _) = x

trd3 :: (Int, Int, Int) -> Int
trd3 (_, _, x) = x

doble x = 2*x
triple x = 3*x

aplicar (f1, f2) x = (f1 x, f2 x)

cuentaBizarra :: (Int, Int) -> Int
cuentaBizarra (x, y)
    | x > y = x + y
    | y > 10 + x = y - x
    | otherwise = x * y

esNotaBochazo :: Int -> Bool
esNotaBochazo x = x < 6

aprobo :: (Int, Int) -> String
aprobo (x, y)
    | not(esNotaBochazo x) && not(esNotaBochazo y) = "Aprueba"
    | otherwise = "Desaprueba"

promociono :: (Int, Int) -> Bool
promociono (x, y) = x+y == 15 && x >= 7 && y >= 7

notasFinales :: (Int, Int) -> (Int, Int) -> (Int, Int)
notasFinales (x, y) (z, t)
    | z == -1 && t == -1 = (x, y)
    | z == -1 = (x, t)
    | t == -1 = (z, y)
    | otherwise = (z, t)

--ver
recuperoDeGusto :: (Int, Int) -> (Int, Int) -> Bool
recuperoDeGusto (x, y) (z, t) = promociono (x, y) && not(promociono (z, t)) || not(promociono (x, y)) && promociono (z, t)


esMayorDeEdad :: (String, Int) -> Bool
esMayorDeEdad = (>=21) . snd