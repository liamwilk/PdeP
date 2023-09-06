/* Parte Canciones */
% Cancion, Compositores, Reproducciones
cancion(bailanSinCesar, [pabloIlabaca, rodrigoSalinas], 10600177).
cancion(yoOpino, [alvaroDiaz, carlosEspinoza, rodrigoSalinas], 5209110).
cancion(equilibrioEspiritual, [danielCastro, alvaroDiaz, pabloIlabaca, pedroPeirano, rodrigoSalinas], 12052254).
cancion(tangananicaTanganana, [danielCastro, pabloIlabaca, pedroPeirano], 5516191).
cancion(dienteBlanco, [danielCastro, pabloIlabaca, pedroPeirano], 5872927).
cancion(lala, [pabloIlabaca, pedroPeirano], 5100530).
%Revisa el archivo del repo, que este hecho estaba con un argumento de más.
cancion(meCortaronMalElPelo, [danielCastro, alvaroDiaz, pabloIlabaca, rodrigoSalinas], 3428854).

% Mes, Puesto, Cancion
rankingTop3(febrero, 1, lala).
rankingTop3(febrero, 2, tangananicaTanganana).
rankingTop3(febrero, 3, meCortaronMalElPelo).
rankingTop3(marzo, 1, meCortaronMalElPelo).
rankingTop3(marzo, 2, tangananicaTanganana).
rankingTop3(marzo, 3, lala).
rankingTop3(abril, 1, tangananicaTanganana).
rankingTop3(abril, 2, dienteBlanco).
rankingTop3(abril, 3, equilibrioEspiritual).
rankingTop3(mayo, 1, meCortaronMalElPelo).
rankingTop3(mayo, 2, dienteBlanco).
rankingTop3(mayo, 3, equilibrioEspiritual).
rankingTop3(junio, 1, dienteBlanco).
rankingTop3(junio, 2, tangananicaTanganana).
rankingTop3(junio, 3, lala).

/* Punto 1 */
esUnaCancion(Cancion):- cancion(Cancion, _, _).
esUnMes(Mes):- rankingTop3(Mes, _, _).
esUnHit(Cancion):- esUnaCancion(Cancion), forall(esUnMes(Mes), rankingTop3(Mes, _, Cancion)).

/* Punto 2 */
tieneMuchasReproducciones(Cancion):- cancion(Cancion,_,Cantidad), Cantidad > 7000000.
estuvoEnRanking(Cancion):- esUnaCancion(Cancion), rankingTop3(_, _, Cancion).
noEsReconocida(Cancion):- tieneMuchasReproducciones(Cancion), not(estuvoEnRanking(Cancion)).

/* Punto 3 */
sonColaboradores(Compositor1, Compositor2):- cancion(_,ListaCompositores,_), member(Compositor1, ListaCompositores), member(Compositor2, ListaCompositores), Compositor1 \= Compositor2.

/* Parte Trabajo */
/* Punto 4 */
trabajador(tulio, conductor(5)).
trabajador(juanin, conductor(0)).
trabajador(bodoque, periodista(2, licenciatura)).
trabajador(marioHugo, periodista(10, posgrado)).
trabajador(bodoque, reportero(5, 300)).

/* Punto 5 */
sueldo(trabajador(_, conductor(Anios)), Sueldo):- Sueldo is 10000 * Anios.
sueldo(trabajador(_, reportero(Anios, Notas)), Sueldo):- Sueldo is (10000 * Anios) + (100 * Notas).
sueldo(trabajador(_, periodista(Anios, licenciatura)), Sueldo):- Sueldo is 5000 * Anios * 1.20.
sueldo(trabajador(_, periodista(Anios, posgrado)), Sueldo):- Sueldo is 5000 * Anios * 1.35.

esUnaPersona(Persona):- trabajador(Persona, _).

sueldoTotal(Persona, Sueldo):- esUnaPersona(Persona), listaSueldos(Persona, Lista), sumlist(Lista, Sueldo).

listaSueldos(Persona, Lista):- findall(SueldoPersona, (trabajador(Persona, Trabajo), sueldo(trabajador(Persona, Trabajo), SueldoPersona)), Lista).