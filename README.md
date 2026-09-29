# CivicVoice 🏛️
**A Centralized Civic Information & Issue Reporting Portal**  
*College Capstone / Final Year Software Engineering Project*

---

## 1. Project Overview & Problem Statement

### Problem Statement
In local governance and municipal jurisdictions, citizens face recurring obstacles:
1. **Fragmented Voter Services:** Voter registration, Form 6/8 instructions, and electoral qualifications are scattered across cumbersome portals without contextual guidance.
2. **Opaque Candidate Information:** Voters often lack a neutral, factual platform to inspect candidate educational qualifications, background, and declared assets without bias or promotional political hype.
3. **Inconvenient Polling Booth Discovery:** Finding designated polling stations, booth accessibility (e.g. wheelchair ramps), and presiding officer details is challenging on election days.
4. **Uncoordinated Civic Grievances:** Citizens encounter broken street lights, potholes, drainage overflows, and garbage hazards without a straightforward way to report them with photographic evidence, geolocation, and real-time status tracking.

### Solution: CivicVoice
**CivicVoice** is a clean, practical Flutter mobile application built with **Material 3**. It consolidates voter registration guides, factual candidate profiles, polling booth discovery with offline cartography, and an end-to-end civic issue reporting pipeline with status lifecycle tracking.

---

## 2. Realistic College Design Philosophy

The application strictly avoids AI-generated gimmicks (excessive gradients, glassmorphism, neon colors, huge glowing buttons, floating shapes, or marketing copy). Instead, it adopts a **practical, government/civic utility design**:
* **Theme:** Civic Dark Navy (`#1B365D`) primary, Muted Forest Green (`#2D6A4F`) secondary, Off-White background (`#F6F8FA`), and subtle 1px borders (`#DCE2E8`).
* **Components:** Standard Flutter Material 3 widgets (`AppBar`, `NavigationBar`, `Card`, `ListTile`, `TextField`, `FilterChip`, `DropdownButtonFormField`, `FilledButton`, `OutlinedButton`, `Dialog`, `BottomSheet`, `ExpansionTile`).
* **Neutrality:** No candidate rankings, popularity scores, voting recommendations, or persuasive political messaging.

---

## 3. Project Directory Structure

```text
lib/
├── main.dart                       # App entry point, MultiProvider & Theme initialization
├── models/                         # Strongly-typed data models with fromMap() / toMap()
│   ├── candidate.dart              # Factual candidate affidavits & credentials
│   ├── civic_report.dart           # Grievance reports & status lifecycle history
│   ├── polling_booth.dart          # Booth coordinates, addresses & accessibility
│   ├── user_profile.dart           # Citizen authentication & ward enrollment
│   └── voter_info.dart             # Voter registration guides, FAQs & official links
├── screens/                        # User interface screens
│   ├── splash_screen.dart          # App launch & auth session check
│   ├── main_navigation_screen.dart # Bottom Navigation: Home | Explore | Reports | Profile
│   ├── auth/
│   │   ├── login_screen.dart       # Citizen login with dev quick-fill
│   │   ├── register_screen.dart    # New citizen registration & ward selection
│   │   └── forgot_password_screen.dart # Password recovery workflow
│   ├── dashboard/
│   │   └── dashboard_screen.dart   # Central civic hub & 2-3 recent reports
│   ├── voter_info/
│   │   ├── voter_info_screen.dart  # Searchable expandable voter guides
│   │   └── voter_detail_screen.dart# Mandatory documents & procedural steps
│   ├── candidates/
│   │   ├── candidate_list_screen.dart # Constituency filter & candidate cards
│   │   └── candidate_detail_screen.dart # Factual public affidavits & declarations
│   ├── polling_booths/
│   │   ├── polling_booth_screen.dart  # Nearby booths list & interactive map toggle
│   │   └── booth_detail_screen.dart   # Booth officer, address & directions
│   ├── reports/
│   │   ├── report_issue_screen.dart   # Grievance form (category, photo, GPS)
│   │   ├── my_reports_screen.dart     # Citizen grievance history & filter chips
│   │   └── report_detail_screen.dart  # Issue details & step-by-step progress timeline
│   └── profile/
│       ├── profile_screen.dart        # Citizen profile, electoral ID & settings
│       └── edit_profile_dialog.dart   # Update personal & ward particulars
├── widgets/                        # Modular, reusable presentation components
│   ├── civic_card.dart             # Standardized 1px bordered surface card
│   ├── info_banner.dart            # Official source and sample data disclaimers
│   ├── map_placeholder_widget.dart # Offline cartographic canvas with booth pins
│   ├── status_chip.dart            # Accessible status indicator badges
│   └── timeline_widget.dart        # Simple linear grievance lifecycle tracker
├── services/                       # Business logic, data repositories & bridges
│   ├── auth_service.dart           # Dual-mode authentication (Dev Mock + Firebase bridge)
│   ├── candidate_service.dart      # Candidate search and ward filtering
│   ├── firebase_service.dart       # Firestore paths, schemas & storage folders
│   ├── location_service.dart       # GPS lock simulation & Haversine distance
│   ├── mock_data.dart              # Curated, realistic sample dataset
│   ├── report_service.dart         # Report persistence & ID sequence generation
│   └── voter_service.dart          # Searchable voter information repository
├── providers/                      # ChangeNotifier state management
│   ├── auth_provider.dart          # Session state, profile updates & loading flags
│   ├── booth_provider.dart         # Booth queries, map/list view mode & selection
│   ├── candidate_provider.dart     # Candidate filtering by query and ward
│   └── report_provider.dart        # Grievance submissions & status updates
├── theme/
│   └── app_theme.dart              # Comprehensive Material 3 theme definitions
└── utils/
    ├── constants.dart              # App constants, categories & wards
    ├── formatters.dart             # Date, distance, and report ID formatting
    └── validators.dart             # Robust form field validators
```

---

## 4. Key Screens & Features

| Screen | Core Functionality |
| :--- | :--- |
| **Splash Screen** | Initializes services and checks authenticated citizen session. |
| **Login / Register** | Form validation, password visibility toggle, ward assignment, and one-tap dev quick-fill for viva testing. |
| **Dashboard** | Personalized greeting, four primary civic service action cards, recent 2–3 filed reports, and citizen helpline notice. |
| **Voter Information** | Searchable directory covering Form 6 registration, eligibility criteria, required documents, address change (Form 8), e-EPIC download, and official ECI portal links clearly segregated from general info. |
| **Candidate Profiles** | Neutral candidate cards with photo placeholders, constituency filter, declared education, professional history, public background, and asset disclosures as per Form 26. |
| **Polling Booth Locator** | List and Map view toggle, interactive offline cartography canvas with clickable pins, calculated distance (e.g., `1.2 km away`), wheelchair accessibility badges, and routing directions. |
| **Report Civic Issue** | Category selector (Road, Street Light, Garbage, Water Supply, Public Safety, Drainage, Traffic, Other), multiline description, GPS / ward picker, evidence image capture with preview, generating unique IDs like `CV-2026-0004`. |
| **My Reports** | Grievance history with filter chips (`All`, `Active`, `Submitted`, `In Progress`, `Resolved`), category badges, and quick-track links. |
| **Report Detail & Timeline** | Complete grievance audit log with an interactive step-by-step progress timeline: `Submitted` → `Under Review` → `In Progress` → `Resolved`. Includes a demonstration mode to simulate triage live during evaluation. |
| **Citizen Profile** | Displays full name, email, phone, EPIC voter card number, registered constituency, and settings. |

---

## 5. Firebase Architecture & Firestore Schema

CivicVoice is structured to operate seamlessly in **Offline Development Mode** (for instant demonstration without setup delays) and seamlessly scale to **Production Firebase**:

### Firestore Collections

#### 1. `users` collection
```json
{
  "uid": "citizen-demo-01",
  "name": "Aarav Patel",
  "email": "citizen@civicvoice.org",
  "phone": "9876543210",
  "constituency": "North Central Ward 12",
  "epicNumber": "XYZ-2026-90412",
  "registeredAt": "2025-08-15T10:00:00.000Z"
}
```

#### 2. `civic_reports` collection
```json
{
  "id": "CV-2026-0001",
  "userId": "citizen-demo-01",
  "title": "Street Light Not Working",
  "category": "Street Light",
  "description": "Two consecutive street light poles outside Green Valley Society have been dark for 4 days.",
  "location": "Green Valley Society Main Gate, North Central Ward 12",
  "latitude": 19.0772,
  "longitude": 72.8790,
  "imageUrl": "gs://civicvoice.appspot.com/issue_reports/CV-2026-0001.jpg",
  "status": "Submitted",
  "createdAt": "2026-09-28T09:30:00.000Z",
  "updatedAt": "2026-09-28T09:30:00.000Z",
  "statusHistory": [
    {
      "status": "Submitted",
      "timestamp": "2026-09-28T09:30:00.000Z",
      "remarks": "Report registered through CivicVoice portal and assigned ID CV-2026-0001."
    }
  ]
}
```

#### 3. `candidates` collection
```json
{
  "id": "cand-001",
  "name": "Dr. Ananya Sharma",
  "constituency": "North Central Ward 12",
  "party": "Progressive Civic Alliance (Sample)",
  "age": "44",
  "education": "Ph.D. in Urban Planning, M.Sc. in Public Policy",
  "professionalInformation": "Former Senior Research Fellow at Municipal Infrastructure Advisory Board",
  "background": "Platform focusing on road safety and rainwater harvesting mandate.",
  "source": "Public Election Commission Affidavit Records (Sample Ref: AFF-2026-NC12-01)",
  "declaredAssets": "Movable: ₹42 Lakhs | Immovable: ₹85 Lakhs"
}
```

#### 4. `polling_booths` collection
```json
{
  "id": "booth-104",
  "name": "ABC Municipal Model School - Booth 104",
  "boothNumber": "Polling Booth 104",
  "address": "Main Road, Civil Lines, South Ward 15",
  "latitude": 19.0680,
  "longitude": 72.8710,
  "constituency": "South Ward 15",
  "landmark": "Next to Civic Health Sub-Centre",
  "wheelchairAccessible": true,
  "contactOfficer": "K. V. Rao (Sector Officer)",
  "contactPhone": "022-2410-1014"
}
```

---

## 6. Security Rules (`firestore.rules`)

The project contains configured Firestore rules in [`firestore.rules`](file:///Users/riddhizunjarrao/Desktop/CivicVoice/firestore.rules):
* Citizen profiles can only be written by the authenticated user (`request.auth.uid == userId`).
* Voter information, candidate profiles, and polling booths are publicly readable, while mutations require administrator credentials.
* Civic issue reports can be created by authenticated citizens matching their own `userId`.

---

## 7. Setup & Execution Instructions

### Prerequisites
* Flutter SDK (version 3.19.0 or higher / tested on Flutter 3.44.8)
* Dart SDK (3.3.0 or higher)
* Android Studio / Xcode (for mobile emulators or physical devices) or Chrome for web preview

### Running the Application

1. **Clone / Navigate to Project Directory:**
   ```bash
   cd /Users/riddhizunjarrao/Desktop/CivicVoice
   ```

2. **Fetch Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Verify Code Health & Tests:**
   ```bash
   flutter analyze
   flutter test
   ```

4. **Run on Connected Device / Simulator:**
   * **Android:**
     ```bash
     flutter run -d android
     ```
   * **iOS (macOS required):**
     ```bash
     flutter run -d ios
     ```
   * **macOS Desktop / Chrome (Instant preview):**
     ```bash
     flutter run -d macos
     # or
     flutter run -d chrome
     ```

---

## 8. Viva & Evaluation Highlights

When presenting this project to professors and external examiners, emphasize:
1. **Ethical Civic Data Architecture:** Clear distinction between educational sample data and official state portals.
2. **Neutral Candidate Presentation:** Absence of algorithmic ranking, voting advice, or persuasive endorsements.
3. **Resilient Offline Design:** Polling booth distance calculation (Haversine formula) and custom-painted municipal map that work without proprietary API keys.
4. **End-to-End Issue Lifecycle:** The progression model from `Submitted` to `Under Review` to `In Progress` to `Resolved` with full timestamped audit logs.
5. **Clean Architecture:** Separation of concerns across `models/`, `services/`, `providers/`, and `widgets/` using standard Provider state management.
