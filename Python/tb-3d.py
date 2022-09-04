for sendNum in range(512):
    testNum = '{0:09b}'.format(sendNum)
    a0 = int(testNum[0])
    a1 = int(testNum[1])
    a2 = int(testNum[2])
    b0 = int(testNum[3])
    b1 = int(testNum[4])
    b2 = int(testNum[5])
    r0 = int(testNum[6])
    r1 = int(testNum[7])
    r2 = int(testNum[8])


    first = (a0&b0)^(r0^(a0&b1)^(a1&b0))^((r1^(a0&b2))^(a2&b0))
    second = r1^(a1&b1)^((r2^(a1&b2))^(a2&b1))
    third = r1^r2^(a2&b2)
    print(str(first) + str(second) + str(third) + ' ', sep=' ', end='', flush=True)