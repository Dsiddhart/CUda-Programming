#include <stdlib.h>
#include <stdio.h>
#include<cstdio>
#include <math.h>
#include <assert.h>

const int N=1000000;
#define MAX_ERR 1e-6
__global__
	void add(float *sum, float *a, float *b, int n){
		int i = blockIdx.x * blockDim.x + threadIdx.x;

		if(i<n)
			sum[i]=a[i]+b[i];
	
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
	//Allocate GPU memory
	
	float *da,*db,*dsum;
	cudaMalloc((void **)&da , nbytes);
	cudaMalloc((void **)&db,nbytes);
	cudaMalloc((void **)&dsum,nbytes);
	
	// transfer datafrom main memory(cpu) to GPU memory
	cudaMemcpy(da, a, nbytes, cudaMemcpyHostToDevice);
	cudaMemcpy(db, b, nbytes, cudaMemcpyHostToDevice);
	
	int blockSize=256;
	int nBlocks=(N+blockSize - 1) / blockSize;
	add<<<nBlocks,blockSize>>>(dsum, da, db, N);

	// --- ADD THESE LINES TO CATCH SILENT ERRORS ---
	cudaError_t err = cudaGetLastError();
	if (err != cudaSuccess) {
    		printf("GPU Error: %s\n", cudaGetErrorString(err));
	}
	
	//Transfer data back to host memory
	cudaMemcpy(sum, dsum, nbytes,cudaMemcpyDeviceToHost);
	
	// verification
	for(int i=0;i<N;i++){
		assert(fabs(sum[i]-a[i]-b[i])<MAX_ERR);
	}
	printf("sum[0]=%f\n", sum[0]);
	printf("PASSED\n");
	free(a);
	free(b);
	free(sum);
	cudaFree(da);
	cudaFree(db);
	cudaFree(dsum);
	return 0;
}
