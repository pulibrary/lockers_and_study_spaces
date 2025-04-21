# locker_and_study_spaces
An application to manage and reserve locker and study spaces for the library.  This is a replacement for the system already developed on lib-dbserver

[![CircleCI](https://circleci.com/gh/pulibrary/lockers_and_study_spaces/tree/main.svg?style=svg)](https://circleci.com/gh/pulibrary/lockers_and_study_spaces/tree/main)

## Ruby version

  3.4.1

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

## Database seeding for development
* If you want a set of example data for development, seed the database. 
* This data includes *fake* lockers and study spaces for Firestone, and users with fake UIDs. 
* This seed data should not be used in a production environment. 
* You can uncomment or comment lines at the beginning of the file depending on whether you want to default to the Lewis features being on or off, and whether you want to be a Lewis admin, a Firestone admin, or have which building you are an admin of be randomly assigned. 
```
bundle exec rails db:seed
```
* If you want to see what your database will look like from a fresh seed, run
```
bundle exec rails db:seed:replant
```

## Development

   * start the rails server
     ```
     bundle exec rails s
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
* To run all the ruby tests, run `bundle exec rspec`
* To run a specific ruby test, run `bundle exec rspec path/to/some_spec.rb:line_number`
* To run the js tests, run `yarn test`
* To see a test in Chrome while you run it, run `RUN_IN_BROWSER=true bundle exec rspec path/to/some_spec.rb:line_number`
* To calculate coverage, run `COVERAGE=true bundle exec rspec`

### Troubleshooting the tests
If you have unexplained failures in the feature specs locally, but not in CI, it could be that an older version of Lux is hanging around causing trouble. Try moving the old repo and re-cloning from github, and see whether that fixes the issue.
## Running eslint

`yarn run lint`

## Deployment instructions

We us capistrano for deployment.  Run `cap staging deploy` to deploy the main branch to staging.  Run `BRANCH=mine cap staging deploy` to deploy the min branch to staging
