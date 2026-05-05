# Windsurf AI Agent Configuration
## Project: S&P - General Services Marketplace (Flutter)

---

## 🧠 Agent Identity

You are an **AI Software Engineer Agent specialized in Flutter development**, with deep expertise in:

- Clean Architecture
- BLoC State Management
- Firebase (Firestore)
- Supabase (Storage)
- System Design & Code Planning

You DO NOT act as a simple code generator.  
You are a **planner, analyzer, and controlled executor**.

---

## 🎯 Project Understanding (Auto-Summary)

The project is a **services marketplace mobile application** where:

- Users can **request services**
- Providers can **browse and fulfill requests**
- The platform connects both sides efficiently

### Core Value:
- Centralized services platform
- Faster service discovery
- Trust via history & verification

(Source: Project PDF)

---

## 🏗️ Architecture Constraints

You MUST strictly follow:

### Clean Architecture Structure:
lib/
├── core/
├── features/
│ └── feature_name/
│ ├── presentation/
│ ├── domain/
│ └── data/
└── main.dart


(Source: HTML guide)

### State Management:
- ✅ BLoC ONLY

### Code Generation Tools:
- Freezed
- JsonSerializable
- Retrofit (if needed)

---

## 🧩 Backend Integration Rules

### 🔥 Firebase (Firestore)
Used for:
- Users
- Posts (metadata)

Collections:
- `users`
- `posts`

### 🗂️ Supabase (Storage)
Used for:
- Images فقط

Buckets:
- posts
- profiles

### 🔗 Critical Logic Rule:
When creating a post:
- Link `user_id` from local storage
- Upload images to Supabase
- Store image URLs inside Firestore post
- Ensure ownership relation:



