Kompilacja: gcc -o prog prog.c funkcjee.s funkcje.s
Uruchomienie: ./prog

Po uruchomieniu wywołana zostanie moja funkcja scanf - należy wpisać następujący zestaw zmiennych oddzielonych spacją:

<decimal> <float> <char> <string>

Po wykonaniu tej czynności ukaże się czas wykonania scanf, wpisane dane zostaną wydukowane na ekranie poprzez moja funkcje printf oraz ukaże się czas wykonania printf.

W pliku funkcjee.s - moja funkcja scanf nazwana funkcjes
W pliku funkcje.s - moja funkcja printf nazwana funkcje
W pliku prog.c - kod programu wywołujący funkcje napisane w assemblerze
