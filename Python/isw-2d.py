for sendNum in range(32):
    testNum = '{0:05b}'.format(sendNum)
    print ("""
AndEnable= 1'b0;
#1

ina = 2'b"""+ testNum[0:2] +""";
inb = 2'b"""+ testNum[2:4] +""";
rin = 1'b"""+ testNum[4] +""";

#1
AndEnable= 1'b1;
#4
//////////////////////////////////////////////////////////////////////////////////
    """)

