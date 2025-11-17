-- ============================================================================
-- LUASNIP SNIPPETS
-- ============================================================================

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- ============================================================================
-- C++ SNIPPETS
-- ============================================================================

ls.add_snippets("cpp", {
    -- Main competitive programming template
    s("code", {
        t({
            "#include <bits/stdc++.h>",
            "#define endl '\\n'",
            "",
            "namespace soon {",
            "      using namespace std;",
            "",
            "      auto summon_power = []() {",
            "            ios::sync_with_stdio(false);",
            "            cin.tie(nullptr);",
            "      };",
            "",
            "      bool __cases = true;",
            "}",
            "",
            "using namespace soon;",
            "",
            "void init() {",
            "      ",
        }),
        i(1),
        t({
            "",
            "}",
            "",
            "signed main() {",
            "      summon_power();",
            "",
            "      int cases = 1;",
            "      if (__cases) cin >> cases;",
            "      while (cases--) {",
            "            init();",
            "      }",
            "      return 0;",
            "}",
            "",
        })
    }),

    -- Run-length encoding
    s("rle", {
        t({
            "template <typename T, typename T_iterable>",
            "vector<pair<T, int>> run_length_encoding(const T_iterable &items) {",
            "      vector<pair<T, int>> runs;",
            "      T previous = T();",
            "      int count = 0;",
            "",
            "      for (const T &item : items)",
            "            if (item == previous) {",
            "                  count++;",
            "            } else {",
            "                  if (count > 0)",
            "                        runs.emplace_back(previous, count);",
            "",
            "                  previous = item;",
            "                  count = 1;",
            "            }",
            "",
            "      if (count > 0)",
            "            runs.emplace_back(previous, count);",
            "",
            "      return runs;",
            "}",
            "",
        })
    }),

    -- Check prime
    s("cp", {
        t({
            "bool is_prime(int n) {",
            "      if (n < 2) return false;",
            "      if (n == 2) return true;",
            "      if (n % 2 == 0) return false;",
            "",
            "      for (int i = 3; i * i <= n; i += 2) {",
            "            if (n % i == 0) return false;",
            "      }",
            "",
            "      return true;",
            "}",
            "",
        })
    }),

    -- Vector of primes (sieve)
    s("vop", {
        t({
            "vector<int> sieve(int n) {",
            "      vector<bool> is_prime(n + 1, true);",
            "      vector<int> primes;",
            "",
            "      is_prime[0] = false;",
            "      is_prime[1] = false;",
            "",
            "      for (int i = 2; i <= n; i++) {",
            "            if (is_prime[i]) {",
            "                  primes.push_back(i);",
            "                  for (int64_t x = (int64_t)i * i; x <= n; x += i) {",
            "                        is_prime[x] = false;",
            "                  }",
            "            }",
            "      }",
            "",
            "      return primes;",
            "}",
            "",
        })
    }),

    -- Vector of factors
    s("vof", {
        t({
            "vector<int> factors(int n) {",
            "      vector<int> res;",
            "",
            "      for (int i = 1; i * i <= n; i++) {",
            "            if (n % i == 0) {",
            "                  res.push_back(i);",
            "                  if (i != n / i) res.push_back(n / i);",
            "            }",
            "      }",
            "",
            "      sort(res.begin(), res.end());",
            "      return res;",
            "}",
            "",
        })
    }),

    -- Perfect square check
    s("psq", {
        t({
            "bool is_psq(int64_t n) {",
            "      if (n < 0) return false;",
            "      if (n == 0) return true;",
            "",
            "      int64_t l = 1, r = std::min(n, (int64_t)1e9);",
            "      while (l <= r) {",
            "            int64_t m = l + (r - l) / 2;",
            "            int64_t sq = m * m;",
            "            if (sq == n) return true;",
            "            if (sq < n) l = m + 1;",
            "            else r = m - 1;",
            "      }",
            "",
            "      return false;",
            "}",
            "",
        })
    }),

    -- Fenwick tree
    s("fen", {
        t({
            "struct Fenwick {",
            "      vector<int> fen;",
            "      int n;",
            "",
            "      Fenwick(int n) : n(n), fen(n + 1) {}",
            "",
            "      void update(int i, int val) {",
            "            while (i <= n) {",
            "                  fen[i] += val;",
            "                  i += (i & -i);",
            "            }",
            "      }",
            "",
            "      int64_t query(int i) {",
            "            int64_t sum = 0;",
            "            while (i > 0) {",
            "                  sum += fen[i];",
            "                  i -= (i & -i);",
            "            }",
            "            return sum;",
            "      }",
            "",
            "      int64_t range_query(int l, int r) {",
            "            return (l > r) ? 0LL : query(r) - query(l - 1);",
            "      }",
            "};",
            "",
        })
    }),

    -- DSU (Disjoint Set Union)
    s("dsu", {
        t({
            "struct DSU {",
            "      vector<int> parent, sz;",
            "      ",
            "      DSU(int n) : parent(n), sz(n, 1) {",
            "            iota(parent.begin(), parent.end(), 0);",
            "      }",
            "      ",
            "      int find(int x) {",
            "            while (x != parent[x]) x = parent[x] = parent[parent[x]];",
            "            return x;",
            "      }",
            "      ",
            "      bool same(int x, int y) { return find(x) == find(y); }",
            "      ",
            "      bool unite(int x, int y) {",
            "            x = find(x), y = find(y);",
            "            if (x == y) return false;",
            "            if (sz[x] < sz[y]) swap(x, y);",
            "            parent[y] = x;",
            "            sz[x] += sz[y];",
            "            return true;",
            "      }",
            "      ",
            "      int size(int x) { return sz[find(x)]; }",
            "};",
            "",
        })
    }),
})
