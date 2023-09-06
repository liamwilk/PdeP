import Text.Show.Functions
data Nave = UnaNave{
    nombre :: String,
    durabilidad :: Int,
    escudo :: Int,
    ataque :: Int,
    poderes :: [Accion]
} deriving (Show)

type Accion = Nave -> Nave
turbo :: Accion
turbo unaNave = unaNave {ataque = ataque unaNave + 25}

reparacionDeEmergencia :: Accion
reparacionDeEmergencia unaNave = unaNave {durabilidad = durabilidad unaNave + 50, ataque = ataque unaNave - 30}

superTurbo :: Accion
superTurbo unaNave = (turbo.turbo.turbo) unaNave {durabilidad = durabilidad unaNave - 45}

incrementarEscudos :: Accion
incrementarEscudos unaNave = unaNave {escudo = escudo unaNave + 100}

poderEspecial :: Accion
poderEspecial = turbo . incrementarEscudos

{- Naves -}

tieFighter :: Nave
tieFighter = UnaNave "Tie Fighter" 200 100 50 [turbo]

xWing :: Nave
xWing = UnaNave "X Wing" 300 150 100 [reparacionDeEmergencia]

naveDarthVader :: Nave
naveDarthVader = UnaNave "Nave de Darth Vader" 500 300 200 [superTurbo]

milleniumFalcon :: Nave
milleniumFalcon = UnaNave "Millenium Falcon" 1000 500 50 [reparacionDeEmergencia, incrementarEscudos]

ussEnterprise :: Nave
ussEnterprise = UnaNave "USS Enterprise" 1000 300 120 [poderEspecial]

{- Durabilidad de una flota -}
type Flota = [Nave]

durabilidadTotal :: [Nave] -> Int
durabilidadTotal flota = sum (map durabilidad flota)

{- Saber cómo queda una nave luego de ser atacada por otra. Cuando ocurre un ataque ambas naves primero activan su poder especial y luego la nave atacada reduce su durabilidad según el daño recibido, 
que es la diferencia entre el ataque de la atacante y el escudo de la atacada. (si el escudo es superior al ataque, la nave atacada no es afectada). 
La durabilidad, el escudo y el ataque nunca pueden ser negativos, a lo sumo 0. -}

activarPoderNave :: Nave -> Nave
activarPoderNave unaNave = foldl (flip ($)) unaNave (poderes unaNave)

ataqueNaves :: Nave -> Nave -> Nave
ataqueNaves naveAtacante naveAtacada
    | ataque naveAtacante > escudo naveAtacada = naveAtacada {durabilidad = durabilidad naveAtacada - (ataque naveAtacante - escudo naveAtacada)}
    | otherwise = naveAtacada

estadoNave :: Nave -> Nave -> Nave
estadoNave naveAtacante naveAtacada = activarPoderNave (ataqueNaves naveAtacante naveAtacada)

naveFueraDeCombate :: Nave -> Bool
naveFueraDeCombate nave = durabilidad nave == 0

{- Estrategias -}
type Estrategia = Nave -> Bool

naveDebil :: Estrategia
naveDebil unaNave = escudo unaNave < 200

navesPeligrosas :: Int -> Estrategia
navesPeligrosas valor unaNave = ataque unaNave > valor

navesQueQuedarianFuera :: Estrategia
navesQueQuedarianFuera = naveFueraDeCombate

misionSorpresa :: Nave -> Flota -> Estrategia -> Flota
misionSorpresa nave flota estrategia = map (estadoNave nave) (filter estrategia flota)

{- Considerando una nave y una flota enemiga en particular, dadas dos estrategias, determinar cuál de ellas es la que minimiza la durabilidad total de la flota atacada y llevar adelante una misión con ella. -}

estrategiaOptima :: Nave -> Flota -> Estrategia -> Estrategia -> Flota
estrategiaOptima nave flota estrategia1 estrategia2
    | durabilidadTotal (misionSorpresa nave flota estrategia1) < durabilidadTotal (misionSorpresa nave flota estrategia2) = misionSorpresa nave flota estrategia1
    | otherwise = misionSorpresa nave flota estrategia2