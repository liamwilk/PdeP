sum :: [Int] -> Int
sum = foldr (+) 0

frecuenciaCardiaca :: [Int]
frecuenciaCardiaca = [80, 100, 120, 128, 130, 123, 125]
promedioFrecuenciaCardiaca :: [Int] -> Float
promedioFrecuenciaCardiaca x = fromIntegral (Prelude.sum x) / fromIntegral (length x)


numeroMuestra :: Int -> Int
numeroMuestra minuto = (minuto `div` 10) - 1

frecuenciaCardiacaMinuto :: Int -> Int
frecuenciaCardiacaMinuto minuto = frecuenciaCardiaca !! numeroMuestra minuto

frecuenciasHastaMomento :: Int -> [Int]
frecuenciasHastaMomento min = take (numeroMuestra min) frecuenciaCardiaca

esCapicua :: [String] -> Bool
esCapicua x = concat x == reverse (concat x)

duracionLlamadas = (("horarioReducido",[20,10,25,15]), ("horarioNormal",[10,5,8,2,9,10]))

cuandoHabloMasMinuto :: String
cuandoHabloMasMinuto
    | Prelude.sum (snd (fst duracionLlamadas)) > Prelude.sum (snd (snd duracionLlamadas)) = "horarioReducido"
    | otherwise = "horarioNormal"

cuandoHizoMasLlamadas :: String
cuandoHizoMasLlamadas = if length (snd (fst duracionLlamadas)) > length (snd (snd duracionLlamadas)) then "horarioReducido" else "horarioNormal"

existsAny f (x, y, z) = any f [x, y, z]

mejor f g x
    | f x > g x = f x
    | otherwise = g x


aplicarPar f (x, y) = (f x, f y)

parDeFns f g x = (f x, g x)

esMultiploDeAlguno :: Int -> [Int] -> Bool
esMultiploDeAlguno x = any (\y -> mod x y == 0)

average :: [Float] -> Float
average xs = Prelude.sum xs / fromIntegral (length xs)

promedios :: [[Float]] -> [Float]
promedios = map average

promediosSinAplazos :: [[Float]] -> [Float]
promediosSinAplazos = map (average . filter (>= 4))

mejoresNotas :: [[Float]] -> [Float]
mejoresNotas = map maximum

aprobo :: [Float] -> Bool
aprobo = all (>= 6)

aprobaron :: [[Float]] -> [[Float]]
aprobaron = filter aprobo

divisores :: Int -> [Int]
divisores x = filter (\y -> mod x y == 0) [1..x]

exists :: Foldable t => (a -> Bool) -> t a -> Bool
exists = any

hayAlgunNegativo :: [Int] -> (Int, Int) -> Bool
hayAlgunNegativo x (y, z) = any (< 0) (take z (drop y x))

aplicarFunciones :: [a -> b] -> a -> [b]
aplicarFunciones funciones valor = map (\f -> f valor) funciones

sumaF :: Num a1 => [a2 -> a1] -> a2 -> a1
sumaF funciones valor = Prelude.sum (aplicarFunciones funciones valor)


subirHabilidad :: Int -> [Int] -> [Int]
subirHabilidad x = map (\y -> min (y + x) 12)


flimitada f n = min (max (f n) 0) 12

cambiarHabilidad = map . flimitada

primerosPares = takeWhile even

primerosDivisores n = takeWhile (\x -> mod n x == 0)

primerosNoDivisores n = takeWhile (\x -> mod n x /= 0)

huboMesMejorDe :: [Int] -> [Int] -> Int -> Bool
huboMesMejorDe x y z = any (> z) (zipWith (+) x y)


crecimientoAnual :: Int -> Int
crecimientoAnual edad
    | edad <= 10 = 24 - (edad * 2)
    | edad <= 15 = 24 - edad
    | otherwise = 0