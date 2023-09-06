import Data.List

data Persona = UnaPersona{
    nombre :: String,
    calorias :: Int,
    nutrientes :: [String]
} deriving (Show, Eq)

{- Punto 1 -}
sofia :: Persona
sofia = UnaPersona "Sofia" 0 ["Vitamina A"]

estaNutriente :: String -> Persona -> Bool
estaNutriente unNutriente unaPersona = unNutriente `elem` nutrientes unaPersona

agregarNutriente :: String -> Persona -> Persona
agregarNutriente nutriente unaPersona = unaPersona{nutrientes = nutriente : nutrientes unaPersona}

incorporarNutriente :: String -> Persona -> Persona
incorporarNutriente unNutriente unaPersona
    | not (estaNutriente unNutriente unaPersona) = agregarNutriente unNutriente unaPersona
    | otherwise = unaPersona

{- Punto 2 -}
data Comida = UnaComida{
    nombreComida :: String,
    caloriasComida :: Int,
    nutrientesComida :: [String]
} deriving (Show, Eq)

tomate :: Comida
tomate = UnaComida "Tomate" 0 ["Vitamina A", "Vitamina C"]

zanahoria :: Comida
zanahoria = UnaComida "Zanahoria" 0 ["Vitamina A", "Vitamina C", "Vitamina E", "Vitamina K"]

carne :: Int -> Comida
carne gramos = UnaComida "Carne" (240 * gramos `div` 10) ["Calcio", "Hierro"]

personaEstaPipona :: Persona -> Bool
personaEstaPipona unaPersona = calorias unaPersona > 2000

pan :: String -> Persona -> Comida
pan tipoPan unaPersona
    | tipoPan == "Blanco" = UnaComida "Pan Blanco" 265 ["Zinc"]
    | tipoPan == "Integral" = UnaComida "Pan Integral" 200 ["Zinc", "Fibras"]
    | tipoPan == "De papa" && personaEstaPipona unaPersona = UnaComida "Pan de Papa" 100 ["Zinc"]
    | tipoPan == "De papa" && not (personaEstaPipona unaPersona) = UnaComida "Pan de Papa" 500 ["Zinc"]
    | otherwise = UnaComida "Pan" 0 []

{- Hamburguesa cheta: equivalente a comer primero un pan de papa, luego tomate, luego 180 gramos de carne y finalmente otro pan de papa. -}

comer :: Comida -> Persona -> Persona
comer unaComida = agregarCalorias unaComida . agregarNutrientes unaComida

agregarCalorias :: Comida -> Persona -> Persona
agregarCalorias unaComida = modificarCalorias (caloriasComida unaComida)

agregarNutrientes :: Comida -> Persona -> Persona
agregarNutrientes unaComida = eliminarNutrientesRepetidos . modificarNutrientes (nutrientesComida unaComida)

modificarNutrientes :: [String] -> Persona -> Persona
modificarNutrientes nuevosNutrientes unaPersona = unaPersona{nutrientes = nuevosNutrientes ++ nutrientes unaPersona}

modificarCalorias :: Int -> Persona -> Persona
modificarCalorias cantidad unaPersona = unaPersona {calorias = calorias unaPersona + cantidad}

eliminarNutrientesRepetidos :: Persona -> Persona
eliminarNutrientesRepetidos unaPersona = unaPersona {nutrientes = eliminarRepetidos $ nutrientes unaPersona}

eliminarRepetidos :: [String] -> [String]
eliminarRepetidos = map head . group . sort

