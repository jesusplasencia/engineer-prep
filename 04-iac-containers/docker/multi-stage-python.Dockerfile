# ==============================================================================
# Multi-Stage Dockerfile for Python (FastAPI / Flask / Celery)
# Features: Wheel pre-building, Debian slim runtime, non-root user, and healthcheck.
# ==============================================================================

# Stage 1: Build wheels and compile C extensions if needed
FROM python:3.12-slim AS builder

WORKDIR /build

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt* ./
RUN pip install --no-cache-dir --upgrade pip && \
    pip wheel --no-cache-dir --no-deps --wheel-dir /build/wheels -r requirements.txt 2>/dev/null || true

# Stage 2: Final Production Runtime Image
FROM python:3.12-slim AS runner

WORKDIR /app

# Create dedicated non-privileged user and group
RUN groupadd -g 10001 appgroup && \
    useradd -u 10001 -g appgroup -s /sbin/nologin -M appuser

# Install pre-built wheels from builder
COPY --from=builder /build/wheels /wheels
RUN if [ -d "/wheels" ] && [ "$(ls -A /wheels)" ]; then \
        pip install --no-cache /wheels/* && rm -rf /wheels; \
    fi

COPY . /app

RUN chown -R appuser:appgroup /app

USER 10001

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PORT=8000

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" || exit 1

CMD ["python", "app.py"]

