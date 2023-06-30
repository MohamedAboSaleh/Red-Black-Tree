class TreeNode():
    def __init__(self, data):
        self.data = data  # holds the key
        self.parent = None  # pointer to the parent
        self.left = None  # pointer to left child
        self.right = None  # pointer to right child
        self.color = 1  # 1 . Red, 0 . Black

    def left_rotate(self, x):
        root = x.right
        lsub = root.left
        root.left = x
        x.right = lsub
        return root

    def right_rotate(self, x):
        root = x.left
        rsub = root.right
        x.left = rsub
        root.right = x
        return root