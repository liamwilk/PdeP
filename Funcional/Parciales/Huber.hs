{- Una agencia de remises contrata los más eficientes choferes de los que conoce:
el nombre
el kilometraje de su auto
los viajes que tomó
qué condición impone para tomar un viaje -}
data Cliente = UnCliente {
    nombreCliente :: String,
    direccion :: String
} deriving (Show, Eq)

data Viaje = UnViaje {
    fecha :: (Int, Int, Int),
    cliente :: Cliente,
    costo :: Int
} deriving (Show, Eq)

data Chofer = UnChofer {
    nombre :: String,
    kilometraje :: Int,
    viajes :: [Viaje],
    condicion :: Cliente -> Bool
} deriving (Show)

instance Show (Cliente -> Bool) where
  show _ = "<función de cliente a booleano>"


-- Implementar con las abstracciones que crea conveniente las condiciones que cada chofer tiene para tomar un viaje. Debe utilizar en este punto composición y aplicación parcial.
condicion1 :: Cliente -> Bool
condicion1 cliente = (length . nombreCliente) cliente > 5

condicion2 :: Cliente -> Bool
condicion2 cliente = (length . direccion) cliente > 10

condicion3 :: Cliente -> Bool
condicion3 cliente = (length . nombreCliente) cliente > 5 && (length . direccion) cliente > 10

toninas :: Viaje
toninas= UnViaje (20, 04, 2017) (UnCliente "Toninas" "Olivos") 150

lucas :: Cliente
lucas = UnCliente "Lucas" "Victoria"

daniel :: Chofer
daniel = UnChofer "Daniel" 23500 [UnViaje (20, 04, 2017) lucas 150] (\cliente -> direccion cliente /= "Olivos")

alejandra :: Chofer
alejandra = UnChofer "Alejandra" 180000 [] (const True)

-- Saber si un chofer puede tomar un viaje.
puedeTomarViaje :: Chofer -> Viaje -> Bool
puedeTomarViaje chofer viaje = condicion chofer (cliente viaje)

--Saber la liquidación de un chofer, que consiste en sumar los costos de cada uno de los viajes.
liquidacionChofer :: Chofer -> Int
liquidacionChofer chofer = sum (map costo (viajes chofer))

-- Realizar un viaje: dado un viaje y una lista de choferes, se pide que filtre los choferes que toman ese viaje. Si ningún chofer está interesado, no se preocupen: el viaje no se puede realizar.
tomaViaje :: Viaje -> [Chofer] -> [Chofer]
tomaViaje viaje = filter (`puedeTomarViaje` viaje)

-- considerar el chofer que menos viaje tenga. Si hay más de un chofer elegir cualquiera.

choferMenosViajes :: [Chofer] -> [Chofer]
choferMenosViajes choferes = filter ((==) (minimum (map (length . viajes) choferes)) . length . viajes) choferes

tomaChoferMenosViajes :: Viaje -> [Chofer] -> Chofer
tomaChoferMenosViajes viaje = head . tomaViaje viaje . choferMenosViajes

-- efectuar el viaje: esto debe incorporar el viaje a la lista de viajes del chofer. 
efectuarViaje :: Viaje -> Chofer -> Chofer
efectuarViaje viaje chofer = chofer {viajes = viaje : viajes chofer}

-- Modelar al chofer “Nito Infy”, su auto tiene 70.000 kms., que el 11/03/2017 hizo infinitos viajes de $ 50 con Lucas y toma cualquier viaje donde el cliente tenga al menos 3 letras.

repetirViaje :: t -> [t]
repetirViaje viaje = viaje : repetirViaje viaje
nitoInfy :: Chofer
nitoInfy = UnChofer "Nito Infy" 70000 (repetirViaje (UnViaje (11, 03, 2017) lucas 50)) (\cliente -> (length . nombreCliente) cliente >= 3)