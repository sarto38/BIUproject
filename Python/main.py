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
Queries = 20000 # 20000

# number of average per trace
Naverage = 1

# number of files
NoFiles = 10

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
ChACoupling = 0  # 0 - AC ; 1 - DC
ChARange = 0.2  # 200mV
ChAOffset = 0

# Channel B configuration
ChBEnabled = True
ChBCoupling = 0  # 0 - AC ; 1 - DC
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
time.sleep(1)

# Connecting the PicoScope unit
ps = ps5000a.PS5000a()

# Setting the resolution
ps.resolution = BitsResolution

# Setting channels A and B
ps.setChannel('A', ChACoupling, ChARange, ChAOffset, ChAEnabled, probeAttenuation=1, BWLimited=0)
ps.setChannel('B', ChBCoupling, ChBRange, ChBOffset, ChBEnabled, probeAttenuation=1, BWLimited=0)

# Setting trigger
ps.setSimpleTrigger(TriggerChannel, TriggerLevel, TriggerDirection,
                    TriggerDelay, TriggerAutosetms, True)

# Setting the sampling frequency
(SamplingFrequency,
 maxSamples) = ps.setSamplingFrequency(SamplingFrequency,
                                       NumPreTriggerSamples+NumPostTriggerSamples, 1, 0)

SamplingTime = 1 / SamplingFrequency

Timebase = ps.getTimeBaseNum(SamplingTime)
ps.timebase = Timebase

ps.noSamples = NumPostTriggerSamples


def assure_path_exists(path):
    dir = os.path.dirname(path)
    if not os.path.exists(dir):
        os.makedirs(dir)


"""
CUSTOM SECTION
"""
t = time.time()

for j in range(0, NoFiles, 1):

    # array of 20000x1 zeros
    sendxs = np.zeros((Queries, 1), dtype=np.uint8)

    # mat of 20000x600 zeros
    traces = np.zeros((Queries, NumPostTriggerSamples), dtype=np.int16)

    path = '../Data/New/File' + repr(j) + '.mat'
    path_timeNs = '../Traces/timeNs.mat'
    assure_path_exists(path)

    assure_path_exists(path_timeNs)

    str_save_traces_npy = path
    str_save_traces_mat = path

    str_save_conf_npy = path_timeNs
    str_save_conf_mat = path_timeNs


    # LOOP
    for i in range(0, Queries, 1):
        try:
            resultBit = np.random.randint(0, 2)
            sendResultBit = np.random.randint(0, 8)
            if resultBit == 0:
                randgrup = np.random.randint(0, 3)
                if randgrup == 0:
                    sendx= np.array([grop01[sendResultBit]], dtype=np.uint8)
                elif randgrup == 1:
                    sendx = np.array([grop02[sendResultBit]], dtype=np.uint8)
                else:
                    sendx = np.array([grop03[sendResultBit]], dtype=np.uint8)
            else:
                sendx = np.array([grop1[sendResultBit]], dtype=np.uint8)




            sendxs[i, :] = sendx
            ps.runBlock(0, 0)


            #while(!ps.waitReady())
            p_ser.write(np.hstack(sendx).astype(np.uint8))


            # wait for the trigger
            # stime = datetime.datetime.now()
            ps.waitReady()
            # ftime = datetime.datetime.now()
            #print(stime, ftime)
            # collect data from the oscilloscope
            (traces[i, :],
             numSamplesReturned,
             overflow) = ps.getDataRaw('A', NumPostTriggerSamples, 0, 1, 0, 0)
            str_tr = 'Run ' + repr(j) + '. Traces ' + repr(i) + ' of ' + repr(Queries) + '.'
            print(str_tr)
        except Exception as ex:
            print(ex)

    elapsed = time.time() - t

    str_1 = 'Elapsed time ' + repr(elapsed)
    print(str_1)

    print('----------------------------------')
    print('Acquisition completed.')

    timeNs = np.linspace(0, NumPostTriggerSamples * SamplingTime, NumPostTriggerSamples,
                         endpoint=False, retstep=False, dtype=float)

    if saving_met == 1:
        """
        data_1 = {'traces': np.int16(traces.tolist()),
                  'plaintexts': np.uint8(plaintexts.tolist()),
                  'key': np.uint8(key.tolist()), 'ciphertexts': np.uint8(ciphertexts.tolist()),
                  'sendxs': np.uint8(sendxs.tolist()), 'Naverage': Naverage,
                  'Queries': Queries}
        data_2 = {'ChACoupling': ChACoupling, 'ChARange': ChARange,
                  'ChAOffset': ChAOffset, 'TriggerDirection': TriggerDirection,
                  'TriggerLevel': TriggerLevel, 'Timebase': Timebase,
                  'timeNs': np.float(timeNs.tolist()),
                  'SamplingFrequency': SamplingFrequency,
                  'NumPostTriggerSamples': NumPostTriggerSamples,
                  'BitsResolution': BitsResolution,
                  'Queries': Queries}
        np.save(str_save_traces_npy, data_1)
        np.save(str_save_conf_npy, data_2)
        """
    elif saving_met == 2:
        data_1 = {'traces': np.int16(traces.tolist()),
                  'sendxs': np.uint8(sendxs.tolist()), 'Naverage': Naverage,
                  'Queries': Queries}
        data_2 = {'ChACoupling': ChACoupling, 'ChARange': ChARange,
                  'ChAOffset': ChAOffset, 'TriggerDirection': TriggerDirection,
                  'TriggerLevel': TriggerLevel, 'Timebase': Timebase,
                  'timeNs': timeNs,
                  'SamplingFrequency': SamplingFrequency,
                  'NumPostTriggerSamples': NumPostTriggerSamples,
                  'BitsResolution': BitsResolution,
                  'Queries': Queries}
        savemat(str_save_traces_mat, data_1, format='5',
                         do_compression=True, oned_as='row')
        savemat(str_save_conf_mat, data_2, format='5',
                         do_compression=True, oned_as='row')
    else:
        print('WARNING: workspace and dataset are not saved yet...')

# closing the Picoscope (IT IS MANDATORY!)
ps.stop()
ps.close()

# closing the serial port
p_ser.close()

# plt.plot(traces.T)