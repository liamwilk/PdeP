comercioAdherido(iguazu, grandHotelIguazu).
comercioAdherido(iguazu, gargantaDelDiabloTour).
comercioAdherido(bariloche, aerolineas).
comercioAdherido(iguazu, aerolineas).

%factura(Persona, DetalleFactura).
%Detalles de facturas posibles:
% hotel(ComercioAdherido, ImportePagado)
% excursion(ComercioAdherido, ImportePagadoTotal, CantidadPersonas)
% vuelo(NroVuelo,NombreCompleto)
factura(estanislao, hotel(grandHotelIguazu, 2000)).
factura(antonieta, excursion(gargantaDelDiabloTour, 5000, 4)).
factura(antonieta, vuelo(1515, antonietaPerez)).
valorMaximoHotel(5000).

%registroVuelo(NroVuelo,Destino,ComercioAdherido,Pasajeros,Precio)
registroVuelo(1515, iguazu, aerolineas, [estanislaoGarcia, antonietaPerez, danielIto], 10000).

esFacturaValida(hotel(Comercio, Monto)):- comercioAdherido(_, Comercio), Monto < valorMaximoHotel(Monto).
esFacturaValida(excursion(Comercio, _, _)):- comercioAdherido(_, Comercio).
esFacturaValida(vuelo(NumeroVuelo, Persona)):- registroVuelo(NumeroVuelo, _, _, Pasajeros, _), member(Persona, Pasajeros).
esFacturaTrucha(Factura):- not(esFacturaValida(Factura)).

aDevolver(hotel(_, Monto), MontoDevolver):- MontoDevolver is Monto * 0.5.
aDevolver(vuelo(NumeroVuelo, _), MontoDevolver):- 
    registroVuelo(NumeroVuelo, Ciudad, _, _, Precio), 
    Ciudad \= buenosAires, 
    MontoDevolver is Precio * 0.3.
aDevolver(vuelo(NumeroVuelo, _), MontoDevolver):- 
    registroVuelo(NumeroVuelo, Ciudad, _, _, Precio), 
    Ciudad == buenosAires, 
    MontoDevolver is 0.
aDevolver(excursion(_, Monto, CantidadPersonas), MontoDevolver):- MontoDevolver is (Monto / CantidadPersonas) * 0.8.

valorMaximoADevolver(100000).
cantidadCiudadesVisitadas(Persona, CantidadCiudades):- 
    findall(Ciudades, (factura(Persona, vuelo(_, Persona)), registroVuelo(_, Ciudades, _, _, _)), CiudadesVisitadas), 
    length(CiudadesVisitadas, CantidadCiudades).

/* Punto 1 */

unaPersona(Persona):- factura(Persona ,_).
montoADevolver(Persona, Monto):-
    unaPersona(Persona),
    findall(MontoDevolver, (factura(Persona, Factura), esFacturaValida(Factura), aDevolver(Factura, MontoDevolver)), MontosADevolver),
    sum_list(MontosADevolver, MontoADevolver),
    cantidadCiudadesVisitadas(Persona, CantidadCiudades),
    Monto is MontoADevolver + (CantidadCiudades * 1000),
    valorMaximoADevolver(ValorMaximo),
    Monto =< ValorMaximo.

/* Punto 2 */

unDestino(Destino):- comercioAdherido(Destino, _).
tuvoVuelos(Destino):- registroVuelo(_, Destino, _, _, _).
destinoTuristico(Destino):- 
    comercioAdherido(Destino, Comercio), 
    forall(comercioAdherido(Destino, OtroComercio), Comercio == OtroComercio).
destinoTuristico(Destino):- 
    comercioAdherido(Destino, Comercio), 
    forall(factura(Persona, hotel(Comercio, _)), not(factura(Persona, hotel(_, _)))).

esDestinoTuristico(Destino):- 
    unDestino(Destino),
    tuvoVuelos(Destino),
    destinoTuristico(Destino).

/* Punto 3 */

esEstafador(Persona):- 
    factura(Persona, _),
    forall(factura(Persona, Factura), facturaTruchaOMontoCero(Factura)).

facturaTruchaOMontoCero(Persona):- 
    factura(Persona, Factura), 
    esFacturaTrucha(Factura).
facturaTruchaOMontoCero(Persona):-
    factura(Persona, hotel(_, Monto)),
    Monto == 0.