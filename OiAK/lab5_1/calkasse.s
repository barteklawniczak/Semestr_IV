.data

KROK: .space 8
AK: .space 8
AK2: .space 8
JEDEN: .space 8
LICZNIK: .space 8
GORNY: .space 8

.text
.globl calkasse

calkasse:
	.type calkasse, @function

calkasse:
push %rbp
movq %rsp, %rbp
movsd %xmm0, AK
movsd %xmm1, GORNY
movsd %xmm2, KROK
movsd %xmm3, JEDEN
movq %rdi, LICZNIK
movsd AK, %xmm5
addsd KROK, %xmm5
movsd %xmm5, AK2
movlpd AK, %xmm0	#wrzucenie pierwszej wartosci do niższej czesci xmm0
movhpd AK2, %xmm0	#wrzucenie drugiej wartosci do wyzszej czesci xmm0
movhpd JEDEN, %xmm3	#uzupelnienie wektora w xmm3 o brakujaca jedynke
movupd %xmm3, %xmm6	#zapisanie wektora jedynek w rejestrze pomocniczym
divpd %xmm0, %xmm3	#podzielenie wektora jedynek przez wartosci x
movhpd KROK, %xmm2	#uzupelnienie wektora xmm2 o brakujacy krok
movupd %xmm2, %xmm7
addpd %xmm7, %xmm7	#zapisanie wektora kroku i podwojenie wartosci, przydatne w petli
mulpd %xmm2, %xmm3	#przemnozenie wektora wartosci 1/x przez krok
xorpd %xmm4, %xmm4	#wyzerowanie rejestru xmm4 - wynikowego
addpd %xmm3, %xmm4	#zapisanie obecnych wynikow w rejestrze wynikowym
sub $2, %rdi

petla:
cmp $0, %rdi
jle exit
cmp $1, %rdi
je jeden
addpd %xmm7, %xmm0	#dodanie podwojonego wektora kroku by uzyskac wartosci
movupd %xmm6, %xmm3	#wczytanie jedynek do xmm3
divpd %xmm0, %xmm3	#kolejne dzielenie
mulpd %xmm2, %xmm3	#kolejne mnozenie
addpd %xmm3, %xmm4	#nadpisanie wyniku
sub $2, %rdi
jmp petla

jeden:
movlpd %xmm0, AK	#zapisanie interesujacej nas wartosci
xorpd %xmm0, %xmm0	#wyzerowanie wartosci w xmm0
movsd AK, %xmm0		#wpisanie zapisanej wartosci do rejestru xmm0
movsd JEDEN, %xmm3	#wpisanie jedynki do xmm3 bo jest tam inna liczba
divsd %xmm0, %xmm3	#wykonanie dzielenia ostatniej liczby
mulsd %xmm2, %xmm3	#mnozenie przez krok
addsd %xmm3, %xmm4	#dodanie naszej liczby do wektora wynikowego
jmp exit

exit:
haddpd %xmm4, %xmm4	#zsumowanie w poziomie wyniku
movapd %xmm4, %xmm0	#zapisanie do xmm0
pop %rbp
ret
