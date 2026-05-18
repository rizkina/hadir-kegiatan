up:
	docker-compose up -d
down:
	docker-compose down
build:
	docker-compose build
up-build:
	docker-compose up -d --build
shell:
	docker-compose exec app bash
migrate:
	docker-compose exec app php artisan migrate
fresh:
	docker-compose exec app php artisan migrate:fresh --seed
seed:
	docker-compose exec app php artisan db:seed
import-wilayah:
	docker-compose exec app php artisan wilayah:import
shield-setup:
	docker-compose exec app php artisan shield:install --fresh
logs:
	docker-compose logs -f app