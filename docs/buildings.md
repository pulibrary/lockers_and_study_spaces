As an admin in the system, you can only see lockers that are associated with your
building.  If you need to use the UI as the admin for a different building, you
can do so with the rails console:

```
me = User.find_by_uid 'net_id'
me.building = Building.find_by_name 'Firestone Library' # or 'Lewis Library'
me.save
```