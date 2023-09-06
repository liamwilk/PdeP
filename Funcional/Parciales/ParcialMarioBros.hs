import Data.List (genericLength)
import Text.Show.Functions
data Herramienta = UnaHerramienta{
    nombreHerramienta :: String,
    precio :: Float,
    material :: Mango
} deriving (Show, Eq)

data Mango = Hierro | Madera | Goma | Plastico deriving (Show, Eq)

data Plomero = UnPlomero{
    nombrePlomero :: String,
    cajaHerramientas :: [Herramienta],
    historialReparaciones :: [String],
    dinero :: Float
} deriving (Show, Eq)

{- Punto 1 -}
llaveInglesa :: Herramienta
llaveInglesa = UnaHerramienta "Llave Inglesa" 200 Hierro

martillo :: Herramienta
martillo = UnaHerramienta "Martillo" 20 Madera

llaveFrancesa :: Herramienta
llaveFrancesa = UnaHerramienta "Llave Francesa" 1 Hierro

mario :: Plomero
mario = UnPlomero "Mario" [llaveInglesa, martillo] [] 1200

{- Wario, tiene 50 centavos encima, no hizo reparaciones, lleva infinitas llaves francesas, obviamente de hierro, la primera le salió un peso, 
pero cada una que compraba le salía un peso más cara. La inflación lo está matando.  -}

tenerLlavesFrancesasInfinitas :: Herramienta -> [Herramienta]
tenerLlavesFrancesasInfinitas herramienta = herramienta : tenerLlavesFrancesasInfinitas (UnaHerramienta "Llave Francesa" (precio herramienta + 1) Hierro)

wario :: Plomero
wario = UnPlomero "Wario" (tenerLlavesFrancesasInfinitas llaveFrancesa) [] 50


{- Punto 2 -}
tieneHerramientaConCiertaDenom :: String -> Plomero -> Bool
tieneHerramientaConCiertaDenom nombre unPlomero = any ((== nombre) . nombreHerramienta) (cajaHerramientas unPlomero)

esMalvado :: Plomero -> Bool
esMalvado unPlomero = (take 2 . nombrePlomero) unPlomero == "Wa"

puedeComprarHerramienta :: Plomero -> Herramienta -> Bool
puedeComprarHerramienta unPlomero unaHerramienta = dinero unPlomero >= precio unaHerramienta

{- Punto 3 -}

esHerramientaBuena :: Herramienta -> Bool
esHerramientaBuena unaHerramienta
    | precio unaHerramienta > 10000 = True
    | nombreHerramienta unaHerramienta == "Martillo" && material martillo == Goma = True
    | nombreHerramienta unaHerramienta == "Martillo" && material martillo == Madera = True
    | otherwise = False

{- Punto 4 -}
comprarHerramienta :: Plomero -> Herramienta -> Plomero
comprarHerramienta unPlomero unaHerramienta
    | puedeComprarHerramienta unPlomero unaHerramienta = unPlomero {cajaHerramientas = unaHerramienta : cajaHerramientas unPlomero, dinero = dinero unPlomero - precio unaHerramienta}
    | otherwise = unPlomero

{- Punto 5 -}

data Reparacion = UnaReparacion{
    descripcion :: String,
    requerimiento :: Plomero -> Bool
} deriving (Show)


filtracionDeAgua :: Reparacion
filtracionDeAgua = UnaReparacion "Filtracion de agua" (tieneHerramientaConCiertaDenom "Llave Inglesa")

esUnGrito :: Reparacion -> Bool
esUnGrito unaReparacion = all (== ' ') (filter (>= 'A') (descripcion unaReparacion))

esReparacionDificil :: Reparacion -> Bool
esReparacionDificil unaReparacion = length (descripcion unaReparacion) > 100 && esUnGrito unaReparacion

presupuestoReparacion :: Reparacion -> Float
presupuestoReparacion unaReparacion = genericLength (descripcion unaReparacion) * 3

{- Punto 6 -}
destornillador :: Herramienta
destornillador = UnaHerramienta "Destornillador" 0 Goma

pierdeTodasHerramientasBuenas :: Plomero -> Plomero
pierdeTodasHerramientasBuenas unPlomero = unPlomero {cajaHerramientas = filter (not . esHerramientaBuena) (cajaHerramientas unPlomero)}

seOlvidaPrimerHerramienta :: Plomero -> Plomero
seOlvidaPrimerHerramienta unPlomero = unPlomero {cajaHerramientas = tail (cajaHerramientas unPlomero)}

cumpleRequerimientos :: Plomero -> Reparacion -> Bool
cumpleRequerimientos unPlomero unaReparacion = requerimiento unaReparacion unPlomero

puedeResolverReparacion :: Plomero -> Reparacion -> Bool
puedeResolverReparacion unPlomero unaReparacion
    | cumpleRequerimientos unPlomero unaReparacion = True
    | esMalvado unPlomero && tieneHerramientaConCiertaDenom "Martillo" unPlomero = True
    | otherwise = False

robarHerramienta :: Herramienta -> Plomero -> Plomero
robarHerramienta unaHerramienta unPlomero = unPlomero {cajaHerramientas = unaHerramienta : cajaHerramientas unPlomero}

cobrarYAgregarAHistorial :: Plomero -> Reparacion -> Plomero
cobrarYAgregarAHistorial unPlomero unaReparacion = unPlomero {dinero = dinero unPlomero + presupuestoReparacion unaReparacion, historialReparaciones = unaReparacion : historialReparaciones unPlomero}

hacerReparacion :: Plomero -> Reparacion -> Plomero
hacerReparacion unPlomero unaReparacion
    | puedeResolverReparacion unPlomero unaReparacion && esMalvado unPlomero = (cobrarYAgregarAHistorial . robarHerramienta destornillador) unPlomero unaReparacion
    | puedeResolverReparacion unPlomero unaReparacion && not (esMalvado unPlomero) && esReparacionDificil unaReparacion = (cobrarYAgregarAHistorial . pierdeTodasHerramientasBuenas) unPlomero unaReparacion
    | puedeResolverReparacion unPlomero unaReparacion && not (esMalvado unPlomero) && not (esReparacionDificil unaReparacion) = (cobrarYAgregarAHistorial . seOlvidaPrimerHerramienta) unPlomero unaReparacion
    | otherwise = unPlomero {dinero = dinero unPlomero + 100}

{- Punto 7 -}
type Jornada = [Reparacion]

jornadaDeTrabajo :: Plomero -> Jornada -> Plomero
jornadaDeTrabajo = foldl hacerReparacion

{- Punto 8 -}
reparacionesHistorial :: Plomero -> Int
reparacionesHistorial unPlomero = length (historialReparaciones unPlomero)

plomeroMasReparador :: [Plomero] -> Plomero
plomeroMasReparador listaPlomeros
    | reparacionesHistorial (head listaPlomeros) > reparacionesHistorial (head (tail listaPlomeros)) = plomeroMasReparador (head listaPlomeros : tail (tail listaPlomeros))
    | otherwise = plomeroMasReparador (tail listaPlomeros)

plomeroMasAdinerado :: [Plomero] -> Plomero
plomeroMasAdinerado listaPlomeros
    | dinero (head listaPlomeros) > dinero (head (tail listaPlomeros)) = plomeroMasAdinerado (head listaPlomeros : tail (tail listaPlomeros))
    | otherwise = plomeroMasAdinerado (tail listaPlomeros)

cuantoInvirtio :: Plomero -> Float
cuantoInvirtio unPlomero = sum (map precio (cajaHerramientas unPlomero))

plomeroQueMasInvierte :: [Plomero] -> Plomero
plomeroQueMasInvierte listaPlomeros
    | cuantoInvirtio (head listaPlomeros) > cuantoInvirtio (head (tail listaPlomeros)) = plomeroQueMasInvierte (head listaPlomeros : tail (tail listaPlomeros))
    | otherwise = plomeroQueMasInvierte (tail listaPlomeros)
