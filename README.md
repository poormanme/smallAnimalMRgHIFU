smallAnimalMRgHIFU
==================
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

Usage notes:

--On the Varian systems, the current acquisition file can be found in '~/vnmrsys/exp2/acqfil/fid'

--Previously stored runs and data are found in'~/vnmrsys/data/studies/s_YYYYMMDD_##'

--The file "sloppyRunMRHIFU.m" is a non-modular version of the V1 code that does not have a GUI.  This file is intended to help with debugging of the GUI and parameters must be manually changed within the code.

MRgHIFU_hardware_pt#: 

--contains solidworks files for HIFU bed

--FIXED known issue: paths are absolute not relative and missing magnet parts
