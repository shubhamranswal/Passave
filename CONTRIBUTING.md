# Contributing to Passave

Thanks for your interest in contributing to **Passave**!  
This project values **security, clarity, and correctness** over speed or shortcuts.

Please read this guide before submitting issues or pull requests.

---

## 🧠 Contribution Philosophy

Passave is:
- Security-first
- Zero-knowledge
- Vault-centric
- UX-conscious

Contributions that compromise these principles will not be accepted.

---

## 🧩 Ways to Contribute

You can help by:
- Reporting bugs
- Suggesting improvements
- Improving documentation
- Refactoring UI components
- Adding tests
- Reviewing code

---

## 🐞 Reporting Issues

Before opening an issue:
- Search existing issues
- Ensure it’s reproducible
- Provide clear steps and expected behavior

For **security vulnerabilities**, see `SECURITY.md` instead.

---

## 🛠 Development Setup

Basic setup:
```bash
git clone https://github.com/<your-username>/passave.git
cd passave
flutter pub get
flutter run
```

Make sure:

* `flutter doctor` shows no critical issues
* You are using a stable Flutter channel

---

## 🧱 Project Structure Guidelines

* Feature-based architecture (`features/vault/...`)
* No UI drift from the defined design system
* Reusable widgets live in appropriate scopes
* Avoid dumping components into `shared/` unnecessarily

---

## 🎨 UI Contributions

UI changes must:

* Follow the Passave design system
* Match Figma-inspired layouts
* Avoid Material defaults unless explicitly intended
* Maintain dark-mode-first styling

If unsure, open a discussion before large UI changes.

---

## 🔐 Security-Sensitive Code

For any changes involving:

* Encryption
* Key derivation
* Sync logic
* Authentication or recovery

Please:

* Clearly document assumptions
* Avoid “clever” shortcuts
* Prefer explicit, readable logic
* Expect deeper review

---

## 📦 Pull Request Guidelines

* Keep PRs focused and small
* Explain *why*, not just *what*
* Reference relevant issues
* Ensure code compiles and runs
* Follow existing code style

Draft PRs are welcome for early feedback.

---

## 🚫 What Not to Contribute

* Hardcoded secrets or keys
* Logging sensitive data
* Weak cryptographic practices
* Features that break zero-knowledge guarantees
* UI changes without design rationale

---

## 💬 Community & Conduct

Be respectful.
Be constructive.
Assume good intent.

We’re building something that handles people’s most sensitive data.

---

## ❤️ Final Note

Good security is boring.
Good UX is invisible.
Good software is intentional.

If you align with that, you’re welcome here.

