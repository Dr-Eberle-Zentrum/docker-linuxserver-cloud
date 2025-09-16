---
title: 'Betriebssystem und Linuxgrundlagen'
teaching: 10
exercises: 2
---

:::::::::::::::::::::::::::::::::::::: questions 

- Wie wähle ich die richtige Hard- und Software aus?

- Wie installiere ich ein Linux-Betriebssystems?

- Wie bediene ich ein Linux-Betriebssystem?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Begriffsklärung
- Betriebssystem installieren
- Grundlagen mit der Linux-Kommandozeile

::::::::::::::::::::::::::::::::::::::::::::::::

# Die Hard- und Software

## Hardware
Zu Beginn der meisten IT-Projekte steht die Frage, wo diese Projekte umgesetzt werden sollen. Dabei gibt es heutzutage unterschiedliche Möglichkeiten. Abgesehen von Tests auf lokalen Endgeräten wie PC oder Notebook, werden für viele Projekte spezialisierte Geräte genutzt. Vor allem für Firmen, Rechenzentren und andere Hochleistungsszenarien werden Computer mit **spezialisierter Hardware** (Prozessoren, Festplatten, Arbeitsspeicher oder RAID-Controller) eingesetzt, die für diese anspruchsvollen Aufgaben geeignet ist und häufig nicht mit Endanwender-Hardware vergleichbar ist.

Neben eigener Hardware besteht heute auch die Möglichkeit, seine Projekte auf fremder Hardware umzusetzen. Diese fremde Hardware befindet sich in einem **entfernten Rechenzentrum ("der Cloud")** und ist über das Internet erreich- und steuerbar. Häufig wird die Hardware dabei virtualisiert, d.h. dass z.B. die Leistung eines echten Prozessors mithilfe von Software für mehrere virtuelle Computer zur Verfügung gestellt wird.

Für dezentrale Projekte können sogenannte **Embedded Devices** genutzt werden. Hierbei handelt es sich häufig um Spezialanfertigungen für genau einen Einsatzzweck, z.B. als Kassensystem oder Waage im Supermarkt oder als Informationsdisplay im öffentlichen Raum. Für diese Geräte werden auch spezielle Betriebssysteme und Software eingesetzt.

Für kleinere Projekte wie Heimanwender können normale PCs genutzt werden. Passender für Projekte mit wenig Leistungsanspruch (und im Heimanwenderbereich ist das i.d.R. der Fall) sind Mini-PCs, bei denen sämtliche oder die meisten Bauteile (Prozessor, Arbeitsspeicher, Datenspeicher und externe Schnittstellen wie Netzwerk und USB) auf einer Platine verbaut sind. Diese sogenannten **Systems-on-a-Chip (SoC)** haben den Vorteil, dass sie besonders energiesparsam sind, wenig Platz benötigen, keinen oder kaum Lärm verursachen und im Vergleich mit herkömmlichen PCs oder gar professionellen Servern deutlich günstiger sind.

## Server vs. Client
Bezogen auf ihre Funktion innerhalb eines Computernetzwerks werden Geräte unterschiedlich bezeichnet:

1. Client

Klassisches Endgerät wie PC, Notebook oder Smartphone. Hat keine zentralen Aufgaben. Ist ein Client-Gerät ausgefallen, ist das Netzwerk nicht betroffen.

2. Server

Übernimmt als Kommunikationsknotenpunkt zentrale Aufgaben im Netzwerk. Je nach Leistungsbedarf werden spezialisierte Hochleistungshardware, normale PCs oder SoCs genutzt. Fällt ein Server aus, fehlt damit i.d.R. eine zentrale Funktion im Netzwerk. Je nachdem welche Aufgaben der Server hat, kann dies zum vollständigen versagen des Netzwerks führen oder nur zum Ausfall eines Dienstes (z.B. einer Website).

## Software

Unter Software kann all das verstanden werden, was nicht angefasst werden kann. Also sämtlicher Programmcode, der auf einem Computer installiert ist. Dazu gehört sowohl das Betriebssystem, die Boot-Umgebung (welche das Betriebssystem lädt) aber auch alle anderen Programme wie Treiber, eine Firewall, ein Office-Programm oder ein Webserver-Programm.

Möchte man ein bestimmtes IT-Projekt umsetzen und hat die Hardware besorgt, gilt es auch die richtige Software auszuwählen. Hierbei ist zu beachten, dass Hard- und Software miteinander kompatibel sein müssen. Z.B. unterstützt nicht jedes Betriebssystem jede Art von Prozessor (siehe auch diesen [Wikipedia-Artikel](https://de.wikipedia.org/wiki/Prozessorarchitektur)). 

Abhängig von den Programmen, die man nutzen möchte, kann das passende Betriebssystem gewählt werden. Für viele Serveranwendungen, wie die in diesem Kurs genutzte Software [Nextcloud][nextcloud], werden Linux-Betriebssysteme empfohlen. In vielen Fällen werden für die Funktion des Hauptprogramms (in unserem Fall Nextcloud) weitere Programme benötigt. Das sind häufig ein [Datenbankmanagementsystem](https://de.wikipedia.org/wiki/Datenbank#Komponenten_eines_Datenbanksystems) wie Mysql oder MariaDB, die Skriptsprache PHP, und ein Webserver wie [Apache2](https://httpd.apache.org/). In dieser Kombination spricht man auch von einem LAMP-Stack (**L**inux, **A**pache, **M**ysql/**M**ariaDB und **P**HP).

Die genauen Anforderungen an die Hard- und Software sind häufig den Handbüchern der Programme zu entnehmen. Allerdings hängt die richtige Wahl auch von der Intensivität der Nutzung, persönlichen Vorlieben oder Vorgaben innerhalb einer Organisation ab.

::::::challenge
### System requirements

Szenario: Sie wollen für eine kleine Forschungsgruppe (ca. 10 Personen) eine Datenmanagement-Lösung betreiben und als Serversoftware [Nextcloud][nextcloud] installieren.

Welche Hardware wählen Sie dafür? Schauen Sie sich dafür die [System requirements](https://docs.nextcloud.com/server/latest/admin_manual/installation/system_requirements.html) von Nextcloud an und wählen Sie aus einer der folgenden Hardware-Optionen:

1. [Raspberry Pi 4](https://www.raspberrypi.com/products/raspberry-pi-4-model-b/) mit 8GB RAM für ca. 100€ und einer externen [2 TB USB-HDD-Festplatte](https://www.idealo.de/preisvergleich/OffersOfProduct/204400140_-mysafe-advance-3-5-usb-3-0-2tb-i-tec.html)

2. [Raspberry Pi 5](https://www.raspberrypi.com/products/raspberry-pi-5/) mit 8GB RAM für ca. 110€ und einer [2 TB SSD-Festplatte](https://geizhals.de/crucial-p310-ssd-2tb-ct2000p310ssd2-a3234426.html?hloc=at&hloc=de)

3. [Odroid H4 Ultra](https://www.hardkernel.com/shop/odroid-h4-ultra/) mit einer [2 TB SSD-Festplatte](https://geizhals.de/crucial-p310-ssd-2tb-ct2000p310ssd2-a3234426.html?hloc=at&hloc=de)

4. Einen Tower Server [Intel RI1104-SMXEH Serie](https://www.thomas-krenn.com/de/produkte/rack-server/1he-server/intel-single-cpu/1he-intel-single-cpu-ri1104-smxeh-server)

:::solution
Die genauen Hardwareanforderungen sind (v.a. am Anfang des Projekts und ohne Vorkenntnisse) schwer abzuschätzen. Geeignete Lösungen können aber die Nummern 2. und 3. sein. Die Nummer 4 wäre überdimensioniert und mit der Nummer 1. kommt das System an seine Grenzen. Auch der Raspberry Pi 5 ist für 10 Personen vermutlich zu schwach. Das hängt aber stark von der Art und der Intensivität der Nutzung ab.
:::
::::::

### Installation des Betriebssystems

Um ein Betriebssystem neu zu installieren, muss beim Starten des PCs/Servers (egal ob virtualisiert oder als physisches Gerät) ein bootbares Medium mit den Installationsdateien angeschlossen und beim Startvorgang ausgewählt werden.

In diesem Kurs wird mit virtuellen Servern gearbeitet, die mit der Virtualisierungsplattform [Proxmox](https://proxmox.com/en/) betrieben werden. Beim Start Ihres Servers ist bereits ein Installationsmedium eingebunden und als Startmedium hinterlegt. 

Loggen Sie sich in der [Proxmox-Webconsole][proxmox] ein und wählen Sie Ihren Server im rechten Menü aus. Gehen Sie nun im vertikalen Menü der virtuellen Maschine in den Bereich *Console* und klicken Sie im Konsolen-Fenster auf *starten*. Die virtuelle Maschine startet und der Ubuntu-Installationsassistent leitet durch die Installation des Servers.

<!--Installation abschließen -->

### Linux Grundlagen

+ Dateisystem

+ Kommandozeile

+ Arbeit mit Dateien

::::::::::::::::::::::::::::::::::::: keypoints 

- Für viele Heimanwender und Kleinprojekte reichen Mini-PCs (SoC) aus.
- Für große Projekte wird spezialisierte Serverhardware benötigt
- In diesem Kurs wird auf einem virtuellen Server mit Linux-Betriebssystem die Cloud-Software [Nextcloud][nextcloud] als Docker-Container installiert. 

::::::::::::::::::::::::::::::::::::::::::::::::

