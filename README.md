# 🚀 Staff / Senior Engineer Preparation Dashboard

Un repositorio integral de preparación técnica para roles Senior / Staff / SRE / Platform Engineer. Contiene ejercicios prácticos, scripts de troubleshooting de producción, patrones avanzados de almacenamiento SQL / PL-SQL, estructuras de datos fundamentales (CLRS) e Infraestructura como Código (IaC).

---

## 📊 Dashboard de Progreso & Metas

### 🔥 Racha de Práctica & Objetivos
- **Meta Semanal:** 5 días de práctica activa
- **Racha Actual:** `0 días` <!-- Actualiza este contador diariamente -->
- **Objetivo Principal:** Dominio en troubleshooting Linux, SQL analítico de alto rendimiento, diseño de algoritmos CLRS e infraestructura resiliente.

### 🧭 Resumen de Módulos
| Módulo | Área | Estado | Completitud |
| :--- | :--- | :---: | :--- |
| **01** | [Linux & Troubleshooting de Producción](./01-linux-bash/) | 🟡 En Progreso | 0 / 20 Scripts |
| **02** | [SQL Avanzado & Storage Patterns](./02-sql-storage/) | 🟡 En Progreso | 0 / 9 Prácticas |
| **03** | [Algoritmos & Teoría CLRS](./03-algorithms-clrs/) | 🟡 En Progreso | 0 / 7 Módulos |
| **04** | [IaC, Docker & Terraform](./04-iac-containers/) | 🟡 En Progreso | 0 / 5 Recursos |

---

## 🗺️ Estructura del Repositorio

```text
.
├── 01-linux-bash/          # 20 scripts de troubleshooting y administración Linux de producción
├── 02-sql-storage/         # Prácticas analíticas PostgreSQL y programación procedimental PL/SQL (Oracle)
│   ├── init-db/            # Esquemas DDL y datos semilla para Docker Compose
│   ├── postgres/           # Window Functions, Recursive CTEs, Gaps & Islands, JSONB
│   └── plsql-oracle/       # BULK COLLECT, Cursors, PRAGMA AUTONOMOUS, Pipelined Functions
├── 03-algorithms-clrs/     # Implementaciones de Cormen, Leiserson, Rivest, Stein (CLRS)
│   ├── ch03-growth-of-functions/
│   ├── ch10-linear-structures/
│   ├── ch11-hash-tables/
│   ├── ch18-btree-storage/
│   └── ch20-graphs-dag/
├── 04-iac-containers/      # Dockerfiles optimizados multi-stage y módulos Terraform
│   ├── docker/
│   └── terraform/
├── docker-compose.yml      # Base de datos PostgreSQL 16 y Oracle 23c Free listas para usar
├── Makefile                # Atajos rápidos para testing y ejecución
└── README.md
```

---

## ⚡ Comandos Rápidos (`Makefile`)

Levanta bases de datos y ejecuta pruebas con una sola instrucción:

```bash
# Ver todos los comandos disponibles
make help

# Levantar PostgreSQL y Oracle con Docker Compose
make db-up

# Probar todos los algoritmos CLRS en Python
make test-algo

# Validar sintaxis de scripts Bash
make test-bash

# Conectar a PostgreSQL interactivo
make db-psql

# Conectar a Oracle interactivo
make db-oracle

# Apagar bases de datos y limpiar contenedores
make db-down
```

---

## ✅ Checklist de Preparación

### 🐧 01. Linux & Troubleshooting
- [ ] `01-disk-cleanup-fuser.sh`: Liberar espacio retenido por file descriptors abiertos eliminados.
- [ ] `02-log-rotator-monitor.sh`: Rotación segura con gzip y truncamiento de logs activos.
- [ ] `03-process-zombie-killer.sh`: Detección de procesos zombi (`<defunct>`) y manejo de PPID.
- [ ] `04-high-cpu-mem-watcher.sh`: Captura de métricas y dumps de procesos con alto consumo.
- [ ] `05-tcp-port-service-healthcheck.sh`: Healthchecks TCP con control de timeouts y concurrencia.
- [ ] `06-network-socket-analyzer.sh`: Diagnóstico de estados `TIME_WAIT` / `CLOSE_WAIT`.
- [ ] `07-ssl-cert-expiry-checker.sh`: Monitoreo remoto de vencimiento de certificados TLS/SSL.
- [ ] `08-user-permission-auditor.sh`: Auditoría de binarios SUID/SGID y permisos riesgosos.
- [ ] `09-systemd-service-watchdog.sh`: Watchdog para auto-recuperar servicios caídos.
- [ ] `10-db-backup-rotation-s3.sh`: Respaldo automático cifrado con políticas de retención.
- [ ] `11-oom-killer-analyzer.sh`: Análisis de eventos OOM Killer en kernel y cgroups.
- [ ] `12-disk-io-bottleneck-tracer.sh`: Identificación de cuellos de botella en I/O wait.
- [ ] `13-dns-latency-resolver-test.sh`: Benchmarks de resolución DNS y latencias.
- [ ] `14-docker-container-autohealer.sh`: Detección y auto-reinicio de contenedores degradados.
- [ ] `15-log-parser-regex-alert.sh`: Parseo en tiempo real de errores 5xx con alertas.
- [ ] `16-file-integrity-hasher.sh`: Detección de drift en archivos de configuración con SHA-256.
- [ ] `17-swap-pressure-monitor.sh`: Monitoreo de presión de swap y procesos consumidores.
- [ ] `18-ssh-failed-login-banner.sh`: Detección de ataques de fuerza bruta SSH y bloqueo.
- [ ] `19-core-dump-analyzer.sh`: Inspección y generación de stack traces para coredumps.
- [ ] `20-chaos-latency-injector.sh`: Inyección de caos de red (latencia y pérdida de paquetes con `tc`).

### 🗄️ 02. SQL & Storage Patterns
- [ ] PostgreSQL: Window Functions (`ROW_NUMBER`, `DENSE_RANK`, `NTILE`).
- [ ] PostgreSQL: Running Totals & Frame Clauses (`ROWS BETWEEN`).
- [ ] PostgreSQL: Recursive CTEs (Árboles jerárquicos y grafos).
- [ ] PostgreSQL: Gaps and Islands (Rachas de logins e intervalos continuos).
- [ ] PostgreSQL: JSONB e Indexación GIN.
- [ ] Oracle PL/SQL: `BULK COLLECT` y `FORALL` para procesamiento por lotes masivo.
- [ ] Oracle PL/SQL: Cursores parametrizados y `SYS_REFCURSOR`.
- [ ] Oracle PL/SQL: Manejo de errores con `PRAGMA AUTONOMOUS_TRANSACTION`.
- [ ] Oracle PL/SQL: Funciones Pipelined para streaming de datos eficiente.

### 🧠 03. Algoritmos CLRS
- [ ] `ch03`: Análisis Asintótico y Benchmarking $O(1)$ a $O(n^2)$.
- [ ] `ch10`: Queue Circular FIFO (Ring Buffer) y Min Stack $O(1)$.
- [ ] `ch11`: Hash Table con Chaining & LRU Cache con Doubly Linked List.
- [ ] `ch18`: Árbol B (B-Tree) con inserción y división de nodos.
- [ ] `ch20`: Topological Sort (Algoritmo de Kahn & DFS para CI/CD DAGs) y Dijkstra.

### 🏗️ 04. IaC & Contenedores
- [ ] Dockerfiles Multi-stage optimizados (Go distroless, Python slim, Node standalone).
- [ ] Módulos Terraform para VPC resiliente (subnets públicas/privadas, NAT Gateways).
- [ ] Módulos Terraform para base de datos gestionada (RDS / PostgreSQL).

