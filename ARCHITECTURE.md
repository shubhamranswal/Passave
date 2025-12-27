# Passave – Architecture Overview

This document describes the **high-level architecture, security model, and data flow** of Passave.

Passave is designed as a **vault-first, zero-knowledge password manager** where:
- Users control all encryption keys
- The server acts only as an encrypted data store
- Security decisions are explicit and intentional

---

## 🧠 Core Architectural Principles

1. **Zero-Knowledge**
   - The backend never has access to plaintext credentials
   - The backend never receives the master password or recovery key

2. **Vault-First Design**
   - The vault exists independently of accounts
   - Accounts are used only for sync and discovery, not encryption

3. **Client-Side Cryptography**
   - All encryption, decryption, and key derivation happen on the client
   - The server stores only encrypted blobs and metadata

4. **Explicit Trust Boundaries**
   - Devices are untrusted until verified
   - Recovery paths are limited and user-controlled

---

## 🏗 High-Level System Components

### 1️⃣ Client Applications
- Flutter-based mobile app (Android first, iOS planned)
- Responsible for:
  - UI rendering
  - Cryptographic operations
  - Local secure storage
  - Autofill integration
  - Vault state management

### 2️⃣ Backend Services
- Firebase (initially)
- Responsible for:
  - Encrypted vault blob storage
  - Device metadata
  - Sync orchestration
  - Account discovery

> Backend services are **blind** to vault contents.

---

## 🔐 Vault & Key Architecture

### Master Password
- Chosen by the user during vault creation
- Used to derive a **Vault Encryption Key (VEK)** via a KDF
- Never stored or transmitted

### Recovery Key
- Generated once during vault creation
- Acts as an alternative unlock mechanism
- Must be stored by the user
- Passave cannot regenerate it

### Trusted Devices
- A device becomes trusted after successfully unlocking the vault
- Trusted devices may:
  - Cache derived keys securely
  - Enable biometric unlock
  - Reset the master password (re-encryption)

---

## 🔑 Key Derivation & Encryption Flow (Conceptual)

```

Master Password
│
▼
Key Derivation Function (Argon2 / PBKDF2)
│
▼
Vault Encryption Key (VEK)
│
▼
Encrypted Vault

```

- The same process applies when unlocking via recovery key
- Encryption strategy may vary by security level

---

## 🧬 Credential Model (Conceptual)

Each credential contains:
- Identifier (UUID)
- Website / App name
- Username
- Password
- Optional notes
- Security level
- Metadata (timestamps, tags)

All sensitive fields are encrypted **individually or as part of the vault**, depending on the security tier.

---

## 🛡 Security Levels

Passave supports multiple **security levels per credential**:

| Level | Characteristics |
|----|----|
Low | Faster encryption, lower KDF cost |
Medium | Balanced security & performance |
High | Stronger KDF parameters, higher cost |

Security levels influence:
- Key derivation parameters
- Encryption strategy
- Access behavior

---

## 🔄 Sync Architecture

- Encrypted vault blobs are synced to the backend
- Sync operates on **opaque encrypted data**
- Conflict resolution happens at the vault level
- Offline-first: vault is usable without network access

Sync does **not** imply recoverability.

---

## 📱 Device Onboarding Flow

### First Device
1. User creates vault
2. Master password + recovery key generated
3. Vault encrypted locally
4. Optional account sign-in for sync
5. Device marked as trusted

### Additional Device
1. User signs into account
2. Encrypted vault downloaded
3. User enters master password or recovery key
4. Vault decrypted locally
5. Device becomes trusted

---

## 🔓 Unlock Mechanisms

Supported unlock methods:
- Master password (always valid)
- Biometric unlock (device-level convenience)
- Recovery key (fallback)

Biometrics never replace cryptographic secrets.

---

## 🔁 Password Reset & Recovery

Passave does **not** support server-side password resets.

Recovery options:
- Recovery key
- Trusted device re-encryption

If all recovery methods are lost, the vault is permanently inaccessible.

---

## ⚠️ Threat Model Summary

### Protected Against
- Server-side breaches
- Database leaks
- Insider access
- Network interception

### Not Protected Against
- Compromised user devices
- Malware or keyloggers
- Weak master passwords
- User negligence

---

## 🧭 UI & State Architecture

- Feature-based structure
- Vault state determines navigation:
  - Locked
  - Empty
  - Unlocked
- UI layers never handle raw cryptographic logic directly

---

## 🛠 Technology Stack

- **Frontend:** Flutter
- **Backend:** Firebase (Firestore, Auth)
- **Crypto:** AES + KDF (Argon2 / PBKDF2)
- **Storage:** Secure local storage + cloud sync
- **Design:** Figma-driven UI system

---

## 🚧 Evolution & Future Work

Planned architectural extensions:
- Browser extensions
- Desktop apps
- Advanced sync conflict handling
- Breach detection integrations
- Optional enterprise features

All future features must preserve zero-knowledge guarantees.

---

## 📌 Final Notes

Passave favors:
- Explicit security tradeoffs
- Honest UX
- Minimal trust assumptions

If something cannot be done securely, it is not done at all.

That is the architecture.
