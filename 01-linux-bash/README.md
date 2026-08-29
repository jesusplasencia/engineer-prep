# 🐧 01 - Linux & Troubleshooting de Producción

Colección de scripts de troubleshooting, automatización y procesamiento de sistemas Linux diseñados para escenarios reales de SRE, DevOps y System Engineering.

---

## 📋 Índice de Scripts

| # | Script | Nivel | Propósito & Comando Clave |
| :---: | :--- | :---: | :--- |
| **01** | [`01-kill-zombie-process.sh`](./01-kill-zombie-process.sh) | 🟢 Básico | Identificar y terminar procesos rebeldes/zombis reteniendo logs y file descriptors (`lsof`, `fuser`, `kill`). |
| **02** | [`02-ip-counter.sh`](./02-ip-counter.sh) | 🟢 Básico | Extracción, ordenamiento y conteo de frecuencias de IPs en web logs (`awk`, `sort`, `uniq`, `head`). |
| **03** | [`03-grep-incident-triage.sh`](./03-grep-incident-triage.sh) | 🟢 Básico | Triage y filtrado de incidentes en logs ruidosos (`grep -i`, `grep -E`, `grep -v`). |
| **04** | [`04-awk-metric-extractor.sh`](./04-awk-metric-extractor.sh) | 🟢 Básico | Cirugía de columnas, filtros numéricos y latencias en logs (`awk '$col >= val'`). |

---

## 🛠️ Cómo Ejecutar los Scripts

Asegúrate de otorgar permisos de ejecución:

```bash
chmod +x 01-linux-bash/*.sh
```

Ejecuta cualquier script pasando sus parámetros correspondientes:

```bash
# Ejemplo 01: Terminar el proceso que está escribiendo en bad.log
./01-linux-bash/01-kill-zombie-process.sh /tmp/saint-john/bad.log

# Ejemplo 02: Ejecutar el contador de IPs sobre un log de acceso
./01-linux-bash/02-ip-counter.sh

# Ejemplo 03: Filtrar errores de incidentes con grep
./01-linux-bash/03-grep-incident-triage.sh

# Ejemplo 04: Extraer métricas de latencia y 5xx con awk
./01-linux-bash/04-awk-metric-extractor.sh
```

---

## 🧪 Laboratorios & Simuladores de SadServers y SRE

Escenarios interactivos para recrear localmente desafíos de producción con verificación automatizada:

| Desafío / Práctica | Script de Solución | Laboratorio / Setup | Tema & Comandos Clave |
| :--- | :--- | :--- | :--- |
| **"Saint John"** (*what is writing to this log file?*) | [`01-kill-zombie-process.sh`](./01-kill-zombie-process.sh) | [`lab-saint-john-log-writer.sh`](./lab-saint-john-log-writer.sh) | File Descriptors abiertos, Inodes, terminación de procesos (`lsof`, `fuser`, `kill`, `/proc`). |
| **"Saskatoon"** (*counting IPs in access.log*) | [`02-ip-counter.sh`](./02-ip-counter.sh) | [`lab-saskatoon-ip-counter.sh`](./lab-saskatoon-ip-counter.sh) | Procesamiento de texto en streaming, pipelines y ranking (`awk`, `sort`, `uniq`, `head`). |
| **"SRE Triage con Grep"** (*filtrado sin ruido*) | [`03-grep-incident-triage.sh`](./03-grep-incident-triage.sh) | [`lab-grep-incident.sh`](./lab-grep-incident.sh) | Patrones regex, exclusión de ruido y banderas case-insensitive (`grep -i`, `-E`, `-v`). |
| **"Cirugía de Métricas con Awk"** (*latencias y 5xx*) | [`04-awk-metric-extractor.sh`](./04-awk-metric-extractor.sh) | [`lab-awk-metrics.sh`](./lab-awk-metrics.sh) | Filtros de umbral numérico por columna y proyección (`awk '$4>=500 && $5>1000'`). |





