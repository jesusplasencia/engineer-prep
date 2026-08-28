"""
CLRS Chapter 18: B-Trees (Foundational Storage Engine Index Data Structure)
Self-balancing search tree designed for disk/storage engines where nodes have multiple keys and children.
"""
from typing import List, Optional, Tuple
import unittest


class BTreeNode:
    def __init__(self, leaf: bool = True):
        self.leaf = leaf
        self.keys: List[int] = []
        self.children: List['BTreeNode'] = []


class BTree:
    def __init__(self, t: int = 2):
        """
        t: Minimum degree of the B-Tree.
        Every non-root node must contain at least t-1 keys and at most 2t-1 keys.
        """
        if t < 2:
            raise ValueError("Minimum degree t must be >= 2")
        self.root = BTreeNode(leaf=True)
        self.t = t

    def search(self, k: int, node: Optional[BTreeNode] = None) -> Optional[Tuple[BTreeNode, int]]:
        """Searches for key k in the subtree rooted at node. Returns (node, index) if found."""
        if node is None:
            node = self.root

        i = 0
        while i < len(node.keys) and k > node.keys[i]:
            i += 1

        if i < len(node.keys) and k == node.keys[i]:
            return (node, i)

        if node.leaf:
            return None

        return self.search(k, node.children[i])

    def insert(self, k: int) -> None:
        """Inserts key k into the B-Tree."""
        root = self.root
        if len(root.keys) == (2 * self.t - 1):
            # Root is full, tree grows in height
            new_root = BTreeNode(leaf=False)
            new_root.children.append(self.root)
            self._split_child(new_root, 0)
            self.root = new_root
            self._insert_non_full(new_root, k)
        else:
            self._insert_non_full(root, k)

    def _split_child(self, parent: BTreeNode, i: int) -> None:
        """Splits full child parent.children[i] of degree t."""
        t = self.t
        y = parent.children[i]
        z = BTreeNode(leaf=y.leaf)

        # z receives the last t-1 keys and t children of y
        z.keys = y.keys[t:]
        median_key = y.keys[t - 1]
        y.keys = y.keys[:t - 1]

        if not y.leaf:
            z.children = y.children[t:]
            y.children = y.children[:t]

        parent.children.insert(i + 1, z)
        parent.keys.insert(i, median_key)

    def _insert_non_full(self, node: BTreeNode, k: int) -> None:
        i = len(node.keys) - 1
        if node.leaf:
            node.keys.append(0)
            while i >= 0 and k < node.keys[i]:
                node.keys[i + 1] = node.keys[i]
                i -= 1
            node.keys[i + 1] = k
        else:
            while i >= 0 and k < node.keys[i]:
                i -= 1
            i += 1
            if len(node.children[i].keys) == (2 * self.t - 1):
                self._split_child(node, i)
                if k > node.keys[i]:
                    i += 1
            self._insert_non_full(node.children[i], k)


class TestBTree(unittest.TestCase):
    def test_btree_insertion_and_search(self):
        tree = BTree(t=2)
        keys_to_insert = [10, 20, 5, 6, 12, 30, 7, 17]
        for key in keys_to_insert:
            tree.insert(key)

        for key in keys_to_insert:
            result = tree.search(key)
            self.assertIsNotNone(result, f"Key {key} should be found")
            node, idx = result
            self.assertEqual(node.keys[idx], key)

        self.assertIsNone(tree.search(999))
        self.assertIsNone(tree.search(0))


if __name__ == "__main__":
    unittest.main()

