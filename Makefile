# 初期マイグレーション
init:
	alembic revision --autogenerate -m "create models"

# db反映
migrate:
	alembic upgrade head
