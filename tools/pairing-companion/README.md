# Pairing Companion

This is a small browser companion for testing the real Firebase pairing flow with one Android phone. It acts as the second partner and can also generate the code that the phone enters.

## Run

From the repository root, serve this directory over HTTP:

```bash
python3 -m http.server 8080 --directory tools/pairing-companion
```

Open `http://localhost:8080` on the computer. If the phone is on the same network, the computer's LAN address can be used instead.

## Test flow

1. Start the Flutter app in debug mode on the phone.
2. Create or sign in to the first test account in the app.
3. Open this companion in the browser.
4. Create a separate test account, or sign in with an existing partner account.
5. Either enter the code from the phone and choose **Approve pairing**, or choose **Generate a code for the phone** and enter that code in the app.
6. Complete confirmation on the phone.
7. After both accounts connect, use the companion to send a partner check-in, request a phone check-in, or start/end Live Sharing.

The companion uses the project's Firebase Auth and Firestore. It intentionally requires a separate account because Firebase rejects pairing an account with itself.
