---
title: Setup
---

## Voraussetzungen

Um an den Kursen teilnehmen zu können, müssen Sie an der Universität Tübingen immatrikuliert sein und sich über das ALMA-System zum Kurs angemeldet haben.

:::callout
Sie sind **nicht** an der Universität Tübingen **immatrikuliert**? 

Kein Problem. Sie können die Materialien zum Selbststudium nutzen und so dennoch einiges lernen.
:::

Um den Kursinhalten folgen zu können, sollten Sie Interesse an Computertechnik, Systemadministration, Kommandozeile und Linux haben. Vorkenntnisse in diesen Bereichen sind nicht nötig (aber hilfreich).

Die hier veröffentlichten Materialien sollen Ihnen als Selbstlernmaterial dienen. Wesentlicher Bestandteil des Kurses sind jedoch die praktischen Live-Übungen.

Für die Teilnahme am Kurs benötigen Sie ein Endgerät mit Webbrowser, Maus und Tastatur. Zwar sind grundlegend auch mobile Geräte möglich, werden aber nicht empfohlen.

## Data Sets

<!--
FIXME: place any data you want learners to use in `episodes/data` and then use
       a relative link ( [data zip file](data/lesson-data.zip) ) to provide a
       link to it, replacing the example.com link.
-->
Benötige Daten werden über das ILIAS-Portal zur Verfügung gestellt

## Software Setup

### Systemsetup

- **Zugriff über Proxmox Webconsole**:

  - Zugang Uni-VPN (EduVPN): ✅
  
  - URL: [Proxmox Web Console][proxmox]
      ✅
    
  - Username: ****
  
  - Realm: UniTuebingen-bwIDM
  
  - "Or sing in with bwIDM" auswählen
  
  - Login mit zentralem Uni-Tübingen-Account
  
  - Ggf. Freischaltung abwarten

  + Wählen Sie in der linken Seitenleiste Ihren virtuellen Server aus

  + Wählen Sie den Reiter "console" im vertikalen Menü

- **Nach der Installation des Betriebssystems**: Zugriff per SSH:

  - Wireguard-VPN für Zugang zum Computerpool-Netzwerk:
  
    - [Wirguardclient](https://www.wireguard.com/install/) installiert: ✅
    
    - Konfigurationsdatei per Mail erhalten und im Wireguard-Client geladen: ✅
    
  - VPN testen:
  
    - `ping 10.10.10.1`  
    
    - `ping <IP-Adresse-eigener-Server>`
    
  - SSH-Verbindungen aufbauen:
  
    - `ssh user@IP-Adresse`



