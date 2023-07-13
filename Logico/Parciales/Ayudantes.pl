/* 1. Los ayudantes están para trabajar...
Se conocen las tareas pendientes que cada ayudante tiene asignadas (todo ayudante tiene al menos
una tarea), los grupos de tp que están en problemas y el día del año corriente: */
% Las tareas son functores de la forma
% corregirTp(fechaEnQueElGrupoEntrego, grupo, paradigma)
% robarseBorrador(diaDeLaClase, horario)
% prepararParcial(paradigma).
tarea(vero, corregirTp(190, losMagiosDeTempeley, funcional)).
tarea(hernan, corregirTp(181, analiaAnalia, objetos)).
tarea(hernan, robarseBorrador(197, turnoManiana)).
tarea(hernan, prepararParcial(objetos)).
tarea(alf, prepararParcial(funcional)).
tarea(nitu, corregirTp(190, analiaAnalia, funcional)).
tarea(ignacio, corregirTp(186, laTerceraEsLaVencida, logico)).
tarea(clara, robarseBorrador(197, turnoNoche)).
tarea(hugo, corregirTp(10, laTerceraEsLaVencida, objetos)).
tarea(hugo, robarseBorrador(11, turnoNoche)).
% Estos grupos están en problemas
noCazaUna(loMagiosDeTempeley).
noCazaUna(losExDePepita).
% El 1 es el primero de enero, el 32 es el 1 de febrero, etc
diaDelAnioActual(192).


/* 1.a. Saber si una tarea es difícil. Considerar que:
● Robarse un borrador es difícil solamente en el turno noche
● Corregir un tp es difícil si es sobre el paradigma de objetos o si el grupo no caza una.
● Preparar un parcial es difícil */

esDificil(robarseBorrador(_, turnoNoche)).
esDificil(corregirTp(_, _, objetos)).
esDificil(corregirTp(_, Grupo, _)):- noCazaUna(Grupo).
esDificil(prepararParcial(_)).

/* 1.b. Saber si la tarea de un ayudante está atrasada. Una tarea está atrasada si su atraso es mayor a
tres días (pasados de la fecha de vencimiento).
● La fecha de vencimiento para corregir un tp es 4 días después de entregado
● La fecha de vencimiento para robar un borrador de un aula vecina es el día de la clase.
Además, todos se atrasan siempre para hacer los parciales. */

tareaAtrasada(Ayudante, Tarea):-
    tarea(Ayudante, Tarea),
    fechaDeVencimiento(Tarea, FechaDeVencimiento),
    diaDelAnioActual(DiaDelAnioActual),
    Atraso is DiaDelAnioActual - FechaDeVencimiento,
    Atraso > 3.

fechaDeVencimiento(corregirTp(FechaEnQueElGrupoEntrego, _, _), FechaDeVencimiento):-
    FechaDeVencimiento is FechaEnQueElGrupoEntrego + 4.

fechaDeVencimiento(robarseBorrador(DiaDeLaClase, _), DiaDeLaClase).

% 1.c Conocer la lista de ayudantes que corrigieron tps de cada grupo.

verdugos(Grupo, ListaAyudantes):-
    tarea(_, corregirTp(_, Grupo, _)),
    findall(Ayudante, tarea(Ayudante, corregirTp(_, Grupo, _)), ListaAyudantes).

/* 2. Pero también son seres humanos...
Se agrega la siguiente información a la base de conocimiento: */
laburaEnProyectoEnLLamas(alf).
laburaEnProyectoEnLLamas(hugo).
cursa(nitu, [ operativos, disenio, analisisMatematico2 ]).
cursa(clara, [ sintaxis, operativos ]).
cursa(ignacio, [ tacs, administracionDeRecursos ] ).
tienePareja(nitu).
tienePareja(alf).

% 2.a. Saber si un ayudante tiene problemitas: los tiene si tiene pareja, si el proyecto en el que labura está en llamas o si cursa sistemas operativos.

tieneProblemitas(Ayudante):- tienePareja(Ayudante).
tieneProblemitas(Ayudante):- laburaEnProyectoEnLLamas(Ayudante).
tieneProblemitas(Ayudante):-
    cursa(Ayudante, ListaMaterias),
    member(operativos, ListaMaterias).

% 2.b alHorno/1 Saber si un ayudante está al horno: lo está si todas sus tareas son difíciles, tiene alguna tareas atrasada y tiene problemitas.

alHorno(Ayudante):-
    tarea(Ayudante, Tarea),
    forall(tarea(Ayudante, Tarea), esDificil(Tarea)),
    tareaAtrasada(Ayudante, Tarea),
    tieneProblemitas(Ayudante).

/* 3.a Se tiene la siguiente consulta:
    ?- tareaAtrasada(franco, prepararParcial(logico)).
    ● ¿Cual es su valor de verdad?
    ● ¿Con qué concepto está relacionado? */

% El valor de verdad es false, ya que no se encuentra en la base de conocimiento la tarea de prepararParcial(logico) para el ayudante franco.
% El concepto relacionado es el de universo cerrado, ya que si no se encuentra en la base de conocimiento, se considera que es falso.

% 3.b ¿Dónde se utilizó el polimorfismo? ¿Para qué fue util?

% Se utilizó el polimorfismo en el predicado esDificil/1, ya que se puede utilizar para cualquier tipo de tarea, sin importar el paradigma.

% 3.c ¿Son inversibles los predicados de los items 2.a y 2.b? ¿Por qué? En caso afirmativo, ¿Cómo se logró que lo sean? En caso negativo, ¿Cómo modificar la solución para que lo sea?

% El predicado tieneProblemitas/1 es inversible, ya que se puede consultar si un ayudante tiene problemas, y también se puede consultar qué ayudantes tienen problemas.
% El predicado alHorno/1 es inversible, ya que se puede consultar si un ayudante está al horno, y también se puede consultar qué ayudantes están al horno.