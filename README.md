smallAnimalMRgHIFU
==================
DOI: 10.5281/zenodo.51633

Set of MATLAB and Solidworks files for implementing a small-animal MRgHIFU system on a small-animal MRI scanner

    --Created by ME Poorman, VL Chaplin, K Wilkens, MD Dockery, T Giorgio, WA Grissom, and CF Caskey at the Vanderbilt University Institue for Imaging Science
    --Open for use according to the license file with citation

MRgFUS_software:

    --Contains matlab code for GUI interface and real-time temperature reconstruction and control software
    --V1: Older version of code
    --V2: Jan 2016 updates: include drift correction, streamlined ROI, quit with CEM threshold

To run the program:

    --V1: open the "runMRHIFU.m" file and use this function call.
    --V2: run the "runControlSoftware.m" directly. Be sure to specify GUI usage, recon options, and data saving
    --GUI: The gui automatically loads with "default" suggested values for thermal targets and PID gain parameters. These can be freely modified by the user.

Usage notes:

    --On the Varian systems, the current acquisition file can be found in '~/vnmrsys/exp2/acqfil/fid'
    --Previously stored runs and data are found in'~/vnmrsys/data/studies/s_YYYYMMDD_##'
    --The file "sloppyRunMRHIFU.m" is a non-modular version of the V1 code that does not have a GUI.  This file is intended to help with debugging of the GUI and parameters must be manually changed within the code.

Modules:

    --initFGEN: initialize function generator and connect via ethernet for remote control
    --offFGEN: turn off function generator output and return control to local
    --runTempRecon: run temperature reconstruction routine, continuously poll MR file for updates and process data into temperature evolution
    --pidUpdate: compute the next voltage step via PID feedback control
    --calcCEM_vect: compute the current thermal dose in CEM43
ARFI:

    --V2/ARFI/gems_meg.c is the pulse sequence written for varian and modified to include a motion encoding gradient for ARFI
    --The c code will need to be compiled on the scanner prior to execution
    --V2/ARFI/visualizeARFI takes all of the files for ARFI images and computes the eddy-current corrected displacements   
    
MRgHIFU_hardware_pt#: 

    --contains solidworks files for HIFU bed
    --FIXED known issue: paths are absolute not relative and missing magnet parts
