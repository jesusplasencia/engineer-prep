"""
CLRS Chapter 11 / System Design: Least Recently Used (LRU) Cache
O(1) get and put operations using a Doubly Linked List + Hash Map.
"""
from typing import Dict, Optional, Any
import unittest


class DNode:
    def __init__(self, key: Any = 0, val: Any = 0):
        self.key = key
        self.val = val
        self.prev: Optional['DNode'] = None
        self.next: Optional['DNode'] = None


class LRUCache:
    def __init__(self, capacity: int):
        self.capacity = capacity
        self.cache: Dict[Any, DNode] = {}
        # Dummy head and tail
        self.head = DNode()
        self.tail = DNode()
        self.head.next = self.tail
        self.tail.prev = self.head

    def _remove(self, node: DNode) -> None:
        """Unlinks a node from the doubly linked list."""
        prev_node = node.prev
        next_node = node.next
        if prev_node and next_node:
            prev_node.next = next_node
            next_node.prev = prev_node

    def _add_to_front(self, node: DNode) -> None:
        """Inserts node right after dummy head (most recently used position)."""
        node.next = self.head.next
        node.prev = self.head
        if self.head.next:
            self.head.next.prev = node
        self.head.next = node

    def get(self, key: Any) -> Optional[Any]:
        if key not in self.cache:
            return None
        node = self.cache[key]
        self._remove(node)
        self._add_to_front(node)
        return node.val

    def put(self, key: Any, value: Any) -> None:
        if key in self.cache:
            node = self.cache[key]
            node.val = value
            self._remove(node)
            self._add_to_front(node)
            return

        if len(self.cache) >= self.capacity:
            # Evict least recently used item (node right before tail)
            lru = self.tail.prev
            if lru and lru != self.head:
                self._remove(lru)
                del self.cache[lru.key]

        new_node = DNode(key, value)
        self.cache[key] = new_node
        self._add_to_front(new_node)


class TestLRUCache(unittest.TestCase):
    def test_lru_cache(self):
        cache = LRUCache(2)
        cache.put(1, "one")
        cache.put(2, "two")
        self.assertEqual(cache.get(1), "one")   # returns "one", moves 1 to MRU

        cache.put(3, "three")                   # evicts key 2
        self.assertIsNone(cache.get(2))         # 2 should be evicted
        self.assertEqual(cache.get(3), "three")
        self.assertEqual(cache.get(1), "one")


if __name__ == "__main__":
    unittest.main()

