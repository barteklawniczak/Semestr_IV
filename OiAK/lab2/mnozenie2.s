.data
STDIN = 0
STDOUT = 1
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
EXIT_SUCCESS = 0
EXIT_FAILURE = 1

wyswietl1: .ascii "Wprowadz liczbe w systemie szesnastkowym bedaca mnozna(max 256 znakow)\n"
dlg_wyswietl1 = .-wyswietl1

wyswietl2: .ascii "Wprowadz liczbe w systemie szesnastkowym bedaca mnoznikiem(max 8 znakow)\n"
dlg_wyswietl2 = .-wyswietl2

wyswietl3: .ascii "Wynik mnozenia obu liczb:\n"
dlg_wyswietl3 = .-wyswietl3

blad: .ascii "BLEDNA LICZBA!\n"
dlg_blad = .-blad

wynik: .ascii "Twoj wynik:\n"
dlg_wynik = .-wynik

.bss
.comm wczytanie1, 260 #bufor zawierajacy wczytana mnozna
.comm wczytanie2, 15 #bufor przechowujacy wczytana mnozna
.comm wynik_hex, 269 #bufor przechowujacy wynik

.comm konwersja1, 129 #mnozna w postaci bajtowej
.comm konwersja2, 5 #mnoznik w postaci bajtowej
.comm wynik_bin, 134 #wynik w postaci bajtowej
.comm pomocniczy, 134 #pomocniczy bufor

.text
.globl main

main:
#wyzerowanie bufora mnoznej w postaci bajtowej
mov $129, %r8
mov $0, %al

petla_zerowania1:
dec %r8
mov %al, konwersja1(,%r8,1)
cmp $0, %r8
jg petla_zerowania1

#wyzerowanie bufora mnoznika w postaci bajtowej
mov $5, %r8

petla_zerowania2:
dec %r8
mov %al, konwersja2(,%r8,1)
cmp $0, %r8
jg petla_zerowania2

#wyswietlenie komunikatu do wczytania pierwszego ciagu
mov $SYSWRITE, %rax
mov $STDOUT, %rdi
mov $wyswietl1, %rsi
mov $dlg_wyswietl1, %rdx
syscall

#wczytanie mnoznej
mov $SYSREAD, %rax    #ilosc wprowadzanych znakow
mov $STDIN, %rdi
mov $wczytanie1, %rsi
mov $260, %rdx
syscall
cmp $257, %rax #sprawdzenie czy liczba max 1024 bitowa
jg error

#zdekodowanie mnoznej
mov %rax, %r8 #przeniesienie ilosci znakow do rejestru r8
dec %r8 #odjecie znaku końca linii z licznika
mov $129, %r9 #licznik o dlugosci bufora konwersja1

petla1:
dec %r8
dec %r9
#zdekodowanie 4 bitów
mov wczytanie1(,%r8,1), %al
cmp $'A', %al
jge litera #jezeli kod ascii jest wiekszy rowny 'A' dekodujemy litere
cmp $'0', %al
jl error
cmp $'9', %al
jg error
sub $'0', %al #jezeli mniejszy dekodujemy cyfre
jmp powrot_petla1

litera:
cmp $'F', %al
jg error
sub $55, %al

powrot_petla1:
cmp $0, %r8 #zbadanie czy zdekodowano ostatnia wczytana liczbe
jle powrot2_petla1

#zdekodowanie kolejnych 4 bitow
mov %al, %bl
dec %r8
mov wczytanie1(,%r8,1), %al

cmp $'A', %al #analogiczna sytuacja
jge litera2
cmp $'0', %al
jl error
cmp $'9', %al
jg error
sub $'0', %al
jmp powrot3_petla1

litera2:
cmp $'F', %al
jg error
sub $55, %al

powrot3_petla1:
#pomnozenie zdekodowanej wartosci przez 16, by byla w starszej czesci bajtu
mov $16, %cl
mul %cl
add %bl, %al #dodanie młodszej części

powrot2_petla1:
mov %al, konwersja1(,%r9,1)
cmp $0, %r8
jg petla1 #powrot na poczatek petli

#wyswietlenie komunikatu do wczytania drugiego ciagu
mov $SYSWRITE, %rax
mov $STDOUT, %rdi
mov $wyswietl2, %rsi
mov $dlg_wyswietl2, %rdx
syscall

#wczytanie mnoznika
mov $SYSREAD, %rax   #ilosc wprowadzanych znakow
mov $STDIN, %rdi
mov $wczytanie2, %rsi
mov $15, %rdx
syscall
cmp $9, %rax #sprawdzenie czy liczba max 32 bitowa
jg error

mov %rax, %r8
dec %r8
mov $5, %r9

petla2:
dec %r8
dec %r9
#zdekodowanie 4 bitow
mov wczytanie2(,%r8,1), %al
cmp $'A', %al
jge litera3
cmp $'0', %al
jl error
cmp $'9', %al
jg error
sub $'0', %al
jmp powrot1_petla2

litera3:
cmp $'F', %al
jg error
sub $55, %al

powrot1_petla2:
cmp $0, %r8
jle powrot2_petla2

#zdekodowanie kolejnych 4 bitow
mov %al, %bl
dec %r8
mov wczytanie2(,%r8,1), %al
cmp $'A', %al
jge litera4
cmp $'0', %al
jl error
cmp $'9', %al
jg error
sub $'0', %al
jmp powrot3_petla2

litera4:
cmp $'F', %al
jg error
sub $55, %al

powrot3_petla2:
mov $16, %cl
mul %cl
add %bl, %al

powrot2_petla2:
mov %al, konwersja2(,%r9,1)
cmp $0, %r8
jg petla2

#zamiana mnoznika na dziesietna
mov $4, %r8 #licznik do petli
mov $1, %eax
mov $0, %ecx
mov $0, %r9
petla_bin_dec:
mov $0, %bl
mov konwersja2(,%r8,1), %bl
imul %ebx, %eax
add %eax, %ecx
dec %r8
inc %r9
cmp $0, %r8
jle mnozenie
cmp $1, %r9
je druga
cmp $2, %r9
je czwarta
cmp $3, %r9
je szosta

druga:
mov $256, %eax
jmp petla_bin_dec

czwarta:
mov $65536, %eax
jmp petla_bin_dec

szosta:
mov $16777216, %eax
jmp petla_bin_dec

mnozenie:
mov %rcx, %r8 #umieszczenie obliczonego mnoznika w rejestrze r8 jako licznik
mov $128, %r9 #umieszczenie dlugosci bufora mnoznej w r9
mov $133, %r14 #umieszczenie dlugosci bufora wynikowego w r14
cmp $1, %r8
je petla_dodawania

petla_pierwsza:
mov konwersja1(,%r9,1), %al #odczyt wartosci z bufora
mov %al, pomocniczy(,%r14,1) #zapisanie jej do bufora
dec %r9
dec %r14
cmp $0, %r9
jg petla_pierwsza

petla_dodawania:
mov $128, %r9
mov $133, %r14
clc #czyszczenie flagi przeniesienia z poprzedniej pozycji
pushfq #umieszczenie rejestru flagowego na stosie
petelka:
mov konwersja1(,%r9,1), %al
mov pomocniczy(,%r14,1), %bl
popfq
adc %bl, %al
pushfq
mov %al, wynik_bin(,%r14,1)
dec %r9
dec %r14
cmp $0,%r9
jg petelka
mov $133, %r14
jmp przepisanie
dalej:
dec %r8
cmp $1, %r8
jg petla_dodawania
jmp zamiana

przepisanie:
mov wynik_bin(,%r14,1), %al
mov %al, pomocniczy(,%r14,1)
dec %r14
jg przepisanie
jmp dalej

zamiana:
#zamiana na HEX
mov $133, %r8 #licznik do petli
mov $267, %r9 #dlugosc bufora po rozkodowaniu, licznik

petla_rozkodowania:
mov wynik_bin(,%r8,1), %al
mov %al, %bl
mov %al, %cl
shr $4, %cl #podzial odczytanej wartosci na dwie czesci
and $0b1111, %bl #w rejestrze bl najmniej znaczace bity
and $0b1111, %cl
add $'0', %bl #dodanie wartosci kodu ascii '0'
add $'0', %cl
cmp $'9', %bl #sprawdzenie czy mamy do czynienia z liczba
jle do_cl
add $7, %bl #jezeli nie, dodajemy jeszcze 7 by uzyskac litere

do_cl: #to samo dla rejestru cl
cmp $'9', %cl
jle kontynuuj
add $7, %cl

kontynuuj:
mov %bl, wynik_hex(,%r9,1)
dec %r9
mov %cl, wynik_hex(,%r9,1)
dec %r9

dec %r8
cmp $0, %r8
jge petla_rozkodowania

mov $SYSWRITE, %rax
mov $STDOUT, %rdi
mov $wynik, %rsi
mov $dlg_wynik, %rdx
syscall

movq $268, %r8
movb $0xA, wynik_hex(,%r8,1) #dodanie znaku konca linii
mov $SYSWRITE, %rax
mov $STDOUT, %rdi
mov $wynik_hex, %rsi
mov $269, %rdx
syscall
jmp to_exit

error:
mov $SYSWRITE, %rax
mov $STDOUT, %rdi
mov $blad, %rsi
mov $dlg_blad, %rdx
syscall

mov $SYSEXIT, %rax
mov $EXIT_FAILURE, %rdi
syscall 

to_exit:
mov $SYSEXIT, %rax
mov $EXIT_SUCCESS, %rdi
syscall

