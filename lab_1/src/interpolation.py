import logging
import math

class funcTable:
    def __init__(self, x:float, y:float, dy:float) -> None:
        self.x = x
        self.y = y
        self.dy = dy
    

class interFunc:
    table = []
    diffs = []

    ermit_table = []
    ermit_diffs = []

    def __init__(self, polynom_size:int):
        self.polynom_size = polynom_size

    def get_table_from_file(self, filename:str, ) -> list:
        try:
            with open(filename, "r") as f:
                for line in f:
                    x, y, dy = map(float, line.split())
                    record = funcTable(x, y, dy)
                    self.table.append(record)
            self.table.sort(key=lambda x: x.x)
        except OSError:
            logging.error("Unexisting file")
            print("That file doesn't exists. Try again.")
            return None   

        return self.table

    def set_table_slice(self, x:float) -> list:
        num_of_records = self.polynom_size + 1

        for ind, rec in enumerate(self.table):
            if rec.x >= x:
                logging.debug(f"Index of {ind}\tnum of records {num_of_records}")
                half = num_of_records / 2
                half = math.ceil(half)

                indent = num_of_records

                while ind < len(self.table) and half > 0:
                    half -= 1
                    ind += 1

                ind -= indent

                if (ind < 0):
                    ind = 0

                
                logging.debug(f"Index of {ind}\tnum of records {num_of_records}")
                self.table = self.table[ind:ind + self.polynom_size + 1]


                self.__set_diffs()
                self.__double_table()
                self.__set_ermit_diffs()      
                return self.table
        
        self.table = self.table[len(self.table) - 1 - self.polynom_size:len(self.table)]

        self.__set_diffs()
        self.__double_table()
        self.__set_ermit_diffs()

        return self.table

    def get_sep_diff(self, vals:tuple) -> float:
        if len(vals) == 2:
            return (self.table[vals[0]].y - self.table[vals[1]].y) / (self.table[vals[0]].x - self.table[vals[1]].x)

        return (self.get_sep_diff(vals[0:len(vals) - 1]) - self.get_sep_diff(vals[1:len(vals)])) / (self.table[vals[0]].x - self.table[vals[-1]].x)
        

    def newton_polynom(self, x:float) -> float:
        y_z = self.table[0].y

        for i in range(self.polynom_size):
            val = self.diffs[i]

            for j in range(i + 1):
                val *= (x - self.table[j].x)
            y_z += val

        return y_z
    

    def invert(self):
        for i in range(len(self.table)):
            self.table[i].x, self.table[i].y = self.table[i].y, self.table[i].x
        self.__set_diffs()
    
    def __set_diffs(self):
        ind = [0, 1]
        self.diffs = []

        for i in range(self.polynom_size):
            self.diffs.append(self.get_sep_diff(tuple(ind)))
            ind.append(i + 2)
    

    # ------------ ERMIT ------------

    def get_ermit_sep_diff(self, vals:tuple) -> float:
        if len(vals) == 2:
            if (self.ermit_table[vals[0]].x == self.ermit_table[vals[1]].x): # (x_0, x_0)
                return self.ermit_table[vals[0]].dy 
            return (self.ermit_table[vals[0]].y - self.ermit_table[vals[1]].y) / (self.ermit_table[vals[0]].x - self.ermit_table[vals[1]].x)

        return (self.get_ermit_sep_diff(vals[0:len(vals) - 1]) - self.get_ermit_sep_diff(vals[1:len(vals)])) / (self.ermit_table[vals[0]].x - self.ermit_table[vals[-1]].x)

    def __double_table(self):
        for record in self.table:
            self.ermit_table.append(record)
            self.ermit_table.append(record)
    
    def __set_ermit_diffs(self):
        ind = [0, 1]
        self.ermit_diffs = []

        for i in range(self.polynom_size):
            self.ermit_diffs.append(self.get_ermit_sep_diff(tuple(ind)))
            ind.append(i + 2)
    
    
    def ermit_polynom(self, x:float):
        y_z = self.ermit_table[0].y

        for i in range(self.polynom_size):
            val = self.ermit_diffs[i]

            for j in range(i + 1):
                val *= (x - self.ermit_table[j].x)
            y_z += val

        return y_z

    
