presidencia(alfonsin, 1983, 1989, "Recuperación de la democracia").
presidencia(menem, 1990, 1995, "Convertibilidad 1 peso = 1 dolar").
presidencia(menem, 1996, 1999, "Desocupación record").
presidencia(delarua, 2000, 2001, "Salida en helicoptero").

% Quiénes fueron presidente por más de un período (sin importar si fueron sucesivos o no) (Menem)

masDeUnPeriodo(Presidente):-
    presidencia(Presidente, F1, F2, _),
    presidencia(Presidente, F3, F4, _),
    F1 \= F3,
    F2 \= F4.

% En una fecha dada, quién era el presidente. (2000 De la Rua)

quienEraPresidente(Fecha, Presidente):-
    presidencia(Presidente, F1, F2, _),
    Fecha >= F1,
    Fecha =< F2.

/* Se conocen las acciones de gobierno que se realizan. De cada una de ellas se conoce una descripción que identifica al suceso, el año en que se produjo, 
el lugar y la cantidad de gente beneficiada. Las acciones que benefician a más de 10000 personas se consideran buenas. */

accionGobierno(juiciojuntas, 1985, bsas, 30000000).
accionGobierno(hiperinflacion, 1989, bsas, 10).
accionGobierno(privatizacionYPF, 1992, campana, 1).

% Si un determinado acto de gobierno fue bueno. (el juicio a las juntas? Si - La hiper? No)

fueBuenActo(Acto):-
    accionGobierno(Acto, _, _, Personas),
    Personas > 10000.

/* Si un presidente hizo algo bueno, es decir, si en alguno de sus periodos de gobierno hizo alguna accion 
de gobierno que se considere buena. (Alfonsin? Si - Menem? No - De la Rua? No) */

gobiernoBueno(Presidente):-
    presidencia(Presidente, F1, F2, _),
    accionGobierno(X, Fecha, _, _),
    fueBuenActo(X).

