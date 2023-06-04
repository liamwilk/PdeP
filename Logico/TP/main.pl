% TP: horoscopo pdep
/* Según en que parte del año nacio una persona, le toca un paradigma diferente:
- desde el inicio de clases hasta ayer, funcional
- desde hoy hasta las vacaciones de invierno, logico
- segundo cuatrimestre objetos
- resto del año, nada 

por ejemplo:
por ejemplo:
horoscopoPdeP(nacho, P)
P = funcional

horoscopoPdeP(lola, P)
false

horoscopoPdeP(Quien, logico)
Quien = tito
Quien = tita
*/

nacio(nacho,bsas,26,6,1989).
nacio(tito,bsas,26,4,2000).
nacio(tita,bsas,27,4,2000).
nacio(lola,bsas,1,1,2001).

horoscopoPdeP(Quien, funcional) :-
    nacio(Quien, _, _, Mes, _),
    (Mes = 3, nacio(Quien, _, Dia, _, _), Dia >= 28;
    Mes = 4;
    Mes = 5, nacio(Quien, _, Dia, _, _), Dia =< 29).

horoscopoPdeP(Quien, logico) :-
    nacio(Quien, _, _, Mes, _),
    (Mes = 5, nacio(Quien, _, Dia, _, _), Dia >= 30;
    Mes = 6;
    Mes = 7, nacio(Quien, _, Dia, _, _), Dia =< 11).

horoscopoPdeP(Quien, objetos) :-
    nacio(Quien, _, _, Mes, _),
    (Mes = 8, nacio(Quien, _, Dia, _, _), Dia >= 22;
    Mes = 9;
    Mes = 10;
    Mes = 11, nacio(Quien, _, Dia, _, _), Dia =< 14).

horoscopoPdeP(Quien, nada) :-
    nacio(Quien, _, _, _, _),
    \+ horoscopoPdeP(Quien, funcional),
    \+ horoscopoPdeP(Quien, logico),
    \+ horoscopoPdeP(Quien, objetos).

