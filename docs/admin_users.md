### Admin users

Each library has one or more admin users, who can manage lockers,
locker applications, and locker assignments.  Firestone admin users
can also manage study rooms.

#### Adding a new admin user

1. Find the user's netid.
1. In the rails console:
    ```
    new_admin = User.find_or_create_by uid: 'USER_NET_ID'
    new_admin.admin = true
    new_admin.building = Building.find_by name: 'Lewis Library' # or 'Firestone Library'
    new_admin.save
    ```
1. Confirm with the user that they can log in and access the needed functions.
