data Personaje = UnPersonaje{
    nombre :: String,
    dinero :: Int,
    felicidad :: Int
} deriving (Show, Eq)


{- Actividades que pueden realizar -}
type Actividad = Personaje -> Personaje

irAEscuela :: Actividad
irAEscuela unPersonaje
    | esLisa unPersonaje = unPersonaje {felicidad = felicidad unPersonaje + 20}
    | otherwise = unPersonaje {felicidad = felicidad unPersonaje - 20}

esLisa :: Personaje -> Bool
esLisa unPersonaje = nombre unPersonaje == "Lisa"

comerDonas :: Int -> Actividad
comerDonas cantidad unPersonaje = unPersonaje {felicidad = felicidad unPersonaje + (cantidad * 10), dinero = dinero unPersonaje - (cantidad * 10)}

irATrabajar :: String -> Actividad
irATrabajar lugar unPersonaje
    | lugar == "planta nuclear" = unPersonaje {dinero = dinero unPersonaje + 14}
    | lugar == "escuela elemental" = irAEscuela unPersonaje
    | lugar == "mafia" = unPersonaje {dinero = dinero unPersonaje + 5}
    | otherwise = unPersonaje

jugarBowling:: Actividad
jugarBowling unPersonaje = unPersonaje {felicidad = felicidad unPersonaje +30, dinero = dinero unPersonaje - 15}


{- Personajes de muestra -}

homero :: Personaje
homero = UnPersonaje "Homero" 150 70
skinner :: Personaje
skinner = UnPersonaje "Skinner" 70 40
lisa :: Personaje
lisa = UnPersonaje "Lisa" 45 60
burns :: Personaje
burns = UnPersonaje "Burns" 200 20


{- Logros que puede alcanzar una persona -}

type Logro = Personaje -> Bool

tieneMasDineroQueAlguien :: Personaje -> Personaje -> Bool
tieneMasDineroQueAlguien unPersonaje1 unPersonaje2 = dinero unPersonaje1 > dinero unPersonaje2

serMillonario :: Logro
serMillonario unPersonaje = tieneMasDineroQueAlguien unPersonaje burns

alegrarse :: Int -> Logro
alegrarse nivelDeseado unPersonaje = nivelDeseado > felicidad unPersonaje

irAVerKrosti :: Logro
irAVerKrosti unPersonaje = dinero unPersonaje >= 10

esDecisiva :: Logro -> Actividad -> Personaje -> Bool
esDecisiva unLogro unaActividad unPersonaje = unLogro (unaActividad unPersonaje) && not (unLogro unPersonaje)

{- Dada una persona, un logro a alcanzar y una serie de actividades, encontrar la primera de ellas que sea decisiva y hacer que la persona la realice obteniendo cómo queda dicha persona. 
En caso que no haya ninguna decisiva, la persona permanece igual.  -}

hayAccionDecisiva :: Personaje -> Logro -> [Actividad] -> Bool
hayAccionDecisiva unPersonaje unLogro = any (\actividad -> esDecisiva unLogro actividad unPersonaje)

primeraAccionDecisiva :: Personaje -> Logro -> [Actividad] -> Personaje
primeraAccionDecisiva unPersonaje unLogro actividades
    | hayAccionDecisiva unPersonaje unLogro actividades = head actividades unPersonaje
    | otherwise = unPersonaje
