/* Un consorcio internacional nos pidió que relevemos su negocio, que consiste en hacer el seguimiento de los sueños que tiene cada una 
de las personas y los personajes que están destinados a cumplir esos sueños. 

Punto 1 (2 puntos)
Queremos reflejar que */

% Gabriel cree en Campanita, el Mago de Oz y Cavenaghi
cree(gabriel, campanita).
cree(gabriel, magodeoz).
cree(gabriel, cavenaghi).

%Juan cree en el Conejo de Pascua
cree(juan, conejodepascua).

%Macarena cree en los Reyes Magos, el Mago Capria y Campanita 
cree(macarena, reyesmagos).
cree(macarena, magocapria).
cree(macarena, campanita).

%Diego no cree en nadie

/* Conocemos tres tipos de sueño
ser un cantante y vender una cierta cantidad de “discos” (≅ bajadas)
ser un futbolista y jugar en algún equipo
ganar la lotería apostando una serie de números */

/* Queremos reflejar entonces que
Gabriel quiere ganar la lotería apostando al 5 y al 9, y también quiere ser un futbolista de Arsenal
Juan quiere ser un cantante que venda 100.000 “discos”
Macarena no quiere ganar la lotería, sí ser cantante estilo “Eruca Sativa” y vender 10.000 discos */

/* a) Generar la base de conocimientos inicial
b) Indicar qué conceptos entraron en juego para cada punto.*/

% Punto 1
% a)
% Gabriel
suenio(gabriel, ganarLoteria([5,9])).
suenio(gabriel, serFutbolista(arsenal)).
% Juan
suenio(juan, serCantante(100000)).
% Macarena
suenio(macarena, serCantante(10000)).

/* Punto 2 (4 puntos)
Queremos saber si una persona es ambiciosa, esto ocurre cuando la suma de dificultades de los sueños es mayor a 20. La dificultad de cada sueño se calcula como
- 6 para ser un cantante que vende más de 500.000 ó 4 en caso contrario
- ganar la lotería implica una dificultad de 10 * la cantidad de los números apostados
- lograr ser un futbolista tiene una dificultad de 3 en equipo chico o 16 en caso contrario. Arsenal y Aldosivi son equipos chicos.
Puede agregar los predicados que sean necesarios. El predicado debe ser inversible para todos sus argumentos. 
Gabriel es ambicioso, porque quiere ganar a la lotería con 2 números (20 puntos de dificultad) y quiere ser futbolista de 
Arsenal (3 puntos) = 23 que es mayor a 20. En cambio Juan y Macarena tienen 4 puntos de dificultad (cantantes con menos de 500.000 discos) */

dificultad(serCantante(Discos), 6) :- Discos > 500000.
dificultad(serCantante(_), 4).
dificultad(ganarLoteria(Numeros), Dificultad) :- length(Numeros, Cantidad), Dificultad is Cantidad * 10.
dificultad(serFutbolista(Equipo), 3) :- equipoChico(Equipo).
dificultad(serFutbolista(Equipo), 16):- not(equipoChico(Equipo)).
equipoChico(arsenal).
equipoChico(aldosivi).

sumaDificultades(Persona, Total):-
    suenio(Persona, _),
    findall(Dificultad, dificultadSuenio(Persona, Dificultad), Dificultades),
    sum_list(Dificultades, Total).

dificultadSuenio(Persona, Dificultad):-
    suenio(Persona, Suenio),
    dificultad(Suenio, Dificultad).

ambicioso(Persona):-
    suenio(Persona, _),
    sumaDificultades(Persona, Total),
    Total > 20.

/* Punto 3 (4 puntos)
Queremos saber si un personaje tiene química con una persona. Esto se da
    - si la persona cree en el personaje y...
        - para Campanita, la persona debe tener al menos un sueño de dificultad menor a 5.
        - para el resto, 
                - todos los sueños deben ser puros (ser futbolista o cantante de menos de 200.000 discos)
                - y la persona no debe ser ambiciosa

No puede utilizar findall en este punto.
El predicado debe ser inversible para todos sus argumentos.
Campanita tiene química con Gabriel (porque tiene como sueño ser futbolista de Arsenal, que es un sueño de dificultad 3 - menor a 5), y los Reyes Magos, 
el Mago Capria y Campanita tienen química con Macarena porque no es ambiciosa. */

personajeTieneQuimica(campanita, Persona):-
    cree(Persona, campanita),
    suenio(Persona, Suenio),
    dificultad(Suenio, Dificultad),
    Dificultad < 5.

personajeTieneQuimica(Personaje, Persona):-
    cree(Persona, Personaje),
    Personaje \= campanita,
    forall(suenio(Persona, Suenio), esPuro(Suenio)),
    not(ambicioso(Persona)).

esPuro(serFutbolista(_)).
esPuro(serCantante(Discos)):- Discos < 200000.

/* Punto 4 (2 puntos)
Sabemos que
    - Campanita es amiga de los Reyes Magos y del Conejo de Pascua
    - el Conejo de Pascua es amigo de Cavenaghi, entre otras amistades

Necesitamos definir si un personaje puede alegrar a una persona, esto ocurre
    - si una persona tiene algún sueño
    - el personaje tiene química con la persona y...
    - el personaje no está enfermo
    - o algún personaje de backup no está enfermo. Un personaje de backup es un amigo directo o indirecto del personaje principal

Debe evitar repetición de lógica.
El predicado debe ser totalmente inversible.
Debe considerar cualquier nivel de amistad posible (la solución debe ser general).
Suponiendo que Campanita, los Reyes Magos y el Conejo de Pascua están enfermos, 
    - el Mago Capria alegra a Macarena, ya que tiene química con ella y no está enfermo
    - Campanita alegra a Macarena; aunque está enferma es amiga del Conejo de Pascua, que aunque está enfermo es amigo de Cavenaghi que no está enfermo. */

amigo(campanita, reyesMagos).
amigo(campanita, conejoDePascua).
amigo(conejoDePascua, cavenaghi).

estaEnfermo(campanita).
estaEnfermo(reyesMagos).
estaEnfermo(conejoDePascua).

puedeAlegrar(Personaje, Persona):-
    suenio(Persona, _),
    personajeTieneQuimica(Personaje, Persona),
    not(estaEnfermo(Personaje)),
    not(estaEnfermo(PersonajeBackup, Personaje)).

estaEnfermo(PersonajeBackup, Personaje):-
    amigo(Personaje, PersonajeBackup),
    estaEnfermo(Personaje).

estaEnfermo(PersonajeBackup, Personaje):-
    amigo(Personaje, PersonajeIntermedio),
    estaEnfermo(PersonajeIntermedio),
    estaEnfermo(PersonajeBackup, PersonajeIntermedio).

