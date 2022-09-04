for sendNum in range(512):
    testNum = '{0:09b}'.format(sendNum)
    print ("""
AndEnable= 1'b0;
#1

ina = 3'b"""+ testNum[0:3] +""";
inb = 3'b"""+ testNum[3:6] +""";
rin = 3'b"""+ testNum[6:9] +""";

#1
AndEnable= 1'b1;
#6
//////////////////////////////////////////////////////////////////////////////////
    """)

