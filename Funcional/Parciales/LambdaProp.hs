-- Tenemos la información que maneja el sistema modelada de la siguiente forma:
type Barrio = String
type Mail = String
type Requisito = Depto -> Bool
type Busqueda = [Requisito]

data Depto = Depto {
 ambientes :: Int,
 superficie :: Int,
 precio :: Int,
 barrio :: Barrio
} deriving (Show, Eq)

data Persona = Persona {
   mail :: Mail,
   busquedas :: [Busqueda]
}

ordenarSegun :: (a -> a -> Bool) -> [a] -> [a]
ordenarSegun _ [] = []
ordenarSegun criterio (x:xs) =
 (ordenarSegun criterio . filter (not . criterio x)) xs ++
 [x] ++
 (ordenarSegun criterio . filter (criterio x)) xs

between :: Ord a => a -> a -> a -> Bool
between cotaInferior cotaSuperior valor =
 valor <= cotaSuperior && valor >= cotaInferior

deptosDeEjemplo :: [Depto]
deptosDeEjemplo = [
 Depto 3 80 7500 "Palermo",
 Depto 1 45 3500 "Villa Urquiza",
 Depto 2 50 5000 "Palermo",
 Depto 1 45 5500 "Recoleta"]

-- Definir las funciones mayor y menor que reciban una función y dos valores, y retorna true si el resultado de evaluar esa función sobre el primer valor es mayor o menor que el resultado de evaluarlo sobre el segundo valor respectivamente.
mayor :: Ord a => (t -> a) -> t -> t -> Bool
mayor f x y = f x > f y

menor :: Ord a => (t -> a) -> t -> t -> Bool
menor f x y = f x < f y

-- Mostrar un ejemplo de cómo se usaría una de estas funciones para ordenar una lista de strings en base a su longitud usando ordenarSegun.
ordenarStrings :: [String] -> [String]
ordenarStrings = ordenarSegun (mayor length)

-- ubicadoEn que dada una lista de barrios que le interesan al usuario, retorne verdadero si el departamento se encuentra en alguno de los barrios de la lista.
ubicadoEn :: [String] -> Depto -> Bool
ubicadoEn barrios = any (`elem` barrios) . words . barrio

-- cumpleRango que a partir de una función y dos números, indique si el valor retornado por la función al ser aplicada con el departamento se encuentra entre los dos valores indicados.
cumpleRango :: Ord a => (Depto -> a) -> a -> a -> Depto -> Bool
cumpleRango f x y = between x y . f

-- Definir la función cumpleBusqueda :: Depto -> Busqueda -> Bool que se cumple si todos los requisitos de la búsqueda se verifican para ese departamento.
cumpleBusqueda :: Depto -> Busqueda -> Bool
cumpleBusqueda depto = all ($ depto)

-- Definir la función buscar que a partir de una búsqueda, un criterio de ordenamiento y una lista de departamentos retorne todos aquellos que cumplen con la búsqueda ordenados en base al criterio recibido.
buscar :: Busqueda -> (Depto -> Depto -> Bool) -> [Depto] -> [Depto]
buscar busqueda criterio = ordenarSegun criterio . filter (`cumpleBusqueda` busqueda)

-- Definir la función mailsDePersonasInteresadas que a partir de un departamento y una lista de personas retorne los mails de las personas que tienen alguna búsqueda que se cumpla para el departamento dado.
mailsDePersonasInteresadas :: Depto -> [Persona] -> [Mail]
mailsDePersonasInteresadas depa = map mail . filter (estaInteresado depa)

estaInteresado :: Depto -> Persona -> Bool
estaInteresado depa persona = any (cumpleBusqueda depa) (busquedas persona)