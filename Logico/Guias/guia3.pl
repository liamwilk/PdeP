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

/* Determinamos que alguien es coleccionista si todos los elementos que tiene son valiosos:
un libro de un premio Nobel es valioso
una foto con más de 3 integrantes es valiosa
una foto anterior a 1990 es valiosa
el whisky es valioso */

esColeccionista(Alguien):-
    tiene(Alguien, _),
    forall(tiene(Alguien, Cosa), esValiosa(Cosa)).

esValiosa(libro(Escritor, _)):-
    premioNobel(Escritor).

esValiosa(foto(Integrantes, _)):-
    length(Integrantes, Cantidad),
    Cantidad > 3.

esValiosa(foto(_, Anio)):-
    Anio < 1990.

esValiosa(bebida(whisky)).
