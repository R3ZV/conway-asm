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
    int type;
    std::string s;
    std::cin >> type >> s;

    std::vector<std::vector<int>> mat = conway(n, m, v, k);
    std::vector<int> bits;
    for (auto line : mat) {
        for (int x : line) {
            bits.push_back(x);
        }
    }

    int mod = bits.size();
    int bit_id = 0, eax = 0, ebx = 0, j = 0;
    if (type == 0) {
        printf("0x");
        j = 0;
    } else {
        j = 3;
    }
    while (j < (int)s.size()) {
        if (type == 0) {
            eax = s[j];
        } else {
            int c = s[j - 1] - 48; // conver 0-9 chars into digit
            if (c > 9) c -= 7; // if it is a upper case letter
            eax = (c << 4);

            c = s[j] - 48; // conver 0-9 chars into digit
            if (c > 9) c -= 7; // if it is a upper case letter
            eax += c;
        }
        ebx = 0;
        for (int i = 7; i >= 0; --i) {
            ebx |= (1 << i) * bits[bit_id];
            bit_id++;
            if (bit_id == mod) {
                bit_id = 0;
            }
        }
        if (type == 0) {
            printf("%X", eax ^ ebx);
        } else {
            printf("%c", eax ^ ebx);
        }

        j++;
        j += type;
    }
    printf("\n");
    return 0;
}
