import matplotlib.pyplot as plt

def read_poly_from_file(filename):
    poly_coeffs = []
    with open(filename, 'r') as f:
        for i in f:
            line = i.split(",")
            
            poly = list(map(float, line))

            poly_coeffs.append(poly)
    
    return poly_coeffs

def read_table_from_file(filename):
    table = []

    with open(filename, "r") as f:
        for i in f:
            line = list(map(float, i.split()))

            table.append(line)
    
    return table

def polynomial(x, coeffs):
    y = 0
    for i, v in enumerate(coeffs):
        y += v * (x ** i)
    
    return y

def interval(x1, x2, coeffs, step=0.1):
    x = []
    y = []
    while x1 < x2:
        x.append(x1)
        y.append(polynomial(x1, coeffs))
        x1 += step
    
    return x, y

def main():
    fig = plt.figure()
    
    table = read_table_from_file('../data/test.csv')
    coeffs = read_poly_from_file("../data/output.csv")

    left = table[0][0]
    right = table[0][0]

    for i in table:
        left = min(left, i[0])
        right = max(right, i[0])

        plt.scatter(i[0], i[1])
        plt.text(i[0], i[1], f'{i[2]}')
    


    x_1, y_1 = interval(left - 1, right + 2, coeffs[0])
    x_2, y_2 = interval(left - 1, right + 2, coeffs[1])
    x_3, y_3 = interval(left - 1, right + 2, coeffs[2])
    x_4, y_4 = interval(left - 1, right + 2, coeffs[3])

    plt.plot(x_1, y_1, label='1 степень (вес одинаковый)')
    plt.plot(x_2, y_2, label='2 степень (вес одинаковый)')
    plt.plot(x_3, y_3, label='1 степень (вес разный)', linestyle='dashed')
    plt.plot(x_4, y_4, label='2 степень (вес разный)', linestyle='dashed')

    plt.legend()
    plt.grid()

    plt.show()


if __name__ == '__main__':
    main()
