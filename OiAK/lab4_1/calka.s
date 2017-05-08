.data 

LICZNIK: .space 8 #zmienna na liczbe n
#DOLNY: .space 8 #zmienna na dolny pulap calki
GORNY: .space 8 #zmienna na gorny pulap calki
KROK: .space 8 #zmienna na krok
JEDEN: .space 8 #zmienna na mianownik
WYNIK: .space 8 #zmienna na wynik
AKTUALNY: .space 8 #zmienna na aktualny wyraz

.text
.globl calka
.type calka, @function
calka:
finit
fstp %st
push %rbp
mov %rsp, %rbp
sub $8, %rsp
zall:
movabsq	$4607182418800017408, %rax
movq	%rax, 16(%rbp)
fldl 16(%rbp)		#zaladowanie aktualnego wyrazu
q:
fstpl AKTUALNY
zal:
fldl 24(%rbp)
zal1:
fstpl GORNY 		#zaladowanie gornego pulapu
a:
fldl 32(%rbp)
b:
fstpl KROK		#zaladowanie kroku
c:
fldl 48(%rbp)
d:
fstpl LICZNIK		#zaladowanie licznika n
fld1
fstpl JEDEN		#zaladowanie licznika mianownika
fldz
fstpl WYNIK		#zaladowanie wyniku, obecnie 0

petla:
finit
fldl JEDEN
fdiv AKTUALNY
w:
fadd %st(1), %st(0)
add $32, %rsp
movq WYNIK, %xmm0
e:
leave
ret

