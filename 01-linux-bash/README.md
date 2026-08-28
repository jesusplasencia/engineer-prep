# 🐧 01 - Linux & Troubleshooting de Producción

Colección de **20 scripts de troubleshooting**, automatización y auditoría de sistemas Linux diseñados para escenarios reales de SRE, DevOps y System Engineering.

---

## 📋 Índice de Scripts

| # | Script | Nivel | Propósito & Comando Clave |
| :---: | :--- | :---: | :--- |
| **01** | [`01-disk-cleanup-fuser.sh`](./01-disk-cleanup-fuser.sh) | 🟢 Básico | Identificar y liberar archivos eliminados retenidos por file descriptors (`lsof`, `fuser`). |
| **02** | [`02-log-rotator-monitor.sh`](./02-log-rotator-monitor.sh) | 🟢 Básico | Rotación, compresión `gzip` y truncamiento seguro de logs activos. |
| **03** | [`03-process-zombie-killer.sh`](./03-process-zombie-killer.sh) | 🟡 Intermedio | Detección de procesos zombi (`<defunct>`), rastreo de PPID y señalización `SIGCHLD`. |
| **04** | [`04-high-cpu-mem-watcher.sh`](./04-high-cpu-mem-watcher.sh) | 🟡 Intermedio | Snapshots de top consumidores de CPU/Memoria y alertas ante umbrales críticos. |
| **05** | [`05-tcp-port-service-healthcheck.sh`](./05-tcp-port-service-healthcheck.sh) | 🟢 Básico | Verificación concurrente de puertos y endpoints TCP con timeout. |
| **06** | [`06-network-socket-analyzer.sh`](./06-network-socket-analyzer.sh) | 🟡 Intermedio | Análisis de estados de sockets (`TIME_WAIT`, `CLOSE_WAIT`) con `ss` y `netstat`. |
| **07** | [`07-ssl-cert-expiry-checker.sh`](./07-ssl-cert-expiry-checker.sh) | 🟡 Intermedio | Auditoría remota de certificados SSL/TLS con `openssl s_client` y alertas de expiración. |
| **08** | [`08-user-permission-auditor.sh`](./08-user-permission-auditor.sh) | 🟡 Intermedio | Búsqueda de binarios SUID/SGID, archivos world-writable y anomalías de seguridad. |
| **09** | [`09-systemd-service-watchdog.sh`](./09-systemd-service-watchdog.sh) | 🟡 Intermedio | Watchdog para auto-reiniciar unidades de systemd fallidas con backoff y logs. |
| **10** | [`10-db-backup-rotation-s3.sh`](./10-db-backup-rotation-s3.sh) | 🟡 Intermedio | Pipeline de dump de base de datos, compresión, cifrado GPG y retención. |
| **11** | [`11-oom-killer-analyzer.sh`](./11-oom-killer-analyzer.sh) | 🔴 Avanzado | Parseo de eventos OOM-Killer en `dmesg`/`journalctl` y métricas de cgroups. |
| **12** | [`12-disk-io-bottleneck-tracer.sh`](./12-disk-io-bottleneck-tracer.sh) | 🔴 Avanzado | Trazado de I/O wait, análisis con `iostat`, `vmstat` e identificación de cuellos de botella. |
| **13** | [`13-dns-latency-resolver-test.sh`](./13-dns-latency-resolver-test.sh) | 🟢 Básico | Benchmarking de servidores DNS con `dig` midiendo tiempos de query y resolución. |
| **14** | [`14-docker-container-autohealer.sh`](./14-docker-container-autohealer.sh) | 🟡 Intermedio | Monitor y auto-recuperador de contenedores Docker en estado unhealthy o crash-loop. |
| **15** | [`15-log-parser-regex-alert.sh`](./15-log-parser-regex-alert.sh) | 🟡 Intermedio | Parseo en streaming de logs web con `awk`/`sed` para alertas de picos de errores 5xx. |
| **16** | [`16-file-integrity-hasher.sh`](./16-file-integrity-hasher.sh) | 🟡 Intermedio | Verificador de integridad de archivos de configuración (`/etc`) mediante hashes SHA-256. |
| **17** | [`17-swap-pressure-monitor.sh`](./17-swap-pressure-monitor.sh) | 🔴 Avanzado | Monitoreo de presión de memoria swap, `swappiness` y rastreo de PIDs causantes en `/proc`. |
| **18** | [`18-ssh-failed-login-banner.sh`](./18-ssh-failed-login-banner.sh) | 🟡 Intermedio | Detección de ataques de fuerza bruta en `auth.log` y generación de reglas `iptables`/`ufw`. |
| **19** | [`19-core-dump-analyzer.sh`](./19-core-dump-analyzer.sh) | 🔴 Avanzado | Detección de volcados de memoria (core dumps) y extracción automática de backtraces con `gdb`. |
| **20** | [`20-chaos-latency-injector.sh`](./20-chaos-latency-injector.sh) | 🔴 Avanzado | Inyección de latencia, jitter y pérdida de paquetes en interfaces con `tc` (Traffic Control). |

---

## 🛠️ Cómo Ejecutar los Scripts

Asegúrate de otorgar permisos de ejecución:

```bash
chmod +x 01-linux-bash/*.sh
```

Ejecuta cualquier script pasando `--help` o sus parámetros correspondientes:

```bash
# Ejemplo: Analizar sockets en TIME_WAIT y CLOSE_WAIT
./01-linux-bash/06-network-socket-analyzer.sh

# Ejemplo: Comprobar certificados SSL
./01-linux-bash/07-ssl-cert-expiry-checker.sh google.com:443 github.com:443
```

