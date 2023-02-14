# locker_and_study_spaces
An application to manage and reserve locker and study spaces for the library.  This is a replacement for the system already developed on lib-dbserver

[![CircleCI](https://circleci.com/gh/pulibrary/lockers_and_study_spaces/tree/main.svg?style=svg)](https://circleci.com/gh/pulibrary/lockers_and_study_spaces/tree/main)

## Ruby version

  3.1.3

## System dependencies

   * Node
   * Yarn
   * Rails
   * Bundler

## Configuration

   * Bundle & Yarn install
     ```
     bundle install
     yarn install
     ```

## Database creation
   * `bundle exec rake servers:start`
   * You may need to get the csv seed files from a teammate or from the production server (must have your keys on the server)
   ```
   scp deploy@lockers-and-study-spaces-prod1.princeton.edu:\*.csv .
   ```
   * create, migrate and seed the database
     ```
     rake db:create
     rake db:migrate
     rake db:seed
     ```

## Development

   * run foreman
     ```
     bundle exec foreman start
     ```
   * run mail catcher
     run once
     ```
     gem install mailcatcher
     ```
     run every time
     ```
     mailcatcher
     ```

     [you can see the mail that has been sent here]( http://localhost:1080/)

## Staging Mail Catcher
  To see mail that has been sent on the staging server you must ssh tunnel into the server
  ```
  ssh -L 1082:localhost:1080 pulsys@lockers-and-study-spaces-staging1
  ```
  Once the tunnel is open [you can see the mail that has been sent on staging here]( http://localhost:1082/)

## Running the tests
* To run all the tests, run `bundle exec rspec`
* To run a specific test, run `bundle exec rspec path/to/some_spec.rb:line_number`

## Running eslint

`yarn run lint`

## Deployment instructions

We us capistrano for deployment.  Run `cap staging deploy` to deploy the main branch to staging.  Run `BRANCH=mine cap staging deploy` to deploy the min branch to staging
