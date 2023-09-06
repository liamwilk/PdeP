import Text.Show.Functions
{- Parte Postres -}
data Postre = UnPostre{
    sabor :: [String],
    peso :: Int,
    temperatura :: Int
}deriving (Show, Eq)

bizcocho :: Postre
bizcocho = UnPostre ["Frutilla", "Crema"] 100 25

tarta :: Postre
tarta = UnPostre ["Melaza"] 50 0

type Hechizo = Postre -> Postre

cambiarTemperatura :: Int -> Postre -> Postre
cambiarTemperatura valor unPostre = unPostre{temperatura = temperatura unPostre - valor}

congelarPostre :: Postre -> Postre
congelarPostre unPostre = unPostre{temperatura = 0}

cambiarPeso :: Int -> Postre -> Postre
cambiarPeso valor unPostre = unPostre{peso = div (valor * 100) (peso unPostre)}

agregarASabores :: String -> Postre -> Postre
agregarASabores nuevoSabor unPostre = unPostre{sabor = nuevoSabor : sabor unPostre}

borrarSabores :: Postre -> Postre
borrarSabores unPostre = unPostre{sabor = []}

incendio :: Hechizo
incendio = cambiarTemperatura (-1) . cambiarPeso 5

immobulus :: Hechizo
immobulus = congelarPostre

wingardiumLeviosa :: Hechizo
wingardiumLeviosa = cambiarPeso 10 . agregarASabores "concentrado"

diffindo :: Int -> Hechizo
diffindo porcentaje = cambiarPeso (porcentaje * 100)

riddikulus :: String -> Hechizo
riddikulus sabor = agregarASabores (reverse sabor)

avadaKedavra :: Hechizo
avadaKedavra = borrarSabores . immobulus

postreEstaListo :: Postre -> Bool
postreEstaListo unPostre = peso unPostre > 0 && not (null (sabor unPostre)) && temperatura unPostre > 0

hechizoDejaPreparados :: [Postre] -> Hechizo -> Bool
hechizoDejaPreparados postres unHechizo = all (postreEstaListo . unHechizo) postres

mesa :: [Postre]
mesa = [bizcocho, tarta]

pesoPromedioListos :: [Postre] -> Int
pesoPromedioListos postres = div (sum (map peso (filter postreEstaListo postres))) (length (filter postreEstaListo postres))

{- Parte Magos -}

data Mago = UnMago{
    hechizos :: [Hechizo],
    cantidadHorrorcruxes :: Int
} deriving (Show)

agregarHechizo :: Hechizo -> Mago -> Mago
agregarHechizo unHechizo unMago = unMago{hechizos = unHechizo : hechizos unMago}

sumarHorrorcruxes :: Int -> Mago -> Mago
sumarHorrorcruxes cantidad unMago = unMago{cantidadHorrorcruxes = cantidadHorrorcruxes unMago + cantidad}

hechizoEsAvadaKedavra :: Hechizo -> Postre -> Bool
hechizoEsAvadaKedavra unHechizo unPostre = unHechizo unPostre == avadaKedavra unPostre

claseDeDefensa :: Mago -> Hechizo -> Postre -> Mago
claseDeDefensa unMago unHechizo unPostre
    | hechizoEsAvadaKedavra unHechizo unPostre = (sumarHorrorcruxes 1 . agregarHechizo unHechizo) unMago
    | otherwise = agregarHechizo unHechizo unMago

cantidadDeSabores :: Postre -> Int
cantidadDeSabores unPostre = length (sabor unPostre)

mejorHechizo :: Postre -> [Hechizo] -> Hechizo
mejorHechizo unPostre = foldl1 (.) . filter ((> cantidadDeSabores unPostre) . cantidadDeSabores . ($ unPostre))

{- Parte 3 -}

postresInfinitos :: [Postre]
postresInfinitos = repeat bizcocho

hechizosInfinitos :: Mago
hechizosInfinitos = UnMago {hechizos = repeat avadaKedavra, cantidadHorrorcruxes = 2}

