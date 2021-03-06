# Advent of Code 2018

![Build Status](https://github.com/sevenseacat/advent_of_code_2018/workflows/Elixir%20CI/badge.svg)

My Elixir solutions for the [Advent of Code 2018](http://adventofcode.com/2018).

## Benchmarks

If you're curious how long each of my solutions roughly takes to run.

```
Name                    ips        average  deviation         median         99th %
day 1, part 1        7.11 K       0.141 ms    ±32.97%       0.131 ms        0.27 ms
day 1, part 2     0.00703 K      142.28 ms    ±23.03%      126.11 ms      218.78 ms

Name                    ips        average  deviation         median         99th %
day 2, part 1        430.85        2.32 ms    ±10.97%        2.28 ms        3.30 ms
day 2, part 2        222.68        4.49 ms     ±8.41%        4.42 ms        6.82 ms

Name                    ips        average  deviation         median         99th %
day 3, part 2          1.32      755.09 ms     ±9.69%      754.45 ms      891.66 ms
day 3, part 1          1.27      789.14 ms    ±15.87%      793.00 ms     1025.02 ms

Name                    ips        average  deviation         median         99th %
day 4, part 1         94.95       10.53 ms     ±7.73%       10.34 ms       14.54 ms
day 4, part 2         62.12       16.10 ms    ±50.51%       12.39 ms       53.79 ms

Name                    ips        average  deviation         median         99th %
day 5, part 1         37.08       26.97 ms    ±22.25%       24.64 ms       45.12 ms
day 5, part 2          1.56      641.23 ms     ±4.28%      642.31 ms      692.80 ms

Name                    ips        average  deviation         median         99th %
day 6, part 1          0.58         1.72 s     ±0.24%         1.72 s         1.73 s
day 6, part 2          3.54         0.28 s     ±4.48%         0.28 s         0.33 s

Name                    ips        average  deviation         median         99th %
day 7, part 1        2.04 K        0.49 ms    ±14.23%        0.48 ms        0.72 ms
day 7, part 2       0.117 K        8.57 ms     ±8.10%        8.37 ms       12.23 ms

Name                    ips        average  deviation         median         99th %
day 8, part 1        351.92        2.84 ms    ±78.01%        2.36 ms       10.63 ms
day 8, part 2        177.74        5.63 ms    ±92.16%        4.14 ms       26.92 ms

Name                              ips        average  deviation         median         99th %
day 9, part 1 (ziplist)         31.99       31.26 ms    ±25.27%       27.89 ms       65.41 ms
day 9, part 1 (digraph)          1.55      646.02 ms    ±11.54%      610.26 ms      806.71 ms
day 9, part 2 (ziplist)         0.192     5219.41 ms     ±0.00%     5219.41 ms     5219.41 ms
day 9, part 2 (digraph)        0.0100    99945.40 ms     ±0.00%    99945.40 ms    99945.40 ms

Name                    ips        average  deviation         median         99th %
day 10, both parts     3.99      250.91 ms    ±10.51%      245.45 ms      315.55 ms

Name                     ips        average  deviation         median         99th %
day 11, part 1          4.92         0.20 s    ±27.39%        0.180 s         0.38 s
day 11, part 2         0.101         9.86 s     ±0.00%         9.86 s         9.86 s

Name                     ips        average  deviation         median         99th %
day 12, part 1        258.93        3.86 ms    ±11.25%        3.77 ms        6.15 ms
day 12, part 2         26.59       37.61 ms     ±3.37%       37.25 ms       42.79 ms

Name                     ips        average  deviation         median         99th %
day 13, part 1         60.41       16.55 ms    ±11.49%       15.61 ms       20.63 ms
day 13, part 2          5.68      176.00 ms     ±1.95%      176.24 ms      182.77 ms

Name                     ips        average  deviation         median         99th %
day 14, part 1          1.19         0.84 s    ±20.34%         0.82 s         1.08 s
day 14, part 2        0.0186        53.87 s     ±0.00%        53.87 s        53.87 s

name                     ips        average  deviation         median         99th %
day 15, part 1       0.00824       2.02 min     ±0.00%       2.02 min       2.02 min
day 15, part 2       0.00058      28.76 min     ±0.00%      28.76 min      28.76 min

Name                     ips        average  deviation         median         99th %
day 16, part 1         82.34       12.15 ms    ±17.13%       11.31 ms       20.46 ms
day 16, part 2         65.87       15.18 ms    ±12.87%       14.68 ms       21.13 ms

Name                     ips        average  deviation         median         99th %
day 17, part 1         12.90       77.53 ms    ±27.57%       73.49 ms      218.66 ms
day 17, part 2         12.91       77.45 ms    ±12.22%       75.51 ms      133.81 ms

Name                     ips        average  deviation         median         99th %
day 18, part 1         17.34       0.0577 s    ±27.89%       0.0517 s        0.166 s
day 18, part 2          0.50         2.01 s     ±3.80%         1.99 s         2.09 s

Name                     ips        average  deviation         median         99th %
day 19, part 1          0.29         3.39 s     ±0.92%         3.39 s         3.41 s

Name                     ips        average  deviation         median         99th %
day 20, part 1        100.62        9.94 ms    ±26.81%        9.37 ms       18.81 ms
day 20, part 2         82.97       12.05 ms    ±39.18%       10.46 ms       34.37 ms

Name                     ips        average  deviation         median         99th %
day 21, part 1        820.53    0.00002 min    ±11.50%    0.00002 min    0.00003 min
day 21, part 2       0.00056      29.94 min     ±0.00%      29.94 min      29.94 min

Name                     ips        average  deviation         median         99th %
day 22, part 1         86.69       0.0115 s    ±16.70%       0.0113 s       0.0189 s
day 22, part 2          0.35         2.87 s     ±8.59%         2.87 s         3.05 s

Name                     ips        average  deviation         median         99th %
day 23, part 1        242.71      0.00412 s    ±10.94%      0.00405 s      0.00650 s
day 23, part 2         0.154         6.48 s     ±0.00%         6.48 s         6.48 s

Name                     ips        average  deviation         median         99th %
day 24, part 1         31.72       0.0315 s     ±3.58%       0.0312 s       0.0360 s
day 24, part 2          0.36         2.75 s     ±7.72%         2.75 s         2.90 s

Name                     ips        average  deviation         median         99th %
day 25, part 1          1.37      729.43 ms     ±1.75%      724.16 ms      749.65 ms
```
