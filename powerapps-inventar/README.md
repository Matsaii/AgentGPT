# Inventar – Canvas App für Power Apps (SharePoint)

Eine Canvas App mit zwei Bildschirmen, um einen Lagerbestand zu verwalten:

| Bildschirm | Funktionen |
|---|---|
| **scrInventar** (Übersicht) | Suche nach Name oder Artikelnummer, Filter nach Kategorie, Filter „unter Mindestbestand“, Bestand direkt per **+ / −** ändern, Farbmarkierung (rot = unter Mindestbestand, grün = ok), Anzahl der Treffer |
| **scrArtikel** (Detail) | Artikel anlegen, bearbeiten und löschen (mit Bestätigungsdialog), Prüfung auf Pflichtfeld, Warnung bei niedrigem Bestand |

## Dateien

| Datei | Inhalt |
|---|---|
| `01_SharePoint-Liste-anlegen.ps1` | Legt die Liste **Inventar** mit allen Spalten und Beispieldaten an (PnP.PowerShell) |
| `02_App-Formulas.txt` | Benannte Formeln (Kategorien, Farben) für `App.Formulas` |
| `03_scrInventar.yaml` | Steuerelemente des Übersichtsbildschirms (zum Einfügen) |
| `04_scrArtikel.yaml` | Steuerelemente des Detailbildschirms (zum Einfügen) |

## 1. SharePoint-Liste anlegen

Per Skript:

```powershell
./01_SharePoint-Liste-anlegen.ps1 -SiteUrl "https://<tenant>.sharepoint.com/sites/<site>" -ClientId "<App-ID>"
```

Oder manuell eine Liste **Inventar** mit diesen Spalten anlegen (interne Namen genau so schreiben):

| Spalte | Typ | Hinweis |
|---|---|---|
| Title | Eine Textzeile | vorhanden, als „Artikelname“ genutzt |
| Artikelnummer | Eine Textzeile | |
| Kategorie | Auswahl | Werkzeug, Material, Elektronik, Büro, Sonstiges |
| Menge | Zahl | |
| Mindestbestand | Zahl | |
| Lagerort | Eine Textzeile | |
| Bemerkung | Mehrere Textzeilen | Nur-Text |

## 2. App in Power Apps Studio aufbauen

1. **make.powerapps.com → Erstellen → Leere App → Leere Canvas-App** (Format *Tablet*).
2. **Daten → Daten hinzufügen → SharePoint** → Website wählen → Liste **Inventar**.
3. In der Strukturansicht **App** auswählen, Eigenschaft **Formulas** wählen und den Inhalt von `02_App-Formulas.txt` einfügen.
4. `Screen1` umbenennen in **scrInventar**, einen zweiten leeren Bildschirm **scrArtikel** hinzufügen.
5. Inhalt von `03_scrInventar.yaml` kopieren → in der Strukturansicht mit Rechtsklick auf **scrInventar** → **Einfügen → Code einfügen** (*Paste code*).
6. Dasselbe mit `04_scrArtikel.yaml` auf **scrArtikel**.
7. Speichern, veröffentlichen, fertig. ▶ F5 zum Testen.

> **Hinweis zu deutschen Spracheinstellungen:** Die YAML-Dateien verwenden die
> englische Formel-Syntax (`,` als Trennzeichen, `;` zum Verketten). Power Apps
> wandelt das beim Einfügen automatisch um. Wenn du Formeln (z. B. aus
> `02_App-Formulas.txt`) **direkt in die Bearbeitungsleiste** tippst und Studio auf
> Deutsch steht, nutze `;` statt `,` und `;;` statt `;`.

## Hinweise

- **Steuerelement-Versionen:** Die YAML enthält Versionsangaben wie `Label@2.5.1`. Falls Studio beim Einfügen eine Version ablehnt, die Angabe nach dem `@` an die Version anpassen, die Studio beim Kopieren eines vorhandenen Steuerelements anzeigt.
- **Delegierung:** Suche (`StartsWith`) und Kategoriefilter werden an SharePoint delegiert. Der Filter „unter Mindestbestand“ vergleicht zwei Spalten und läuft lokal – bei mehr als 500 Artikeln (bzw. 2000, einstellbar unter *Einstellungen → Allgemein → Datenzeilenlimit*) werden nicht alle Treffer berücksichtigt.
- **Kategorien erweitern:** Neue Kategorie in der SharePoint-Auswahlspalte **und** in `fxKategorien` (App.Formulas) eintragen.
- **Ideen für später:** Barcode-Scanner (`BarcodeReader`) zur Suche nach Artikelnummer, Buchungshistorie in einer zweiten Liste, Power-Automate-Flow mit E-Mail bei Unterschreiten des Mindestbestands.
