/* En la jungla tan imponente el león rey duerme ya... Y Timón y Pumba salieron a lastrar bichos.
Tenemos tres tipos de bichos, representados por functores: las vaquitas de San Antonio (de quienes nos interesa un peso), las cucarachas (de quienes nos interesa un tamaño y un peso) y las
hormigas, que pesan siempre lo mismo. De los personajes también se conoce el peso, mediante hechos.
La base de conocimiento es la que sigue: */

%comio(Personaje, Bicho)
comio(pumba, vaquitaSanAntonio(gervasia,3)).
comio(pumba, hormiga(federica)).
comio(pumba, hormiga(tuNoEresLaReina)).
comio(pumba, cucaracha(ginger,15,6)).
comio(pumba, cucaracha(erikElRojo,25,70)).
comio(timon, vaquitaSanAntonio(romualda,4)).
comio(timon, cucaracha(gimeno,12,8)).
comio(timon, cucaracha(cucurucha,12,5)).
comio(simba, vaquitaSanAntonio(remeditos,4)).
comio(simba, hormiga(schwartzenegger)).
comio(simba, hormiga(niato)).
comio(simba, hormiga(lula)).
%Por ejemplo, un día había una hiena distraida y con mucho hambre y amplio su dieta.
comio(shenzi, hormiga(conCaraDeSimba)).
pesoHormiga(2).
%peso(Personaje, Peso)
peso(pumba, 100).
peso(timon, 50).
peso(simba, 200).
%Completando la base...
peso(scar, 300).
peso(shenzi, 400).
peso(banzai, 500).

% 1) A falta de pochoclos...
% a) Qué cucaracha es jugosita: ó sea, hay otra con su mismo tamaño pero ella es más gordita.

esUnaCucaracha(Nombre, Tamanio, Peso):-
    comio(_, cucaracha(Nombre, Tamanio, Peso)).

jugosita(cucaracha(Nombre, Tamanio, Peso)):-
    esUnaCucaracha(Nombre2, Tamanio, Peso2),
    Nombre \= Nombre2,
    Peso > Peso2.

% b) Si un personaje es hormigofílico... (Comió al menos dos hormigas).
hormigofilico(Nombre):-
    comio(Nombre, _),
    findall(Nombre, (comio(Nombre, hormiga(_))), Lista),
    length(Lista, Cantidad),
    Cantidad >= 2.

% c) Si un personaje es cucarachofóbico (no comió cucarachas).
cucarachofobico(Nombre):-
    comio(Nombre, _),
    not(comio(Nombre, cucaracha(_, _, _))).

% d) Conocer al conjunto de los picarones. Un personaje es picarón si comió una cucaracha jugosita ó si se come a Remeditos la vaquita. Además, pumba es picarón de por sí.


picarones(Lista):-
    findall(Nombre, (comio(Nombre, cucaracha(_, _, _)), jugosita(cucaracha(_, _, _))), Lista1),
    findall(Nombre, (comio(Nombre, vaquitaSanAntonio(remeditos, _))), Lista2),
    append(Lista1, Lista2, Lista3),
    append(Lista3, [pumba], Lista).


% Aparece en escena el malvado Scar, que persigue a algunos de nuestros amigos. Y a su vez, las hienas Shenzi y Banzai también se divierten...
persigue(scar, timon).
persigue(scar, pumba).
persigue(shenzi, simba).
persigue(shenzi, scar).
persigue(banzai, timon).
%Se agrega el hecho para 3)
persigue(scar, mufasa).

% 2) Pero yo quiero carne...
% a) Se quiere saber cuánto engorda un personaje (sabiendo que engorda una cantidad igual a la suma de los pesos de todos los bichos en su menú). Los bichos no engordan.

pesoBicho(hormiga(_), 2).
pesoBicho(cucaracha(_, _, Peso), Peso).
pesoBicho(vaquitaSanAntonio(_, Peso), Peso).

cuantoEngorda(Personaje, Peso):-
    comio(Personaje, _),
    findall(Peso, (comio(Personaje, Bicho), pesoBicho(Bicho, Peso)), Pesos),
    sum_list(Pesos, Peso).


% b) Pero como indica la ley de la selva, cuando un personaje persigue a otro, se lo termina comiendo, y por lo tanto también engorda. Realizar una nueva version del predicado cuantoEngorda.

cuantoEngorda(Personaje, Peso):-
    persigue(Personaje, _),
    findall(Peso, (persigue(Personaje, OtroPersonaje), peso(OtroPersonaje, Peso)), Pesos),
    sum_list(Pesos, Peso).

/* c) Ahora se complica el asunto, porque en realidad cada animal antes de comerse a sus víctimas espera a que
estas se alimenten. De esta manera, lo que engorda un animal no es sólo el peso original de sus víctimas, sino
también hay que tener en cuenta lo que éstas comieron y por lo tanto engordaron. Hacer una última version del
predicado. */

cuantoEngorda(Personaje, Peso):-
    persigue(Personaje, _),
    findall(Peso, (persigue(Personaje, Victima), cuantoEngorda(Victima, Peso)), Pesos),
    sum_list(Pesos, Peso).

/* 3) Buscando el rey...
Sabiendo que todo animal adora a todo lo que no se lo come o no lo
persigue, encontrar al rey. El rey es el animal a quien sólo hay un animal
que lo persigue y todos adoran. */

loPersigueUnoSolo(Personaje):-
    persigue(_, Personaje),
    findall(Personaje, persigue(_, Personaje), Lista),
    length(Lista, Cantidad),
    Cantidad = 1.

adora(Victima, Personaje):-
    comio(_, Victima),
    not(persigue(Personaje, Victima)),
    not(comio(Personaje, Victima)).


rey(Personaje):-
    loPersigueUnoSolo(Personaje),
    forall(persigue(_, Personaje), distinct(adora(_, Personaje))).