# README

Commands to run the server on docker container:

- docker-compose -f docker-compose.yml up --build

Stop the services with `ctrl+c` and run

- docker-compose run web rails db:migrate
- docker-compose run web rails db:seed

Run the services again

- docker-compose up
