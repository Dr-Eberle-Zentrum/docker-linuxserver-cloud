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

### SSH-Zugriff

Angepasster SSH-Befehl: `ssh -o ProxyCommand="openssl s_client -quiet -connect 134.2.17.196:15101 -servername <name>-ssh" <username>@<name>-ssh -i <Pfad-zum-SSH-Key` (Dabei natürlich die Werte in `< >` jeweils anpassen).

Siehe dazu auch [Lektion 3](03-remote-access.Rmd#besonderheiten-zur-ssh-anmeldung-im-kurssetup)

### Zugriff auf die Virtualisierungsumgebung:

+ Öffnen Sie die [Proxmox Web Console][proxmox]

+ Melden Sie sich mit den kursspezifischen Anmeldedaten an

+ Wählen Sie in der linken Seitenleiste Ihren virtuellen Server aus

+ Wählen Sie den Reiter "console" im vertikalen Menü


