# Instructions for use

## Hardware Setup
####Materials needed:
* HIFU delivery table (constructed from solidworks files)
* Waveform generator
* Amplifier
* FUS transducer+matching network
* Ethernet cable
* BNC cables (MR safe)
* Coil
* Note: see partsList.txt for exact equipment used in our setup
* Note2: Equipment that you already have (such as amps and generators) can be used provided the specs are compatible with your transducer

#### Setup Process
1. Ensure gradient of proper size is in magnet
2. Fill transducer cone with degassed water and seal with rubber membrane
3. Place transducer and cone in slot within head of delivery table
4. Secure delivery table platform and window in place.
5. Connect MR computer to waveform generator with ethernet cable.
6. If doing ARFI connect BNC from trigger on gradient amplifer to input on waveform generator
7. Connect waveform generator output to amplifer input.
8. Connect amplifer output to transducer's matching network and string matching network through wall into MR room
10. Place sample (phantom or small animal) on delivery table with coil and couple to cone with ultrasond gel.
11. If using a small animal secure monitoring equipment and heating pad to platform
12. Insert delivery table into magnet.
13. Connect transducer to matching network (in magnet room)
14. Close magnet room door and start MR software on host PC
15. Shim and calibrate magnet as usual (monitor small animal according to institutional protocols)
16. You're ready to begin pre-treatment imaging (including ARFI)!

## Software execution
The software comes pre-loaded with default values for each parameter. 
In the GUI, if no modification is made, the software will execute with default values.
__You will need the Matlab Instrument Control Toolbox to control the waveform generator.__

1. open "smallAnimalMRgHIFU/MRgFUS_software/V2/runControlSoftware.m" in Matlab on the MR host PC
2. Select execution options (a save location, if you'd like to use the GUI, or if you'd like to use reconmode)
3. Define all sonication parameters using GUI or direclty in script (desired dose cutoff, focus/drift ROI location, file location, etc.)
4. Run "runControlSoftware.m" to initialize parameters and function generator. 
5. A button should pop up asking if yo're ready to sonication
6. Setup dynamic scans on the MR software(we used spoiled gradient echo, single slice)
7. Decide on sonication length and array your MR images to fill that time
8. Click start on the MR scan and immediately click go on the matlab button to start sonication
9. Watch the sonication in the matlab software display 

## PID Controller Tuning
* The PID controller gains will likely have to be tuned for your specific target.
* Tuning is an active area of research and you are encouraged to choose the approach that is best for you.
* Our system was tuned empirically using test sonications in a tissue-mimicking phantom to achieve the desired characteristics
