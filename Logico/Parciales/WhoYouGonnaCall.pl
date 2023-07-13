/* En épocas de crisis financiera, incluso los habitantes del mundo paranormal abandonan el plano físico en busca de empleo, dejando montones de hogares dados 
vuelta y con sustancias pegajosas en lugares exóticos. Sin fantasmas, y ninguna fuente de ingresos estable,  los cazafantasmas (Peter, Egon, Ray y Winston) deciden cambiar de 
rumbo en una empresa de otro calibre, la tenebrosa limpieza a domicilio.
Sabemos cuáles son las herramientas requeridas para realizar una tarea de limpieza. Además, para las aspiradoras se indica cuál es la potencia mínima requerida para la tarea en cuestión.  */
herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordeadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).

/* Se pide resolver los siguientes requerimientos aprovechando las ideas del paradigma lógico, y asegurando que los predicados principales sean completamente inversibles, a menos que se indique lo contrario:

1) Agregar a la base de conocimientos la siguiente información:
    a) Egon tiene una aspiradora de 200 de potencia.
    b) Egon y Peter tienen un trapeador, Ray y Winston no.
    c) Sólo Winston tiene una varita de neutrones.
    d) Nadie tiene una bordeadora.  */

tiene(egon, aspiradora(200)).
tiene(egon, trapeador).
tiene(peter, trapeador).
tiene(winston, varitaDeNeutrones).

/* 2) Definir un predicado que determine si un integrante satisface la necesidad de una herramienta requerida. Esto será cierto si tiene dicha herramienta, teniendo en 
cuenta que si la herramienta requerida es una aspiradora, el integrante debe tener una con potencia igual o superior a la requerida.
Nota: No se pretende que sea inversible respecto a la herramienta requerida. */

satisfaceNecesidadHerramienta(Integrante, Herramienta):-
    tiene(Integrante, Herramienta).

satisfaceNecesidadHerramienta(Integrante, aspiradora(PotenciaRequerida)):-
    tiene(Integrante, aspiradora(Potencia)),
    Potencia >= PotenciaRequerida.

/* 3) Queremos saber si una persona puede realizar una tarea, que dependerá de las herramientas que tenga. Sabemos que:
    - Quien tenga una varita de neutrones puede hacer cualquier tarea, independientemente de qué herramientas requiera dicha tarea.
    - Alternativamente alguien puede hacer una tarea si puede satisfacer la necesidad de todas las herramientas requeridas para dicha tarea. */

puedeHacerTarea(Integrante, Tarea):-
    herramientasRequeridas(Tarea, _),
    tiene(Integrante, varitaDeNeutrones).

puedeHacerTarea(Integrante, Tarea):-
    herramientasRequeridas(Tarea, _),
    tiene(Integrante, _),
    forall(requiereHerramientas(Tarea, Herramientas), satisfaceNecesidadHerramienta(Integrante, Herramientas)).

requiereHerramientas(Tarea, Herramientas):-
    herramientasRequeridas(Tarea, HerramientasReq),
    member(Herramientas, HerramientasReq).

/* 4) Nos interesa saber de antemano cuanto se le debería cobrar a un cliente por un pedido (que son las tareas que pide). Para ellos disponemos de la siguiente información en la base de conocimientos:
    - tareaPedida/3: relaciona al cliente, con la tarea pedida y la cantidad de metros cuadrados sobre los cuales hay que realizar esa tarea.
    - precio/2: relaciona una tarea con el precio por metro cuadrado que se cobraría al cliente.
Entonces lo que se le cobraría al cliente sería la suma del valor a cobrar por cada tarea, multiplicando el precio por los metros cuadrados de la tarea. */    

%tareaPedida(Cliente, Tarea, Metros^2)
tareaPedida(walter, ordenarCuarto, 30).
tareaPedida(amalia, limpiarTecho, 10).
tareaPedida(pedro, cortarPasto, 50).
tareaPedida(lucas, limpiarBanio, 5).
tareaPedida(mercedes, encerarPisos, 15).

%precio(Tarea, PrecioXMetro^2)
precio(ordenarCuarto, 13).
precio(limpiarTecho, 25).
precio(cortarPasto, 12).
precio(limpiarBanio, 8).
precio(encerarPisos, 20).

cobrarACliente(Cliente, Monto):-
    tareaPedida(Cliente, _, _),
    findall(Tarea, precioTarea(Cliente, Tarea, _), ListaTareas),
    sum_list(ListaTareas, Monto).

precioTarea(Cliente, Tarea, Precio):-
    tareaPedida(Cliente, Tarea, Metros),
    precio(Tarea, PrecioMetro),
    Precio is PrecioMetro * Metros.

/* Finalmente necesitamos saber quiénes aceptarían el pedido de un cliente. Un integrante acepta el pedido cuando puede realizar todas las tareas del pedido y además está dispuesto a aceptarlo.
Sabemos que Ray sólo acepta pedidos que no incluyan limpiar techos, Winston sólo acepta pedidos que paguen más de $500, Egon está dispuesto a aceptar 
pedidos que no tengan tareas complejas y Peter está dispuesto a aceptar cualquier pedido.
Decimos que una tarea es compleja si requiere más de dos herramientas. Además la limpieza de techos siempre es compleja. */

esTareaCompleja(Tarea):-
    herramientasRequeridas(Tarea, Herramientas),
    length(Herramientas, Cantidad),
    Cantidad > 2.
esTareaCompleja(limpiarTecho).

estaDispuestoAHacerlo(ray, Cliente):- not(tareaPedida(_, limpiarTecho, _)).
estaDispuestoAHacerlo(winston, Cliente):- 
    precioTarea(Cliente, _, Precio),
    Precio > 500.
estaDispuestoAHacerlo(egon, Cliente):- not(esTareaCompleja(Tarea)).
estaDispuestoAHacerlo(peter, Cliente).

aceptaPedido(Integrante, Cliente):-
    puedeHacerPedido(Integrante, Cliente),
    estaDispuestoAHacerlo(Integrante, Cliente).

puedeHacerPedido(Integrante, Cliente):-
    tiene(Integrante, _),
    tareaPedida(Cliente, _, _),
    forall(tareaPedida(Cliente, Tarea, _), puedeHacerTarea(Integrante, Tarea)).



    

