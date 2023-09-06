fst3 :: (Int, Int, Int) -> Int
fst3 (x, _, _) = x

snd3 :: (Int, Int, Int) -> Int
snd3 (_, y, _) = y

trd3 :: (Int, Int, Int) -> Int
trd3 (_, _, z) = z

aplicar (x, y) z = (x z, y z)

cuentaBizarra (x, y)
    | x > y = x + y
    | y > 10 + x = y - x
    | otherwise = x * y

esNotaBochazo :: Int -> Bool
esNotaBochazo = (<6)

aprobo :: (Int, Int) -> Bool
aprobo (nota1, nota2) = not (esNotaBochazo nota1) && not (esNotaBochazo nota2)

promociono :: (Int, Int) -> Bool
promociono (nota1, nota2) = nota1 + nota2 >= 15 && nota1 >= 7 && nota2>=7



notasFinales :: (Int, Int) -> (Int, Int) -> (Int, Int)
notasFinales (x, y) (z, t)
    | z == -1 && t == -1 = (x, y)
    | z == -1 = (x, t)
    | t == -1 = (z, y)
    | otherwise = (z, t)

recuperoDeGusto :: (Int, Int) -> (Int, Int) -> Bool
recuperoDeGusto (nota1, nota2) (recu1, recu2) = promociono (nota1, nota2) && recu1 /= -1 && recu2 /= -1

esMayorDeEdad :: (String, Int) -> Bool
esMayorDeEdad = (>21) . snd