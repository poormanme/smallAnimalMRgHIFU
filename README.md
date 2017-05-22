#smallAnimalMRgHIFU
***
## Open-source plans for constructing and implementing a preclinical MRgHIFU/MRgFUS system on a small-animal MRI scanner.
### DOI: 10.5281/zenodo.51633

#### ME Poorman, VL Chaplin, K Wilkens, MD Dockery, T Giorgio, WA Grissom, and CF Caskey
#### Vanderbilt University Institue for Imaging Science

Freely available for use and modification with citation of original distribution/article (https://jtultrasound.biomedcentral.com/articles/10.1186/s40349-016-0066-7). See license file for more information.
***

### MRgFUS_software:
* Matlab code to control sonication real-time with baseline subtraction thermometry and a PID feedback controller
* __V1:__ Single script version - intended for debugging purposes only
* __V2:__ Modular software and GUI commented and tested - intended for use and straightforward modification
 * __ARFI folder:__ pulse sequence and recon code. C code must be compiled prior to use
 * __calcCEM_vect.m:__ computes thermal dose given focal temperature
 * __initFGEN.m:__ initializes waveform generator
 * __offFGEN.m:__ stops all waveform outputs to transducer
 * __parsepp.m:__ reads parameter file 
 * __pidUpdate.m:__ PID controller computation
 * __readInFID.m:__ reads in next image from .fid data file
 * __runControlSoftware.m:__ master script, contains GUI to set up execution, begins sonication
 * __runExpGui.m/.fig:__ button to begin sonication
 * __runTempRecon.m:__ computes thermometry, calls other modules for execution
 * __userinterface.m/fig:__ optional GUI to set up sonication parameters

###MRgHIFU_hardware_pt#:
* Solidworks files and parts list of all hardware components used to build the system
* Split into 4 ".zip" files to comply with size requirements. Unzip into same folder for proper use.

### Instructions for use:
* See instructions file

### License
* See license file

### Helpful tips:
* On the Varian systems, the current acquisition file can be found in '~/vnmrsys/exp2/acqfil/fid'
* Previously stored Varian data is found in'~/vnmrsys/data/studies/s_YYYYMMDD_##' 
 * Can run software in recon mode to see past execution 
