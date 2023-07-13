% Relaciona al dueño con el nombre del juguete y la cantidad de años que lo ha tenido
duenio(andy, woody, 8).
duenio(sam, jessie, 3).
% Relaciona al juguete con su nombre
% los juguetes son de la forma:
% deTrapo(tematica)
% deAccion(tematica, partes)
% miniFiguras(tematica, cantidadDeFiguras)
% caraDePapa(partes)
juguete(woody, deTrapo(vaquero)).
juguete(jessie, deTrapo(vaquero)).
juguete(buzz, deAccion(espacial, [original(casco)])).
juguete(soldados, miniFiguras(soldado, 60)).
juguete(monitosEnBarril, miniFiguras(mono, 50)).
juguete(seniorCaraDePapa, caraDePapa([ original(pieIzquierdo), original(pieDerecho), repuesto(nariz) ])).

% Dice si un juguete es raro
esRaro(deAccion(stacyMalibu, 1, [sombrero])).
% Dice si una persona es coleccionista
esColeccionista(sam).

% Nota: siempre que nos refiramos al functor que representa al juguete le diremos “juguete”. Y siempre que nos refiramos al átomo con su nombre, le diremos “nombre del juguete”

% 1. a. tematica/2: relaciona a un juguete con su temática. La temática de los cara de papa es caraDePapa.

tematica(Juguete, Tematica):-
    juguete(Juguete, deTrapo(Tematica)).

tematica(Juguete, Tematica):-
    juguete(Juguete, deAccion(Tematica, _)).

tematica(Juguete, Tematica):-
    juguete(Juguete, miniFiguras(Tematica, _)).

tematica(Juguete, caraDePapa):-
    juguete(Juguete, caraDePapa(_)).

% 1. b. esDePlastico/1: Nos dice si el juguete es de plástico, lo cual es verdadero sólo para las miniFiguras y los caraDePapa.

esDePlastico(Juguete):-
    juguete(Juguete, miniFiguras(_, _)).

esDePlastico(Juguete):-
    juguete(Juguete, caraDePapa(_)).

% 1. c. esDeColeccion/1:Tanto lo muñecos de acción como los cara de papa son de colección si son raros, los de trapo siempre lo son, y las mini figuras, nunca.

esDeColeccion(Juguete):-
    esRaro(Juguete).

esDeColeccion(Juguete):-
    juguete(Juguete, deTrapo(_)).

% 2. amigoFiel/2: Relaciona a un dueño con el nombre del juguete que no sea de plástico que tiene hace más tiempo. Debe ser completamente inversible.

amigoFiel(Duenio, Juguete):-
    duenio(Duenio, Juguete, Tiempo),
    not(esDePlastico(Juguete)),
    forall((duenio(Duenio, OtroJuguete, OtroTiempo), not(esDePlastico(OtroJuguete)), Juguete \= OtroJuguete), Tiempo >= OtroTiempo). 

% 3. superValioso/1: Genera los nombres de juguetes de colección que tengan todas sus piezas originales, y que no estén en posesión de un coleccionista.

superValioso(Juguete):-
    esDeColeccion(Juguete),
    juguete(Juguete, Tipo),
    todasOriginales(Tipo),
    not(estaEnPosesionDeColeccionista(Juguete)).

todasOriginales(deAccion(_, Partes)):-
    forall(member(Parte, Partes), esOriginal(Parte)).

todasOriginales(caraDePapa(Partes)):-
    forall(member(Parte, Partes), esOriginal(Parte)).

esOriginal(original(_)).

estaEnPosesionDeColeccionista(Juguete):-
    esColeccionista(Duenio),
    duenio(Duenio, Juguete, _).

/* 4. dúoDinámico/3: Relaciona un dueño y a dos nombres de juguetes que le pertenezcan que
hagan buena pareja. Dos juguetes distintos hacen buena pareja si son de la misma temática.
Además woody y buzz hacen buena pareja. Debe ser complemenente inversible. */

duoDinamico(Duenio, Juguete, OtroJuguete):-
    duenio(Duenio, Juguete, _),
    duenio(Duenio, OtroJuguete, _),
    tienenMismaTematica(Juguete, OtroJuguete).

duoDinamico(_, woody, buzz).


tienenMismaTematica(Juguete, OtroJuguete):-
    tematica(Juguete, Tematica),
    tematica(OtroJuguete, Tematica).

/* 5. felicidad/2:Relaciona un dueño con la cantidad de felicidad que le otorgan todos sus juguetes:
    ● las minifiguras le dan a cualquier dueño 20 * la cantidad de figuras del conjunto
    ● los cara de papas dan tanta felicidad según que piezas tenga: las originales dan 5, las de repuesto,8.
    ● los de trapo, dan 100
    ● Los de accion, dan 120 si son de coleccion y el dueño es coleccionista. Si no dan lo mismo que los de trapo.
    Debe ser completamente inversible. */

felicidad(Duenio, Cantidad):-
    duenio(Duenio, _, _),
    findall(Juguetes, duenio(Duenio, Juguetes, _), ListaJuguetes),
    findall(CantidadFelicidad, (member(Juguete, ListaJuguetes), cantidadFelicidad(Juguete, CantidadFelicidad)), Cantidades),
    sum_list(Cantidades, Cantidad).

cantidadFelicidad(Juguete, Cantidad):-
    juguete(_, minifiguras(_, CantidadMinifiguras)),
    Cantidad is 20 * CantidadMinifiguras.

cantidadFelicidad(Juguete, Cantidad):-
    juguete(Juguete, caraDePapa(Partes)),
    findall(Felicidad, felicidadDeParte(Partes, Felicidad), Felicidades),
    sum_list(Felicidades, Cantidad).

felicidadDeParte(original(_), 5).
felicidadDeParte(repuesto(_), 8).

cantidadFelicidad(Juguete, 100):-
    juguete(Juguete, deTrapo(_)).

cantidadFelicidad(Juguete, Cantidad):-
    juguete(Juguete, deAccion(_, _, _)),
    esDeColeccion(Juguete),
    esColeccionista(Duenio),
    Cantidad is 120.

/* 6. puedeJugarCon/2: Relaciona a alguien con un nombre de juguete cuando puede jugar con él.
Esto ocurre cuando:
● este alguien es el dueño del juguete
● o bien, cuando exista otro que pueda jugar con este juguete y pueda prestárselo
Alguien puede prestarle un juguete a otro cuando es dueño de una mayor cantidad de juguetes. */
puedeJugarCon(Alguien, Juguete):- duenio(Alguien, Juguete, _).
puedeJugarCon(Alguien, Juguete):- puedePrestarJuguete(Alguien, Juguete).

puedePrestarJuguete(Alguien, Juguete):-
    duenio(Alguien, _, _),
    duenio(OtroAlguien, Juguete, _),
    cantidadJuguetes(Alguien, CantidadAlguien),
    cantidadJuguetes(OtroAlguien, CantidadOtroAlguien),
    CantidadAlguien > CantidadOtroAlguien.

cantidadJuguetes(Alguien, Cantidad):-
    findall(Juguete, duenio(Alguien, Juguete, _), ListaJuguetes),
    length(ListaJuguetes, Cantidad).

/* 7. podriaDonar/3: relaciona a un dueño, una lista de
juguetes propios y una cantidad de felicidad cuando entre
todos los juguetes de la lista le generan menos que esa
cantidad de felicidad. Debe ser completamente inversible. */

podriaDonar(Duenio, ListaJuguetes, CantidadFelicidad):-
    duenio(Duenio, _, _),
    findall(Juguete, duenio(Duenio, Juguete, _), ListaJuguetes),
    felicidad(Duenio, Felicidad),
    Felicidad < CantidadFelicidad.

/* 8. Comentar dónde se aprovechó el polimorfismo */

/* Se aprovechó el polimorfismo en el predicado cantidadFelicidad/2, debido a que es posible utilizarlo para cualquier tipo de juguete,
ya que se utiliza el predicado juguete/2 para obtener el tipo de juguete y luego se utiliza el predicado felicidadDeParte/2
para obtener la felicidad de cada parte del juguete. */
