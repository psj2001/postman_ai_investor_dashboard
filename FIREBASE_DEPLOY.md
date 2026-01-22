# Deploy Flutter Web App to Firebase Hosting

Follow these steps to host your **Investor Revenue Dashboard** on Firebase.

---

## Prerequisites

1. **Flutter** – [flutter.dev](https://flutter.dev) (with web enabled)
2. **Firebase CLI** – [firebase.google.com/docs/cli](https://firebase.google.com/docs/cli)

---

## 1. Install Firebase CLI

```bash
npm install -g firebase-tools
```

---

## 2. Log in to Firebase

```bash
firebase login
```

---

## 3. Link Your Firebase Project

Create a project in the [Firebase Console](https://console.firebase.google.com) if you don’t have one, then run:

```bash
firebase use --add
```

- Select your project (or create one).
- Choose an alias, e.g. `default`.

This updates `.firebaserc` with your project ID.  
Alternatively, edit `.firebaserc` and replace `REPLACE_WITH_YOUR_PROJECT_ID` with your Firebase project ID.

---

## 4. Build the Flutter Web App

```bash
flutter build web
```

Output goes to `build/web/`, which is configured as the Hosting `public` directory in `firebase.json`.

---

## 5. Deploy

```bash
firebase deploy
```

Or deploy only hosting:

```bash
firebase deploy --only hosting
```

---

## 6. Open Your App

After deploy, Firebase prints a Hosting URL, for example:

- **Live:** `https://<project-id>.web.app`
- **Preview:** `https://<project-id>.firebaseapp.com`

---

## One-time setup (optional)

If you prefer to run everything in sequence:

```bash
npm install -g firebase-tools
firebase login
firebase use --add
```

Then for each new deploy:

```bash
flutter build web
firebase deploy --only hosting
```

---

## Troubleshooting

| Issue | What to do |
|-------|------------|
| `No project active` | Run `firebase use --add` and select your project. |
| `Build failed` | Run `flutter pub get` and `flutter build web` again. |
| 404 on refresh / deep links | The `rewrites` in `firebase.json` should send all routes to `index.html`. If not, check that `build/web` is the `public` folder. |
| Blank page | Check the browser console. Ensure `flutter build web` completed without errors. |

---

## Files added for Firebase Hosting

- **`firebase.json`** – Hosting config: `public: "build/web"`, SPA rewrites to `index.html`.
- **`.firebaserc`** – Project ID; set via `firebase use --add` or by editing manually.
