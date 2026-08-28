# 🗄️ 02 - SQL Storage & Analytical Patterns

Prácticas de bases de datos relacionales, consultas analíticas complejas (StrataScratch / LeetCode Hard level) y optimización procedimental con **PostgreSQL 16** y **Oracle Database PL/SQL**.

---

## 📁 Estructura del Módulo

```text
02-sql-storage/
├── init-db/
│   ├── 01-postgres-schema.sql       # DDL de tablas principales en PostgreSQL
│   ├── 02-oracle-schema.sql         # DDL adaptado para Oracle Database 23c
│   └── 03-seed-data.sql             # Datos de prueba para transacciones, usuarios y telemetry
├── postgres/
│   ├── 01-window-functions.sql             # ROW_NUMBER, RANK, DENSE_RANK, NTILE
│   ├── 02-running-totals-aggregations.sql  # Ventanas móviles ROWS BETWEEN, SUM OVER
│   ├── 03-recursive-ctes-hierarchies.sql   # Organización jerárquica y grafos
│   ├── 04-gaps-and-islands.sql             # Rachas de actividad y sessionization
│   └── 05-jsonb-indexing.sql               # Indexación GIN y consultas semiestructuradas
└── plsql-oracle/
    ├── 01-bulk-collect-forall.sql          # Procesamiento en bloque con LIMIT y FORALL
    ├── 02-explicit-cursors-refcursors.sql  # Cursores explícitos y SYS_REFCURSOR
    ├── 03-exception-handling-autonomous.sql# PRAGMA AUTONOMOUS_TRANSACTION para audit logging
    └── 04-pipelined-table-functions.sql    # Transformación de streams con memoria constante
```

---

## 🚀 Cómo Ejecutar los Ejercicios

1. **Levantar los Contenedores:**
   ```bash
   make db-up
   ```

2. **Ejecutar Consultas en PostgreSQL:**
   ```bash
   # Abrir psql interactivo
   make db-psql

   # O ejecutar un script directamente
   docker compose exec -T postgres psql -U prep_user -d prep_db < 02-sql-storage/postgres/01-window-functions.sql
   ```

3. **Ejecutar Scripts en Oracle PL/SQL:**
   ```bash
   # Abrir SQL*Plus interactivo
   make db-oracle

   # O ejecutar un bloque anónimo directamente
   docker compose exec -T oracle sqlplus -S prep_user/prep_password@//localhost:1521/FREEPDB1 < 02-sql-storage/plsql-oracle/01-bulk-collect-forall.sql
   ```

