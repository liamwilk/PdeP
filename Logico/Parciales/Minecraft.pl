/* cada uno sobre su nombre, ítems que posee, y su nivel de hambre (0 a 10). 
También se tiene información sobre el mapa del juego, particularmente de las distintas secciones del mismo, los jugadores que se encuentran en cada uno, y su nivel de oscuridad (0 a 10).
Por último, se conoce cuáles son los ítems comestibles. */

jugador(stuart, [piedra, piedra, piedra, piedra, piedra, piedra, piedra, piedra], 3).
jugador(tim, [madera, madera, madera, madera, madera, pan, carbon, carbon, carbon, pollo, pollo], 8).
jugador(steve, [madera, carbon, carbon, diamante, panceta, panceta, panceta], 2).

lugar(playa, [stuart, tim], 2).
lugar(mina, [steve], 8).
lugar(bosque, [], 6).

comestible(pan).
comestible(panceta).
comestible(pollo).
comestible(pescado).


% 1) Jugando con los ítems
% a) Relacionar un jugador con un ítem que posee. tieneItem/2

tieneItem(Jugador, Item):-
    jugador(Jugador, Lista, _),
    member(Item, Lista).

% b) Saber si un jugador se preocupa por su salud, esto es si tiene entre sus ítems más de un tipo de comestible. (Tratar de resolver sin findall) sePreocupaPorSuSalud/1

sePreocupaPorSuSalud(Jugador):-
    tieneItem(Jugador, Item1),
    tieneItem(Jugador, Item2),
    comestible(Item1),
    comestible(Item2),
    Item1 \= Item2.

% c) Relacionar un jugador con un ítem que existe (un ítem existe si lo tiene alguien), y la cantidad que tiene de ese ítem. Si no posee el ítem, la cantidad es 0. cantidadDeItem/3

cantidadDeItem(Jugador, ItemExistente, Cantidad):-
    tieneItem(Jugador, ItemExistente),
    findall(ItemExistente, tieneItem(Jugador, ItemExistente), Lista),
    length(Lista, Cantidad).

% d) Relacionar un jugador con un ítem, si de entre todos los jugadores, es el que más cantidad tiene de ese ítem. tieneMasDe/2

tieneMasDe(Jugador, Item):-
    cantidadDeItem(Jugador, Item, Cantidad),
    forall((cantidadDeItem(OtroJugador, Item, OtraCantidad), OtroJugador \= Jugador), Cantidad > OtraCantidad).

% 2) Alejarse de la oscuridad 
% a) Obtener los lugares en los que hay monstruos. Se sabe que los monstruos aparecen en los lugares cuyo nivel de oscuridad es más de 6. hayMonstruos/1

hayMonstruos(Lugar):-
    lugar(Lugar, _, NivelOscuridad),
    NivelOscuridad > 6.

/*  b) Saber si un jugador corre peligro. Un jugador corre peligro si se encuentra en un lugar donde hay monstruos; o si está hambriento (hambre < 4) y 
no cuenta con ítems comestibles. correPeligro/1 */

correPeligro(Jugador):-
    lugar(Lugar, ListaJugadores, _),
    member(Jugador, ListaJugadores),
    hayMonstruos(Lugar).

correPeligro(Jugador):-
    jugador(Jugador, Items, NivelHambre),
    NivelHambre > 4,
    comestible(ItemComestibles),
    not(member(ItemComestibles, Items)).

/* c) Obtener el nivel de peligrosidad de un lugar, el cual es un número de 0 a 100 y se calcula:
    - Si no hay monstruos, es el porcentaje de hambrientos sobre su población total.
    - Si hay monstruos, es 100.
    - Si el lugar no está poblado, sin importar la presencia de monstruos, es su nivel de oscuridad * 10. nivelPeligrosidad/2 */

porcentajeHambrientos(Lugar, Porcentaje):-
    lugar(Lugar, ListaJugadores, _),
    findall(Jugador, (member(Jugador, ListaJugadores), jugador(Jugador, _, NivelHambre), NivelHambre < 4), ListaHambrientos),
    length(ListaJugadores, CantidadJugadores),
    length(ListaHambrientos, CantidadHambrientos),
    Porcentaje is (CantidadHambrientos * 100) / CantidadJugadores.

estaPoblado(Lugar):-
    lugar(Lugar, _, _),
    findall(Jugadores, lugar(Lugar, Jugadores, _), ListaJugadores),
    length(ListaJugadores, Cantidad),
    Cantidad >= 1.

nivelPeligrosidad(Lugar, Nivel):-
    lugar(Lugar, _, _),
    not(hayMonstruos(Lugar)),
    porcentajeHambrientos(Lugar, Nivel).

nivelPeligrosidad(Lugar, Nivel):-
    lugar(Lugar, _, _),
    hayMonstruos(Lugar),
    Nivel is 100.

nivelPeligrosidad(Lugar, Nivel):-
    lugar(Lugar, _, NivelOscuridad),
    not(estaPoblado(Lugar)),
    Nivel is NivelOscuridad * 10.

/* 3) A construir

El aspecto más popular del juego es la construcción. Se pueden construir nuevos ítems a partir de otros, cada uno tiene ciertos requisitos para poder construirse:
- Puede requerir una cierta cantidad de un ítem simple, que es aquel que el jugador tiene o puede recolectar. Por ejemplo, 8 unidades de piedra.
- Puede requerir un ítem compuesto, que se debe construir a partir de otros (una única unidad).
Con la siguiente información, se pide relacionar un jugador con un ítem que puede construir. puedeConstruir/2 */

item(horno, [ itemSimple(piedra, 8) ]).
item(placaDeMadera, [ itemSimple(madera, 1) ]).
item(palo, [ itemCompuesto(placaDeMadera) ]).
item(antorcha, [ itemCompuesto(palo), itemSimple(carbon, 1) ]).

% Aclaración: Considerar a los componentes de los ítems compuestos y a los ítems simples como excluyentes, es decir no puede haber más de un ítem que requiera el mismo elemento.

puedeConstruir(Jugador, Item):-
    jugador(Jugador, _, _),
    item(Item, ListaRequisitos),
    forall(member(Requisito, ListaRequisitos), cumpleRequisito(Jugador, Requisito)).

cumpleRequisito(Jugador, itemSimple(Item, Cantidad)):-
    cantidadDeItem(Jugador, Item, CantidadJugador),
    CantidadJugador >= Cantidad.

cumpleRequisito(Jugador, itemCompuesto(Item)):-
    puedeConstruir(Jugador, Item).


%4) Para pensar sin bloques

%a) ¿Qué sucede si se consulta el nivel de peligrosidad del desierto? ¿A qué se debe?

/*
?- nivelPeligrosidad(desierto, Nivel).
false.
*/

% El desierto no está poblado, por lo tanto no se cumple la primer cláusula de nivelPeligrosidad/2.

% b) ¿Cuál es la ventaja que nos ofrece el paradigma lógico frente a funcional a la hora de realizar una consulta?

% La ventaja que nos ofrece el paradigma lógico frente al funcional es que podemos realizar consultas existenciales, es decir, preguntar si existe un elemento que cumpla con ciertas condiciones.