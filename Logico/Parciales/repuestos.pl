%auto(identificacion, combustible, capacidad, seguridad)
auto(mcqueen, 40, 50, 5).
auto(delorean, 50, 60, 7).
auto(troncomovil, 30, 70, 9).

% repuesto(Descripcion, Magnitud).
repuesto(tanqueCombustible, 5).
repuesto(condensadorDeFlujo, 10).
repuesto(cubierta, 30).
esencial(turbo).

% componente(Identificacion, Descripcion, CantidadDiasDesdeAdquisicion).
componente(mcqueen, tanqueCombustible, 17).
componente(mcqueen, cubierta, 50).
componente(delorean, condensadorDeFlujo, 365).

nivelInseguridad(10).

/* Punto 1 */

componenteHaceMasDe100Dias(Auto, Repuesto) :-
    componente(Auto, Repuesto, DiasDesdeAdquisicion),
    DiasDesdeAdquisicion > 100.

repuestoConMagnitud17(Repuesto) :-
    repuesto(Repuesto, 17).

autoInseguroOMitadTanque(Auto) :-
    auto(Auto, _, _, Seguridad),
    nivelInseguridad(NivelMax),
    Seguridad > NivelMax.

autoInseguroOMitadTanque(Auto) :-
    auto(Auto, _, Capacidad, _),
    Capacidad / 2 > 0.

seColocoAnteriormente(Auto, Repuesto) :-
    componente(Auto, Repuesto, _).

esConveniente(Auto, Repuesto) :-
    autoInseguroOMitadTanque(Auto),
    esencial(Repuesto).

esConveniente(Auto, Repuesto) :-
    componenteHaceMasDe100Dias(Auto, Repuesto).

esConveniente(Auto, Repuesto) :-
    repuestoConMagnitud17(Repuesto),
    not(seColocoAnteriormente(Auto, Repuesto)).

/* Punto 2 */

cantidadComponentes(Auto, Cantidad) :-
    auto(Auto, _, _, _),
    findall(Repuesto, componente(Auto, Repuesto, _), Repuestos),
    length(Repuestos, Cantidad).

tienenMasDe1Componente(Auto) :-
    cantidadComponentes(Auto, Cantidad),
    Cantidad > 1.

tiene1Componente(Auto):- 
    cantidadComponentes(Auto, Cantidad),
    Cantidad = 1.

noTieneComponentes(Auto):-
    cantidadComponentes(Auto, Cantidad),
    Cantidad = 0.

/* Punto 3 */

convieneColocar(Auto, Repuesto) :-
    repuesto(Repuesto, _),
    forall(tienenMasDe1Componente(Auto), esConveniente(Auto, Repuesto)).