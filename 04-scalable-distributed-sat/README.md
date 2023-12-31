# Scalable Distributed SAT Solving

## Software

* [Mallob](https://github.com/domschrei/mallob)
    - Commit 72cab2a743ab5166deaac1c8fd784ef1cbac6fd3 essentially corresponds to our evaluations.
* [HordeSat](https://github.com/domschrei/hordesat)
* [Kissat-MAB_HyWalk](https://satcompetition.github.io/2022/downloads/sequential-solvers.zip)

## Benchmarks

* [Benchmarks from International SAT Competition 2021](https://benchmark-database.de/getinstances?track=main_2021)
* [Benchmarks from International SAT Competition 2022](https://benchmark-database.de/getinstances?track=main_2022)
    - Selection of 349 "solvable" instances: See `selection-isc2022.txt`.

## Data

The directory `data` features the following directories:

* `isc22-selection`: All experiments performed on the 349 "solvable" benchmarks from ISC 2022.
* `isc21`: All experiments regarding isolated SAT solving performance on the 400 benchmarks from ISC 2021.
* `scheduling`: The experiments on malleable SAT solving and massively parallel processing of SAT tasks (also with ISC 2021 benchmarks).
* `post-isc22`: Follow-up experiment regarding the parallel track of ISC 2022.

## Configurations

File `data/base-options` provides the base options we ran Mallob with. Additional `options` files as well as `sbatch` scripts give further information on how the individual runs were configured and executed.
