import logging
import math
from copy import deepcopy

class funcTable:
    def __init__(self, x:float, y:float, z:float=0) -> None:
        self.x = x
        self.y = y
        self.z = z
    
    def __str__(self):
        return f"{self.x} {self.y} {self.z}"
    

class interFunc:
    table = []
    diffs = []

    def __init__(self, nx:int, ny:int):
        self.polynom_size = min(nx, ny)

    def get_table_from_file(self, filename:str) -> list:
        try:
            with open(filename, "r") as f:
                for line in f:
                    x, y, z = map(float, line.split())
                    record = funcTable(x, y, z)
                    self.table.append(record)
        except OSError:
            logging.error("Unexisting file")
            print("That file doesn't exists. Try again.")
            return None   

        return self.table

    def set_table_slice(self, table:list, x:float) -> list:
        num_of_records = self.polynom_size + 1

        for ind, rec in enumerate(table):
            if rec.x >= x:
                half = num_of_records / 2
                half = math.ceil(half)

                indent = num_of_records

                while ind < len(table) and half > 0:
                    half -= 1
                    ind += 1

                ind -= indent

                if (ind < 0):
                    ind = 0

                
                logging.debug(f"Index of {ind}\tnum of records {num_of_records}")
                table = table[ind:ind + self.polynom_size + 1]

                # self.__print_table(table)

                return table
        
        table = table[len(table) - 1 - self.polynom_size:len(table)]


        return table

    def get_sep_diff(self, vals:tuple) -> float:
        if len(vals) == 2:
            # logging.debug(f"x[0] = {self.table[vals[0]].x}\tx[1] = {self.table[vals[1]].x}")
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
    

    def newton3d(self, x, y):
        self.x = self.__set_arg_slice(self.x, x)
        self.y = self.__set_arg_slice(self.y, y)
        self.__set_z_matrix()

        self.prep_newton3d(x)
        table_copy = deepcopy(self.table)

        self.table = []
        for i, v in enumerate(table_copy):
            self.table.append(funcTable(self.y[i], self.interp_vals[i]))
        
        self.__set_diffs()

        z = self.newton_polynom(y)

        self.table = deepcopy(table_copy)

        return z
    
    def prep_newton3d(self, x):
        table_copy = deepcopy(self.table)

        table_copy = self.set_table_slice(table_copy, x)

        self.interp_vals = []


        for j in range(self.polynom_size + 1):
            self.table = []

            for i in range(self.polynom_size + 1):
                self.table.append(funcTable(self.x[i], self.z[j][i]))
            
            self.__set_diffs()

            self.interp_vals.append(self.newton_polynom(x))

        self.table = deepcopy(table_copy)

    def __print_table(self, table):
        for i in table:
            print(str(i))
    
    def __set_args(self, table):
        self.x = []
        self.y = []

        for i in table:
            if i.x not in self.x:
                self.x.append(i.x)

            if i.y not in self.y:
                self.y.append(i.y)
        
        self.x.sort()
        self.y.sort()
        self.width  = len(self.x)
        self.height = len(self.y)
    
    def set_table(self, table):
        self.table = table
        self.__set_args(table)
    
    def __set_arg_slice(self, args_list, x) -> list:
        num_of_records = self.polynom_size + 1

        for ind, rec in enumerate(args_list):
            if rec >= x:
                half = num_of_records / 2
                half = math.ceil(half)

                indent = num_of_records

                while ind < len(args_list) and half > 0:
                    half -= 1
                    ind += 1

                ind -= indent

                if (ind < 0):
                    ind = 0

                args_list = args_list[ind:ind + self.polynom_size + 1]

                self.l = ind
                self.r = ind + self.polynom_size + 1
                return args_list
        
        args_list = args_list[len(args_list) - 1 - self.polynom_size:len(args_list)]

        self.l = len(args_list) - 1 - self.polynom_size
        self.r = len(args_list)

        return args_list
    
    def __set_z_matrix(self):
        z = []
        for i in range(self.width):
            record = []
            for j in range(self.height):
                record.append(self.table[i * self.width + j].z)
            
            z.append(record)
        
        for i, v in enumerate(z):
            z[i] = v[self.l:self.r]
        
        self.z = z[self.l:self.r]
        
        return z
