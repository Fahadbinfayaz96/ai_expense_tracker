# AI Expense Tracker

An AI-powered expense tracking application built with Flutter that helps users manage daily expenses, scan receipts using Gemini AI, and generate intelligent spending insights.

## ✨ Features

### 💰 Expense Management
- Add, edit, and delete expenses
- Categorize expenses
- Select custom expense dates
- Local persistence using Hive
- Swipe to delete with confirmation dialog

### 🤖 AI Receipt Scanner
- Scan receipts using the device camera
- Import receipts from the gallery
- Automatically extracts:
  - Merchant name
  - Amount
  - Date
  - Expense category
- Auto-fills the expense form for quick saving
- Permission handling for camera and gallery access

### 📊 AI Spending Insights
- Generates spending analysis using Gemini AI
- Displays:
  - Total spending
  - Category-wise breakdown
  - Largest expense
  - Spending trends
  - Personalized recommendations
- Insights are cached locally for faster loading
- Cache is automatically invalidated whenever expenses change

### 🎨 Modern UI
- Material 3 design
- Responsive layout using Flutter ScreenUtil
- Google Fonts (Sora)
- Light & Dark theme support
- Clean and minimal interface

---

## 🏗 Architecture

The project follows **Clean Architecture**.

```
lib/
│
├── core/
│   ├── di/
│   ├── error/
│   ├── network/
│   ├── router/
│   └── theme/
│
├── features/
│   ├── expense/
│   ├── receipt/
│   └── insights/
│
└── main.dart
```

Each feature contains:

```
data/
domain/
presentation/
```

---

## 🛠 Tech Stack

- Flutter
- Dart
- flutter_bloc
- Clean Architecture
- Hive
- Dio
- GetIt
- GoRouter
- Gemini API
- Image Picker
- Permission Handler
- Flutter ScreenUtil
- Google Fonts
- Dartz (Either)
- Equatable

---

## 📱 Screens

- Home
- Add Expense
- Edit Expense
- Receipt Scanner
- AI Spending Insights

---

## 📦 Dependencies

Major packages used:

- flutter_bloc
- hive
- hive_flutter
- get_it
- dio
- dartz
- go_router
- image_picker
- permission_handler
- flutter_dotenv
- flutter_markdown
- flutter_screenutil
- google_fonts
- intl
- uuid

---

## 🔑 Environment Variables

Create a `.env` file in the project root.

```env
GEMINI_API_KEY=YOUR_API_KEY
```

Obtain your API key from:

https://aistudio.google.com/

---

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/Fahadbinfayaz96/ai_expense_tracker.git
```

### 2. Navigate to the project

```bash
cd ai_expense_tracker
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Generate Hive adapters

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 5. Add your Gemini API key

Create a `.env` file:

```env
GEMINI_API_KEY=YOUR_API_KEY
```

### 6. Run the application

```bash
flutter run
```

---

## 📂 Data Storage

Expenses and cached AI insights are stored locally using Hive.

No backend server is required.

---

## 🧠 AI Integration

The application integrates with **Google Gemini** to:

- Extract structured data from receipt images
- Generate AI-powered spending insights


---

## 🔮 Future Improvements

- Expense charts and analytics
- Search and filtering
- Monthly reports
- Export to PDF/CSV
- Cloud synchronization
- Authentication
- Unit and widget tests
- Budget planning
- Multi-currency support

---

## 👨‍💻 Author

**Fahad Bin Fayaz**

GitHub: https://github.com/Fahadbinfayaz96

LinkedIn: https://linkedin.com/in/fahad-bin-fayaz-87349221a/

---

## 📄 License

This project is licensed under the MIT License.
