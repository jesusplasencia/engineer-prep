# 🐧 01 - Linux & Troubleshooting de Producción

Colección de scripts de troubleshooting, automatización y procesamiento de sistemas Linux diseñados para escenarios reales de SRE, DevOps y System Engineering.

---

## 📋 Índice de Scripts

| # | Script | Nivel | Propósito & Comando Clave |
| :---: | :--- | :---: | :--- |
| **01** | [`01-kill-zombie-process.sh`](./01-kill-zombie-process.sh) | 🟢 Básico | Identificar y terminar procesos rebeldes/zombis reteniendo logs y file descriptors (`lsof`, `fuser`, `kill`). |
| **02** | [`02-ip-counter.sh`](./02-ip-counter.sh) | 🟢 Básico | Extracción, ordenamiento y conteo de frecuencias de IPs en web logs (`awk`, `sort`, `uniq`, `head`). |

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
```

---

## 🧪 Laboratorios & Simuladores de SadServers

Escenarios interactivos para recrear localmente los desafíos de [SadServers](https://sadservers.com/) con verificación automatizada:

| Desafío SadServers | Script de Solución | Laboratorio / Setup | Tema & Comandos Clave |
| :--- | :--- | :--- | :--- |
| **"Saint John"** (*what is writing to this log file?*) | [`01-kill-zombie-process.sh`](./01-kill-zombie-process.sh) | [`lab-saint-john-log-writer.sh`](./lab-saint-john-log-writer.sh) | File Descriptors abiertos, Inodes, terminación de procesos (`lsof`, `fuser`, `kill`, `/proc`). |
| **"Saskatoon"** (*counting IPs in access.log*) | [`02-ip-counter.sh`](./02-ip-counter.sh) | [`lab-saskatoon-ip-counter.sh`](./lab-saskatoon-ip-counter.sh) | Procesamiento de texto en streaming, pipelines y ranking (`awk`, `sort`, `uniq`, `head`). |




