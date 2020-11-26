import sys
import time
print('FORVER ECHO UP')
while True:
    echo = input()
    for c in echo:
        time.sleep(0.01)
        print(c,end='')
        # sys.stdout.write(c)
        sys.stdout.flush()

