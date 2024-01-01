#include <iostream>
#include <utility>
#include <vector>

//                      N   NE  E  SE S SW    W  NW
std::vector<int> di = {-1,  -1, 0, 1, 1,  1,  0, -1};
std::vector<int> dj = { 0,   1, 1, 1, 0, -1, -1, -1};

std::vector<std::vector<int>> conway(const int &n, const int &m, const std::vector<std::pair<int, int>> &v, const int &k) {
    std::vector<std::vector<int>> grid(n + 2, std::vector<int>(m + 2, 0));

    for (const std::pair<int, int> &cell : v) {
        grid[cell.first + 1][cell.second + 1] = 1;
    }
    std::vector<std::vector<int>> prev = grid;

    for (int gen = 0; gen < k; ++gen) {
        prev = grid;
        for (int i = 1; i <= n; ++i) {
            for (int j = 1; j <= m; ++j) {
                int cnt = 0;
                for (int d = 0; d < 8; ++d) {
                    int ni = i + di[d];
                    int nj = j + dj[d];
                    cnt += prev[ni][nj];
                }

                // 1. Any live cell with fewer than two live neighbours dies, as if by underpopulation.
                if (prev[i][j] == 1 && cnt < 2) {
                    grid[i][j] = 0;
                }
                // 2. Any live cell with two or three live neighbours lives on to the next generation.
                if (prev[i][j] == 1 && (cnt == 2 || cnt == 3)) {
                    grid[i][j] = 1;
                }
                // 3. Any live cell with more than three live neighbours dies, as if by overpopulation.
                if (prev[i][j] == 1 && cnt > 3) {
                    grid[i][j] = 0;
                }
                // 4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
                if (prev[i][j] == 0 && cnt == 3) {
                    grid[i][j] = 1;
                }
            }
        }
    }

    return grid;
}

int main() {
    int n, m;
    std::cin >> n >> m;

    int p;
    std::cin >> p;
    std::vector<std::pair<int, int>> v(p);
    for (int i = 0; i < p; ++i) {
        std::cin >> v[i].first >> v[i].second;
    }

    int k;
    std::cin >> k;
    std::vector<std::vector<int>> ans = conway(n, m, v, k);
    for (int i = 1; i <= n; ++i) {
        for (int j = 1; j <= m; ++j) {
            std::cout << ans[i][j] << " ";
        }
        std::cout << "\n";
    }
    return 0;
}
