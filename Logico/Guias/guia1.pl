progenitor(homero, bart).
progenitor(homero, lisa).
progenitor(homero, maggie).
progenitor(abe, homero).
progenitor(abe, jose).
progenitor(jose, pepe).
progenitor(mona, homero).
progenitor(jacqueline, marge).
progenitor(marge, bart).
progenitor(marge, lisa).
progenitor(marge, maggie).

hermano(Hermano1, Hermano2):-
    progenitor(Padre, Hermano1),
    progenitor(Padre, Hermano2),
    Hermano1 \= Hermano2.

tio(Sobrino, Tio):-
    progenitor(Padre, Sobrino),
    hermano(Padre, Tio).

primo(Primo1, Primo2):-
    progenitor(Padre, Primo1),
    progenitor(Tio, Primo2),
    hermano(Padre, Tio).

abuelo(Abuelo, Nieto):-
    progenitor(Padre, Nieto),
    progenitor(Abuelo, Padre).