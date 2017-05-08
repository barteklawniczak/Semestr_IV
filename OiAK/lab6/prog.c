#include <stdio.h>
#include <stdlib.h>
#include <time.h>

unsigned long long rdtsc()
{
	unsigned long long lo, hi;
	__asm__ __volatile__ (
      	 	 "xorl %%eax,%%eax \n        cpuid"
       		 ::: "%rax", "%rbx", "%rcx", "%rdx");
	__asm__ __volatile__ ("rdtsc" : "=a" (lo), "=d" (hi));
return (unsigned long long)hi << 32 | lo;
}

int main()
{
	srand(time(NULL));
	int N=1;
	int k=1;
	unsigned long long start, end, time;
	for(int i=1; i<9; i++)
	{
		N=N*2;
		int tab1[N][N];
		int tab2[N][N];
		int tab3[N][N];
		k=1;
	for(int q=0; q<3; q++)
	{
	k=k*10;
	time=0;
	for(int h=k; h>0; h--)
	{
		for(int j=0; j<N; j++)
		{
			for(int l=0; l<N; l++)
			{
				tab1[j][l] = rand();
				tab2[j][l] = rand();		
			}
		}

		start = rdtsc();
		for(int j=0; j<N; j++)
		{
			for(int l=0; l<N; l++)
			{
				for(int p=0; p<N; p++)
				{
					tab3[j][l]+=tab1[j][p]*tab2[p][l];
				}
			}
		}
		end=rdtsc();
		time+=(end-start);
		if(h==1)
		{	
			printf("Mnozenie macierzy N=%d, ilosc powtorzen %d\n", N, k);
			printf("Czas wykonania: %.0f ns\n", (double)time/k*3.3);
		}
	}
	//MNOZENIE TRANSPONOWANE
	
	time=0;
	for(int h=k; h>0; h--)
	{
		start = rdtsc();
		for(int j=0; j<N; j++)
		{
			for(int r=0; r<N; r++)
			{
				tab2[j][r]=tab2[r][j];
			}
		}
		for(int j=0; j<N; j++)
		{
			for(int l=0; l<N; l++)
			{
				for(int p=0; p<N; p++)
				{
					tab3[j][l]+=tab1[j][p]*tab2[j][p];
				}
			}
		}
		end=rdtsc();
		time+=(end-start);
		if(h==1)
		{	
			printf("Mnozenie macierzy transponowanej N=%d, ilosc powtorzen %d\n", N, k);
			printf("Czas wykonania jednego mnożenia: %.0f ns\n", (double)time/k*3.3);
		}
	}
	}
	}
	return 0;
}
