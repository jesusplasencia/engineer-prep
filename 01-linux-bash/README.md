# 🐧 01 - Linux & Troubleshooting de Producción

Colección de scripts de troubleshooting, automatización y procesamiento de sistemas Linux diseñados para escenarios reales de SRE, DevOps y System Engineering.

---

## 📋 Índice de Scripts

| # | Script | Nivel | Propósito & Comando Clave |
| :---: | :--- | :---: | :--- |
| **01** | [`01-disk-cleanup-fuser.sh`](./01-disk-cleanup-fuser.sh) | 🟢 Básico | Identificar y liberar archivos eliminados retenidos por file descriptors (`lsof`, `fuser`, `/proc`). |
| **02** | [`02-ip-counter.sh`](./02-ip-counter.sh) | 🟢 Básico | Extracción, ordenamiento y conteo de frecuencias de IPs en web logs (`awk`, `sort`, `uniq`, `head`). |

---

## 🛠️ Cómo Ejecutar los Scripts

Asegúrate de otorgar permisos de ejecución:

```bash
chmod +x 01-linux-bash/*.sh
```

Ejecuta cualquier script pasando sus parámetros correspondientes:

```bash
# Ejemplo 01: Inspeccionar archivos abiertos y ghost file descriptors en /tmp o /var/log
./01-linux-bash/01-disk-cleanup-fuser.sh /tmp

# Ejemplo 02: Ejecutar el contador de IPs sobre un log de acceso
./01-linux-bash/02-ip-counter.sh
```

---

## 🧪 Laboratorios & Simuladores de SadServers

Escenarios interactivos para recrear localmente los desafíos de [SadServers](https://sadservers.com/) con verificación automatizada:

| Desafío SadServers | Script de Solución | Laboratorio / Setup | Tema & Comandos Clave |
| :--- | :--- | :--- | :--- |
| **"Saint John"** (*what is writing to this log file?*) | [`01-disk-cleanup-fuser.sh`](./01-disk-cleanup-fuser.sh) | Directo en el script | File Descriptors abiertos, Inodes, archivos borrados retenidos (`lsof`, `fuser`, `/proc`). |
| **"Saskatoon"** (*counting IPs in access.log*) | [`02-ip-counter.sh`](./02-ip-counter.sh) | [`lab-saskatoon-ip-counter.sh`](./lab-saskatoon-ip-counter.sh) | Procesamiento de texto en streaming, pipelines y ranking (`awk`, `sort`, `uniq`, `head`). |



