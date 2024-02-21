# Benchmark Report for */home/bqminh/.julia/dev/FastPerms.jl*

## Job Properties
* Time of benchmark: 20 Feb 2024 - 22:50
* Package commit: dirty
* Julia commit: 7790d6
* Julia command flags: None
* Environment variables: None

## Results
Below is a table of this job's results, obtained by running the benchmarks.
The values listed in the `ID` column have the structure `[parent_group, child_group, ..., key]`, and can be used to
index into the BaseBenchmarks suite to retrieve the corresponding benchmarks.
The percentages accompanying time and memory values in the below table are noise tolerances. The "true"
time/memory value for a given benchmark is expected to fall within this percentage of the reported value.
An empty cell means that the value was zero.

| ID                             | time           | GC time | memory | allocations |
|--------------------------------|---------------:|--------:|-------:|------------:|
| `["CPerm{12}", "inv"]`         | 10.084 ns (5%) |         |        |             |
| `["CPerm{12}", "mul"]`         | 12.155 ns (5%) |         |        |             |
| `["CPerm{16}", "inv"]`         | 11.576 ns (5%) |         |        |             |
| `["CPerm{16}", "mul"]`         | 13.069 ns (5%) |         |        |             |
| `["CPerm{4}", "inv"]`          |  6.574 ns (5%) |         |        |             |
| `["CPerm{4}", "mul"]`          |  8.060 ns (5%) |         |        |             |
| `["CPerm{8}", "inv"]`          |  8.082 ns (5%) |         |        |             |
| `["CPerm{8}", "mul"]`          | 10.076 ns (5%) |         |        |             |
| `["LPerm{3}", "inv"]`          |  5.546 ns (5%) |         |        |             |
| `["LPerm{3}", "mul"]`          |  5.568 ns (5%) |         |        |             |
| `["LPerm{4}", "inv"]`          |  5.085 ns (5%) |         |        |             |
| `["LPerm{4}", "mul"]`          |  6.129 ns (5%) |         |        |             |
| `["LPerm{5}", "inv"]`          |  5.085 ns (5%) |         |        |             |
| `["LPerm{5}", "mul"]`          |  5.566 ns (5%) |         |        |             |
| `["SPerm{12, Int64}", "inv"]`  | 18.070 ns (5%) |         |        |             |
| `["SPerm{12, Int64}", "mul"]`  | 11.590 ns (5%) |         |        |             |
| `["SPerm{12, UInt8}", "inv"]`  | 16.339 ns (5%) |         |        |             |
| `["SPerm{12, UInt8}", "mul"]`  | 11.704 ns (5%) |         |        |             |
| `["SPerm{128, Int64}", "inv"]` | 93.397 ns (5%) |         |        |             |
| `["SPerm{128, Int64}", "mul"]` | 98.457 ns (5%) |         |        |             |
| `["SPerm{128, UInt8}", "inv"]` | 76.755 ns (5%) |         |        |             |
| `["SPerm{128, UInt8}", "mul"]` | 76.304 ns (5%) |         |        |             |
| `["SPerm{16, Int64}", "inv"]`  | 20.578 ns (5%) |         |        |             |
| `["SPerm{16, Int64}", "mul"]`  | 16.080 ns (5%) |         |        |             |
| `["SPerm{16, UInt8}", "inv"]`  | 19.576 ns (5%) |         |        |             |
| `["SPerm{16, UInt8}", "mul"]`  | 16.691 ns (5%) |         |        |             |
| `["SPerm{24, Int64}", "inv"]`  | 24.619 ns (5%) |         |        |             |
| `["SPerm{24, Int64}", "mul"]`  | 22.952 ns (5%) |         |        |             |
| `["SPerm{24, UInt8}", "inv"]`  | 22.734 ns (5%) |         |        |             |
| `["SPerm{24, UInt8}", "mul"]`  | 16.101 ns (5%) |         |        |             |
| `["SPerm{32, Int64}", "inv"]`  | 46.705 ns (5%) |         |        |             |
| `["SPerm{32, Int64}", "mul"]`  | 40.050 ns (5%) |         |        |             |
| `["SPerm{32, UInt8}", "inv"]`  | 28.596 ns (5%) |         |        |             |
| `["SPerm{32, UInt8}", "mul"]`  | 19.632 ns (5%) |         |        |             |
| `["SPerm{4, Int64}", "inv"]`   | 14.563 ns (5%) |         |        |             |
| `["SPerm{4, Int64}", "mul"]`   |  6.060 ns (5%) |         |        |             |
| `["SPerm{4, UInt8}", "inv"]`   |  6.767 ns (5%) |         |        |             |
| `["SPerm{4, UInt8}", "mul"]`   |  6.067 ns (5%) |         |        |             |
| `["SPerm{48, Int64}", "inv"]`  | 40.725 ns (5%) |         |        |             |
| `["SPerm{48, Int64}", "mul"]`  | 40.150 ns (5%) |         |        |             |
| `["SPerm{48, UInt8}", "inv"]`  | 36.662 ns (5%) |         |        |             |
| `["SPerm{48, UInt8}", "mul"]`  | 29.626 ns (5%) |         |        |             |
| `["SPerm{64, Int64}", "inv"]`  | 49.689 ns (5%) |         |        |             |
| `["SPerm{64, Int64}", "mul"]`  | 51.549 ns (5%) |         |        |             |
| `["SPerm{64, UInt8}", "inv"]`  | 44.675 ns (5%) |         |        |             |
| `["SPerm{64, UInt8}", "mul"]`  | 42.198 ns (5%) |         |        |             |
| `["SPerm{8, Int64}", "inv"]`   | 16.570 ns (5%) |         |        |             |
| `["SPerm{8, Int64}", "mul"]`   |  7.996 ns (5%) |         |        |             |
| `["SPerm{8, UInt8}", "inv"]`   | 17.070 ns (5%) |         |        |             |
| `["SPerm{8, UInt8}", "mul"]`   | 18.032 ns (5%) |         |        |             |

## Benchmark Group List
Here's a list of all the benchmark groups executed by this job:

- `["CPerm{12}"]`
- `["CPerm{16}"]`
- `["CPerm{4}"]`
- `["CPerm{8}"]`
- `["LPerm{3}"]`
- `["LPerm{4}"]`
- `["LPerm{5}"]`
- `["SPerm{12, Int64}"]`
- `["SPerm{12, UInt8}"]`
- `["SPerm{128, Int64}"]`
- `["SPerm{128, UInt8}"]`
- `["SPerm{16, Int64}"]`
- `["SPerm{16, UInt8}"]`
- `["SPerm{24, Int64}"]`
- `["SPerm{24, UInt8}"]`
- `["SPerm{32, Int64}"]`
- `["SPerm{32, UInt8}"]`
- `["SPerm{4, Int64}"]`
- `["SPerm{4, UInt8}"]`
- `["SPerm{48, Int64}"]`
- `["SPerm{48, UInt8}"]`
- `["SPerm{64, Int64}"]`
- `["SPerm{64, UInt8}"]`
- `["SPerm{8, Int64}"]`
- `["SPerm{8, UInt8}"]`

## Julia versioninfo
```
Julia Version 1.10.1
Commit 7790d6f0641 (2024-02-13 20:41 UTC)
Build Info:
  Official https://julialang.org/ release
Platform Info:
  OS: Linux (x86_64-linux-gnu)
      Linux Mint 21.3
  uname: Linux 5.15.0-94-generic #104-Ubuntu SMP Tue Jan 9 15:25:40 UTC 2024 x86_64 x86_64
  CPU: Intel(R) Core(TM) M-5Y10c CPU @ 0.80GHz: 
              speed         user         nice          sys         idle          irq
       #1   500 MHz       3713 s          3 s       1453 s      24606 s          0 s
       #2  2000 MHz       4432 s        100 s       1462 s      23787 s          0 s
       #3   924 MHz       2679 s         15 s       1501 s      25544 s          0 s
       #4   500 MHz       4527 s         14 s       1445 s      23777 s          0 s
  Memory: 7.653839111328125 GB (4650.74609375 MB free)
  Uptime: 2996.91 sec
  Load Avg:  0.99  0.66  0.55
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-15.0.7 (ORCJIT, broadwell)
Threads: 1 default, 0 interactive, 1 GC (on 4 virtual cores)
```