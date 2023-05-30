-- De cada auto conocemos su color (que nos servirá para identificarlo durante el desarrollo de la carrera), la velocidad a la que está yendo y la distancia que recorrió, ambos valores de tipo entero.
-- De la carrera sólo nos interesa el estado actual de los autos que están participando, lo cual nos permitirá analizar cómo viene cada uno, y posteriormente procesar aquellos eventos que se den en la carrera para determinar el resultado de la misma.
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use newtype instead of data" #-}

data Auto = UnAuto {
    color :: String,
    velocidad :: Int,
    distancia :: Int
} deriving (Show, Eq)

data Carrera = UnaCarrera {
    autos :: [Auto]
} deriving (Show, Eq)

-- Saber si un auto está cerca de otro auto, que se cumple si son autos distintos y la distancia que hay entre ellos (en valor absoluto) es menor a 10.
estaCerca :: Auto -> Auto -> Bool
estaCerca auto1 auto2 = auto1 /= auto2 && abs (distancia auto1 - distancia auto2) < 10

-- Saber si un auto va tranquilo en una carrera, que se cumple si no tiene ningún auto cerca y les va ganando a todos (por haber recorrido más distancia que los otros).
vaTranquilo :: Auto -> Carrera -> Bool
vaTranquilo auto = not . any (estaCerca auto) . autos

-- Conocer en qué puesto está un auto en una carrera, que es 1 + la cantidad de autos de la carrera que le van ganando.
puesto :: Auto -> Carrera -> Int
puesto auto =  (+1) . length . filter (leGana auto) . autos

leGana :: Auto -> Auto -> Bool
leGana auto1 auto2 = distancia auto1 > distancia auto2

{- Hacer que un auto corra durante un determinado tiempo. Luego de correr la cantidad de tiempo indicada, la distancia recorrida por el auto debería ser equivalente a la distancia que llevaba recorrida, 
la distancia recorrida por el auto debería ser equivalente a la distancia que llevaba recorrida + ese tiempo * la velocidad a la que estaba yendo. -}
corra :: Int -> Auto -> Auto
corra minutos auto = auto {distancia = distancia auto + (minutos * velocidad auto)}

{- A partir de un modificador de tipo Int -> Int, queremos poder alterar la velocidad de un auto de modo que su velocidad final 
sea la resultante de usar dicho modificador con su velocidad actual. -}

modifiqueVelocidad :: (Int -> Int) -> Auto -> Auto
modifiqueVelocidad modificador auto = auto {velocidad = velocidad auto + modificador (velocidad auto)}

{- Usar la función del punto anterior para bajar la velocidad de un auto en una cantidad indicada de modo que se le reste 
a la velocidad actual la cantidad indicada, y como mínimo quede en 0, ya que no es válido que un auto quede con velocidad negativa. -}

bajarVelocidad :: Int -> Auto -> Auto
bajarVelocidad cantidad = modifiqueVelocidad (max 0 . subtract cantidad)

{- Como se explicó inicialmente sobre las carreras que queremos simular, los autos que participan pueden gatillar poderes 
especiales a los que denominamos power ups. Estos poderes son variados y tienen como objetivo impactar al estado general de la carrera, ya 
sea afectando al auto que lo gatilló y/o a sus contrincantes dependiendo de qué poder se trate. -}

afectarALosQueCumplen :: (a -> Bool) -> (a -> a) -> [a] -> [a]
afectarALosQueCumplen criterio efecto lista = (map efecto . filter criterio) lista ++ filter (not.criterio) lista


-- terremoto: luego de usar este poder, los autos que están cerca del que gatilló el power up bajan su velocidad en 50.

terremoto :: PowerUp
terremoto auto = afectarALosQueCumplen (estaCerca auto) (bajarVelocidad 50)

{- miguelitos: este poder debe permitir configurarse con una cantidad que indica en cuánto deberán bajar la velocidad los autos 
que se vean afectados por su uso. Los autos a afectar son aquellos a los cuales el auto que gatilló el power up les vaya ganando. -}

miguelitos :: Int -> PowerUp
miguelitos cantidad auto = afectarALosQueCumplen (leGana auto) (bajarVelocidad cantidad)

{- jet pack: este poder debe afectar, dentro de la carrera, solamente al auto que gatilló el poder. El jet pack tiene un impacto que dura 
una cantidad limitada de tiempo, el cual se espera poder configurar. Cuando se activa el poder del jet pack, el auto afectado duplica 
su velocidad actual, luego corre durante el tiempo indicado y finalmente su velocidad vuelve al valor que tenía antes de que se active el poder.
Por simplicidad, no se espera que los demás autos que participan de la carrera también avancen en ese tiempo. -}

jetpack :: Int -> PowerUp
jetpack tiempo auto = afectarALosQueCumplen (== auto) (corra tiempo . modifiqueVelocidad (*2))

type Color = String
type Evento = Carrera -> Carrera
type TablaDePosiciones = [(Int, Color)]

{- Desarrollar la función:
simularCarrera :: Carrera -> [Carrera -> Carrera] -> [(Int, Color)]
que permita obtener la tabla de posiciones a partir del estado final de la carrera, el cual se obtiene 
produciendo cada evento uno detrás del otro, partiendo del estado de la carrera recibido. -}

simularCarrera :: Carrera -> [Carrera -> Carrera] -> TablaDePosiciones
simularCarrera carrera eventos = zip [1..] (map color (autos (foldl (flip ($)) carrera eventos)))

-- correnTodos que hace que todos los autos que están participando de la carrera corran durante un tiempo indicado.
correnTodos :: Int -> [Auto] -> [Auto]
correnTodos tiempo = map (corra tiempo)

{- usaPowerUp que a partir de un power up y del color del auto que gatilló el poder en cuestión, encuentre el auto correspondiente dentro 
del estado actual de la carrera para usarlo y produzca los efectos esperados para ese power up. -}

type PowerUp = (Auto->[Auto]->[Auto])

usaPowerUp :: PowerUp -> Color -> Carrera -> Carrera
usaPowerUp powerup color carrera = carrera { autos = powerup (autoDeColor color carrera) (autos carrera) }

autoDeColor :: Color -> Carrera -> Auto
autoDeColor colorBuscado = head . filter (\auto -> color auto == colorBuscado) . autos

