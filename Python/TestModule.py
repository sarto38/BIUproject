"""
Python PicoScope Acquisition Script
Edited by
Itamr Levi
PicoScope Model 5244A
"""

import time
import serial
import numpy as np
import os
import sys

# clear the screen
print("\n" * 100)

# number of traces per file
Queries = 20000 # 20000

# number of average per trace
Naverage = 1

# number of files
NoFiles = 400

# saving method 1 for NPY (Python compatible), 2 for MAT (Matlab compatible),
# 0 for not saving the workspace
saving_met = 2

# Serial Port Configuration
BaudRate = 9600  # 57600    # baud/s
COM_aux = 'COM4'  # 'COM4'

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


# Serial communication UART (TEST)
p_ser = serial.Serial(port=COM_aux, baudrate=BaudRate,
                      bytesize=serial.EIGHTBITS, parity=serial.PARITY_NONE,
                      stopbits=serial.STOPBITS_ONE, timeout=30, xonxoff=0,
                      rtscts=0, dsrdtr=0)
time.sleep(1)



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



    # LOOP
    for i in range(0, Queries, 1):
        resultBit = np.random.randint(0, 2)
        sendResultBit = np.random.randint(0, 8)
        if resultBit == 0:
            randgrup = np.random.randint(0, 3)
            if randgrup == 0:
                sendNum = grop01[sendResultBit]
                sendx= np.array([sendNum], dtype=np.uint8)
            elif randgrup == 1:
                 sendNum = grop02[sendResultBit]
                 sendx = np.array([sendNum], dtype=np.uint8)
            else:
                sendNum = grop03[sendResultBit]
                sendx = np.array([sendNum], dtype=np.uint8)
        else:
            sendNum = grop1[sendResultBit]
            sendx = np.array([sendNum], dtype=np.uint8)

        sendxs[i, :] = sendx

        p_ser.write(np.hstack(sendx).astype(np.uint8))
        time.sleep(0.01)
        resultFromUART = p_ser.read(1)
        decoded_bytes = np.frombuffer(resultFromUART, np.uint8)
        print(np.hstack(sendx).astype(np.uint8), decoded_bytes)

        testNum = '{0:08b}'.format(sendNum)
        testAnd = (int(testNum[0]) ^ int(testNum[1])) & (int(testNum[2]) ^ int(testNum[3]))
        resultAndUART = '{0:08b}'.format(int(decoded_bytes))

        resultAnd = int(resultAndUART[0]) & int(resultAndUART[1])
        if testAnd == resultAnd:
            print('yes')
        else:
            print(testNum, resultAndUART)
            sys.exit()


p_ser.close()

# plt.plot(traces.T)
