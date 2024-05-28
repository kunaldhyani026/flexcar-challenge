FROM ruby:2.6.10

RUN mkdir /flexcar-challenge
WORKDIR /flexcar-challenge

RUN apt-get update

# BUILD DOCKER IMAGE flexcar-challenge
# docker build -t 'flexcar-challenge' -f /path/to/local/code/Dockerfile .

# BUILD CONTAINER flexcar-challenge
# docker run --expose 3000 -p 3000:3000 --name flexcar-challenge -it -v /path/to/local/code:/flexcar-challenge -d flexcar-challenge

# START CONTAINER flexcar-challenge
# docker start flexcar-challenge

# LOG IN TO CONTAINER flexcar-challenge
# docker exec -it flexcar-challenge bash

# RUN FOLLOWING COMMANDS
#   - bundle install
#   - rails db:migrate RAILS_ENV=development
#   - apt-get -y install --no-install-recommends sqlite3 //optional but helps in visualizing db data
#   - rails db:seed // optional, to populate developement data
#   - rspec // optional, to check that all test cases are passing

# RUN rails server
# rails s -b 0.0.0.0 -p 3000

# APIs accessible at: http://localhost:3000/