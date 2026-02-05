## NOYALY: Stress Monitoring App

### 1. Overview
This project is built in fulfillment of the requirements for the module ET0529: Mobile Application Development CA3. It aims to develop a **Stress Monitoring App** designed to help users check in with their stress levels, learn about stress, and reflect on their well-being over time. It is built around the Perceived Stress Scale (PSS-10), a widely used research-based questionnaire for measuring perceived stress.

> ⚠️ Noyaly is not a medical or diagnostic tool. It is intended for self-reflection and stress awareness only.

---

### 2. Features
#### Home
* Contains 10 PSS-10 research-based questions
* Likert scale responses (Never → Very Often)
* One-time stress score calculated per check-in
* Results are automatically saved
#### Articles
* Curated articles related to understanding and managing stress from verified sources
* Supports user awareness beyond just numerical scores
#### Report
* Categorises stress level to better understand self
* Visualises stress history using chart
* Provide song recommendations for emotional regulations
#### User profile
* Display basic user information
* Stores user preference

--- 

### 3. Tech Stack
| Layer           | Technology 
|-----------------|------------
| **Design**      | Figma
| **Frontend**    | Flutter (Dart)
| **Backend**     | Firebase
| **Database**    | Cloud Firestore
| **Version Control** | Git & GitHub 

#### 3.1. libraries
| Library | Version | Purpose |
|---------|---------|---------|
| `url_launcher` | ^6.2.6 | Open URLs in browser or external apps |
| `webview_flutter` | ^4.10.0 | Launch articles in-app for mobile |
| `intl` | ^0.19.0 | Format months (1–12 → Jan–Dec) and handle localization |
| `fl_chart` | ^1.1.1 | Render graphs (e.g., stress history score) |
| `http` | ^1.2.2 | Perform HTTP requests |
| `google_maps_flutter` | ^2.6.1 | Display Google Maps on mobile |
| `google_maps_flutter_web` | ^0.5.6 | Display Google Maps on web |
| `firebase_core` | ^4.4.0 | Initialize Firebase services |
| `firebase_auth` | ^6.1.4 | Handle user authentication via Firebase |
| `cloud_firestore` | ^6.1.2 | Store and query data with Firestore |


---

### 4. Getting Started

#### 4.1. Clone Repository
```bash
git clone https://github.com/marytheshepherd/noyaly.git
cd noyaly
```

#### 4.2. Get the libraries
```bash
flutter pub get
```
#### 4.3. Set up Firebase

##### 4.3.1 users
- **Key fields:**
  - `string displayName`
  - `string email`
  - `bool notification`
  - `int streak`
  - `timestamp createdAt`
  - `timestamp lastActiveDate`

###### 4.3.2 stress_entries 
(subcollection of users)
- **Key fields:**
  - `int score`
  - `date date`
  - `timestamp createdAt`

##### 4.3.3 articles
- **Key fields:**
  - `string imageUrl`
  - `string title`
  - `string url`

##### 4.3.4 stress_labels
- **Key fields:**
  - `array gentleTips`
  - `string imageAsset`
  - `string key`
  - `string shortLabel`
  - `string summary`
  - `string title`
  - `string whyDescription`
  - `timestamp updatedAt`

##### 4.3.5 User Authentication
- Enable **Email/Password** sign‑in method



#### 4.4. Run
```bash
flutter run --dart-define=GOOGLE_MAPS_API_KEY=<INSERT_YOUR_API_KEY_HERE>
```




