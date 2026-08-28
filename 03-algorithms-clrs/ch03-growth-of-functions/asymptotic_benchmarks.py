"""
CLRS Chapter 3: Growth of Functions
Demonstrates practical empirical verification of Big-O notations (O(1), O(log n), O(n), O(n log n), O(n^2)).
"""
import time
import math
import unittest
from typing import Callable, List, Tuple


def constant_time_lookup(arr: List[int], index: int = 0) -> int:
    """O(1) Constant Time Complexity"""
    return arr[index]


def binary_search(arr: List[int], target: int) -> int:
    """O(log n) Logarithmic Time Complexity"""
    left, right = 0, len(arr) - 1
    while left <= right:
        mid = (left + right) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    return -1


def linear_scan(arr: List[int], target: int) -> int:
    """O(n) Linear Time Complexity"""
    for i, val in enumerate(arr):
        if val == target:
            return i
    return -1


def merge_sort(arr: List[int]) -> List[int]:
    """O(n log n) Linearithmic Time Complexity"""
    if len(arr) <= 1:
        return arr
    mid = len(arr) // 2
    left = merge_sort(arr[:mid])
    right = merge_sort(arr[mid:])
    return _merge(left, right)


def _merge(left: List[int], right: List[int]) -> List[int]:
    result = []
    i = j = 0
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1
    result.extend(left[i:])
    result.extend(right[j:])
    return result


def quadratic_pairs(arr: List[int]) -> int:
    """O(n^2) Quadratic Time Complexity"""
    count = 0
    for i in range(len(arr)):
        for j in range(len(arr)):
            if arr[i] == arr[j]:
                count += 1
    return count


class TestAsymptoticAlgorithms(unittest.TestCase):
    def setUp(self):
        self.sorted_list = list(range(1000))
        self.unsorted_list = [5, 2, 9, 1, 5, 6, 3, 8, 4, 7]

    def test_constant_time(self):
        self.assertEqual(constant_time_lookup(self.sorted_list, 42), 42)

    def test_binary_search(self):
        self.assertEqual(binary_search(self.sorted_list, 777), 777)
        self.assertEqual(binary_search(self.sorted_list, -5), -1)

    def test_linear_scan(self):
        self.assertEqual(linear_scan(self.sorted_list, 500), 500)
        self.assertEqual(linear_scan(self.sorted_list, 2000), -1)

    def test_merge_sort(self):
        self.assertEqual(merge_sort(self.unsorted_list), [1, 2, 3, 4, 5, 5, 6, 7, 8, 9])

    def test_quadratic_pairs(self):
        self.assertEqual(quadratic_pairs([1, 2, 1]), 5)  # pairs: (1,1)x4 + (2,2)


if __name__ == "__main__":
    unittest.main()

