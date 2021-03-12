import logging
import interpolation
import sys
import prettytable
import math as m


GREEN = '\u001b[32m'
RESET = '\u001b[0m'

def main():
    logging.basicConfig(level=logging.INFO)

    if len(sys.argv) < 2:
        print("Few arguments.\nUse main.py filename")
        logging.error("Few arguments")
        sys.exit(1)

    nx = int(input("Input x polynom grade: "))
    ny = int(input("Input y polynom grade: "))
    x = float(input("Input x: "))
    y = float(input("Input y: "))
    
    interp = interpolation.interFunc(nx, ny)

    table = interp.get_table_from_file(sys.argv[1])
    interp.set_table(table)

    x_y_z_table = prettytable.PrettyTable()

    x_y_z_table.field_names = ["x", 'y', 'z']
    for i in table:
        x_y_z_table.add_row([i.x, i.y, i.z])
    
    # print(x_y_z_table)
    
    z = interp.newton3d(x, y)

    print("\n" + GREEN + "Result is:" + RESET, z)
    print(f"Real is: {x**2 + y**2}")
    

if __name__ == '__main__':
    main()
