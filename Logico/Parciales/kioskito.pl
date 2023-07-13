/* Son tiempos difíciles y además de dar clases, los profesores de Paradigmas abrimos un kioskito. Para poder atenderlo como se debe, establecimos un sistema de turnos donde cada persona se hace responsable. Por ejemplo:
dodain atiende lunes, miércoles y viernes de 9 a 15.
lucas atiende los martes de 10 a 20
juanC atiende los sábados y domingos de 18 a 22.
juanFdS atiende los jueves de 10 a 20 y los viernes de 12 a 20.
leoC atiende los lunes y los miércoles de 14 a 18.
martu atiende los miércoles de 23 a 24. */
atiende(dodain, lunes, 9, 15).
atiende(dodain, miercoles, 9, 15).
atiende(dodain, viernes, 9, 15).
atiende(lucas, martes, 10, 20).
atiende(juanC, sabado, 18, 22).
atiende(juanC, domingo, 18, 22).
atiende(juanFdS, jueves, 10, 20).
atiende(juanFdS, viernes, 12, 20).
atiende(leoC, lunes, 14, 18).
atiende(leoC, miercoles, 14, 18).
atiende(martu, miercoles, 23, 24).

/* Punto 1: calentando motores (2 puntos)
Definir la relación para asociar cada persona con el rango horario que cumple, e incorporar las siguientes cláusulas:
    - vale atiende los mismos días y horarios que dodain y juanC.
    - nadie hace el mismo horario que leoC
    - maiu está pensando si hace el horario de 0 a 8 los martes y miércoles

En caso de no ser necesario hacer nada, explique qué concepto teórico está relacionado y justifique su respuesta. */

atiende(vale, Dia, HI, HF) :- atiende(dodain, Dia, HI, HF).

atiende(vale, Dia, HI, HF) :- atiende(juanC, Dia, HI, HF).

% Nadie no tiene sentido hacerlo, y lo desconocido es Falso.

/* Punto 2: quién atiende el kiosko... (2 puntos)
Definir un predicado que permita relacionar un día y hora con una persona, en la que dicha persona atiende el kiosko. Algunos ejemplos:
si preguntamos quién atiende los lunes a las 14, son dodain, leoC y vale
si preguntamos quién atiende los sábados a las 18, son juanC y vale
si preguntamos si juanFdS atiende los jueves a las 11, nos debe decir que sí.
si preguntamos qué días a las 10 atiende vale, nos debe decir los lunes, miércoles y viernes.

El predicado debe ser inversible para relacionar personas y días. */

quienAtiende(Dia, Hora, Persona) :-
    atiende(Persona, Dia, HI, HF),
    between(HI, HF, Hora).

/* Punto 3: Forever alone (2 puntos)
Definir un predicado que permita saber si una persona en un día y horario determinado está atendiendo ella sola. En este predicado debe utilizar not/1, y debe ser inversible para relacionar personas. Ejemplos:
si preguntamos quiénes están forever alone el martes a las 19, lucas es un individuo que satisface esa relación.
si preguntamos quiénes están forever alone el jueves a las 10, juanFdS es una respuesta posible.
si preguntamos si martu está forever alone el miércoles a las 22, nos debe decir que no (martu hace un turno diferente)
martu sí está forever alone el miércoles a las 23
el lunes a las 10 dodain no está forever alone, porque vale también está */

estaAtendiendoSola(Persona, Dia, Hora):-
    quienAtiende(Dia, Hora, Persona),
    not((quienAtiende(Dia, Hora, OtraPersona), Persona \= OtraPersona)).

/* Punto 4: posibilidades de atención (3 puntos / 1 punto)
Dado un día, queremos relacionar qué personas podrían estar atendiendo el kiosko en algún momento de ese día. Por ejemplo, si preguntamos por el miércoles, tiene que darnos esta combinatoria:
nadie
dodain solo
dodain y leoC
dodain, vale, martu y leoC
vale y martu
etc.

Queremos saber todas las posibilidades de atención de ese día. La única restricción es que la persona atienda ese día (no puede aparecer lucas, por ejemplo, porque no atiende el miércoles).

Punto extra: indique qué conceptos en conjunto permiten resolver este requerimiento, justificando su respuesta. */

atiendenEseDia(Dia, Personas):-
    findall(Persona, atiende(Persona, Dia, _, _), ListaPersonas),
    combinar(ListaPersonas, Personas).

combinar([], []).
combinar([Persona|PersonasPosibles], [Persona|Personas]):-combinar(PersonasPosibles, Personas).
combinar([_|PersonasPosibles], Personas):-combinar(PersonasPosibles, Personas).

/* Punto 5: ventas / suertudas (4 puntos)
En el kiosko tenemos por el momento tres ventas posibles:
    - golosinas, en cuyo caso registramos el valor en plata
    - cigarrillos, de los cuales registramos todas las marcas de cigarrillos que se vendieron (ej: Marlboro y Particulares)
    - bebidas, en cuyo caso registramos si son alcohólicas y la cantidad

Queremos agregar las siguientes cláusulas:
    - dodain hizo las siguientes ventas el lunes 10 de agosto: golosinas por $ 1200, cigarrillos Jockey, golosinas por $ 50
    - dodain hizo las siguientes ventas el miércoles 12 de agosto: 8 bebidas alcohólicas, 1 bebida no-alcohólica, golosinas por $ 10
    - martu hizo las siguientes ventas el miercoles 12 de agosto: golosinas por $ 1000, cigarrillos Chesterfield, Colorado y Parisiennes.
    - lucas hizo las siguientes ventas el martes 11 de agosto: golosinas por $ 600.
    - lucas hizo las siguientes ventas el martes 18 de agosto: 2 bebidas no-alcohólicas y cigarrillos Derby.

Queremos saber si una persona vendedora es suertuda, esto ocurre si para todos los días en los que vendió, la primera venta que hizo fue importante. Una venta es importante:
    - en el caso de las golosinas, si supera los $ 100.
    - en el caso de los cigarrillos, si tiene más de dos marcas.
    - en el caso de las bebidas, si son alcohólicas o son más de 5.

El predicado debe ser inversible: martu y dodain son personas suertudas. */

%ventas(quien, fecha(dia, mes), [quevendio(precio/tipo)])

ventas(dodain, fecha(10,8), [golosinas(1200), cigarrillos([jockey]), golosinas(50)]).
ventas(dodain, fecha(12,8), [bebida(true, 8), bebida(false, 1), golosionas(10)]).
ventas(martu, fecha(12,8), [golosinas(1000), cigarrillos([chesterfield, colorado, parisiennes])]).
ventas(lucas, fecha(11,8), [golosionas(600)]).
ventas(lucas, fecha(18,8), [bebidas(false, 2), cigarrillos([derby])]).

esVentaImportante(golosinas(Valor)):-
    Valor > 100.

esVentaImportante(cigarrillos(Marcas)):-
    length(Marcas, Cantidad),
    Cantidad > 2.

esVentaImportante(bebidas(true, _)).

esVentaImportante(bebidas(_, Cantidad)):-
    Cantidad > 5.

vendedor(Persona):-
    ventas(Persona, _, _).

vendedorSuertudo(Persona):-
    vendedor(Persona),
    forall(ventas(Persona, _, [Venta|_]), esVentaImportante(Venta)).
