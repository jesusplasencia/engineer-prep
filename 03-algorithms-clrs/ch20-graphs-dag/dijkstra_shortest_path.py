"""
CLRS Chapter 22 / Network Routing: Dijkstra's Single-Source Shortest Path Algorithm
Finds shortest paths in weighted directed graphs using a min-heap priority queue in O((V + E) log V).
"""
import heapq
from typing import Dict, List, Tuple, Optional
import unittest


class WeightedGraph:
    def __init__(self):
        self.adj: Dict[str, List[Tuple[str, float]]] = {}

    def add_edge(self, u: str, v: str, weight: float) -> None:
        if u not in self.adj:
            self.adj[u] = []
        if v not in self.adj:
            self.adj[v] = []
        self.adj[u].append((v, weight))

    def dijkstra(self, source: str) -> Tuple[Dict[str, float], Dict[str, Optional[str]]]:
        """Returns (distances_dict, predecessors_dict)"""
        distances: Dict[str, float] = {node: float('inf') for node in self.adj}
        predecessors: Dict[str, Optional[str]] = {node: None for node in self.adj}
        distances[source] = 0.0

        pq: List[Tuple[float, str]] = [(0.0, source)]

        while pq:
            curr_dist, u = heapq.heappop(pq)

            if curr_dist > distances[u]:
                continue

            for v, weight in self.adj[u]:
                if distances[u] + weight < distances[v]:
                    distances[v] = distances[u] + weight
                    predecessors[v] = u
                    heapq.heappush(pq, (distances[v], v))

        return distances, predecessors


class TestDijkstra(unittest.TestCase):
    def test_shortest_path(self):
        g = WeightedGraph()
        g.add_edge("RouterA", "RouterB", 4.0)
        g.add_edge("RouterA", "RouterC", 2.0)
        g.add_edge("RouterC", "RouterB", 1.0)
        g.add_edge("RouterB", "RouterD", 5.0)
        g.add_edge("RouterC", "RouterD", 8.0)

        distances, preds = g.dijkstra("RouterA")

        self.assertEqual(distances["RouterA"], 0.0)
        self.assertEqual(distances["RouterC"], 2.0)
        self.assertEqual(distances["RouterB"], 3.0)  # A -> C -> B (2 + 1 = 3)
        self.assertEqual(distances["RouterD"], 8.0)  # A -> C -> B -> D (3 + 5 = 8)
        self.assertEqual(preds["RouterB"], "RouterC")


if __name__ == "__main__":
    unittest.main()

