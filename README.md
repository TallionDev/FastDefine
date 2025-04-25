# FastDefine
FastDefine MT2
╔══════════════════════════════════════════════════════╗
║                     README - UTILITAR                ║
╚══════════════════════════════════════════════════════╝

# 📦 FastDefine - Sistem automat de extragere coduri condiționale

👤 **Developer**: Tallion  
📬 **Contact**: Discord - tallion0127 

---

## 📁 Structura principală

### `SURSA_GAME_DB_BINARY_PRINCIPALA`
➡️ Folderul care conține sursa originală (client/server).  
➡️ Scriptul `start.py` va scana recursiv acest director și va extrage blocurile de cod condiționale pe baza `#define-urilor`.

---

### `SISTEMUL_EXTRAS_PRIN_DEFINE`
➡️ Aici sunt salvate fișierele `.cpp`, `.h`, `.py` care conțin doar codul relevant pentru fiecare define.  
➡️ Este practic o copie filtrată, ideală pentru documentație sau creare tutoriale.

---

### `GlobalDefines.h`
➡️ Fișier auto-generat care conține lista cu toate `#define`-urile introduse de utilizator.  
➡️ **Nu edita manual** acest fișier – modificările trebuie făcute din scriptul `Adauga_Define.bat`.

---

## 🟩 Scripturi principale

### `Adauga_Define.bat`
➕ Rulează acest script pentru a adăuga un nou define (`ENABLE_SYSTEM_NAME`) în fișierul `GlobalDefines.h`.

---

### `Start.bat`
🚀 Pornește scriptul Python `start.py`, care face scanarea completă a sursei și extrage:

- Blocuri `#ifdef / #ifndef / #if defined(...)`
- Blocuri Python: `if app.ENABLE_SYSTEM:`
- Define-uri directe: `#define XYZ`

⚠️ Înainte de rulare, verifică să fie configurată calea corectă către `pythonw.exe` în interiorul fișierului `.bat`.

---

### `Curata.bat`
🧹 Șterge fișiere temporare sau generate anterior în folderul `SISTEMUL_EXTRAS_PRIN_DEFINE`.  
Ideal de rulat înainte de o nouă extragere.

---

### `Sterge_Tot.bat`
💣 Resetează complet sistemul FastDefine.  
Șterge toate folderele generate, define-urile adăugate, fișierele `.cpp .h .py` și alte scripturi auxiliare.  
**Folosește cu grijă!**

---

## ⚠️ Recomandări importante

- Nu edita manual fișierele generate – rulează scriptul din nou pentru actualizare.
- Verifică codul extras în raport cu sursa originală.
- Toate fișierele generate sunt în scop informativ sau pentru tutoriale.

---

## 🧠 Succes în dezvoltare!
## ⚠️ Recomandare sa rulati FastDefine.exe
╔════════════════════════════════════╗  
║   Mult succes în dezvoltarea ta!  ║  
║        Tool creat de Tallion      ║  
╚════════════════════════════════════╝  
