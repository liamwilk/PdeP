data Turista = UnTurista {
    nivelDeStress :: Int,
    nivelDeCansancio :: Int,
    viajaSolo :: Bool,
    idiomas :: [String]
} deriving (Show, Eq)

-- Ir a la playa: si está viajando solo baja el cansancio en 5 unidades, si no baja el stress 1 unidad.
irAPlaya :: Turista -> Turista
irAPlaya turista
    | viajaSolo turista = turista { nivelDeCansancio = nivelDeCansancio turista - 5 }
    | otherwise = turista { nivelDeStress = nivelDeStress turista - 1 }

-- Apreciar algún elemento del paisaje: reduce el stress en la cantidad de letras de lo que se aprecia. 
apreciarElemento :: String -> Turista -> Turista
apreciarElemento elemento turista = turista { nivelDeStress = nivelDeStress turista - length elemento }

-- Salir a hablar un idioma específico: el turista termina aprendiendo dicho idioma y continúa el viaje acompañado.
hablarIdiomaEspecifico :: String -> Turista -> Turista
hablarIdiomaEspecifico idioma turista = turista { idiomas = idiomas turista ++ [idioma], viajaSolo = False}

-- Caminar ciertos minutos: aumenta el cansancio pero reduce el stress según la intensidad de la caminad, ambos en la misma cantidad. El nivel de intensidad se calcula en 1 unidad cada 4 minutos que se caminen.
caminarMinutos :: Int -> Turista -> Turista
caminarMinutos minutos turista = turista { nivelDeCansancio = nivelDeCansancio turista + minutos `div` 4, nivelDeStress = nivelDeStress turista - minutos `div` 4 }

{- Paseo en barco: depende de cómo esté la marea
si está fuerte, aumenta el stress en 6 unidades y el cansancio en 10.
si está moderada, no pasa nada.
si está tranquila, el turista camina 10’ por la cubierta, aprecia la vista del “mar”, y sale a hablar con los tripulantes alemanes.
-}

paseoEnBarco :: String -> Turista -> Turista
paseoEnBarco marea turista
    | marea == "fuerte" = turista { nivelDeStress = nivelDeStress turista + 6, nivelDeCansancio = nivelDeCansancio turista + 10 }
    | marea == "moderada" = turista
    | marea == "tranquila" = (apreciarElemento "mar" . hablarIdiomaEspecifico "alemán" . caminarMinutos 10) turista
    | otherwise = error "no definido"

-- Ana: está acompañada, sin cansancio, tiene 21 de stress y habla español.
ana :: Turista
ana = UnTurista 21 0 False ["español"]

-- Beto y Cathi, que hablan alemán, viajan solos, y Cathi además habla catalán. Ambos tienen 15 unidades de cansancio y stress.
beto :: Turista
beto = UnTurista 15 15 True ["alemán"]

cathi :: Turista
cathi = UnTurista 15 15 True ["alemán", "catalán"]

-- Modelar las excursiones anteriores de forma tal que para agregar una excursión al sistema no haga falta modificar las funciones existentes.
type Excursion = Turista -> Turista

-- Hacer que un turista haga una excursión. Al hacer una excursión, el turista además de sufrir los efectos propios de la excursión, reduce en un 10% su stress.
hacerExcursion :: Excursion -> Turista -> Turista
hacerExcursion excursion turista = excursion turista { nivelDeStress = nivelDeStress turista - (nivelDeStress turista `div` 10) }

{- Definir la función deltaExcursionSegun que a partir de un índice, un turista y una excursión determine cuánto varió dicho índice 
después de que el turista haya hecho la excursión. Llamamos índice a cualquier función que devuelva un número a partir de un turista. -}
deltaSegun :: (a -> Int) -> a -> a -> Int
deltaSegun f algo1 algo2 = f algo1 - f algo2

deltaExcursionSegun :: (Turista -> Int) -> Excursion -> Turista -> Int
deltaExcursionSegun indice excursion turista = deltaSegun indice turista (hacerExcursion excursion turista)

-- Saber si una excursión es educativa para un turista, que implica que termina aprendiendo algún idioma.
excursionEsEducativa :: Excursion -> Turista -> Bool
excursionEsEducativa excursion turista = length (idiomas turista) < length (idiomas (hacerExcursion excursion turista))

-- Conocer las excursiones desestresantes para un turista. Estas son aquellas que le reducen al menos 3 unidades de stress al turista.
excursionesDesestresantes :: Excursion -> Turista -> Bool
excursionesDesestresantes excursion turista = deltaExcursionSegun nivelDeStress excursion turista >= 3

{- Completo: Comienza con una caminata de 20 minutos para apreciar una "cascada", luego se camina 40 minutos hasta una playa, y 
finaliza con una salida con gente local que habla "melmacquiano". -}
packCompleto :: Excursion
packCompleto = apreciarElemento "cascada" . caminarMinutos 20 . irAPlaya . hablarIdiomaEspecifico "melmacquiano" . caminarMinutos 40

{- Lado B: Este tour consiste en ir al otro lado de la isla a hacer alguna excursión (de las existentes) que elija el turista. 
Primero se hace un paseo en barco por aguas tranquilas (cercanas a la costa) hasta la otra punta de la isla, luego realiza la 
excursión elegida y finalmente vuelve caminando hasta la otra punta, tardando 2 horas. -}
packLadoB :: Excursion
packLadoB = paseoEnBarco "tranquila" . caminarMinutos 120

{- Isla Vecina: Se navega hacia una isla vecina para hacer una excursión. Esta excursión depende de cómo esté la marea al llegar 
a la otra isla: si está fuerte se aprecia un "lago", sino se va a una playa. En resumen, este tour implica hacer un paseo en 
barco hasta la isla vecina, luego llevar a cabo dicha excursión, y finalmente volver a hacer un paseo en barco de regreso. La marea 
es la misma en todo el camino. -}
packIslaVecina :: Excursion
packIslaVecina = paseoEnBarco "fuerte" . apreciarElemento "lago" . paseoEnBarco "fuerte"

{- Hacer que un turista haga un tour. Esto implica, primero un aumento del stress en tantas unidades como cantidad de 
excursiones tenga el tour, y luego realizar las excursiones en orden. -}
hacerTour :: [Excursion] -> Turista -> Turista
hacerTour excursiones turista = foldl (flip hacerExcursion) (turista { nivelDeStress = nivelDeStress turista + length excursiones }) excursiones

{- Dado un conjunto de tours, saber si existe alguno que sea convincente para un turista. Esto significa que el tour tiene 
alguna excursión desestresante la cual, además, deja al turista acompañado luego de realizarla. -}
tourConvincente :: [Excursion] -> Turista -> Bool
tourConvincente tours turista = any (\tour -> excursionesDesestresantes tour turista && estaAcompaniado (hacerTour tours turista)) tours

estaAcompaniado :: Turista -> Bool
estaAcompaniado turista = turista == turista { viajaSolo = False }

{- Saber la efectividad de un tour para un conjunto de turistas. Esto se calcula como la sumatoria de la espiritualidad recibida de cada turista 
a quienes les resultó convincente el tour. 
La espiritualidad que recibe un turista es la suma de las pérdidas de stress y cansancio tras el tour. -}
efectividad :: [Excursion] -> [Turista] -> Int
efectividad tours turistas = sum (map (`espiritualidad` tours) turistas)

espiritualidad :: Turista -> [Excursion] -> Int
espiritualidad turista tours = deltaExcursionSegun nivelDeStress (hacerTour tours) turista + deltaExcursionSegun nivelDeCansancio (hacerTour tours) turista


