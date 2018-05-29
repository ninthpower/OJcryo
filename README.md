# OJcryo
###### A suite of Odd-Job scripts for cryo-em data processing.

## TOOLS AVAILABLE:

### RELION-specific:

- **OJcryo_relion_screen:** A simple interactive micrograph screening program that allows the removal of dirty/unwanted images from a cryo-EM image pool.

- **OJcryo_relion_rm_duplicates:** Removes any duplicate particles from a Relion join_particles.star file.


### Micrograph Drift Correction:

- **OJcryo_m2_tiff_batch:** Simple implementation of a TIFF batch mode for motioncor2 (requires GPU).

- **OJcryo_unblur(soon!):** Implements a parallel, batch version of unblur.

- **OJcryo_unblur_tiff:** Implements the same batch functionality as Ojcryo_unblur_parallel, but takes .tif files as inputs, adjusts using gain reference, bins, and then unblurs (tif2mrc->clip->binvol->unblur).

## OVERVIEW:
OJcryo is a project I have been slowly adding to over the past two years as I have written helper scripts for my work in processing cryo-em data. I hope you find it useful as some of these have saved me LOTS of manual effort. Enjoy! -np

#### OJcryo_relion_screen:
1) Navigate to an Import/ folder in your RELION project that has a micrographs.star inside.
2) Run: OJcryo_relion_screen.py \<output_filename.star (optional)\>
3) One-by-one, each micrograph in this folder's micrographs.star will be displayed. Once you have made a decision on whether to keep it or not, click the window "X" (or press *Escape*).
4) A new window will pop up. To save the micrograph in your set, select "Yes" (or press *Enter*). Otherwise select "No" (or press *Escape*).


![alt text](misc/OJcryo_relion_screen_2.png "Very simple interface.")
  

#### OJcryo_relion_rm_duplicated:
