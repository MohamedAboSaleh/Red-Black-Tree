from RedBlackTreeSet import *
from time import time

if __name__ == "__main__":

    sets = []
    file = open("data_struct(1000x1000).txt", "r")
    key = file.read()
    lines = key.split("\n")
    i = 0
    for line in lines:
        sets.append(RedBlackTreeSet())
        lst = line.split(",  ")
        lst = list(map(float, lst))
        sets[i].insert_list(lst)
        i += 1

    start = time()
    final = sets[0]
    for i in range(1, len(sets)):
        final = final.set_union(sets[i])
        if i % 10 == 0:
            print("%.2lf%%" % (i / len(sets) * 100))
    size = final.size()
    final.delete_set()
    print("size of the merged tree = %d" % size)
    end = time()
    print("executed in %.2lf sec" % (end - start))
    print("<<======================================================================>>")
    start = time()
    lst = []
    for line in lines:
        temp_lst = line.split(",  ")
        temp_lst = list(map(float, temp_lst))
        lst.append(temp_lst)

    python_set = set(lst[0])
    for i in range(1, len(lst)):
        python_set = python_set.union(set(lst[i]))
    print("size of the set (built in) that contains all the elements = %d" % len(python_set))
    end = time()
    print("building and union for all the built in sets = %.2lf" % (end - start))
