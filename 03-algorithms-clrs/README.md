# 🧠 03 - Algoritmos & Teoría CLRS

Implementaciones prácticas de estructuras de datos y algoritmos basadas en el libro estándar de la industria:
*Introduction to Algorithms* (Cormen, Leiserson, Rivest, Stein - **CLRS**).

---

## 📁 Contenido del Módulo

| Capítulo CLRS | Tema / Estructura | Archivos Clave | Complejidad |
| :--- | :--- | :--- | :---: |
| **Capítulo 03** | Crecimiento de Funciones & Análisis Asintótico | [`ch03-growth-of-functions/asymptotic_benchmarks.py`](./ch03-growth-of-functions/asymptotic_benchmarks.py) | $O(1)$ a $O(n^2)$ |
| **Capítulo 10** | Estructuras Lineales Elementales | [`ch10-linear-structures/circular_queue.py`](./ch10-linear-structures/circular_queue.py)<br>[`ch10-linear-structures/min_stack.py`](./ch10-linear-structures/min_stack.py) | $O(1)$ ops |
| **Capítulo 11** | Tablas Hash & Resolución de Colisiones | [`ch11-hash-tables/hash_table_chaining.py`](./ch11-hash-tables/hash_table_chaining.py)<br>[`ch11-hash-tables/lru_cache.py`](./ch11-hash-tables/lru_cache.py) | $O(1)$ amortizado |
| **Capítulo 18** | Árboles B (B-Trees) para Storage Engines | [`ch18-btree-storage/b_tree.py`](./ch18-btree-storage/b_tree.py) | $O(\log_t n)$ |
| **Capítulo 20** | Grafos & DAGs (CI/CD Dependency Resolution) | [`ch20-graphs-dag/dag_topological_sort.py`](./ch20-graphs-dag/dag_topological_sort.py)<br>[`ch20-graphs-dag/dijkstra_shortest_path.py`](./ch20-graphs-dag/dijkstra_shortest_path.py) | $O(V + E)$ |

---

## 🧪 Cómo Ejecutar las Pruebas Unitarias

Todos los archivos cuentan con suites completas de pruebas unitarias basadas en el módulo estándar `unittest`:

```bash
# Ejecutar todas las pruebas del módulo de algoritmos
make test-algo

# O ejecutar un archivo específico
python 03-algorithms-clrs/ch20-graphs-dag/dag_topological_sort.py
```

