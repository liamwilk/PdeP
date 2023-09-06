import Text.Show.Functions
{- Parte 1 -}

data Alfajor = UnAlfajor
  { capasDeRelleno :: [Relleno],
    peso :: Int,
    dulzor :: Int,
    nombre :: String
  }
  deriving (Show, Eq)

data Relleno = UnRelleno
  { sabor :: String,
    precio :: Int
  }
  deriving (Show, Eq)

{- Punto A) -}

jorgito :: Alfajor
jorgito = UnAlfajor [dulceDeLeche] 80 8 "Jorgito"

havanna :: Alfajor
havanna = UnAlfajor [mousse, mousse] 60 12 "Havanna"

capitanDelEspacio :: Alfajor
capitanDelEspacio = UnAlfajor [dulceDeLeche] 40 12 "Capitán del espacio"

{- Punto B) -}

coeficienteDulzor :: Alfajor -> Int
coeficienteDulzor unAlfajor = div (dulzor unAlfajor) (peso unAlfajor)

multiplicarPeso :: Int -> Alfajor -> Alfajor
multiplicarPeso valor unAlfajor = unAlfajor {peso = peso unAlfajor * valor}

dulceDeLeche :: Relleno
dulceDeLeche = UnRelleno "Dulce de Leche" 12

mousse :: Relleno
mousse = UnRelleno "Mousse" 15

frutal :: Relleno
frutal = UnRelleno "Frutal" 10

sumatoriaPrecios :: Alfajor -> Int
sumatoriaPrecios unAlfajor = sum (map precio (capasDeRelleno unAlfajor))

precioAlfajor :: Alfajor -> Int
precioAlfajor = sumatoriaPrecios . multiplicarPeso 2

cantidadCapas :: Alfajor -> Int
cantidadCapas unAlfajor = length (capasDeRelleno unAlfajor)

tieneAlMenosUnaCapa :: Alfajor -> Bool
tieneAlMenosUnaCapa unAlfajor = cantidadCapas unAlfajor >= 1

tieneTodasCapasIguales :: Alfajor -> Bool
tieneTodasCapasIguales unAlfajor = all (== head (capasDeRelleno unAlfajor)) (capasDeRelleno unAlfajor)

coeficienteDulzorMayorQue :: Int -> Alfajor -> Bool
coeficienteDulzorMayorQue valor unAlfajor = (>= valor) (coeficienteDulzor unAlfajor)

esAlfajorPotable :: Alfajor -> Bool
esAlfajorPotable unAlfajor = tieneAlMenosUnaCapa unAlfajor && tieneTodasCapasIguales unAlfajor && coeficienteDulzorMayorQue (div 10 100) unAlfajor

{- Parte 2 -}

reducirPeso :: Int -> Alfajor -> Alfajor
reducirPeso valor unAlfajor = unAlfajor {peso = peso unAlfajor - valor}

reducirDulzor :: Int -> Alfajor -> Alfajor
reducirDulzor valor unAlfajor = unAlfajor {dulzor = dulzor unAlfajor - valor}

abaratarAlfajor :: Alfajor -> Alfajor
abaratarAlfajor = reducirDulzor 7 . reducirPeso 10

agregarCapa :: Relleno -> Alfajor -> Alfajor
agregarCapa unRelleno unAlfajor = unAlfajor{capasDeRelleno = unRelleno : capasDeRelleno unAlfajor}

agregarANombre :: String -> Alfajor -> Alfajor
agregarANombre valor unAlfajor = unAlfajor {nombre = nombre unAlfajor ++ valor}

alfajorPremium :: Alfajor -> Alfajor
alfajorPremium unAlfajor
    | esAlfajorPotable unAlfajor = (agregarANombre "premium" . agregarCapa (head (capasDeRelleno unAlfajor))) unAlfajor
    | otherwise = unAlfajor

hacerPremium :: Int -> Alfajor -> Alfajor
hacerPremium 0 unAlfajor = unAlfajor
hacerPremium valor unAlfajor = hacerPremium (valor - 1) (alfajorPremium unAlfajor)

jorgitito :: Alfajor
jorgitito = UnAlfajor [frutal] 30 5 "Jorgitito"

jorgelin :: Alfajor
jorgelin = agregarCapa dulceDeLeche jorgito

capitanDelEspacioAbaratado :: Alfajor
capitanDelEspacioAbaratado = UnAlfajor [dulceDeLeche] 12 5 "Capitán del espacio"

capitanDelEspacioCostaACosta :: Alfajor
capitanDelEspacioCostaACosta = (agregarANombre "costa a costa" . hacerPremium 4) capitanDelEspacioAbaratado

{- Parte 3 -}

data Cliente = UnCliente{
    nombreCliente :: String,
    dinero :: Int,
    compras :: [Alfajor],
    gustos :: [Criterio]
} deriving (Show)

type Criterio = Alfajor -> Bool


buscaMarca :: String -> Criterio
buscaMarca valor unAlfajor = valor `elem` words (nombre unAlfajor)

esDulcero :: Criterio
esDulcero unAlfajor = coeficienteDulzor unAlfajor > div 15 100

esAntiRelleno :: Relleno -> Criterio
esAntiRelleno unRelleno unAlfajor = unRelleno `notElem` capasDeRelleno unAlfajor

esExtranio :: Criterio
esExtranio unAlfajor = not (esAlfajorPotable unAlfajor)

esPretencioso :: Criterio
esPretencioso = buscaMarca "premium"

emi :: Cliente
emi = UnCliente "Emi" 120 [] [buscaMarca "Capitán del espacio"]

tomi :: Cliente
tomi = UnCliente "Tomi" 100 [] [esPretencioso, esDulcero]

dante :: Cliente
dante = UnCliente "Dante" 200 [] [esAntiRelleno dulceDeLeche, esExtranio]

juan :: Cliente
juan = UnCliente "Juan" 500 [] [esDulcero, buscaMarca "Jorgito", esPretencioso, esAntiRelleno mousse]

leGustan :: Cliente -> [Alfajor] -> [Alfajor]
leGustan unCliente = filter (cumpleCriterios unCliente)

cumpleCriterios :: Cliente -> Alfajor -> Bool
cumpleCriterios unCliente unAlfajor = all (\criterio -> criterio unAlfajor) (gustos unCliente)

puedeComprarAlfajor :: Cliente -> Alfajor -> Bool
puedeComprarAlfajor unCliente unAlfajor = dinero unCliente >= precioAlfajor unAlfajor

agregarAlfajor :: Cliente -> Alfajor -> Cliente
agregarAlfajor unCliente unAlfajor = unCliente {compras = unAlfajor : compras unCliente}

sacarDinero :: Cliente -> Alfajor -> Cliente
sacarDinero unCliente unAlfajor = unCliente {dinero = dinero unCliente - precioAlfajor unAlfajor}

comprarAlfajor :: Cliente -> Alfajor -> Cliente
comprarAlfajor unCliente unAlfajor
    | puedeComprarAlfajor unCliente unAlfajor = agregarAlfajor (sacarDinero unCliente unAlfajor) unAlfajor
    | otherwise = unCliente

comprarAlfajoresQueLeGustan :: Cliente -> [Alfajor] -> Cliente
comprarAlfajoresQueLeGustan unCliente alfajores = foldl comprarAlfajor unCliente (leGustan unCliente alfajores)