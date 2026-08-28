"""
CLRS Chapter 10: Elementary Data Structures - Circular Queue (Ring Buffer)
Implements a fixed-capacity FIFO circular queue with O(1) enqueue and dequeue operations.
"""
from typing import Any, Optional
import unittest


class CircularQueue:
    def __init__(self, capacity: int):
        if capacity <= 0:
            raise ValueError("Capacity must be greater than 0")
        self.capacity = capacity
        self.buffer = [None] * capacity
        self.head = 0
        self.tail = 0
        self.size = 0

    def is_empty(self) -> bool:
        return self.size == 0

    def is_full(self) -> bool:
        return self.size == self.capacity

    def enqueue(self, item: Any) -> bool:
        """Adds an item to the rear of the ring buffer in O(1) time."""
        if self.is_full():
            return False
        self.buffer[self.tail] = item
        self.tail = (self.tail + 1) % self.capacity
        self.size += 1
        return True

    def dequeue(self) -> Optional[Any]:
        """Removes and returns the front item of the ring buffer in O(1) time."""
        if self.is_empty():
            return None
        item = self.buffer[self.head]
        self.buffer[self.head] = None
        self.head = (self.head + 1) % self.capacity
        self.size -= 1
        return item

    def peek(self) -> Optional[Any]:
        if self.is_empty():
            return None
        return self.buffer[self.head]

    def __len__(self) -> int:
        return self.size


class TestCircularQueue(unittest.TestCase):
    def test_queue_operations(self):
        q = CircularQueue(3)
        self.assertTrue(q.is_empty())
        self.assertFalse(q.is_full())

        self.assertTrue(q.enqueue(10))
        self.assertTrue(q.enqueue(20))
        self.assertTrue(q.enqueue(30))
        self.assertTrue(q.is_full())
        self.assertFalse(q.enqueue(40))  # Full

        self.assertEqual(q.peek(), 10)
        self.assertEqual(q.dequeue(), 10)
        self.assertFalse(q.is_full())

        self.assertTrue(q.enqueue(40))  # Wraps around
        self.assertEqual(q.dequeue(), 20)
        self.assertEqual(q.dequeue(), 30)
        self.assertEqual(q.dequeue(), 40)
        self.assertTrue(q.is_empty())
        self.assertIsNone(q.dequeue())


if __name__ == "__main__":
    unittest.main()

