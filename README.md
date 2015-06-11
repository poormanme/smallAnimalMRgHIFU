smallAnimalMRgHIFU
==================

Set of MATLAB and Solidworks files for implementing a small-animal MRgHIFU system on a small-animal MRI scanner
Created by ME Poorman and WA Grissom at the Vanderbilt University Institue for Imaging Science Fall 2014

MRgFUS_software: 
Contains matlab code for GUI interface and real-time temperature reconstruction and control software

To run the program, open the "runMRHIFU.m" file and use this function call.
-The GUI interface can be bit touchy but fixes and usability updates are in progress.
-On the Varian systems, the current acquisition file can be found in '~/vnmrsys/exp2/acqfil/fid'
-Previously stored runs and data are found in'~/vnmrsys/data/studies/s_YYYYMMDD_##'

The file "sloppyRunMRHIFU.m" is a non-modular version of the code that does not have a GUI.  This file is intended to help with debugging of the GUI and parameters must be manually changed within the code.


MRgHIFU_hardware_pt#: 
contains solidworks files for HIFU bed
