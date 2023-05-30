data Peliculas = UnaPelicula {
    nombre :: String,
    actores :: [String],
    duracion :: Int,
    estreno :: Int
} deriving (Show, Eq)



-- Se quiere saber si un determinado actor trabajó en una película
actorTrabajoEnPelicula :: String -> Peliculas -> Bool
actorTrabajoEnPelicula actor pelicula = actor `elem` actores pelicula

-- Se quiere verificar si es cierto que una película es de cierto género, lo cual se deduce de sus actores. Si la mayoría de los actores son de un determinado género, entonces la película es de dicho género.
todosLosActores :: [(String, [String])]
todosLosActores = [("comedia", ["Carrey", "Grint", "Stiller"]),("accion", ["Stallone", "Willis","Schwarzenegger"]), ("drama", ["De Niro", "Foster"])]

actoresDeGenero :: String -> [String]
actoresDeGenero genero = snd (head (filter (\x -> fst x == genero) todosLosActores))

peliculaEsDeGenero :: String -> Peliculas -> Bool
peliculaEsDeGenero genero pelicula = length (filter (\x -> x `elem` actoresDeGenero genero) (actores pelicula)) > length (actores pelicula) `div` 2

{- Existen diversos premios a las películas, como ser:
Clásico setentista: cuando la película se estrenó entre 1970 y 1979
Plomo: si la película dura más de 3 horas
Tres son multitud: cuando una película tiene tres actores.
N son multitud: cuando una película tiene N actores. 
a) Definir lo que sea necesario para poder averiguar si una película ganó un determinado premio.
c) Mostrar ejemplos de invocación y respuesta
d) Inventar un nuevo premio, consistente con los anteriores.
-}

type Premio = Peliculas -> Bool
clasicoSetentista :: Premio
clasicoSetentista pelicula = estreno pelicula >= 1970 && estreno pelicula <= 1979

plomo :: Premio
plomo pelicula = duracion pelicula > 180

tresSonMultitud :: Premio
tresSonMultitud pelicula = length (actores pelicula) == 3

nSonMultitud :: Int -> Premio
nSonMultitud n pelicula = length (actores pelicula) == n

premioVejez :: Premio
premioVejez pelicula = estreno pelicula < 1970


{-
En el mundo hay festivales de cine que otorgan ciertos premios a las películas. Por ejemplo, Cannes otorga los premios 3 son multitud y Clásico setentista. mientras que el festival de Berlín entrega los premios 4 son multitud, plomo y Clasico setentista.
a) Definir la función que permita averiguar cuántos premios de los que otorga un festival puede recibir una película dada y mostrar al menos dos ejemplos de cómo utilizarla para diferentes festivales. 
d) Representar un nuevo festival con al menos dos premios, en el que sea necesario utilizar composición de funciones -}

type Festival = [Peliculas] -> [Peliculas]
cannes :: Festival
cannes peliculas = filter tresSonMultitud peliculas ++ filter clasicoSetentista peliculas

berlin :: Festival
berlin peliculas = filter plomo peliculas ++ filter clasicoSetentista peliculas ++ filter (nSonMultitud 4) peliculas

composicionFuncionesDosPremios :: Festival
composicionFuncionesDosPremios = berlin . cannes