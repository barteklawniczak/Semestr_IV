.data

LICZNIK: .space 8	#zmienna na licznik n
JEDEN: .space 8		#zmienna przechowujaca liczbe 1
AK: .space 8		#zmienna na aktualna liczbe wyliczona 1/x
GORNY: .space 8		#gorna granica, nieuzywana w programie
WYNIK: .space 8		#zmienna na wynik
KROK: .space 8		#dlugosc kroku w calce
ZERO: .double 0		#zmienna przechowujaca liczbe 0

.text
.globl calka
	.type calka, @function

calka:
push %rbp		#odlozenie na stos argumentow
#wpisanie argumentow do poszczegolnych zmiennych
movsd %xmm0, AK		#przekazana pierwsza aktualna liczba
movsd %xmm1, GORNY
movsd %xmm2, KROK
movq %rdi, LICZNIK
movsd %xmm3, JEDEN
movsd %xmm4, WYNIK

petla:
fldl JEDEN		#zaladowanie jedynki
fldl AK			#zaladowanie aktualnej liczby
fdivrp %st, %st(1)	#operacja 1/x
fldl KROK		#zaladowanie kroku
fmulp %st, %st(1)	#przemnozenie (1/x)*krok
fldl WYNIK		#zaladowanie wyniku
faddp %st, %st(1)	#wynik + (1/x)*krok
fstpl WYNIK		#zaktualizowanie wyniku
dec %rdi		#dekrementacja licznika
cmp $0, %rdi		#porownanie licznika z zerem, czy koniec
jle exit		#jesli mniejszy lub rowny 0 do etykiety koniec
fldl AK			#zaladowanie aktualnej liczby
fldl KROK		#zaladowanie kroku
faddp %st, %st(1)	#operacja ak=ak+krok
fstpl AK		#zaktualizowanie aktualnej liczby
jmp petla		#powrot do petli

exit:
movsd WYNIK, %xmm0	#przekazanie wyniku do rejestru xmm0
pop %rbp		#zdjecie argumentow ze stosu
ret			#powrot do funkcji z odlozonym wynikiem 

