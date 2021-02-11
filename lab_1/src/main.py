import logging
import interpolation
import sys
import prettytable
import math as m

def main():
    logging.basicConfig(level=logging.INFO)

    if len(sys.argv) < 2:
        print("Few arguments.\nUse main.py filename")
        logging.error("Few arguments")
        sys.exit(1)

    n = int(input("Input polynom grade: "))
    x = float(input("Input x: "))
    
    interp = interpolation.interFunc(n)

    table = interp.get_table_from_file(sys.argv[1])
    table = interp.set_table_slice(x)

    x_y_dy_table = prettytable.PrettyTable()

    x_y_dy_table.field_names = ["x", 'y', 'dy/dx']
    for i in table:
        x_y_dy_table.add_row([i.x, i.y, i.dy])

    print(x_y_dy_table)

    ptable = prettytable.PrettyTable()
    ptable.field_names = ["x", "Newton", "Ermit"]
    
    ptable.add_row([x, interp.newton_polynom(x), interp.ermit_polynom(x)])
    print(ptable)

    interp.invert()
    print("Root: ", interp.newton_polynom(0))
    

if __name__ == '__main__':
    main()
