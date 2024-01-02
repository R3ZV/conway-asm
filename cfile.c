#include <stdio.h>

int main(void) {
    FILE *input = fopen("in.txt", "r");

    int n;
    fscanf(input, "%d", &n);

    int m;
    fscanf(input, "%d", &m);

    int p;
    fscanf(input, "%d", &p);

    int k;
    fscanf(input, "%d", &k);

    fclose(input);

    FILE *output = fopen("out.txt", "w");

    fprintf(output, "Have: %d\n", k);
    fprintf(output, "Have: %d\n", p);
    fprintf(output, "Have: %d\n", m);
    fprintf(output, "Have: %d\n", n);

    fclose(output);
    return 0;
}
