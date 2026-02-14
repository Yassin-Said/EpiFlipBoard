# 🚀 EpiFlipBoard — Full Stack Developer Guide

Welcome to **EpiFlipBoard**, a full-stack social platform designed to share, discover, and interact with personalized content.

This README provides **everything you need to install, run, and contribute to the project.**

---

# 📌 Table of Contents

- Project Overview  
- Architecture  
- Backend Setup  
- Frontend Setup  
- Database (Supabase)  
- Project Structure  
- Environment Variables  
- Useful Commands  
- Contribution  

---

# 📖 Project Overview

**EpiFlipBoard** is a modern social application featuring:

- Personalized feed  
- Tag system  
- Follow system  
- Smart search  
- Notifications  
- Real-time interactions  

---

# 🏗 Architecture

```EpiFlipBoard/
│
├── back-end/ → Python API (FastAPI + Render)
├── front-end/ → Flutter Application
└── database/ → Supabase (PostgreSQL + Auth + Storage)
```

# 🧠 Backend — Python + FastAPI + Render

## Technologies

- Python 3.10+
- FastAPI
- Uvicorn
- Render

---

## Installation

### 1. Create virtual environment

```bash
python -m venv venv
```

```Windows (PowerShell)
venv\Scripts\activate
```

```Linux / macOS
source venv/bin/activate
```

### 2. Install dependencies

```
pip install -r requirements.txt
```

### 3. Run backend locally

```
uvicorn main:app --reload
```

```Backend URL:
http://localhost:8000
```

```Swagger API documentation:
http://localhost:8000/docs
```

## 🔧 Backend — Useful Commands

| Command | Description |
|------------|--------------|
| `python -m venv venv` | Create virtual environment |
| `venv\Scripts\activate` | Activate venv (Windows) |
| `source venv/bin/activate` | Activate venv (Linux/macOS) |
| `pip install -r requirements.txt` | Install dependencies |
| `uvicorn main:app --reload` | Start backend server |
| `pip freeze > requirements.txt` | Save dependencies |
| `deactivate` | Exit virtual environment |

# Frontend — Flutter

## Install Flutter

Official installation guide:
👉 https://docs.flutter.dev/get-started/install

```Install dependencies
flutter pub get
```

```Run application
flutter run
```

```Build release APK
flutter build apk --release
```

```Generated APK:
build/app/outputs/flutter-apk/app-release.apk
```

## 🎨 Flutter — Useful Commands

| Command | Description |
|--------------|--------------|
| `flutter doctor` | Check Flutter installation |
| `flutter pub get` | Install dependencies |
| `flutter run` | Run app on emulator/device |
| `flutter clean` | Clean build cache |
| `flutter build apk --release` | Build production APK |
| `flutter build appbundle` | Build Play Store bundle (AAB) |
| `flutter devices` | List connected devices |
| `flutter emulators` | List available emulators |
| `flutter create .` | Regenerate project files |
| `flutter -h` | Show Flutter help |

# Database — Supabase

## Dashboard:
👉 https://supabase.com

### Supabase is used for:
- PostgreSQL database
- Authentication
- File storage
- Real-time features

# Project Structure

## Flutter structure

```lib/
│
├── pages/      → UI pages
├── models/     → Data models
├── services/   → API services
├── widgets/    → Reusable widgets
└── main.dart   → Entry point
```

### Environment Variables

Create a .env file inside backend folder:
```
SUPABASE_URL=
SUPABASE_KEY=
DATABASE_URL=
SECRET_KEY=
```

# 🔁 CI/CD

GitHub Actions is used for:
- Automatic build
- Secure APK signing 
- Artifact upload
- Full CI/CD pipeline

# 🤝 Contribution

Contributions are welcome.
Workflow
Fork repository
Create new branch
Develop feature
Commit changes
Open Pull Request
Rules
Clean code
Respect architecture
Proper commits
Tested code

