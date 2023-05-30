data Chico = Chico {
    nombre :: String,
    edad :: Int,
    habilidades :: [String],
    deseos :: [String]
} deriving (Show, Eq)

data Chica = Chica {
    nombres :: String,
    condicion :: Chico -> Bool
}

-- aprenderHabilidades agrega una lista de habilidades nuevas a las que ya tiene el chico
aprenderHabilidades :: [String] -> Chico -> Chico
aprenderHabilidades nuevashabilidades chico = chico {habilidades = habilidades chico ++ nuevashabilidades}

-- dado un chico, le agrega las habilidades de jugar a todas las versiones pasadas y futuras del Need For Speed, que son: “jugar need for speed 1”, “jugar need for speed 2”, etc.
serGrosoEnNeedForSpeed :: Chico -> Chico
serGrosoEnNeedForSpeed chico = chico {habilidades = habilidades chico ++ map (("jugar need for speed " ++) . show) [1..]}

-- Hace que el chico tenga 18 años.
serMayor :: Chico -> Chico
serMayor chico = chico {edad = 18}

-- wanda: dado un chico, wanda le cumple el primer deseo de la lista y lo hace madurar (crecer un año de edad).

wanda :: Chico -> Chico
wanda chico = chico {edad = edad chico + 1, deseos = tail (deseos chico)}

-- cosmo: dado un chico, lo hace “des”madurar, quedando con la mitad de años de edad. Como es olvidadizo, no le concede ningún deseo.

cosmo :: Chico -> Chico
cosmo chico = chico {edad = div (edad chico) 2 }

-- muffinMagico: dado un chico le concede todos sus deseos.

muffinMagico :: Chico -> Chico
muffinMagico chico = chico {deseos = []}

-- Dado un chico y una habilidad, dice si la posee.
tieneHabilidad :: String -> Chico -> Bool
tieneHabilidad unaHabilidad chico = unaHabilidad `elem` habilidades chico

-- Dado un chico dice si es mayor de edad (es decir, tiene más de 18 años) y además sabe manejar.
esSuperMaduro :: Chico -> Bool
esSuperMaduro chico = edad chico > 18 && tieneHabilidad "manejar" chico

-- Dada una chica y una lista de pretendientes, devuelve al que se queda con la chica, es decir, el primero que cumpla con la condición que ella quiere. Si no hay ninguno que la cumpla, devuelve el último pretendiente (una chica nunca se queda sola). (Sólo en este punto se puede usar recursividad)
quienConquistaA :: Chica -> [Chico] -> Chico
quienConquistaA chica pretendientes = head (filter (condicion chica) pretendientes)

-- Dada una lista de chicos, devuelve la lista de los nombres de aquellos que tienen deseos prohibidos. Un deseo está prohibido si, al aplicarlo, entre las cinco primeras habilidades, hay alguna prohibida. En tanto, son habilidades prohibidas enamorar, matar y dominar el mundo.

tieneHabilidadProhibida :: [String] -> Bool
tieneHabilidadProhibida = any (`elem` ["enamorar", "matar", "dominar el mundo"])

infractoresDeDaRules :: [Chico] -> [Chico]
infractoresDeDaRules = filter (tieneHabilidadProhibida . take 5 . habilidades)