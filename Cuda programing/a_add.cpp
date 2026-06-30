#include <stdlib.h>
#include<cstdio>
#include <math.h>
#include <assert.h>

const int N=10000000;
#define MAX_ERR 1e-6

void add(float *sum, float *a, float *b, int n){
	for(int i=0;i<n;i++)sum[i]=a[i]+b[i];
}

int main(){
	float *a,*b,*sum;
	int nbytes =sizeof(float) *N;
	// allocate memory
	a=(float*)malloc(nbytes);
	b=(float*)malloc(nbytes);
	sum=(float*)malloc(nbytes);
	// Initialize array
	for(int i=0;i<N;i++){
		a[i]=2.0;
		b[i]=2.0;
	}

	add(sum,a,b,N);
	// verification
	for(int i=0;i<N;i++){
		assert(fabs(sum[i]-a[i]-b[i])<MAX_ERR);
	}
	printf("sum[0]=%f\n", sum[0]);
	printf("PASSED\n");
	free(a);
	free(b);
	free(sum);
	return 0;
}
