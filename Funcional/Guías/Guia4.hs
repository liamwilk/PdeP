frecuenciaCardiaca :: [Int]
frecuenciaCardiaca = [80, 100, 120, 128, 130, 123, 125]

promedioFrecuenciaCardiaca :: Float
promedioFrecuenciaCardiaca = fromIntegral (sum frecuenciaCardiaca) / fromIntegral (length frecuenciaCardiaca)

numeroMuestra :: Int -> Int
numeroMuestra minuto = minuto `div` 10

frecuenciaCardiacaMomento :: Int -> Int
frecuenciaCardiacaMomento m = frecuenciaCardiaca !! numeroMuestra m

frecuenciasHastaMomento :: Int -> [Int]
frecuenciasHastaMomento m = take (numeroMuestra m) frecuenciaCardiaca

esCapicua :: [String] -> Bool
esCapicua x = concat x == reverse (concat x)

duracionLlamadas = (("horarioReducido",[20,10,25,15]), ("horarioNormal",[10,5,8,2,9,10]))

cuandoHabloMasMinutos :: String
cuandoHabloMasMinutos
        | sum (snd . fst $ duracionLlamadas) > sum (snd . snd $ duracionLlamadas) = "horarioReducido"
        | otherwise = "horarioNormal"

cuandoHizoMasLlamadas :: String
cuandoHizoMasLlamadas
        | length (snd . fst $ duracionLlamadas) > length (snd . snd $ duracionLlamadas) = "horarioReducido"
        | otherwise = "horarioNormal"

existsAny f (x, y, z)
        | f x = True
        | f y = True
        | f z = True
        | otherwise = False

mejor f g x = max (f x) (g x)

aplicarPar f (x, y) = (f x, f y)

parDeFns f g x = (f x, g x)

esMultiploDeAlguno :: Int -> [Int] -> Bool
esMultiploDeAlguno num = any (\x -> mod num x == 0)

promedios :: [[Float]] -> [Float]
promedios = map (\y -> sum y / fromIntegral (length y))

promediosSinAplazos :: [[Float]] -> [Float]
promediosSinAplazos = promedios . filter (all (>4))

mejoresNotasDeCadaUno :: [[Float]] -> [Float]
mejoresNotasDeCadaUno = map maximum

aprobo :: [Int] -> Bool
aprobo = all (>=6)

aprobaron :: [[Int]] -> [[Int]]
aprobaron = filter aprobo

exists :: (a -> Bool) -> [a] -> Bool
exists = any

hayAlgunNegativo :: [Int] -> Bool
hayAlgunNegativo = any (<0)


aplicarFunciones funciones num = map (\f -> f num) funciones

