{- Punto 1 -}
import Text.Show.Functions
data Peleador = UnPeleador
  { vida :: Int,
    resistencia :: Int,
    ataques :: [Ataque]
  }
  deriving (Show)

type Ataque = Peleador -> Peleador

estaMuerto :: Peleador -> Bool
estaMuerto unPeleador = vida unPeleador < 1

esHabil :: Peleador -> Bool
esHabil unPeleador = (length . ataques) unPeleador > 10

bajarVida :: Int -> Ataque
bajarVida valor unPeleador = unPeleador {vida = vida unPeleador - valor}

intensidadDeGolpe :: Int -> Peleador -> Int
intensidadDeGolpe valor unPeleador = div valor (resistencia unPeleador)

golpe :: Int -> Ataque
golpe valor unPeleador = bajarVida (intensidadDeGolpe valor unPeleador) unPeleador

toqueDeLaMuerte :: Ataque
toqueDeLaMuerte unPeleador = unPeleador {vida = 0}

mitadVida :: Peleador -> Int
mitadVida unPeleador = div (vida unPeleador) 2

olvidarPrimerAtaque :: Peleador -> Peleador
olvidarPrimerAtaque unPeleador = unPeleador{ataques = tail (ataques unPeleador)}

patada :: String -> Ataque
patada lugar unPeleador
  | lugar == "pecho" && not (estaMuerto unPeleador) = bajarVida 10 unPeleador
  | lugar == "pecho" && estaMuerto unPeleador = bajarVida (-1) unPeleador
  | lugar == "carita" = bajarVida (mitadVida unPeleador) unPeleador
  | lugar == "nuca" = olvidarPrimerAtaque unPeleador
  | otherwise = unPeleador

tresPatadasCarita :: Ataque
tresPatadasCarita = patada "carita" . patada "carita" . patada "carita"

bruceLee :: Peleador
bruceLee = UnPeleador 200 25 [toqueDeLaMuerte, golpe 500, tresPatadasCarita]

{- Punto 2 -}
mejorAtaque :: Peleador -> Peleador -> Ataque
mejorAtaque peleador enemigo = head (filter (esMasEfectivo peleador enemigo) (ataques peleador))

esMasEfectivo :: Peleador -> Peleador -> Ataque -> Bool
esMasEfectivo peleador enemigo ataque = vida (ataque enemigo) < vida (ataque peleador)

{- Punto 3 -}
type Enemigos = [Peleador]

cuantosQuedanVivos :: Enemigos -> Int
cuantosQuedanVivos enemigos = length (filter (not . estaMuerto) enemigos)

mitadEnemigos :: Enemigos -> Int
mitadEnemigos enemigos = div (length enemigos) 2

terrible :: Ataque -> Enemigos -> Bool
terrible unAtaque enemigos = cuantosQuedanVivos (map unAtaque enemigos) < mitadEnemigos enemigos

sonTerriblesAtaques :: [Ataque] -> Enemigos -> Bool
sonTerriblesAtaques ataques enemigos = all (`terrible` enemigos) ataques

sonEnemigosHabilidosos :: Enemigos -> Enemigos
sonEnemigosHabilidosos = filter esHabil

peligroso :: Peleador -> Enemigos -> Bool
peligroso unPeleador enemigos = sonTerriblesAtaques (ataques unPeleador) (sonEnemigosHabilidosos enemigos)

aplicarAtaques :: Peleador -> Enemigos -> Peleador
aplicarAtaques unPeleador = foldl (mejorAtaque unPeleador) unPeleador

invencible :: Peleador -> Enemigos -> Bool
invencible unPeleador enemigos = vida unPeleador == vida (aplicarAtaques unPeleador enemigos)
