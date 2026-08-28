.PHONY: help db-up db-down db-logs db-psql db-oracle test-bash test-algo clean lint

# Default target
.DEFAULT_GOAL := help

help:
	@echo "================================================================"
	@echo "            ENGINEER PREP - AUTOMATION TOOLKIT                  "
	@echo "================================================================"
	@echo "Available commands:"
	@echo "  make db-up         - Start PostgreSQL and Oracle database containers"
	@echo "  make db-down       - Stop and remove database containers"
	@echo "  make db-logs       - Follow logs from database containers"
	@echo "  make db-psql       - Open an interactive PostgreSQL session (psql)"
	@echo "  make db-oracle     - Open an interactive Oracle SQL*Plus session"
	@echo "  make test-algo     - Run all CLRS algorithm unit tests (Python)"
	@echo "  make test-bash     - Validate syntax of all 20 Linux bash scripts"
	@echo "  make lint          - Lint python, shell, and terraform files"
	@echo "  make clean         - Remove temporary cache files and test artifacts"
	@echo "================================================================"

db-up:
	docker compose up -d
	@echo "Databases are starting in background."
	@echo "PostgreSQL: localhost:5432 (user: prep_user, db: prep_db)"
	@echo "Oracle:     localhost:1521 (user: prep_user, pdb: FREEPDB1)"

db-down:
	docker compose down

db-logs:
	docker compose logs -f

db-psql:
	docker compose exec -it postgres psql -U prep_user -d prep_db

db-oracle:
	docker compose exec -it oracle sqlplus prep_user/prep_password@//localhost:1521/FREEPDB1

test-algo:
	python -m unittest discover -s 03-algorithms-clrs -p "*.py" -v

test-bash:
	@echo "Checking bash scripts syntax with bash -n..."
	@for file in 01-linux-bash/*.sh; do \
		if [ -f "$$file" ]; then \
			bash -n "$$file" && echo "✅ OK: $$file" || echo "❌ ERR: $$file"; \
		fi \
	done

lint:
	@echo "Running basic formatting and linting checks..."
	@which flake8 > /dev/null 2>&1 && flake8 03-algorithms-clrs || echo "flake8 not installed, skipping python lint"
	@which terraform > /dev/null 2>&1 && terraform -chdir=04-iac-containers/terraform fmt -check || echo "terraform not installed, skipping tf fmt"

clean:
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	find . -type f -name "*.pyo" -delete
	find . -type d -name ".pytest_cache" -exec rm -rf {} +
	find . -type d -name ".terraform" -exec rm -rf {} +
	@echo "Cleanup completed."

