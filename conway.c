#include<stdio.h>

int prev[100][100];
int grid[100][100];

int di[] = {-1, 1, 0, 0, -1, 1, 1, -1};
int dj[] = {0, 0, -1, 1, -1, 1, -1, 1};

int main() {
    int n, m;
    scanf("%d %d", &n, &m);
    int p;
    scanf("%d", &p);
    for (int i = 0; i < p; i++) {
        int x, y;
        scanf("%d %d", &x, &y);
        prev[x + 1][y + 1] = 1;
    }
    int k;
    scanf("%d", &k);
    for (int gen = 0; gen < k; gen++) {
        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= m; j++) {
                int cnt = 0;
                for (int d = 0; d < 8; d++) {
                    int ni = i + di[d];
                    int nj = j + dj[d];
                    cnt += prev[ni][nj];
                }
                grid[i][j] = 0;
                if (cnt == 3) {
                    grid[i][j] = 1;
                }
                if (cnt == 2) {
                    grid[i][j] = 1 * prev[i][j];
                }
            }
        }
        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= m; j++) {
                prev[i][j] = grid[i][j];
            }
        }
    }
    for (int i = 1; i <= n; i++) {
        for (int j = 1; j <= m; j++) {
            printf("%d", grid[i][j]);
            if (j < m) {
                printf(" ");
            }
        }
        if (i < n) {
            printf("\n");
        }
    }
}
