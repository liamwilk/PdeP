-- Modelo inicial
data Jugador = UnJugador {
  nombre :: String,
  padre :: String,
  habilidad :: Habilidad
} deriving (Eq, Show)

data Habilidad = Habilidad {
  fuerzaJugador :: Int,
  precisionJugador :: Int
} deriving (Eq, Show)

-- Jugadores de ejemplo
bart :: Jugador
bart = UnJugador "Bart" "Homero" (Habilidad 25 60)
todd :: Jugador
todd = UnJugador "Todd" "Ned" (Habilidad 15 80)
rafa :: Jugador
rafa = UnJugador "Rafa" "Gorgory" (Habilidad 10 1)

data Tiro = UnTiro {
  velocidad :: Int,
  precision :: Int,
  altura :: Int
} deriving (Eq, Show)

type Puntos = Int

-- Funciones útiles
between :: (Eq a, Enum a) => a -> a -> a -> Bool
between n m x = x `elem` [n .. m]

maximoSegun :: (Foldable t, Ord a1) => (a2 -> a1) -> t a2 -> a2
maximoSegun f = foldl1 (mayorSegun f)
mayorSegun :: Ord a => (t -> a) -> t -> t -> t
mayorSegun f a b
  | f a > f b = a
  | otherwise = b

-- Modelar los palos usados en el juego que a partir de una determinada habilidad generan un tiro que se compone por velocidad, precisión y altura.
-- El putter genera un tiro con velocidad igual a 10, el doble de la precisión recibida y altura 0.

type Palo = Habilidad -> Tiro

putter :: Palo
putter habilidad = UnTiro 10 (precisionJugador habilidad * 2) 0

-- La madera genera uno de velocidad igual a 100, altura igual a 5 y la mitad de la precisión.
madera :: Palo
madera habilidad = UnTiro 100 (div (precisionJugador habilidad)  2) 5

{- Los hierros, que varían del 1 al 10 (número al que denominaremos n), generan un tiro de velocidad igual a la fuerza multiplicada por n, la precisión dividida por n y una altura de n-3 (con mínimo 0). 
Modelarlos de la forma más genérica posible. -}
hierros :: Int -> Palo
hierros n habilidad = UnTiro (fuerzaJugador habilidad * n) (div (precisionJugador habilidad) n) (max 0 (n-3))

-- Definir una constante palos que sea una lista con todos los palos que se pueden usar en el juego.
palos :: [Palo]
palos = [putter, madera] ++ map hierros [1..10]

-- Definir la función golpe que dados una persona y un palo, obtiene el tiro resultante de usar ese palo con las habilidades de la persona.
golpe :: Jugador -> Palo -> Tiro
golpe jugador palo = palo (habilidad jugador)

{- Lo que nos interesa de los distintos obstáculos es si un tiro puede superarlo, y en el caso de poder superarlo, cómo se ve afectado dicho tiro por el obstáculo. 
En principio necesitamos representar los siguientes obstáculos: -}

{- Un túnel con rampita sólo es superado si la precisión es mayor a 90 yendo al ras del suelo, independientemente de la velocidad del tiro. Al salir del túnel la velocidad del tiro se 
duplica, la precisión pasa a ser 100 y la altura 0. -}
type Obstaculo = Tiro -> Bool

tunelConRampita :: Obstaculo
tunelConRampita tiro = precision tiro > 90 && rasDelSuelo tiro

rasDelSuelo :: Tiro -> Bool
rasDelSuelo = (== 0) . altura

{- Una laguna es superada si la velocidad del tiro es mayor a 80 y tiene una altura de entre 1 y 5 metros. Luego de superar una laguna el tiro llega con la misma velocidad y 
precisión, pero una altura equivalente a la altura original dividida por el largo de la laguna. -}
laguna :: Obstaculo
laguna tiro = velocidad tiro > 80 && between 1 5 (altura tiro)

-- Un hoyo se supera si la velocidad del tiro está entre 5 y 20 m/s yendo al ras del suelo con una precisión mayor a 95. Al superar el hoyo, el tiro se detiene, quedando con todos sus componentes en 0.
hoyo :: Obstaculo
hoyo tiro = between 5 20 (velocidad tiro) && rasDelSuelo tiro && precision tiro > 95

-- Definir palosUtiles que dada una persona y un obstáculo, permita determinar qué palos le sirven para superarlo.
palosUtiles :: Jugador -> Obstaculo -> [Palo]
palosUtiles jugador obstaculo = filter (leSirve jugador obstaculo) palos

leSirve :: Jugador -> Obstaculo -> Palo -> Bool
leSirve jugador obstaculo palo = obstaculo (golpe jugador palo)

-- Saber, a partir de un conjunto de obstáculos y un tiro, cuántos obstáculos consecutivos se pueden superar.
obstaculosASuperar :: [Obstaculo] -> Tiro -> Int
obstaculosASuperar obstaculos tiro = length (takeWhile id (map (\obstaculo -> obstaculo tiro) obstaculos))

-- Definir paloMasUtil que recibe una persona y una lista de obstáculos y determina cuál es el palo que le permite superar más obstáculos con un solo tiro.
paloMasUtil :: Jugador -> [Obstaculo] -> Palo
paloMasUtil jugador obstaculos = maximoSegun (obstaculosASuperar obstaculos . golpe jugador) palos

{- Dada una lista de tipo [(Jugador, Puntos)] que tiene la información de cuántos puntos ganó cada niño al finalizar el torneo, se pide retornar la lista de padres que 
pierden la apuesta por ser el “padre del niño que no ganó”. Se dice que un niño ganó el torneo si tiene más puntos que los otros niños. -}
padresQuePierden :: [(Jugador, Puntos)] -> [String]
padresQuePierden puntos = map (padre . fst) (filter (not . gana puntos) puntos)

gana :: (Ord b, Eq a) => [(a, b)] -> (a, b) -> Bool
gana puntos (jugador, puntosJugador) = all ((< puntosJugador) . snd) (filter (/= (jugador, puntosJugador)) puntos)