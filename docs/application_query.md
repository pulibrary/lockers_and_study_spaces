### Query for completed applications

We had a request for data on the number of locker applications for the Lewis library

#### Running the query

1. ssh into a production server
    ```
    ssh deploy@lockers-and-study-spaces-prod1.princeton.edu
    ```
1. Navigate to the current directory and start the Rails console
    ```
    cd /opt/lockers_and_study_spaces/current
    bundle exec rails c
    ```
1. In the rails console:
    ```
    start_date = Date.new(2024, 8, 1)
    end_date = Date.new(2025, 7, 31)
    apps = LockerApplication
        .where(created_at: start_date.beginning_of_day..end_date.end_of_day)
        .where(complete: true)
        .where(building: 2)
    apps.length
    ```
    Where building 1 is Firestone and 2 is Lewis
