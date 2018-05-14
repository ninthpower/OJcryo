# OJcryo
###### A suite of Odd-Job scripts for cryo-em data processing.

### TOOLS AVAILABLE:

#### RELION specific:

OJcryo_class_table: Creates a tab-delimited .txt from a 2D/3D model.star file.

OJcryo_remove_duplicates: Removes any duplicate particles from a Relion join_particles.star file.


#### Micrograph Drift Correction:

OJcryo_motioncor2_tiff_batch: Simple implementation of a TIFF batch mode for motioncor2.

OJcryo_tiff_unblur_parallel: Implements a parallel version of tif2mrc->clip->binvol->unblur.
