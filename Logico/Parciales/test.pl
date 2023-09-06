padre(homero,bart). 
padre(homero,maggie). 
padre(homero,lisa).

cantidadHijos(Padre, Valor):-
    padre(Padre, _),
    findall(Hijo, padre(Padre, Hijo), Hijos),
    length(Hijos, Valor).
    

% jugoCon/3: nene, juego, minutos
jugoCon(tobias, pelota, 15).
jugoCon(tobias, bloques, 20).
jugoCon(tobias, rasti, 15).
jugoCon(tobias, dakis, 5).
jugoCon(tobias, casita, 10).
jugoCon(cata, muniecas, 30).
jugoCon(cata, rasti, 20).
jugoCon(luna, muniecas, 10).

/* Queremos saber
cuántos minutos jugó un nene según la base de conocimientos
cuántos juegos distintos jugó (no hay duplicados en la base)
 */

esUnNene(Nene):- jugoCon(Nene, _, _).
minutosNene(Nene, Minutos):-
    esUnNene(Nene),
    findall(Minutos, jugoCon(Nene, _, Minutos), ListaMinutos),
    sumlist(ListaMinutos, Minutos).
    
juegosNene(Nene, Cantidad):-
    esUnNene(Nene),
    findall(Juego, jugoCon(Nene, Juego, _), ListaJuegos),
    length(ListaJuegos, Cantidad).

tiene(juan, foto([juan, hugo, pedro, lorena, laura], 1988)).
tiene(juan, foto([juan], 1977)).
tiene(juan, libro(saramago, "Ensayo sobre la ceguera")).
tiene(juan, bebida(whisky)).
tiene(valeria, libro(borges, "Ficciones")).
tiene(lucas, bebida(cusenier)).
tiene(pedro, foto([juan, hugo, pedro, lorena, laura], 1988)).
tiene(pedro, foto([pedro], 2010)).
tiene(pedro, libro(octavioPaz, "Salamandra")).
 
premioNobel(octavioPaz).
premioNobel(saramago).

unaPersona(Persona):- tiene(Persona, _).

elementoValioso(foto(Gente, _)):- 
    length(Gente, Cantidad),
    Cantidad > 3.

elementoValioso(foto(_, Anio)):-
    Anio < 1990.

elementoValioso(bebida(whisky)).
elementoValioso(libro(Autor, _)):- premioNobel(Autor).

esColeccionista(Persona):-
    unaPersona(Persona),
    forall(tiene(Persona, Elemento), 
    elementoValioso(Elemento)).
