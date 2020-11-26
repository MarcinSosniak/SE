import threading
import time
import sys

class ShareableCharacterStorage:
    #this class gathers data character by character and uses time data to segregate them into full messages
    def __init__(self,single_message_time_window = 1,min_time_since_last_message = 0.1, byte_in = False):
        self._lock = threading.Lock()
        self._data = []
        self._retrieved_combined_data = []
        self._single_message_time_window = single_message_time_window
        self._min_time_since_last_message = min_time_since_last_message
        self._byte_in = byte_in

    def add_data(self,data):
        if  not self._lock.acquire(blocking =True,timeout = 1):
            raise Exception('Failed to aquire lock for longer than 1 seconds')
        self._data.append((time.time(),data))
        self._lock.release()


    def f_new_data(self):
        if  not self._lock.acquire(blocking =True,timeout = 1):
            raise Exception('Failed to aquire lock for longer than 1 seconds')
        out = False
        if len(self._data)==0:
            out= False

        # are we sure last message isn't still being gathered ?
        if len(self._data)>0 and time.time() - self._data[-1][0] > self._min_time_since_last_message:
            out = True
        self._lock.release()
        return out


    def read_data(self):
        if  not self._lock.acquire(blocking =True,timeout = 1):
            raise Exception('Failed to aquire lock for longer than 1 seconds')

        if len(self._data) == 0:
            self._lock.release()
            return ''

        maximum_timestamp =  self._data[0][0] + self._single_message_time_window
        over_last_data_index = len(self._data)
        for k,elem in enumerate(self._data):
            if elem[0]>maximum_timestamp:
                over_last_data_index=k
                break

        out = ''.join(list(map(lambda x: x[1].decode(sys.stdout.encoding) if self._byte_in else x[1], self._data[:over_last_data_index])))
        self._data = self._data[over_last_data_index:]
        self._retrieved_combined_data.append(out)

        self._lock.release()
        return out
