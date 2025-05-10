setup instructions : 

1- open the file in android studio
2- in terminal write "flutter pub get"
3- then "flutter run"
  ----------------------------------- OR -----------------------------------
download < apk > version from th link below
https://drive.google.com/drive/folders/1WwLpvfexGLWbsuOdJbPhU3qckDHrANcR

App Architecture:

State Management: flutter_bloc (Cubit)

Local Storage: sqflite for favorites & shared preferences for saving login 

Backend: Firebase Firestore for real-time bookings & Firebase Auth for user authentication

Structure:
lib/authentications: UI screens (login, register)

lib/screens: UI screens (home, booking, favorites)

lib/cubits: Logic and state management (login, register, booking, home, favorites)

lib/database: Firestore helpers and local SQLite helper

lib/constants: Constants such as shared keys, global values, etc.

lib/components: reusable widgets in the code 

Business Understanding answers:

the goal of this app to help users to book appointments with various specialists ( doctors, consultant, etc)
and also they can manage their appointments and cancel them if they want, search for specialists by category 
and add them in favourite list to ease search for them for every time they want to book an appointment.

User Experience Thought Process:

To enhance the booking experience, i suggest allow to users to Reschedule their appointments and also to make the app better add after login a choice if the user is ( clint or specialist ) clint: we did it in the app.
specialist: he write his data to show it to users for booking appointments with him.

Known limitations:

1-Booking time is only selectable by hour 
2-No push notifications or reminders implemented yet
3-no reschedule for appointments.
4-backend has only two specialist (for test) 
