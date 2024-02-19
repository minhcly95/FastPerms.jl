# Benchmark Report for */home/bqminh/.julia/dev/FastPerms.jl*

## Job Properties
* Time of benchmark: 19 Feb 2024 - 15:56
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

| ID                             | time            | GC time | memory | allocations |
|--------------------------------|----------------:|--------:|-------:|------------:|
| `["CPerm{12}", "inv"]`         |  11.586 ns (5%) |         |        |             |
| `["CPerm{12}", "mul"]`         |  14.076 ns (5%) |         |        |             |
| `["CPerm{16}", "inv"]`         |  14.593 ns (5%) |         |        |             |
| `["CPerm{16}", "mul"]`         |  17.611 ns (5%) |         |        |             |
| `["CPerm{4}", "inv"]`          |   6.575 ns (5%) |         |        |             |
| `["CPerm{4}", "mul"]`          |   8.584 ns (5%) |         |        |             |
| `["CPerm{8}", "inv"]`          |   8.082 ns (5%) |         |        |             |
| `["CPerm{8}", "mul"]`          |  11.573 ns (5%) |         |        |             |
| `["LPerm{3}", "inv"]`          |   5.061 ns (5%) |         |        |             |
| `["LPerm{3}", "mul"]`          |   6.126 ns (5%) |         |        |             |
| `["LPerm{4}", "inv"]`          |   5.047 ns (5%) |         |        |             |
| `["LPerm{4}", "mul"]`          |   6.142 ns (5%) |         |        |             |
| `["LPerm{5}", "inv"]`          |   5.560 ns (5%) |         |        |             |
| `["LPerm{5}", "mul"]`          |   6.126 ns (5%) |         |        |             |
| `["SPerm{12, Int64}", "inv"]`  |  18.079 ns (5%) |         |        |             |
| `["SPerm{12, Int64}", "mul"]`  |  11.423 ns (5%) |         |        |             |
| `["SPerm{12, UInt8}", "inv"]`  |  16.326 ns (5%) |         |        |             |
| `["SPerm{12, UInt8}", "mul"]`  |  12.460 ns (5%) |         |        |             |
| `["SPerm{128, Int64}", "inv"]` | 112.735 ns (5%) |         |        |             |
| `["SPerm{128, Int64}", "mul"]` | 174.048 ns (5%) |         |        |             |
| `["SPerm{128, UInt8}", "inv"]` |  82.284 ns (5%) |         |        |             |
| `["SPerm{128, UInt8}", "mul"]` | 201.766 ns (5%) |         |        |             |
| `["SPerm{16, Int64}", "inv"]`  |  26.099 ns (5%) |         |        |             |
| `["SPerm{16, Int64}", "mul"]`  |  17.803 ns (5%) |         |        |             |
| `["SPerm{16, UInt8}", "inv"]`  |  23.587 ns (5%) |         |        |             |
| `["SPerm{16, UInt8}", "mul"]`  |  31.608 ns (5%) |         |        |             |
| `["SPerm{24, Int64}", "inv"]`  |  30.686 ns (5%) |         |        |             |
| `["SPerm{24, Int64}", "mul"]`  |  29.130 ns (5%) |         |        |             |
| `["SPerm{24, UInt8}", "inv"]`  |  27.607 ns (5%) |         |        |             |
| `["SPerm{24, UInt8}", "mul"]`  |  52.188 ns (5%) |         |        |             |
| `["SPerm{32, Int64}", "inv"]`  |  36.833 ns (5%) |         |        |             |
| `["SPerm{32, Int64}", "mul"]`  |  65.844 ns (5%) |         |        |             |
| `["SPerm{32, UInt8}", "inv"]`  |  35.110 ns (5%) |         |        |             |
| `["SPerm{32, UInt8}", "mul"]`  |  46.164 ns (5%) |         |        |             |
| `["SPerm{4, Int64}", "inv"]`   |  14.564 ns (5%) |         |        |             |
| `["SPerm{4, Int64}", "mul"]`   |   6.048 ns (5%) |         |        |             |
| `["SPerm{4, UInt8}", "inv"]`   |   6.757 ns (5%) |         |        |             |
| `["SPerm{4, UInt8}", "mul"]`   |  18.005 ns (5%) |         |        |             |
| `["SPerm{48, Int64}", "inv"]`  |  51.632 ns (5%) |         |        |             |
| `["SPerm{48, Int64}", "mul"]`  |  65.735 ns (5%) |         |        |             |
| `["SPerm{48, UInt8}", "inv"]`  |  48.148 ns (5%) |         |        |             |
| `["SPerm{48, UInt8}", "mul"]`  |  74.244 ns (5%) |         |        |             |
| `["SPerm{64, Int64}", "inv"]`  |  62.548 ns (5%) |         |        |             |
| `["SPerm{64, Int64}", "mul"]`  |  83.767 ns (5%) |         |        |             |
| `["SPerm{64, UInt8}", "inv"]`  |  50.203 ns (5%) |         |        |             |
| `["SPerm{64, UInt8}", "mul"]`  |  98.366 ns (5%) |         |        |             |
| `["SPerm{8, Int64}", "inv"]`   |  16.575 ns (5%) |         |        |             |
| `["SPerm{8, Int64}", "mul"]`   |   7.577 ns (5%) |         |        |             |
| `["SPerm{8, UInt8}", "inv"]`   |  17.073 ns (5%) |         |        |             |
| `["SPerm{8, UInt8}", "mul"]`   |   8.500 ns (5%) |         |        |             |

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
       #1   934 MHz       5235 s          3 s       2277 s      35317 s          0 s
       #2  2000 MHz       4602 s         54 s       2314 s      35822 s          0 s
       #3   500 MHz       4396 s          0 s       2332 s      36013 s          0 s
       #4   500 MHz       4451 s         85 s       2364 s      35880 s          0 s
  Memory: 7.653850555419922 GB (4596.3203125 MB free)
  Uptime: 4329.5 sec
  Load Avg:  2.47  1.37  1.14
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-15.0.7 (ORCJIT, broadwell)
Threads: 1 default, 0 interactive, 1 GC (on 4 virtual cores)
```