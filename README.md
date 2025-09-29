# BeHealth-DB

# 📄 BeHealth Database

## 🚀 Présentation
**BeHealth-DB** contient la structure de la base de données utilisée par **BeHealth** (backend et mobile).
Elle stocke utilisateurs, repas, activités, programmes, notifications et historiques.

---

## 👥 L'équipe BeHealth
Ce projet a été réalisé dans le cadre d’un projet de cours pour nos études, plus précisément pour le cours de **Technologie Internet** avec **Mr. Palermo**.

- [Delvigne Marius](https://github.com/mariusdelvigne)
- [Reynaert Robin](https://github.com/RobinRHELHa)
- [Leroy Matteo](https://github.com/rococooooo)
- [Malbecq Nathan](https://github.com/NathanHELHa)

---

## 🛠️ Structure de la base
- `users`  
- `meals`  
- `activities`  
- `sleep`  
- `programs`  
- `subscriptions`  
- `notifications`  
- `logs`

---

## 📂 Installation
### Pré-requis
- PostgreSQL ou MySQL

### Création de la base
```sql
CREATE DATABASE behealth;
```
Importer le script `behealth_schema.sql` :
```bash
psql -U postgres -d behealth -f behealth_schema.sql
```
Configurer le backend pour se connecter à la DB.

---

## 🔗 Backend associé
Le frontend communique avec le backend **BeHealth**, disponible ici :
👉 [BeHealth Backend](https://github.com/mariusdelvigne/BeHealth-Backend)

## 🔗 Frontend associé
Le frontend communique avec le frontend **BeHealth**, disponible ici :
👉 [BeHealth Backend](https://github.com/mariusdelvigne/BeHealth-Frontend)

## 🔗 Application Android associé
Le frontend communique avec une application android **BeHealth**, disponible ici :
👉 [BeHealth Android-App](https://github.com/mariusdelvigne/BeHealth-AndroidApp)
