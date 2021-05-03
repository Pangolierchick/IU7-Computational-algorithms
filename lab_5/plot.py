import matplotlib.pyplot as plt
import sys

def read_from_file(filename):
    x_list = []
    y_list = []
    with open(filename, 'r') as f:
        for i in f:
            x, y = i.split(',')
            x_list.append(float(x))
            y_list.append(float(y))
    
    return x_list, y_list


def main():
    g5g5  = read_from_file('./data/gauss5_gauss5.csv')
    g5s5  = read_from_file('./data/gauss5_simp5.csv')
    g5s17 = read_from_file('./data/gauss5_simp7.csv')
    s5g5  = read_from_file('./data/simp5_gauss5.csv')
    s17g5 = read_from_file('./data/simp17_gauss5.csv')

    plt.plot(g5g5[0], g5g5[1], label = 'gauss 5 - gauss 5')
    plt.plot(g5s5[0], g5s5[1], label='gauss 5 - simpson 5')
    plt.plot(g5s17[0], g5s17[1], label='gauss 5 - simpson 17')
    plt.plot(s5g5[0], s5g5[1], label='simpson 5 - gauss 5')
    # plt.plot(s17g5[0], s17g5[1], label='simpson 17 - gauss 5')

    plt.legend()
    plt.grid()

    plt.show()

if __name__ == '__main__':
    main()
