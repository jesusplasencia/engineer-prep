"""
CLRS Chapter 10: Elementary Data Structures - Min Stack
Stack supporting push, pop, top, and retrieving the minimum element in O(1) time complexity.
"""
from typing import List, Optional
import unittest


class MinStack:
    def __init__(self):
        self.stack: List[int] = []
        self.min_stack: List[int] = []

    def push(self, val: int) -> None:
        self.stack.append(val)
        if not self.min_stack or val <= self.min_stack[-1]:
            self.min_stack.append(val)

    def pop(self) -> Optional[int]:
        if not self.stack:
            return None
        val = self.stack.pop()
        if val == self.min_stack[-1]:
            self.min_stack.pop()
        return val

    def top(self) -> Optional[int]:
        if not self.stack:
            return None
        return self.stack[-1]

    def get_min(self) -> Optional[int]:
        if not self.min_stack:
            return None
        return self.min_stack[-1]

    def is_empty(self) -> bool:
        return len(self.stack) == 0


class TestMinStack(unittest.TestCase):
    def test_min_stack(self):
        s = MinStack()
        s.push(-2)
        s.push(0)
        s.push(-3)
        self.assertEqual(s.get_min(), -3)
        self.assertEqual(s.pop(), -3)
        self.assertEqual(s.top(), 0)
        self.assertEqual(s.get_min(), -2)


if __name__ == "__main__":
    unittest.main()

