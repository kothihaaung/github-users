# GitHub Users

A SwiftUI iOS app for exploring GitHub users and their repositories. Built with modern Apple technologies and best practices for async data loading and UI responsiveness.

---

### 🌞 Light Mode

| | | |
|---|---|---|
| <img src="Screenshots/users_w1.png" width="200"/> | <img src="Screenshots/users_w2.png" width="200"/> | <img src="Screenshots/users_w3.png" width="200"/> |

---

### 🌙 Dark Mode

| | | |
|---|---|---|
| <img src="Screenshots/users_b1.png" width="200"/> | <img src="Screenshots/users_b2.png" width="200"/> | <img src="Screenshots/users_b3.png" width="200"/> |

---

## 🛠 Technologies Used

- **Xcode 16.4**
- **SwiftUI**
- **Alamofire** – for handling HTTP networking
- **Combine** – for reactive data flow
- **SDWebImageSwiftUI** – for efficient image loading and caching
- **Swift Concurrency + Combine** – used together for reactive flow and async bindings in SwiftUI  

---

## 🧩 Compatibility Notes

This project uses Swift Concurrency features including `Sendable` protocol conformance.

- Swift Concurrency is available since **Xcode 13 (Swift 5.5)**
- `Sendable` support and strict enforcement is more mature and stable in **Xcode 16.4**
- Using older Xcode versions (14 or 15) may not able to run this project properly

---

## 🚀 Features

- 🔍 Browse GitHub **users** with avatar, login, and ID
- 👤 View **user details**, including their public repositories
- 🌐 Open **repositories** directly in a WebView
- 🔄 Implements **GitHub paging**:
  - Different paging strategies for **users** (based on `since`) and **repositories** (pagination)
- ♻️ Smooth **continuous loading** (infinite scroll) for both:
  - User list screen
  - User detail screen with repositories

---


## 🏗 Architecture & Project Structure

This project is designed following **Clean Architecture** principles as outlined by Uncle Bob:

- **Separation of concerns** between domain, data, and presentation layers  
- Clear boundaries to make code testable, maintainable, and scalable  
- Inspired by [The Clean Architecture (Uncle Bob’s blog)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

Modules are organized as **Swift Packages**, modeled after Apple’s **Backyard Birds** sample:

- Each module encapsulates a feature or layer  
- Promotes modularity and reusability  
- Inspired by [Backyard Birds Sample - Apple Developer Documentation](https://developer.apple.com/documentation/swiftui/backyard-birds-sample)

---

## ⚠️ Simulator Issue (Known Limitation)

While running Unit tests, I encountered an issue on the **iPhone 16 simulator**. I would suggest to change to other simulators. In my case, it worked with **iPhone 16 Pro simulator**.

