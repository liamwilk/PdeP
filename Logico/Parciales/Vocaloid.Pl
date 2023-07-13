%De cada vocaloid (o cantante) se conoce el nombre y además la canción que sabe cantar. De cada canción se conoce el nombre y la cantidad de minutos de duración.

%megurineLuka sabe cantar la canción nightFever cuya duración es de 4 min y también canta la canción foreverYoung que dura 5 minutos.	
%canta(Vocaloid, cancion(Nombre, Duracion))
canta(megurineLuka, cancion(nightFever, 4)).
canta(megurineLuka, cancion(foreverYoung, 5)).

%hatsuneMiku sabe cantar la canción tellYourWorld que dura 4 minutos.
canta(hatsuneMiku, cancion(tellYourWorld, 4)).

%gumi sabe cantar foreverYoung que dura 4 min y tellYourWorld que dura 5 min
canta(gumi, cancion(foreverYoung, 4)).
canta(gumi, cancion(tellYourWorld, 5)).

%seeU sabe cantar novemberRain con una duración de 6 min y nightFever con una duración de 5 min.
canta(seeU, cancion(novemberRain, 6)).
canta(seeU, cancion(nightFever, 5)).

%kaito no sabe cantar ninguna canción.


/* 1) Para comenzar el concierto, es preferible introducir primero a los cantantes más novedosos, por lo que necesitamos un predicado para saber si un vocaloid es novedoso 
cuando saben al menos 2 canciones y el tiempo total que duran todas las canciones debería ser menor a 15. */

seSabeDosCanciones(Cantante):-
    canta(Cantante, cancion(Cancion1, _)),
    canta(Cantante, cancion(Cancion2, _)),
    Cancion1 \= Cancion2.

tiempoCancion(Cantante, TiempoTotal):-
    findall(Tiempo, canta(Cantante, cancion(_, Tiempo)), ListaTiempo),
    sum_list(ListaTiempo, TiempoTotal).

esNovedoso(Cantante):-
    canta(Cantante, _),
    seSabeDosCanciones(Cantante),
    tiempoCancion(Cantante, Tiempo),
    Tiempo < 15.


/* 2) Hay algunos vocaloids que simplemente no quieren cantar canciones largas porque no les gusta, es por eso que se pide saber si un cantante es acelerado, 
 condición que se da cuando todas sus canciones duran 4 minutos o menos. Resolver sin usar forall/2. */

 esAcelerado(Cantante):-
    not(canta(Cantante, cancion(_, Tiempo))),
    Tiempo > 4.


    % Hay tres tipos de conciertos:
    % - gigante del cual se sabe la cantidad mínima de canciones que el cantante tiene que saber y además la duración total de todas las canciones tiene que ser mayor a una cantidad dada.
    %- mediano sólo pide que la duración total de las canciones del cantante sea menor a una cantidad determinada.
    %- pequeño el único requisito es que alguna de las canciones dure más de una cantidad dada.
    
    
    
    
    /*Queremos reflejar los siguientes conciertos:
    
    
    - Miku Expo, es un concierto gigante que se va a realizar en Estados Unidos, le brinda 2000 de fama al vocaloid que pueda participar en él y pide que el vocaloid sepa más de 2 canciones y 
    el tiempo mínimo de 6 minutos.	 */

    %concierto(nombre, pais, fama, tipoConcierto)
    concierto(mikuexpo, estadosunidos, 2000, gigante(2, 6)).

    %- Magical Mirai, se realizará en Japón y también es gigante, pero da una fama de 3000 y pide saber más de 3 canciones por cantante con un tiempo total mínimo de 10 minutos. 
    concierto(magicalmirai, japon, 3000, gigante(3, 10)).
    %- Vocalekt Visions, se realizará en Estados Unidos y es mediano brinda 1000 de fama y exige un tiempo máximo total de 9 minutos.
    concierto(vocalektvisions, estadosunidos, 1000, mediano(9)).	
    %- Miku Fest, se hará en Argentina y es un concierto pequeño que solo da 100 de fama al vocaloid que participe en él, con la condición de que sepa una o más canciones de más de 4 minutos.
    concierto(mikufest, argentina, 100, pequenio(4)).

% 2) Se requiere saber si un vocaloid puede participar en un concierto, esto se da cuando cumple los requisitos del tipo de concierto. También sabemos que Hatsune Miku puede participar en cualquier concierto.

cumpleRequisitos(Vocaloid, gigante(Cantidad, Duracion)):-
    seSabeDosCanciones(Vocaloid),
    tiempoCancion(Vocaloid, Tiempo),
    Tiempo > Duracion.

cumpleRequisitos(Vocaloid, mediano(Duracion)):-
    tiempoCancion(Vocaloid, Tiempo),
    Tiempo < Duracion.

cumpleRequisitos(Vocaloid, pequenio(Duracion)):-
    canta(Vocaloid, cancion(_, Tiempo)),
    Tiempo > Duracion.

puedeParticipar(hatsuneMiku).
puedeParticipar(Vocaloid, Concierto):-
    canta(Vocaloid, _),
    Vocaloid \= hatsuneMiku,
    concierto(Concierto, _, _, Requisitos),
    cumpleRequisitos(Vocaloid, Requisitos).

/* 3) Conocer el vocaloid más famoso, es decir con mayor nivel de fama. El nivel de fama de un vocaloid se calcula como la fama total que 
le dan los conciertos en los cuales puede participar multiplicado por la cantidad de canciones que sabe cantar. */

sumaFama(Vocaloid, CantidadFama):-
    canta(Vocaloid, _),
    findall(Fama, concierto(_, _, Fama, _), ListaFama),
    sum_list(ListaFama, FamaVocaloid),
    cantidadCanciones(Vocaloid, Cantidad),
    CantidadFama is FamaVocaloid * Cantidad.

cantidadCanciones(Vocaloid, Cantidad):-
    canta(Vocaloid, _),
    findall(Canciones, canta(Vocaloid, Cancion), ListaCanciones),
    length(ListaCanciones, Cantidad).

vocaloidMasFamoso(Vocaloid):-
    canta(Vocaloid, _),
    sumaFama(Vocaloid, CantidadFama),
    forall(sumaFama(_, Cantidad), CantidadFama >= Cantidad).

/* 4) Sabemos que:
    - megurineLuka conoce a hatsuneMiku  y a gumi 
    - gumi conoce a seeU
    - seeU conoce a kaito
    
Queremos verificar si un vocaloid es el único que participa de un concierto, esto se cumple si ninguno de sus conocidos ya sea 
directo o indirectos (en cualquiera de los niveles) participa en el mismo concierto. */    

%conoce(Vocaloid, Conocido), Conocido podría operarse como lista, pero no me parece óptimo para este caso.
conoce(megurineLuka, hatsuneMiku).
conoce(megurineLuka, gumi).
conoce(gumi, seeU).
conoce(seeU, kaito).

unicoEnConcierto(Vocaloid):-
    canta(Vocaloid, _),
    puedeParticipar(Vocaloid, Concierto),
    esConocido(Vocaloid, Vocaloid2),
    not(puedeParticipar(Vocaloid2, Concierto)),
    Vocaloid \= Vocaloid2.

esConocido(Vocaloid, Conocido):- conoce(Vocaloid, Conocido).
esConocido(Vocaloid, Indirecto):-
    conoce(Vocaloid, Conocido),
    conoce(Conocido, Indirecto).
