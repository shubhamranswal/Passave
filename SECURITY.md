# Security Policy – Passave

Passave is a security-first password manager built on a **zero-knowledge, vault-first architecture**.  
This document explains our security philosophy, threat model, and how to responsibly report vulnerabilities.

---

## 🔒 Security Principles

Passave follows these non-negotiable principles:

- **Zero-Knowledge by Design**
    - The server never has access to plaintext passwords, master passwords, or recovery keys.
    - All sensitive data is encrypted client-side before sync.

- **User-Controlled Keys**
    - The master password encrypts the vault.
    - Passave does not store or transmit the master password.
    - Recovery is only possible via user-controlled mechanisms.

- **Explicit Tradeoffs**
    - If a user loses both the master password and recovery key and has no trusted device, the vault is unrecoverable.
    - This is a security feature, not a bug.

---

## 🧠 Threat Model (High-Level)

### What Passave Protects Against
- Server-side data breaches
- Unauthorized database access
- Insider access to stored data
- Network interception of synced data

### What Passave Does NOT Protect Against
- Compromised user devices
- Malware or keyloggers on the client
- Users voluntarily sharing credentials
- Weak or reused master passwords

---

## 🔑 Encryption Overview

- Vault encryption uses industry-standard algorithms (e.g. AES)
- Keys are derived using strong KDFs (e.g. Argon2 / PBKDF2)
- Encryption strategy may vary based on user-selected security level
- All cryptographic operations occur on the client

⚠️ Exact implementation details may evolve as the project matures.

---

## 🗝 Recovery Model

Passave supports **two recovery mechanisms**:

1. **Recovery Key**
    - Generated once during vault creation
    - Must be saved by the user
    - Passave cannot regenerate or recover it

2. **Trusted Device Reset**
    - If a user still has access to an unlocked device
    - Allows re-encryption with a new master password

Passave does **not** provide email-based vault resets.

---

## 🚨 Reporting a Vulnerability

If you discover a security vulnerability:

- **Do NOT** open a public GitHub issue
- **Do NOT** disclose details publicly

Instead:
- Contact the maintainer privately via GitHub or LinkedIn
- Include:
    - Clear description of the issue
    - Steps to reproduce
    - Potential impact

We aim to respond responsibly and promptly.

---

## 🛑 Responsible Disclosure

Please allow reasonable time for a fix before public disclosure.  
We appreciate responsible security research and community support.

---

## 📌 Final Note

Security is not a feature.  
It is a contract.

Passave exists to honor that contract.
