## Supabase Auth & Database

This Flutter application demonstrates authentication, CRUD operations, and integration with Supabase. The app allows users to sign up, log in (including via Google Sign-In), and perform CRUD operations on notes stored in a Supabase database. Note that this is a prototype CRUD app without any user-specific logic.

### Features

User Authentication:
Email/password sign-up and sign-in using Supabase authentication.
Google sign-in using flutter_appauth for iOS and google_sign_in for Android.

Notes Management:
Create, read, update, and delete (CRUD) notes using Supabase as the backend database.

Persistent Sessions:
Session management using Supabase's onAuthStateChange listener.

Google Sign-In:
Integrated Google Sign-In for both Android and iOS platforms using OAuth.


### Packages Used

`supabase_flutter` – To handle authentication and database interactions.<br />
`flutter_appauth` – For OAuth authentication with Google on iOS.<br />
`google_sign_in` – For Google sign-in on Android.<br />
`crypto` – For generating secure, random strings and SHA256 hashing.

### Setup Instructions

Prerequisites:

- Supabase project setup with API keys
- Google Cloud project for OAuth (Google sign-in)
- Configure Supabase: Update the following Supabase-related variables in your code:

```
  final String databaseUrl = 'YOUR_SUPABASE_URL';
  final String databaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

Configure Google OAuth:
- For Android, provide the web client ID from your Google Cloud project in _googleSignIn() method.
- For iOS, use flutter_appauth with a configured OAuth redirect URL and set the correct clientId and discoveryUrl.



