#include <stdio.h>

#define COL 10
#define RAW 12800000

int main() {
    int i, j;
    int arr[RAW][COL];

    for (i = 0; i < RAW; i++)
        for (j = 0; j < COL; j++)
            arr[i][j] = 1;

    return 0;
}
