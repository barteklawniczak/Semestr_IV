Kompilacja:
gcc -std=c99 -mfpmath=387 -o lab4 lab4.c set_fpu.s get_fpu.s cal.s
Uruchomienie:
./lab4

Uzytkownik proszony jest o wpisanie dolnej i gornej granicy calki oraz liczby odpowiadajacej ilosci prostokatow na ktore zostanie podzielona calka podczas liczenia. Z tych danych obliczany jest krok calki i przekazywany jest razem z innymi zmiennymi do funkcji w assemblerze. Przy wpisywaniu tych danych nie jest sprawdzana poprawnosc wpisanych argumentow! Mozna wpisywac liczby ujemne lecz nalezy liczyc sie z konsekwencjami.
