# 🏗️ 04 - Infrastructure as Code & Containers

Plantillas de contenedores de producción de alto rendimiento (multi-stage builds, distroless, non-root, cache mounts) y arquitectura modular de **Terraform** para aprovisionamiento seguro de redes VPC y bases de datos.

---

## 📁 Estructura del Módulo

```text
04-iac-containers/
├── docker/
│   ├── .dockerignore
│   ├── multi-stage-go.Dockerfile       # Go distroless con build cache y non-root
│   ├── multi-stage-python.Dockerfile   # Python wheels builder con slim runtime
│   └── multi-stage-node.Dockerfile     # Node / Next.js standalone multi-stage build
└── terraform/
    ├── versions.tf                     # Configuración de providers AWS y versiones mínimas
    ├── variables.tf                    # Variables raíz del proyecto
    ├── outputs.tf                      # Outputs consolidados de infraestructura
    ├── main.tf                         # Composición de módulos VPC y Database
    └── modules/
        ├── vpc/                        # Subnets públicas/privadas, Route Tables, NAT Gateway
        │   ├── main.tf
        │   ├── variables.tf
        │   └── outputs.tf
        └── database/                   # Instancia gestionada PostgreSQL con Security Groups
            ├── main.tf
            ├── variables.tf
            └── outputs.tf
```

---

## 🛠️ Buenas Prácticas Implementadas

1. **Docker:**
   - Reducción drástica del tamaño de imagen final (sin compiladores ni package managers en runtime).
   - Ejecución con usuario no privilegiado (`USER 65532` o `USER appuser`).
   - Implementación de `HEALTHCHECK` nativo.
2. **Terraform:**
   - Módulos desacoplados y reutilizables (`vpc`, `database`).
   - Aislamiento de subnets públicas (inbound internet) y privadas (almacenamiento y workloads).
   - Uso de tags semánticos consistentes.

