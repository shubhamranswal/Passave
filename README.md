<div align="center">
  <img src="https://github.com/shubhamranswal/Passave/blob/main/assets/images/logo.png?raw=true" 
    alt="Passave Logo" 
    width="120"
    style="margin-bottom: 8px;"
  />
  <h1 style="margin: 0;">Passave</h1>
</div>

<p align="center">
  <img src="https://img.shields.io/badge/Security-Zero%20Knowledge-2ea44f?style=flat-square" />
  <img src="https://img.shields.io/badge/Encryption-AES%20%7C%20Argon2-blue?style=flat-square" />
  <img src="https://img.shields.io/badge/Status-Active%20Development-orange?style=flat-square" />
  <img src="https://img.shields.io/badge/License-MIT-purple?style=flat-square" />
</p>

---

**Passave** is a modern, secure, cross-platform password manager built with a **vault-first, zero-knowledge architecture**.  
It helps users generate, store, and manage credentials securely across devices — without ever exposing secrets to the server.

> End-to-end encrypted password management with keys known only to you.

---g

## ✨ Key Highlights

- 🔒 **Zero-Knowledge Encryption** - Server never sees your passwords
- 🧠 **Vault-First Architecture** - Security before accounts
- 🔑 **Master Password + Recovery Key** - No fake resets, real safety
- 📱 **Multi-Device Sync** - Encrypted vault sync via cloud
- ⚡ **Autofill Support** - Across apps and websites
- 🔁 **KeePass Compatible** - Import & export supported
- 🧬 **Configurable Security Levels** - Encryption strength per credential
- 🌙 **Premium Dark UI** - Clean, calm, security-first design

---

## 🧠 Core Security Model

Passave is built on a **true zero-knowledge model**:

- 🔐 **Master Password**
   - Encrypts and decrypts the vault
   - Never stored or sent to the server

- 🗝 **Recovery Key**
   - Generated once during vault creation
   - Can recover the vault if the master password is forgotten
   - Must be saved by the user (Passave cannot recover it)

- 📲 **Trusted Device Reset**
   - If at least one device is unlocked and trusted
   - User can reset master password and re-encrypt vault

- 🔍 **Server Role**
   - Stores only encrypted vault blobs
   - Cannot read or decrypt user data
   - Sync ≠ recovery

> If both master password and recovery key are lost and no trusted device exists, the vault is unrecoverable — by design.

---

## 🧩 Features

### 🔐 Credential Management
- Store usernames, passwords, URLs, notes
- Strong password generator
- Password strength analysis
- Copy & reveal controls
- Secure notes support

### 🛡 Security Levels (Per Credential)
Each credential can be assigned a security tier:
- Low / Medium / High
- Encryption strategy varies per level
- Designed for flexibility and performance balance

### 🔄 Sync & Access
- Encrypted multi-device sync
- Offline-first access
- Secure local caching
- Encrypted backups & restore

### ⚡ Autofill
- System Autofill API integration
- App & browser login detection
- Credential suggestions with user consent
- Save new credentials after login/signup

### 🧬 KeePass Compatibility
- Import from KeePass databases
- Export encrypted vaults
- Open standards support

### 🔐 Authentication & Unlock
- Master password unlock
- Biometric unlock (fingerprint / face)
- Time-based auto-lock
- Trusted device management

### 📊 Security Awareness
- Login & device activity logs
- Password reuse detection
- Breach alerts (planned)
- Password change reminders
- Security score & insights

### 🎨 UX & Design
- Dark-mode first
- Figma-driven premium UI
- Clean, calm, security-focused layout
- Responsive across screen sizes

---

## 🛠 Tech Stack

- **Frontend:** Flutter
- **Backend:** Firebase (Firestore, Auth, Cloud Functions)
- **Encryption:** AES / Argon2 / PBKDF2 (strategy-based)
- **Platforms:** Android (iOS planned)
- **Design:** Figma-driven UI kits

---

## 🧪 Project Status

- ✅ Core UI complete (vault & credential flows)
- 🚧 Encryption & data model in progress
- 🚧 Autofill & sync planned
- 🚧 Onboarding & recovery flows planned

This project is actively being developed with a **security-first mindset**.

---

## 📜 License

This project is licensed under the [**MIT License**](LICENSE)

You are free to use, modify, and distribute this project with proper attribution.

---

## Designed and built by Shubham Singh Ranswal

- 🌐 Portfolio: https://shubham-ranswal.web.app/
- 💼 LinkedIn: https://www.linkedin.com/in/shubhamranswal

---

## ⚠️ Security Philosophy

Passave will **never**:
- Store master passwords
- Provide fake “password reset” emails
- Access user vault data
- Compromise encryption for convenience

Security is a contract. Passave keeps it.
