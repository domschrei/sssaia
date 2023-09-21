# Scalable SAT Solving and its Application 

_Experimental data_

This repository contains the experimental data gathered for and presented in Dominik Schreiber's dissertation _Scalable SAT Solving and its Application_.
At this point in time, (almost) all plots can be reproduced and most of the discussed data is available. Exceptions include the full log files, since these amount to hundreds of Gigabytes. We also reference the used software as well as digital appendices/repositories of the original publications where applicable. 

The data is organized by chapters - see the respective subdirectories.

## Creating Plots

Prerequisites:

* Linux toolchain
* Python3, Matplotlib/PyPlot, LaTeX installation
* The scripts from the [plotscripts repository](https://github.com/domschrei/plotscripts/tree/e5e980e300cc68dedbdd40b1b6b33bb998ff7fcd) must be in the user's `$PATH`.

Execute `bash plot-all.sh`, or, in one of the subdirectories, `bash plot.sh`.

Similarly, use `clean.sh` and `clean-all.sh` to remove the files.
