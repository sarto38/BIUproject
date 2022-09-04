for sendNum in range(32):
    testNum = '{0:05b}'.format(sendNum)
    a0 = int(testNum[0])
    a1 = int(testNum[1])
    b0 = int(testNum[2])
    b1 = int(testNum[3])
    r = int(testNum[4])

    first = (a0&b0)^((a0&b1)^r^(a1&b0))
    second = (a1&b1)^r
    print(str(first) + str(second) + ' ', sep=' ', end='', flush=True)