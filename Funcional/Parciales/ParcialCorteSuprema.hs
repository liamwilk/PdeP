import Text.Show.Functions
data Ley = UnaLey{
    tema :: String,
    presupuesto :: Int,
    partidosQueApoyan :: [Partido]
} deriving (Show, Eq)

type Partido = String

cannabisMedicinal :: Ley
cannabisMedicinal = UnaLey "Uso medicinal del Cannabis" 5 ["Cambio de todos", "Sector Financiero"]

educacionSuperior :: Ley
educacionSuperior = UnaLey "Ley de Educacion Superior" 30 ["Docentes Universitarios", "Partido de Centro Federal"]

profesionalizacionTenisDeMesa :: Ley
profesionalizacionTenisDeMesa = UnaLey "Profesionalizacion de Tenis de Mesa" 1 ["Partido de Centro Federal", "Liga de Deportistas Autonomos", "Club Paleta Veloz"]

tenis :: Ley
tenis = UnaLey "Ley sobre Tenis" 2 ["Liga de Deportistas Autonomos"]

{- Parte 1 -}

tienenAlMenosUnPartidoEnComun :: Ley -> Ley -> Bool
tienenAlMenosUnPartidoEnComun unaLey otraLey = any (estaEnOtraLey otraLey) (partidosQueApoyan unaLey)

estaEnOtraLey :: Ley -> Partido -> Bool
estaEnOtraLey otraLey unPartido = unPartido `elem` partidosQueApoyan otraLey

tienenTemaEnComun :: Ley -> Ley -> Bool
tienenTemaEnComun unaLey otraLey = tema unaLey == tema otraLey

sonCompatibles :: Ley -> Ley -> Bool
sonCompatibles unaLey otraLey = tienenAlMenosUnPartidoEnComun unaLey otraLey && tienenTemaEnComun unaLey otraLey

{- Parte 2 -}
data Juez = UnJuez{
    criterio :: Ley -> Bool
} deriving (Show)

type CorteSuprema = [Juez]

corteSupremaActual :: CorteSuprema
corteSupremaActual = [juezOpinionPublica, juezFinanciero, juezPreocupado1, juezPreocupado2, juezConservador]

juezOpinionPublica :: Juez
juezOpinionPublica = UnJuez {criterio = estaEnAgenda}

juezFinanciero :: Juez
juezFinanciero = UnJuez {criterio = leyApoyadaPorSector "Sector Financiero"}

juezPreocupado1 :: Juez
juezPreocupado1 = UnJuez {criterio = presupuestoExcedido 10}

juezPreocupado2 :: Juez
juezPreocupado2 = UnJuez {criterio = presupuestoExcedido 20}

juezConservador :: Juez
juezConservador = UnJuez {criterio = leyApoyadaPorSector "Partido Conservador"}

agenda :: [Ley]
agenda = [cannabisMedicinal, educacionSuperior]

estaEnAgenda :: Ley -> Bool
estaEnAgenda unaLey = unaLey `elem` agenda

leyApoyadaPorSector :: Partido -> Ley -> Bool
leyApoyadaPorSector unPartido unaLey = unPartido `elem` partidosQueApoyan unaLey

presupuestoExcedido :: Int -> Ley -> Bool
presupuestoExcedido monto unaLey = presupuesto unaLey > monto

constitucionalidad :: CorteSuprema -> Ley -> Bool
constitucionalidad corteSuprema unaLey = all (`criterio` unaLey) corteSuprema

juezAfirmativo :: Juez
juezAfirmativo = UnJuez {criterio = const True}

criterioFutbol :: Ley -> Bool
criterioFutbol unaLey = tema unaLey == "Futbol"

juezFutbolero :: Juez
juezFutbolero = UnJuez {criterio = criterioFutbol}

juezAhorrador :: Juez
juezAhorrador = UnJuez {criterio = presupuestoExcedido 5}

leyesNoConsideradasConstitucionales :: [Ley] -> CorteSuprema -> [Ley]
leyesNoConsideradasConstitucionales leyes corteSuprema = filter (not . constitucionalidad corteSuprema) leyes


{- Parte 3 -}

borocotizar :: CorteSuprema
borocotizar = map (UnJuez . (not .) . criterio) corteSupremaActual

{- Determinar si un juez curiosamente coincide en su posición con un sector social, que
se da cuando de un conjunto dado de leyes actualmente en tratamiento, sólo vota las
que son apoyadas por dicho sector -}

juezCurioso :: [Ley] -> Juez -> Partido -> Bool
juezCurioso leyes unJuez unPartido = all (unJuez `criterio`) (filter (leyApoyadaPorSector unPartido) leyes)


{- Si hubiera una ley apoyada por infinitos sectores ¿puede ser declarada constitucional?
¿cuáles jueces podrián votarla y cuáles no? Justificar -}

{- No puede ser declarada constitucional, ya que para que una ley sea constitucional, todos los jueces deben estar de acuerdo con ella.
   Si una ley es apoyada por infinitos sectores, entonces hay infinitos sectores que no la apoyan, por lo que no todos los jueces estarían de acuerdo con ella.
   Los jueces que no podrían votarla son los que tienen criterios que no se cumplen para la ley, ya que si no se cumplen para la ley, no se cumplen para todos los sectores.
   Los que sí podrían votarla son los que tienen criterios que se cumplen para la ley, ya que si se cumplen para la ley, se cumplen para todos los sectores.

   En el caso dado, los jueces que podrían votarla son juezOpinionPublica, juezFinanciero, juezPreocupado1, juezPreocupado2 y juezConservador, y los que no podrían votarla son juezAfirmativo, juezFutbolero y juezAhorrador. -}
