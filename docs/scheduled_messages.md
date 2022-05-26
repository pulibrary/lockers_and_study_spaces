To add a new type of message:

1. Create a new model that inherits from `ScheduledMessage`.  By default, your new scheduled messages will refer to the LockerAssignment model.
    1. If your type of message refers to a different model (say StudyRoomAssignment), override the `assignment_model` method in your new model.
1. Create a new controller that inherits from `ScheduledMessagesController`.
1. In `ScheduledMessagesController` itself, modify the `method_missing` method's case statement to include your new controller.  This will allow all the route helpers to work automagically.
1. Add your new resource to `config/routes`
