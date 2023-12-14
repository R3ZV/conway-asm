#include <iostream>
#include <utility>
#include <vector>

int n, m, p, k, i, j, gen, cnt, d, ni, nj;

std::vector<int> di = {-1, -1, -1, 0, 0, 1, 1, 1};
std::vector<int> dj = {-1, 0, 1, -1, 1, -1, 0, 1};

std::vector<std::vector<int>> conway(const int &n, const int &m, const std::vector<std::pair<int, int>> &v, const int &k) {
    std::vector<std::vector<int>> grid(n + 2, std::vector<int>(m + 2, 0));

    for (const std::pair<int, int> &cell : v) {
        grid[cell.first + 1][cell.second + 1] = 1;
    }
    std::vector<std::vector<int>> prev = grid;

    for (gen = 0; gen < k; ++gen) {
        prev = grid;
        for (i = 1; i <= n; ++i) {
            for (j = 1; j <= m; ++j) {
                cnt = 0;
                for (d = 0; d < 8; ++d) {
                    ni = i + di[d];
                    nj = j + dj[d];
                    if (ni < 1 || nj < 1 || ni > n || nj > m) {
                        continue;
                    }
                    if (prev[ni][nj] == 1) {
                        ++cnt;
                    }
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
    }

    return grid;
}

int main() {
    std::cin >> n >> m;

    std::cin >> p;
    std::vector<std::pair<int, int>> v(p);
    for (i = 0; i < p; ++i) {
        std::cin >> v[i].first >> v[i].second;
    }

    std::cin >> k;
    std::vector<std::vector<int>> ans = conway(n, m, v, k);
    for (i = 1; i <= n; ++i) {
        for (j = 1; j <= m; ++j) {
            std::cout << ans[i][j];
            if (j < m) {
                std::cout << " ";
            }
        }
        if (i < n) {
            std::cout << "\n";
        }
    }
    return 0;
}
