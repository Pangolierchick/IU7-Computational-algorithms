import logging
import interpolation
import sys
import prettytable
import math as m

def main():
    logging.basicConfig(level=logging.ERROR)

    if len(sys.argv) < 2:
        print("Few arguments.\nUse main.py filename")
        logging.error("Few arguments")
        sys.exit(1)

    
    interp = interpolation.interFunc(4)

    x = 0.6
    table = interp.get_table_from_file(sys.argv[1])
    table = interp.set_table_slice(0.7)

    for i in table:
        print(f"{i.x} {i.y} {i.dy}")

    x = 0.1
    max_diff = -0xfffffffff

    ptable = prettytable.PrettyTable()
    ptable.field_names = ["x", "mine", "true", "diff"]

    while x <= 1: 
        mine = interp.newton_polynom(x)
        true = 1 / m.tan(x)
        max_diff = max(max_diff, abs(mine - true))
        ptable.add_row([round(x, 4), round(mine, 4), round(true, 4), round(abs(mine - true), 4)])
        x += 0.2
    ptable.align = "r"
    print(ptable)
    
    print(f"Biggest diff is {max_diff}")
    
    

if __name__ == '__main__':
    main()
