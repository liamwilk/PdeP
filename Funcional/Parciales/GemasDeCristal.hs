{- Queremos modelar cómo se comportan estos seres para que un grupo de Gemas rebeldes (las Gemas de Cristal) que intentan proteger la Tierra tengan mejores chances de vencer ante una invasión.

Tenemos las siguientes definiciones sobre las cuales partir: -}

data Aspecto = UnAspecto {
  tipoDeAspecto :: String,
  grado :: Float
} deriving (Show, Eq)
type Situacion = [Aspecto]

mejorAspecto :: Aspecto -> Aspecto -> Bool
mejorAspecto mejor peor = grado mejor < grado peor
mismoAspecto :: Aspecto -> Aspecto -> Bool
mismoAspecto aspecto1 aspecto2 = tipoDeAspecto aspecto1 == tipoDeAspecto aspecto2
buscarAspecto :: Aspecto -> [Aspecto] -> Aspecto
buscarAspecto aspectoBuscado = head.filter (mismoAspecto aspectoBuscado)
buscarAspectoDeTipo :: String -> [Aspecto] -> Aspecto
buscarAspectoDeTipo tipo = buscarAspecto (UnAspecto tipo 0)
reemplazarAspecto :: Aspecto -> [Aspecto] -> [Aspecto]
reemplazarAspecto aspectoBuscado situacion =
    aspectoBuscado : filter (not.mismoAspecto aspectoBuscado) situacion

{- Sabemos que las situaciones están conformadas por un grupo acotado de aspectos problemáticos bien conocidos: tensión, incertidumbre y peligro; eventualmente podrían incorporarse más aspectos, 
pero se espera que cada situación incluya el grado correspondiente para cada uno de ellos. El orden en el que los mismos se encuentran al armar una situación es irrelevante. -}

-- Definir modificarAspecto que dada una función de tipo (Float -> Float) y un aspecto, modifique el aspecto alterando su grado en base a la función dada.
modificarAspecto :: (Float -> Float) -> Aspecto -> Aspecto
modificarAspecto funcion aspecto = aspecto { grado = funcion (grado aspecto) }

-- Saber si una situación es mejor que otra: esto ocurre cuando, para la primer situación, cada uno de los aspectos, es mejor que ese mismo aspecto en la segunda situación.
situacionMejor :: Situacion -> Situacion -> Bool
situacionMejor situacion1 situacion2 = all (\aspecto -> mejorAspecto aspecto (buscarAspecto aspecto situacion2)) situacion1

{- Definir una función modificarSituacion que a partir de una situación permita obtener otra de modo que se modifique de cierta forma el grado correspondiente a un tipo de aspecto buscado. 
La alteración a realizar sobre el grado actual de ese aspecto debe poder ser indicada al usar la función. -}
modificarSituacion :: String -> (Float -> Float) -> Situacion -> Situacion
modificarSituacion tipo funcion situacion = reemplazarAspecto (modificarAspecto funcion (buscarAspectoDeTipo tipo situacion)) situacion

{- Modelar a las Gemas de modo que estén compuestas por su nombre, la fuerza que tienen y la personalidad. 
La personalidad de una Gema debe representar cómo reacciona ante una situación, derivando de ese modo a una situación diferente. -}

data Gema = UnaGema {
    nombre :: String,
    fuerza :: Float,
    personalidad :: Personalidad
    }

type Personalidad = Situacion -> Situacion

-- vidente: ante una situación disminuye a la mitad la incertidumbre y baja en 10 la tensión.
vidente :: Personalidad
vidente = modificarSituacion "incertidumbre" (/2). modificarSituacion "tension" (subtract 10)

-- relajada: disminuye en 30 la tensión de la situación y, dependiendo de qué tan relajada sea la Gema, aumenta el peligro en tantas unidades como nivel de relajamiento tenga.
relajada :: Float -> Personalidad
relajada grado1 = modificarSituacion "tension" (subtract 30) . modificarSituacion "peligro" (grado1 +)

{- Saber si una Gema le gana a otra dada una situación, que se cumple si la primera es más o igual de fuerte que la segunda y además entre las dos personalidades, 
la situación resultante de la primera ante la situación dada es mejor que la que genera la segunda personalidad ante la misma situación. -}
leGanaAOtra :: Gema -> Gema -> Situacion -> Bool
leGanaAOtra gema1 gema2 situacion = fuerza gema1 >= fuerza gema2 && situacionMejor (personalidad gema1 situacion) (personalidad gema2 situacion)

{- Su nombre o bien es el mismo de las Gemas que se fusionaron si las mismas se llaman igual, o bien es la concatenación de los 
nombres de dichas Gemas. -}
fusionNombres :: Gema -> Gema -> String
fusionNombres gema1 gema2
    | nombre gema1 == nombre gema2 = nombre gema1
    | otherwise = nombre gema1 ++ nombre gema2

{- Su personalidad fusionada va a producir el mismo efecto que producirían las gemas individuales actuando en sucesión, 
luego de bajar en 10 todos los aspectos de la situación a la que deban enfrentarse. -}
personalidadmenosdiez :: Personalidad
personalidadmenosdiez = map (modificarAspecto (subtract 10))

fusionPersonalidad :: Gema -> Gema -> Personalidad
fusionPersonalidad gema1 gema2 = personalidadmenosdiez . personalidad gema1 . personalidad gema2

{- Para saber cómo va a ser la fuerza de la fusión necesitamos saber si son compatibles entre ellas, lo cual se cumple si, para la situación 
ante la cual se están fusionando, la personalidad fusionada produce una mejor situación que las personalidades individuales de cada gema. 
Si son compatibles, la fuerza de la fusión va a ser la suma de la fuerza de las gemas individuales multiplicada 10.
En caso contrario, su fuerza es 7 veces la fuerza de la gema dominante (si la primera le gana a la otra es la dominante, sino es la segunda). -}
fuerzaFusion :: Gema -> Gema -> Situacion -> Float
fuerzaFusion gema1 gema2 situacion
    | sonCompatibles gema1 gema2 situacion = (fuerza gema1 + fuerza gema2) * 10
    | otherwise = 7 * fuerza (gemaDominante gema1 gema2 situacion)

sonCompatibles :: Gema -> Gema -> Situacion -> Bool
sonCompatibles gema1 gema2 situacion = situacionMejor (fusionPersonalidad gema1 gema2 situacion) (personalidad gema1 situacion) && situacionMejor (fusionPersonalidad gema1 gema2 situacion) (personalidad gema2 situacion)

gemaDominante :: Gema -> Gema -> Situacion -> Gema
gemaDominante gema1 gema2 situacion
    | leGanaAOtra gema1 gema2 situacion = gema1
    | otherwise = gema2



{- Fusión grupal: las fusiones entre gemas no están limitadas a sólo dos de ellas, también pueden fusionarse un grupo de Gemas 
en caso de que sea necesario. Una fusión grupal es el resultado de fusionar a todas las Gemas entre sí hasta que quede sólo una. -}
fusionDeGemas::Gema->Gema->Situacion->Gema
fusionDeGemas gema1 gema2 situacion = UnaGema (fusionNombres gema1 gema2) (fuerzaFusion gema1 gema2 situacion) (fusionPersonalidad gema1 gema2)
