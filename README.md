# 🛠️ Garage App

**Garage App** ist eine mobile Flutter-Anwendung zur Verwaltung von Werkstattaufträgen.  
Sie ermöglicht das Erstellen, Bearbeiten und Nachverfolgen von Aufträgen inklusive Fahrzeugdaten, Status, Ressourcen und Preisen.

Die App ist für den täglichen Einsatz in kleinen bis mittleren Auto-Werkstätten gedacht.

---

## ✨ Features

- 📋 Übersicht aller Werkstattaufträge (Dashboard)
- 🔎 Filter nach Status:
  - Offen
  - In Bearbeitung
  - Fertig
  - Problem
- ➕ Neuen Auftrag anlegen
- ✏️ Bestehende Aufträge bearbeiten
- 🚗 Fahrzeugdetails (Marke, Modell, Kennzeichen, Baujahr, Kilometerstand)
- 🧰 Ressourcenverwaltung:
  - Ressource
  - Menge
  - Preis
- 🏷️ Status-Badges mit Farblogik
- 🔄 Pull-to-Refresh
- 🌐 Backend-Anbindung (REST API)
- 📱 Android-ready (APK Build)

---

## 📸 Screens (optional)

> Dashboard • Neuer Auftrag • Auftragsdetails • Bearbeiten * Berichte * Settings

---

## 🏗️ Architektur

- **Frontend:** Flutter (Material Design)
- **State:** StatefulWidgets + setState
- **Backend:** REST API (z. B. Azure App Service)
- **HTTP:** eigener `ApiService`
- **Plattform:** Android (iOS optional)

---

## 🔌 Backend

Die App kommuniziert mit einem REST-Backend.

