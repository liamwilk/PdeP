%puerto(Puerto,Pais)
puerto(colon,panama).
puerto(georgetown,islasCaiman).
puerto(nicholls,bahamas).
puerto(habana,cuba).
puerto(cartagena,colombia).

%ruta(Puerto,OtroPuerto,Distancia)
ruta(colon,georgetown,70).
ruta(habana,colon,40).
ruta(nicholls,habana,30).
ruta(cartagena,nicholls,500).
ruta(cartagena,georgetown,200).

%viaje(Puerto,OtroPuerto,Botin,Embarcacion)
viaje(colon,nicholls,3000,galeon(4)).
viaje(colon,georgetown,5000,carabela(500,30)).
viaje(colon,georgetown,10000,galera(brasil)).
viaje(cartagena,georgetown,1000,galera(argentina)).
viaje(nicholls,cartagena,2000,galeon(6)).

%barcoPirata(CapitanPirata,NombreBarco,CantPiratas,Impetu)
barcoPirata(jackSparrow, perlaNegra,40,100).
barcoPirata(davyJones, holandesErrante,100,200).
barcoPirata(hectorBarbosa, venganzaDeLaReinaAna, 9, 0).

/* Punto 1 */

poderioCapitanPirata(CapitanPirata, Valor):- 
    barcoPirata(CapitanPirata, _, CantPiratas, Impetu),
    Valor is (CantPiratas + 2) * Impetu.

esUnaEmbarcacion(Embarcacion):- viaje(_, _, _, Embarcacion).

resistenciaEmbarcacion(galeon(CantCaniones), Distancia, Resistencia):- Resistencia is CantCaniones * 100 / Distancia.
resistenciaEmbarcacion(carabela(_, Cantidad), ValorMercancia, Resistencia):- Resistencia is (ValorMercancia / 10) + Cantidad.
resistenciaEmbarcacion(galera(espania), Distancia, Resistencia):- Resistencia is 100 / Distancia.
resistenciaEmbarcacion(galera(Pais), ValorMercancia, Resistencia):- Pais \= espania, Resistencia is ValorMercancia * 10.

puedeAbordarEmbarcacion(CapitanPirata, Embarcacion):-
    esUnaEmbarcacion(Embarcacion),
    poderioCapitanPirata(CapitanPirata, Poderio),
    resistenciaEmbarcacion(Embarcacion, _, Resistencia),
    Poderio > Resistencia.

/* Punto 2 */
botinTotal(CapitanPirata, Puerto, BotinTotal):-
    puerto(Puerto, _),
    findall(Botin, (viaje(Puerto, _, Botin, Embarcacion), puedeAbordarEmbarcacion(CapitanPirata, Embarcacion)), Botines),
    sum_list(Botines, BotinTotal).

/* Punto 3 */

tieneMenosDe10Piratas(CapitanPirata):- 
    barcoPirata(CapitanPirata, _, CantPiratas, _),
    CantPiratas < 10.

esDecadente(CapitanPirata):-
    tieneMenosDe10Piratas(CapitanPirata),
    forall(viaje(_, _, _, Embarcacion), not(puedeAbordarEmbarcacion(CapitanPirata, Embarcacion))).

esElUnicoQuePuedeAbordar(CapitanPirata, Puerto):-
    puerto(Puerto, _),
    forall(viaje(Puerto, _, _, Embarcacion), puedeAbordarEmbarcacion(CapitanPirata, Embarcacion)),
    forall(viaje(_, Puerto, _, Embarcacion), puedeAbordarEmbarcacion(CapitanPirata, Embarcacion)).

terrorDelPuerto(CapitanPirata):-
    esElUnicoQuePuedeAbordar(CapitanPirata, Puerto),
    forall(esElUnicoQuePuedeAbordar(CapitanPirata, OtroPuerto), Puerto == OtroPuerto).

esExcentrico(CapitanPirata):-
    barcoPirata(CapitanPirata, _, _, Impetu),
    forall(barcoPirata(_, _, _, OtroImpetu), Impetu > OtroImpetu).

/* Punto 4 */
/* Asumiendo (sólo para este ítem) que las rutas marítimas son unidireccionales y que no hay ciclos, averiguar si un determinado pirata puede ir de un puerto a otro, 
considerando que se debe poder llegar al destino final pasando eventualmente por puertos intermedios, de manera que el poderío del capitán pirata sea siempre mayor a la 
distancia de cada una de las rutas maritimas utilizadas. */

puedeIrDesdeHasta(Capitan, Puerto1, Puerto2):-
	puedeRealizarRuta(Capitan,Puerto1,Puerto2).

puedeIrDesdeHasta(Capitan, Puerto1, Puerto2):-
	puedeRealizarRuta(Capitan,Puerto1,OtroPuerto),
	puedeIrDesdeHasta(Capitan, OtroPuerto, Puerto2).

puedeRealizarRuta(Capitan,Puerto1,Puerto2):-
	ruta(Puerto1,Puerto2,Distancia),
	poderioCapitanPirata(Capitan,Poderio),
	Poderio > Distancia.