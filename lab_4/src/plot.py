import matplotlib.pyplot as plt

def read_vector_from_file(filename):
    vec = []
    with open(filename, 'r') as f:
        line = f.readline().split(",")
        vec.extend(list(map(float, line)))
    
    return vec

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
    coeffs = read_vector_from_file("../data/output.csv")

    left = table[0][0]
    right = table[0][0]

    for i in table:
        left = min(left, i[0])
        right = max(right, i[0])

        plt.scatter(i[0], i[1])
        plt.text(i[0], i[1], f'{i[2]}')
    

    x, y = interval(left - 1, right + 2, coeffs)

    plt.plot(x, y)
    

    plt.show()


if __name__ == '__main__':
    main()
