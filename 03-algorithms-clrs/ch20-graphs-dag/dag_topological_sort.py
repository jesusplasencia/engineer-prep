"""
CLRS Chapter 20 / System Design: Directed Acyclic Graph (DAG) Topological Sort
Used for CI/CD Pipeline Job Scheduling, Terraform Dependency Graphs, and Package Resolution.
Implements Kahn's In-Degree Algorithm and DFS Cycle Detection in O(V + E).
"""
from collections import deque, defaultdict
from typing import Dict, List, Set, Optional
import unittest


class DependencyGraph:
    def __init__(self):
        self.adj_list: Dict[str, List[str]] = defaultdict(list)
        self.in_degree: Dict[str, int] = defaultdict(int)
        self.nodes: Set[str] = set()

    def add_dependency(self, prerequisite: str, task: str) -> None:
        """Adds a directed edge: prerequisite must complete before task can run."""
        self.nodes.add(prerequisite)
        self.nodes.add(task)
        self.adj_list[prerequisite].append(task)
        self.in_degree[task] += 1
        if prerequisite not in self.in_degree:
            self.in_degree[prerequisite] = 0

    def topological_sort_kahns(self) -> Optional[List[str]]:
        """
        Kahn's Algorithm (BFS based).
        Returns a valid linear execution order, or None if a circular dependency (cycle) exists.
        """
        in_deg = {node: self.in_degree[node] for node in self.nodes}
        queue = deque([node for node in self.nodes if in_deg[node] == 0])
        execution_order = []

        while queue:
            curr = queue.popleft()
            execution_order.append(curr)

            for neighbor in self.adj_list[curr]:
                in_deg[neighbor] -= 1
                if in_deg[neighbor] == 0:
                    queue.append(neighbor)

        if len(execution_order) != len(self.nodes):
            return None  # Cycle detected!

        return execution_order


class TestDAGTopologicalSort(unittest.TestCase):
    def test_cicd_pipeline_order(self):
        graph = DependencyGraph()
        # Pipeline: lint & test -> build -> docker-pack -> deploy
        graph.add_dependency("checkout", "lint")
        graph.add_dependency("checkout", "unit-tests")
        graph.add_dependency("lint", "build")
        graph.add_dependency("unit-tests", "build")
        graph.add_dependency("build", "docker-pack")
        graph.add_dependency("docker-pack", "deploy-staging")

        order = graph.topological_sort_kahns()
        self.assertIsNotNone(order)
        self.assertEqual(order[0], "checkout")
        self.assertEqual(order[-1], "deploy-staging")
        self.assertTrue(order.index("build") > order.index("lint"))
        self.assertTrue(order.index("build") > order.index("unit-tests"))

    def test_cycle_detection(self):
        cyclic_graph = DependencyGraph()
        cyclic_graph.add_dependency("JobA", "JobB")
        cyclic_graph.add_dependency("JobB", "JobC")
        cyclic_graph.add_dependency("JobC", "JobA")  # Circular deadlock

        self.assertIsNone(cyclic_graph.topological_sort_kahns())


if __name__ == "__main__":
    unittest.main()

