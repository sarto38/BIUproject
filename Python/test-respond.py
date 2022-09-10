"""
Python PicoScope Acquisition Script
Edited by
Itamr Levi
PicoScope Model 5244A
"""
import picoscope
import time
import serial
import numpy as np
from scipy.io import savemat
from picoscope import ps5000a
import os
import binascii as ba
import datetime

# picoscope = reload(picoscope)
# ps5000a = reload(ps5000a)

# clear the screen
print("\n" * 100)

# number of traces per file
Queries = 20 # 20000

# number of average per trace
Naverage = 1

# number of files
NoFiles = 1

# saving method 1 for NPY (Python compatible), 2 for MAT (Matlab compatible),
# 0 for not saving the workspace
saving_met = 2

# Serial Port Configuration
BaudRate = 9600  # 57600    # baud/s
COM_aux = 'COM8'  # 'COM4'

# Oscilloscope configuration
"""
% BitsResolution -> {
                        0 = 8bit  ;
                        1 = 12bit ;
                        2 = 14bit ;
                        3 = 15bit ;
                        4 = 16bit ;  }
"""
# (it depends on the device and on the configuration.
# Please, read the user manual.)
BitsResolution = 1

# Sample Frequency (in Hz)
SamplingFrequency = 200E6  # clock is 4MHz in the FPGA==>50 samples per clock
"""--------------------------------------------------------------------------------
random numbers
-----------------------------------------------------------------------------------"""

grop03 = [0,1,2,3,4,7,8,11]
grop01 = [12,13,14,15,16,17,18,19]
grop02 = [20,23,24,27,28,29,30,31]
grop1 = [9,25,5,21,10,26,6,22]


"""--------------------------------------------------------------------------------
End random numbers
-----------------------------------------------------------------------------------"""

print('--------------------------------------------------------------')
print('--------------------------------------------------------------')
print('     PICOSCOPE 5244b UTILITY FOR SIDE-CHANNEL EVALUATION      ')
print('--------------------------------------------------------------')
print('--------------------------------------------------------------')

# Channels Configurations
"""
% ChXEnabled -> True - OFF ; False - ON
% ChXCoupling -> 0 - AC ; 1 - DC
% ChXRange -> {
%                0.01 = +/-10mV ;
%                0.02 = +/-20mV ;
%                0.05 = +/-50mV ;
%                0.1  = +/-100mV ;
%                0.2  = +/-200mV ;
%                0.5  = +/-500mV ;
%                1.0  = +/-1V ;
%                2.0  = +/-2V ;
%                5.0  = +/-5V ;
%                10.0 = +/-10V ;
%                20.0 = +/-20V ;  }
% ChXOffset -> [V]
"""

# Channel A configuration
ChAEnabled = True
ChACoupling = 1  # 0 - AC ; 1 - DC
ChARange = 0.02  # 20mV
ChAOffset = 0

# Channel B configuration
ChBEnabled = True
ChBCoupling = 1  # 0 - AC ; 1 - DC
ChBRange = 5.0
ChBOffset = 0

# Trigger configuration
"""
% Channel list -> {
%                 0 -> CHANNEL A ;
%                 1 -> CHANNEL B ;
%                 2 -> CHANNEL C ;
%                 3 -> CHANNEL D ;
%                 4 -> EXTERNAL ;   }
% Trigger Level -> V
% Trigger Delay -> s
% TriggerDirection -> {
%                 0 -> ABOVE THRESHOLD ;
%                 1 -> BELOW THRESHOLD ;
%                 2 -> RISING EDGE ;
%                 3 -> FALLING EDGE ;
%                 4 -> RISING OR FALLING EDGE ;
%                 5 -> INSIDE WINDOW ;
%                 6 -> OUTSIDE WINDOW ;
%                 7 -> ENTER WINDOW ;
%                 8 -> EXIT WINDOW ;
%                 9 -> NONE ;   }
% TriggerAutosetms -> ms (0 if REPEAT/SINGLE MODE TRIGGERING - CLASSIC)
"""

TriggerChannel = 1
TriggerLevel = 1
TriggerDelay = 0
TriggerDirection = 2
TriggerAutosetms = 0

# Acquisition configuration
NumPreTriggerSamples = 0
NumPostTriggerSamples = 600
DownSampling = 1

# Serial communication UART (TEST)
p_ser = serial.Serial(port=COM_aux, baudrate=BaudRate,
                      bytesize=serial.EIGHTBITS, parity=serial.PARITY_NONE,
                      stopbits=serial.STOPBITS_ONE, timeout=30, xonxoff=0,
                      rtscts=0, dsrdtr=0)






try:
    sendx = np.array([grop1[0]], dtype=np.uint8)

    #while(!ps.waitReady())
    p_ser.write(np.hstack(sendx).astype(np.uint8))
except Exception as ex:
    print(ex)
