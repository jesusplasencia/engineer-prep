"""
CLRS Chapter 11: Hash Tables with Separate Chaining
Collision resolution using linked list chains and dynamic load-factor resizing.
"""
from typing import Any, Optional, List, Tuple
import unittest


class HashNode:
    def __init__(self, key: Any, value: Any):
        self.key = key
        self.value = value
        self.next: Optional['HashNode'] = None


class HashTableChaining:
    def __init__(self, initial_capacity: int = 8, load_factor_threshold: float = 0.75):
        self.capacity = initial_capacity
        self.threshold = load_factor_threshold
        self.size = 0
        self.buckets: List[Optional[HashNode]] = [None] * self.capacity

    def _hash(self, key: Any) -> int:
        return hash(key) % self.capacity

    def put(self, key: Any, value: Any) -> None:
        idx = self._hash(key)
        head = self.buckets[idx]

        # Check if key already exists, update value
        curr = head
        while curr:
            if curr.key == key:
                curr.value = value
                return
            curr = curr.next

        # Insert new node at head of chain
        new_node = HashNode(key, value)
        new_node.next = head
        self.buckets[idx] = new_node
        self.size += 1

        # Check load factor and rehash if necessary
        if (self.size / self.capacity) > self.threshold:
            self._resize(self.capacity * 2)

    def get(self, key: Any) -> Optional[Any]:
        idx = self._hash(key)
        curr = self.buckets[idx]
        while curr:
            if curr.key == key:
                return curr.value
            curr = curr.next
        return None

    def delete(self, key: Any) -> bool:
        idx = self._hash(key)
        curr = self.buckets[idx]
        prev = None

        while curr:
            if curr.key == key:
                if prev:
                    prev.next = curr.next
                else:
                    self.buckets[idx] = curr.next
                self.size -= 1
                return True
            prev = curr
            curr = curr.next
        return False

    def _resize(self, new_capacity: int) -> None:
        old_buckets = self.buckets
        self.capacity = new_capacity
        self.buckets = [None] * new_capacity
        self.size = 0

        for head in old_buckets:
            curr = head
            while curr:
                self.put(curr.key, curr.value)
                curr = curr.next


class TestHashTableChaining(unittest.TestCase):
    def test_hash_table_ops(self):
        ht = HashTableChaining(initial_capacity=4)
        ht.put("apple", 100)
        ht.put("banana", 200)
        ht.put("cherry", 300)

        self.assertEqual(ht.get("apple"), 100)
        self.assertEqual(ht.get("banana"), 200)
        self.assertEqual(ht.get("cherry"), 300)
        self.assertIsNone(ht.get("dragonfruit"))

        # Update
        ht.put("apple", 150)
        self.assertEqual(ht.get("apple"), 150)

        # Delete
        self.assertTrue(ht.delete("banana"))
        self.assertIsNone(ht.get("banana"))
        self.assertFalse(ht.delete("nonexistent"))


if __name__ == "__main__":
    unittest.main()

