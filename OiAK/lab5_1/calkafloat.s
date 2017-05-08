.data

KROK: .space 8
AK: .space 8
AK2: .space 8
JEDEN: .space 8
WYNIK: .space 8
LICZNIK: .space 8
GORNY: .space 8

.text
.globl calkafloat

calkafloat:
	.type calkafloat, @function

calkafloat:
push %rbp
movq %rsp, %rbp
movss %xmm0, AK
movss %xmm1, GORNY
movss %xmm2, KROK
unpcklps %xmm2, %xmm2	#rozsuniecie xmm2 na cztery miejsca
unpcklps %xmm2, %xmm2
movss %xmm3, JEDEN
movq %rdi, LICZNIK
movups %xmm0, %xmm4	#wlozenie wartosci rejestru xmm0 do rejestru dest - xmm4
addss %xmm2, %xmm4 	#dodanie dwa razy wartosci kroku do rejestru xmm4
addss %xmm2, %xmm4
movups %xmm4, %xmm0	#wlozenie tych wartosci do rejestru src - xmm0
addps %xmm2, %xmm0	#dodanie wartosci kroku do wartosci rejestru xmm0
unpcklps %xmm4, %xmm0	#utworzenie wektora czterech liczb w xmm0
unpcklps %xmm3, %xmm3
unpcklps %xmm3, %xmm3	#utworzenie wektora czterech jedynek w xmm3
movups %xmm3, %xmm7	#zapisanie wektora jedynek do xmm7, bo bedzie zmodyfikowany
divps %xmm0, %xmm3	#podzielenie wektora jedynek przez wartosci x
mulps %xmm2, %xmm3	#przemnozenie otrzymanych wartosci przez krok
movups %xmm3, %xmm4 	#zapisanie otrzymanych wartosci do wektora wyniku
movups %xmm2, %xmm6	#wlozenie wektora kroku do xmm6
addps %xmm2, %xmm6
addps %xmm2, %xmm6	#uzyskanie w xmm6 wektora przemnozonych przez cztery kroków
addps %xmm2, %xmm6	#przydatne w petli
sub $4, %rdi		#odjecie czworki od licznika

petla:
cmp $0, %rdi
je exit
cmp $1, %rdi
je jeden
cmp $2, %rdi
je dwa
cmp $3, %rdi
je trzy			#jezeli reszta krokow wynosi trzy, skaczemy do trzy
addps %xmm6, %xmm0	#uzyskanie nastepnych wartosci w wektorze
movups %xmm7, %xmm3	#przekazanie jedynek do xmm3
divps %xmm0, %xmm3
mulps %xmm2, %xmm3
addps %xmm3, %xmm4
sub $4, %rdi
jmp petla

jeden:
addps %xmm6, %xmm0
movups %xmm7, %xmm3
divps %xmm0, %xmm3
mulps %xmm2, %xmm3
xorps %xmm5, %xmm5	#wyzerowanie rejestru xmm5
movss %xmm5, %xmm3	#wrzucenie zera do niepotrzebnej wartosci rejestru xmm3
addps %xmm3, %xmm4	#dodanie pozostalych wartosci do rejestru wynikowego
jmp exit

dwa:
addps %xmm6, %xmm0
movups %xmm7, %xmm3
divps %xmm0, %xmm3
mulps %xmm2, %xmm3
xorps %xmm5, %xmm5	#wyzerowanie rejestru xmm5
movlhps %xmm7, %xmm5	#wrzucenie jedynek do wyzszej czesci rejestru xmm5
mulps %xmm5, %xmm3	#przemnozenie rejestru xmm3 by zostaly dwie wartosci
addps %xmm3, %xmm4	#dodanie tych wartosci do rejestru wynikowego
jmp exit

trzy:
addps %xmm6, %xmm0
movups %xmm7, %xmm3
divps %xmm0, %xmm3
mulps %xmm2, %xmm3
xorps %xmm5, %xmm5	#wyzerowanie rejestru xmm5
unpckhps %xmm5, %xmm3	#rozpakowanie do xmm3 zerujac dwie niepotrzebne wartosci
movss %xmm5, %xmm3	#wyzerowanie ostatniej z wartosci
addps %xmm3, %xmm4	#dodanie do rejestru wynikowego
jmp exit

exit:
haddps %xmm4, %xmm4	#zsumowanie wektora w xmm4 w poziomie
haddps %xmm4, %xmm4
movaps %xmm4, %xmm0	#zapisanie wyniku do rejestru xmm0
pop %rbp
ret
