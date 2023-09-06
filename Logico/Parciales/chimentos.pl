% programa(Nombre, Rating)
programa(intrusos, 10).
programa(infama, 11).
programa(animalesSueltos, 8).

%conduce(NombrePrograma, Persona)
conduce(intrusos, rial).
conduce(intrusos, ventura).
conduce(infama, delMoro).
conduce(animalesSueltos, fantino).
conduce(animalesSueltos, neumann).
conduce(animalesSueltos, cocoSily).

%primicia(nuevaBotinera(Nombre, Edad), Programa)
%primicia(nuevoRomance(Nombre, Nombre), Programa)
%primicia(escandaloTeatral((Obra, ListaPelea), Programa))
primicia(nuevaBotinera(zairaNara, 20), intrusos).
primicia(nuevoRomance(dePaul, tini), intrusos).
primicia(nuevaBotinera(floppyTesouro, 21), animalesSueltos).
primicia(escandaloTeatral(stravaganza, [flavioMendoza, noeliaPompa]), infama).

/* Punto 1 */

esUnPrograma(Programa):- programa(Programa, _).

puntajePrimicia(nuevaBotinera(_, Edad), Puntaje):- Puntaje is Edad / 10.
puntajePrimicia(nuevoRomance(_, _), 5).
puntajePrimicia(escandaloTeatral(_, Integrantes), Puntaje):- length(Integrantes, Cantidad), Puntaje is Cantidad.

ratingTotal(Programa, Puntaje):- 
    esUnPrograma(Programa), 
    programa(Programa, Rating), 
    findall(PuntajePrimicia, (primicia(Primicia, Programa), puntajePrimicia(Primicia, PuntajePrimicia)), Puntajes), 
    sum_list(Puntajes, PuntajeTotal), 
    Puntaje is Rating + PuntajeTotal.

/* Punto 2 */
noTienenEscandaloTeatral(Programa):-
    esUnPrograma(Programa),
    not(primicia(escandaloTeatral(_, _), Programa)).

/* Punto 3 */
hablo(rial, ventura).
hablo(ventura, zairaNara).
hablo(ventura, dePaul).
hablo(cocoSily, tini). 

lePuedeLlegarChisme(Persona, OtraPersona):-
    hablo(Persona, OtraPersona).

lePuedeLlegarChisme(Persona, OtraPersona):-
    hablo(Persona, Alguien),
    lePuedeLlegarChisme(Alguien, OtraPersona).

lePuedeLlegarChisme(delMoro, _).

/* Punto 4 */
unRomanceEsAutentico(nuevoRomance(Persona1, Persona2), Programa):- 
    esUnPrograma(Programa),
    primicia(nuevoRomance(Persona1, Persona2), Programa),
    forall(conduce(Programa, Conductor), lePuedeLlegarChisme(Conductor, Persona1); lePuedeLlegarChisme(Conductor, Persona2)).

/* Punto 5 */

esProgramaFarandulero(Programa):-
    esUnPrograma(Programa),
    ratingTotal(Programa, Puntaje),
    Puntaje > 30,
    findall(RomanceAutentico, unRomanceEsAutentico(RomanceAutentico, Programa), RomancesAutenticos),
    length(RomancesAutenticos, Cantidad),
    Cantidad > 1.