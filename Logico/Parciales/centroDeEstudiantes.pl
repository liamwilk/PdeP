/* Primera Parte */

%elecciones(año).
elecciones(2017).
elecciones(2019).

%estudiante(departamento, año, nombre).
estudiante(sistemas, 2019, juanPerez).
estudiante(sistemas, 2019, unter).
estudiante(sistemas, 2019, mathy).
estudiante(sistemas, 2017, unter).
estudiante(sistemas, 2017, mathy).
estudiante(sistemas, 2018, unter).
estudiante(quimica, 2018, cacho).

%votos(agrupacion, votos, año).
votos(franjaNaranja, 2500, 2017).
votos(franjaNaranja, 2152, 2019).
votos(agosto29, 710, 2019).
votos(seu, 917, 2019).

/* Punto 1 */

quienGano(Anio, Partido):- elecciones(Anio), votos(Partido, Votos, Anio), forall(votos(_, Votos2, Anio), Votos >= Votos2).

/* Punto 2 */

siempreGanaMismo(Partido):- votos(Partido, _, Anio), forall(votos(Partido, _, Anio), quienGano(Anio, Partido)).

/* Punto 3 */

cantidadElectores(Anio, Cantidad):- findall(Estudiante, estudiante(_, Anio, Estudiante), ListaEstudiantes), length(ListaEstudiantes, Cantidad).
cantidadVotos(Anio, Cantidad):- findall(Votos, votos(_, Votos, Anio), ListaVotos), sum_list(ListaVotos, Cantidad).
esUnAnio(Anio):- votos(_, _, Anio).

huboFraude(Anio):- esUnAnio(Anio), cantidadElectores(Anio, CantElectores), cantidadVotos(Anio, CantVotos), CantVotos > CantElectores.

/* Punto 4 */

sinRepeticion([X],[X]).
sinRepeticion([X|XS],[X|ListaSinRepetidos]):- not(member(X,XS)),sinRepeticion(XS,ListaSinRepetidos).
sinRepeticion([X|XS],ListaSinRepetidos):- member(X,XS),sinRepeticion(XS,ListaSinRepetidos).

aniosConFraude(Lista):- findall(Anio, huboFraude(Anio), ListaAnios), sinRepeticion(ListaAnios, Lista).

/* Punto 5 */

cantidadAlumnosDepartamento(Departamento, Anio, Cantidad):- findall(Departamento, estudiante(Departamento, Anio, _), ListaAlumnos), length(ListaAlumnos, Cantidad).
esUnDepartamento(Departamento):- estudiante(Departamento, _, _).

departamentoSuperPoblado(Departamento, Anio):- esUnDepartamento(Departamento), estudiante(_, Anio, _), cantidadAlumnosDepartamento(Departamento, Anio, Cantidad), cantidadAlumnosDepartamento(_, Anio, Cantidad2), Cantidad > (Cantidad2 / 2).

/* Segunda Parte */

%realizoAccion(agrupacion, accion).
realizoAccion(franjaNaranja, lucha(salarioDocente)).
realizoAccion(franjaNaranja, gestionIndividual(excepcionCorrelativas, juanPerez, 2019)).
realizoAccion(franjaNaranja, obra(2019)).
realizoAccion(agosto29, lucha(salarioDocente)).
realizoAccion(agosto29, lucha(boletoEstudiantil)).

esUnaAgrupacion(Agrupacion):- realizoAccion(Agrupacion, _).

esDemagogica(Agrupacion):- esUnaAgrupacion(Agrupacion), forall(realizoAccion(Agrupacion, Accion), Accion = gestionIndividual(_, _, _)).

participoEnLucha(Agrupacion):- realizoAccion(Agrupacion, lucha(_)).

esBurocrata(Agrupacion):- esUnaAgrupacion(Agrupacion), not(participoEnLucha(Agrupacion)).

alumnoRegular(Anio, Alumno):- estudiante(_, Anio, Alumno).

esGenuina(obra(Anio)):- not(elecciones(Anio)).
esGenuina(gestionIndividual(_, Alumno, Anio)):- alumnoRegular(Anio, Alumno).
esGenuina(lucha(_)).

esTransparente(Agrupacion):- esUnaAgrupacion(Agrupacion), esGenuina(Accion), forall(realizoAccion(Agrupacion, Accion), esGenuina(Accion)).