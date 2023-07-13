%Días de cursadas (toda materia que se dicte ofrece al menos una opción horaria)
opcionHoraria(paradigmas, lunes).
opcionHoraria(paradigmas, martes).
opcionHoraria(paradigmas, sabados).
opcionHoraria(algebra, lunes).

%Correlatividades
correlativa(paradigmas, algoritmos).
correlativa(paradigmas, algebra).
correlativa(analisis2, analisis1).
%cursada(persona,materia,evaluaciones)
cursada(maria,algoritmos,[parcial(5),parcial(7),tp(mundial,bien)]).
cursada(maria,algebra,[parcial(5),parcial(8),tp(geometria,excelente)]).
cursada(maria,analisis1,[parcial(9),parcial(4),tp(gauss,bien), tp(limite,mal)]).
cursada(wilfredo,paradigmas,[parcial(7),parcial(7),parcial(7),tp(objetos,excelente),tp(logico,excelente),tp(funcional,excelente)]).
cursada(wilfredo,analisis2,[parcial(8),parcial(10)]).

/* 1. notaFinal/2 relaciona una lista de evaluaciones con la nota final. Las evaluaciones pueden ser o parciales o
tps. La nota final se obtiene promediando las notas. Para eso sabemos que un tp excelente equivale a un 10, un tp bien a un 7 y un tp mal a un 2. */

notaTP(tp(_, excelente), Nota):- Nota is 10.
notaTP(tp(_, bien), Nota):- Nota is 7.
notaTP(tp(_, mal), Nota):- Nota is 2.

notaFinal(ListaEvaluaciones, NotaFinal):-
    findall(Nota, (member(Evaluacion, ListaEvaluaciones), notaEvaluacion(Evaluacion, Nota)), Notas),
    sumlist(Notas, SumaNotas),
    length(Notas, CantidadNotas),
    NotaFinal is SumaNotas / CantidadNotas.

notaEvaluacion(parcial(Nota), Nota).
notaEvaluacion(tp(_, Calificacion), Nota):- notaTP(tp(_, Calificacion), Nota).

/* aprobo/2 relaciona una persona y una materia, sólo si la persona aprobó esa materia (la nota final es 4 ó más
y no se saco menos de 4 en ninguna de sus evaluaciones). Este predicado debe ser inversible. */

seSacoMenosDe4(ListaEvaluaciones):-
    member(Evaluacion, ListaEvaluaciones),
    notaEvaluacion(Evaluacion, Nota),
    Nota < 4.

aprobo(Persona, Materia):-
    cursada(Persona, Materia, Evaluaciones),
    notaFinal(Evaluaciones, NotaFinal),
    NotaFinal >= 4,
    not(seSacoMenosDe4(Evaluaciones)).

/* 3. puedeCursar/2. Relaciona un alumno con una materia que pueda cursar. Una materia se puede cursar cuando
todavia no fue aprobada y todas las correlativas fueron aprobadas (No hay excepciones de correlativas, así que
si una materia esta aprobada todas sus correlativas también). Tengan en cuenta que una materia sin correlativas
siempre puede ser cursada (si no se aprobo antes,claro). */

puedeCursar(Alumno, Materia):-
    not(aprobo(Alumno, Materia)),
    cursada(Alumno, _, _),
    forall(correlativa(Materia, Correlativa), aprobo(Alumno, Correlativa)).

/* 4. opcionesDeCursada/2 Que relaciona un alumno con todas sus opciones posibles de cursadas para el próximo
cuatrimestre. Las opciones de cursadas representan una materia que el alumno puede cursar en una opción
horaria dada para dicha materia.
Una opción se representa con el functor opcion/2 que representa una materia con un día en el que se dicta. Este
predicado debe de ser inversible. */

opcionesDeCursada(Alumno, Opciones):-
    cursada(Alumno, _, _),
    opcionHoraria(Materia, _),
    puedeCursar(Alumno, Materia),
    findall(opcion(Materia, Dia), opcionHoraria(Materia, Dia), Opciones).

/* 5.a. sinSuperposiciones/2 Que relaciona a una lista de opciones con las opciones que podrían conformar una
cursada. Una cursada se conforma cuando todas las opciones de la lista son compatibles entre sí (cada materia
está a lo sumo una vez y no se repiten los días de cursada).
b. Hacer que este predicado sea inversible para el segundo argumento. */

/* Ayuditas:
Se cuenta definido el predicado subconjunto que relaciona un conjunto con una lista si el primero es subconjunto
del segundo. */

subconjunto([],_).
subconjunto([X|Xs],L):-
sinElemento(X,L,L2),
subconjunto(Xs,L2).
sinElemento(E,[E|Xs],Xs).
sinElemento(E,[X|Xs],[X|XsSinE]):-
sinElemento(E,Xs,XsSinE).

sonCompatibles(opcion(Materia1, Dia1), opcion(Materia2, Dia2)):-
    Materia1 \= Materia2,
    Dia1 \= Dia2.

sinSuperposiciones(ListaOpciones, Opciones):-
    subconjunto(Opciones, ListaOpciones),
    forall((member(Opcion1, Opciones), member(Opcion2, Opciones), Opcion1 \= Opcion2), sonCompatibles(Opcion1, Opcion2)).