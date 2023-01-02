#include <stdio.h>

#define MAX 5

void sort(int *);
void swap(int *, int *);

int main() {
	int i = 0;
    int array[] = {9, 8, 7, 2, 11};
    sort(array);

	for(i = 0; i < MAX; i++) {
		printf("%d\n",array[i]);
	}
	return 0;
}


void sort(int *array_ptr) {
	int i = 0, j = 0;
	for (i = 0; i < MAX; i++){
		for (j = 1; j < MAX; j++){
			if (*(array_ptr + j) < *(array_ptr + j - 1)){
				swap(array_ptr + j, array_ptr + j - 1);
			}
		}
	}
}

void swap(int *a_ptr, int *b_ptr) {
	*a_ptr = *a_ptr + *b_ptr;
	*b_ptr = *a_ptr - *b_ptr;
	*a_ptr = *a_ptr - *b_ptr;
}