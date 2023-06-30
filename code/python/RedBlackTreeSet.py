from RedBlackTree import *
from threading import Thread


def get_color(node):
    return node.color if node else 0


def get_height(node):
    if node is None or node == GlobNullNode:
        return 1
    temp = node
    black_height = 0
    while temp is not None:
        if temp.color == 0:
            black_height += 1
        temp = temp.left
    return black_height


def balanced_join(l, r, k, color):
    e = TreeNode(k)
    e.color = color
    e.left = l
    e.right = r
    return e


def joinRightRB(TL, k, TR):
    if get_color(TL) == 0 and get_height(TL) == get_height(TR):
        return balanced_join(TL, TR, k, 1)
    t = TreeNode(TL.data)
    t.color = TL.color
    t.left = TL.left
    t.right = joinRightRB(TL.right, k, TR)
    if get_color(TL) == 0 and get_color(t.right) == get_color(t.right.right) == 1:
        t.right.right.color = 0
        return t.left_rotate(t)
    return t


def joinLeftRB(TL, k, TR):
    if get_color(TR) == 0 and get_height(TL) == get_height(TR):
        return balanced_join(TL, TR, k, 1)
    t = TreeNode(TR.data)
    t.color = TR.color
    t.left = joinLeftRB(TL, k, TR.left)
    t.right = TR.right
    if get_color(TR) == 0 and get_color(t.left) == get_color(t.left.left) == 1:
        t.left.left.color = 0
        return t.right_rotate(t)
    return t


def join(TL, k, TR):
    tl_black_height=get_height(TL)
    tr_black_height=get_height(TR)
    if tl_black_height > tr_black_height:
        t = joinRightRB(TL, k, TR)
        if get_color(t) == 1 and get_color(t.right) == 1:
            t.color = 0
        return t
    if tr_black_height > tl_black_height:
        t = joinLeftRB(TL, k, TR)
        if get_color(t) == 1 and get_color(t.left) == 1:
            t.color = 0
        return t
    if get_color(TL) == 0 and get_color(TR) == 0:
        return balanced_join(TL, TR, k, 1)
    return balanced_join(TL, TR, k, 0)


def split(T, k):
    if T is None or T == GlobNullNode:
        return GlobNullNode, False, GlobNullNode
    if k == T.data:
        return T.left, True, T.right
    if k < T.data:
        L, b, R = split(T.left, k)
        return L, b, join(R, T.data, T.right)
    L, b, R = split(T.right, k)
    return join(T.left, T.data, L), b, R


def union_thread(t1, t2):
    if t1 is None or t1 == GlobNullNode:
        return t2
    if t2 is None or t2 == GlobNullNode:
        return t1
    L, b, R = split(t1, t2.data)
    TL = union_thread(L, t2.left)
    TR = union_thread(R, t2.right)
    return join(TL, t2.data, TR)


def union(t1, t2):
    if t1 is None or t1 == GlobNullNode:
        return t2
    if t2 is None or t2 == GlobNullNode:
        return t1
    L, b, R = split(t1, t2.data)
    tr1 = My_Thread(L, t2.left)
    tr2 = My_Thread(R, t2.right)
    tr1.start()
    tr2.start()
    tr1.join()
    tr2.join()
    return join(tr1.value, t2.data, tr2.value)


expose = lambda t: (t.left, t.data, t.right)


def splitLast(T):
    L, k, R = expose(T)
    if R == GlobNullNode:
        return L, k
    else:
        Tt, kt = splitLast(R)
        return join(L, k, Tt), kt


def join2(L, R):
    if L == GlobNullNode:
        return R
    else:
        Lt, k = splitLast(L)
        return join(Lt, k, R)


def intersection(t1, t2):
    if t1 is None or t2 is None or t1 == GlobNullNode or t2 == GlobNullNode:
        return GlobNullNode
    else:
        l1, k1, r1 = expose(t1)
        t_lower, b, t_higher = split(t2, k1)
        lt = intersection(l1, t_lower)
        rt = intersection(r1, t_higher)
        if b:
            return join(lt, k1, rt)
        else:
            return join2(lt, rt)


def difference(t1, t2):
    if t1 is None or t1 == GlobNullNode:
        return GlobNullNode
    elif t2 is None or t2 == GlobNullNode:
        return t1
    else:
        l1, k1, r1 = expose(t1)
        t_lower, b, t_higher = split(t2, k1)
        lt = difference(l1, t_lower)
        rt = difference(r1, t_higher)
        if b:
            return join2(lt, rt)
        else:
            return join(lt, k1, rt)


class My_Thread(Thread):
    def __init__(self, t1, t2):
        Thread.__init__(self)
        self.t1 = t1
        self.t2 = t2
        self.value = None

    def run(self):
        self.value = union_thread(self.t1, self.t2)


class RedBlackTreeSet:
    def __init__(self):
        self.tree = RedBlackTree()

    def search(self, data):
        return self.tree.searchTree(data) != GlobNullNode

    def insert_list(self, lst):
        for elem in lst:
            if not self.search(elem):
                self.tree.insert(elem)

    def set_union(self, other):
        final_set = RedBlackTreeSet()
        final_set.tree.root = union(self.tree.root, other.tree.root)
        return final_set

    def print_sorted_set(self):
        self.tree.inorder(self.tree.root)
        print()

    def size(self):
        return self.tree.count_nodes(self.tree.root)

    def set_intersection(self, other):
        final_set = RedBlackTreeSet()
        final_set.tree.root = intersection(self.tree.root, other.tree.root)
        return final_set

    def set_difference(self, other):
        final_set = RedBlackTreeSet()
        final_set.tree.root = difference(self.tree.root, other.tree.root)
        return final_set

    def set_to_list(self):
        lst = []
        self.tree.tree_to_lst(self.tree.root, lst)
        return lst

    def delete_set(self):
        self.tree.delete()
