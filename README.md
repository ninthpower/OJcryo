# OJcryo
###### A suite of Odd-Job scripts for cryo-em data processing.

### TOOLS AVAILABLE:

#### RELION specific:

OJcryo_relion_screen: A simple interactive micrograph screening program that allows the removal of dirty/unwanted images from a cryo-EM image pool.

OJcryo_relion_rm_duplicates: Removes any duplicate particles from a Relion join_particles.star file.


#### Micrograph Drift Correction:

OJcryo_m2_tiff_batch: Simple implementation of a TIFF batch mode for motioncor2.

OJcryo_unblur(soon!): Implements a parallel, batch version of unblur.

OJcryo_unblur_tiff: Implements the same batch functionality as Ojcryo_unblur_parallel, but takes .tif files as inputs, adjusts using gain reference, bins, and then unblurs (tif2mrc->clip->binvol->unblur).
