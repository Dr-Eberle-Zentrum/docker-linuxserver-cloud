---
title: 'Nextcloud AIO: Konfiguration'
teaching: 90
exercises: 45
---

:::::::::::::::::::::::::::::::::::::: questions 

- Wie kann die Funktion von Nextcloud AIO erweitert werden?

- Wie kann ich die Leistung und Sicherheit von Nextcloud AIO verbessern?

- Wie war das noch einmal mit dem Backup?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Funktionen im Docker Compose Projekt ergänzen

- Verwaltungsoberfläche von AIO

- Datensicherung von Nextcloud AIO

::::::::::::::::::::::::::::::::::::::::::::::::

## Anpassung von Nextcloud All-in-One (AIO)

Nach der Installation sind weitere Anpassungen zu empfehlen. Dazu zählen z.B. Optmierungen der Performance oder der Sicherheit. Aber auch die Konfiguration eines Backupplans. Die Anpassungen sind an mehreren Stellen möglich, die im Folgenden gezeigt werden.

### In der compose.yaml-Datei

Bereits für die Konfiguration des Reverse Proxy wurden an der Compose-Datei des sogenannten "Mastercontainers" (der Container, der alle anderen Container verwaltet) Änderungen vorgenommen. Die Hinweise in der offiziellen Vorlage der compose.yaml-Datei geben schon einen guten Hinweis, was hier noch optimiert werden kann und wie dies geschehen kann.

#### Perfomance
Die Anpassungen erfolgen i.d.R. durch Anpassung einer der Umgebungsvariablen. Einen Blick Wert sind dabei z.B. *NEXTCLOUD_MEMORY_LIMIT*, *NEXTCLOUD_MAX_TIME* und *NEXTCLOUD_UPLOAD_LIMIT*. Verfügt der Docker Host über eine Grafikkarte, besteht die Möglichkeit deren Rechenleistung für AIO zur Verfügung zu stellen. Dies ist v.a. für Funktionen wie die [Gesichtserkennung](https://github.com/matiasdelellis/facerecognition) oder [KI-Anwendungen](https://docs.nextcloud.com/server/stable/admin_manual/ai/index.html) innerhalb von Nextcloud relevant. Für die Konfiguration der Grafikkarte sind die Umgebungsvariablen *NEXTCLOUD_ENABLE_DRI_DEVICE* oder *NEXTCLOUD_ENABLE_NVIDIA_GPU* relevant

#### Fail2Ban
Um Brute-Force-Angriffe auf seinen Nextcloud-Server zu unterbinden, sollte Fail2Ban auch für Nextcloud eingerichtet werden. Auf [Github](https://github.com/nextcloud/all-in-one?tab=readme-ov-file#fail2ban) und im [Handbuch](https://docs.nextcloud.com/server/stable/admin_manual/installation/harden_server.html#setup-fail2ban) finden sich dafür die nötigen Informationen. In Kurzform: fügen Sie der Fail2Ban-Konfiguration des Hosts ein neues Jail hinzu. Passen Sie den Pfad der Log-Datei an und nutzen Sie die Docker-User Chain (da der Datenverkehr an der UFW-Firewall vorbei geht. Folgend ein mögliches Beispiel der Fail2Ban-Konfiguration (vergessen Sie jedoch nicht, wie im Handbuch geschildert, die Filter-Datei zu erstellen):

```conf
[nextcloud]
backend = auto
enabled = true
port = 80,443
protocol = tcp
filter = nextcloud
maxretry = 3
bantime = 86400
findtime = 43200
logpath = /var/lib/docker/volumes/nextcloud_aio_nextcloud/_data/data/nextcloud.log
chain = DOCKER-USER
```

### Über die Verwaltungsoberfläche von AIO

Nach der Installation von Nextcloud AIO kann die Verwaltungsoberfläche des Docker Mastercontainers im Webbrowser erreicht werden. Entweder unter `https://<öffentliche-Ip-Adresse>:8080` oder unter `https://<ihre-domain>:8443`. Da sich in unserem Fall hinter der gleichen IP-Adresse mehrere Server verstecken, wird der Zugriff über die IP-Adresse nicht erfolgreich sein. Beim Zugriff über den Domainname, kann der Hauptproxy-Server die Anfrage aber korrekt weiterleiten (an den NGINX-Proxy-Manager, welcher dann wiederum an den AIO-Container weiterleitet).

### Über die Administrationsoberfläche von Nextcloud

Wie bei einer "normalen" Nextcloud-Installation (z.B. Bare-Metal) kann der Server auch über die Administrationsseite des Nextcloud-Servers verwaltet werden. Wobei manche Einstelllungen hier nicht möglich sind. Melden Sie sich dazu auf Ihrem Nextcloud-Server mit einem Administrator-Account an. Öffnen Sie über den Button rechts oben das Menü und wählen Sie "Verwaltungseinstellungen" aus. Wählen Sie nun links den Punkt "Grundeinstellungen" aus. Dort werden Ihnen Fehler und Warnungen angezeigt, die insbesondere direkt nach der Installation noch auftreten können. Beheben Sie all diese Fehler und möglichst auch alle Warnungen.

### Mit dem occ-Tool

Das [occ-Tool](https://docs.nextcloud.com/server/stable/admin_manual/occ_command.html) ist ein php-Programm, das mit Nextcloud installiert wird (egal ob als Docker-Container oder Bare-Metal). Mit dem occ-Tool kann der Server in vielerlei Hinsicht verwaltet und angepasst werden. Sämtliche Befehlsoptionen können dem Handbuch entnommen werden. Im Falle von Nextcloud AIO ist zu beachten, dass das Tool im Docker-Container läuft und in diesem mit den Rechten des www-data-Users ausgeführt werden muss. Entsprechend den Informationen im [AIO-GitHub-Repository](https://github.com/nextcloud/all-in-one?tab=readme-ov-file#how-to-run-occ-commands) lautet der Befehl wie folgt: `sudo docker exec --user www-data -it nextcloud-aio-nextcloud php occ <Befehlsoption>`, z.B. `sudo docker exec --user www-data -it nextcloud-aio-nextcloud php occ maintenance:mode --on` um den Wartungsmodus von Nextcloud zu aktivieren.

## Backup

### Grundlagen

Um Datenverlust zu vermeiden, sollte stets ein Backup erstellt werden. Sowohl im Falle des Nextcloud-Servers, des physischen Server aber auch jedes Endgeräts (PC, Notebook, Telefon).

#### Was muss gesichert werden?

Welche Inhalte eines Systems gesichert werden sollen, ist von den eigenen Bedürfnissen abhängig. Es kann jedoch zwischen drei Hauptkategorien an Daten unterschieden werden:

- Dateien (Bilder,Dokumente, Videos, Emails...)

- Programme und Lizenzen (Installationsdateien, Konfigurationen, ganze Installationen)

- System (Betriebssystem mit (allen?) Konfigurationen)

In vielen Fällen wird die Sicherung der Dateien ausreichen, da Programme und System mit etwas Zeitaufwand wieder neu aufgesetzt werden können. In zeitkritischen Umgebungen, wenn ein defektes System schnell wieder verfügbar sein muss, empfiehlt es sich aber, dass gesamte System zu sichern.

#### Wie muss gesichert werden?

Es kann zwischen drei Varianten einer Sicherung unterschieden werden:

- Vollsicherung

- Differentielle Sicherung

- Inkrementelle Sicherung

Bei der **Vollsicherung** werden zu jeder Sicherungszeit (z.B. täglich oder wöchentlich) alle Daten gesichert. Der Vorteil dieser Variante ist, dass für eine Wiederherstellung der Daten nur die letzte Sicherungsversion benötigt wird. Der Nachteil liegt im großen Speicher- und Zeitbedarf, da bei jeder Sicherung alle Daten kopiert werden müssen, also sowohl die ursprünglichen Daten, als auch die Daten, die seit der letzten Sicherung neu hinzugekommen sind.

![Speicherbedarf einer täglichen Vollsicherung im Wochenverlauf mit täglich steigendem Speicherbedarf](fig/11_vollsicherung.png){alt='Diagramm, welches für jeden Wochentag einen Wert für den Speicherbedarf der Vollsicherung in TB anzeigt. Montags werden 4 TB benötigt. Mit jeder weiteren Sicherung erhöht sich der Betrag um neu hinzugekommene Daten. Am Ende der Woche werden 8,5 TB benötigt'}

Bei der **differentiellen Sicherung** wird zur ersten Sicherungszeit eine Vollsicherung durchgeführt. Anschließend wird jeden Tag eine Sicherung erstellt, welche alle seit der letzten Vollsicherung geänderten oder neu erstellten Daten enthält. Der Vorteil dieser Variante besteht darin, dass bei einer Wiederherstellung nur die letzte Vollsicherung und die letzte differentielle Sicherung benötigt werden. Der Nachteil liegt wie bei der Vollsicherung darin, dass nach wie vor ein großer Speicherplatzbedarf besteht und die Daten dupliziert vorliegen.

![Speicherbedarf einer täglichen differentiellen Sicherung im Wochenverlauf](fig/11_differentiell.png){alt='Diagramm, welches für jeden Wochentag einen Wert für den Speicherbedarf der differentiellen Sicherung in TB anzeigt. Montags werden 4 TB benötigt. Dienstags wird nur 1 TB für neue Daten benötigt. Jede weitere Sicherung benötigt jeweils den Bedarf des Vortags plus neu hinzugekommen Daten. Am Wochenende beträgt der Bedarf 4,7 TB'}

Bei der **inkrementellen Sicherung** werden jeden Tag nur diejenigen Daten gesichert, die an diesem Tag geändert bzw. neu hinzugekommen sind. Der Vorteil der inkrementellen Variante besteht darin, dass vergleichsweise wenig Zeit und Speicherplatz benötigt wird, da nur zu Beginn eine Vollsicherung erstellt wird und zu jeder weiteren Sicherungszeit nur die Änderungen gesichert werden. Der Nachteil besteht darin, dass im Falle einer Wiederherstellung die letzte Vollsicherung und alle inkrementellen Zwischensicherungen benötigt werden.

![Speicherbedarf einer täglichen inkrementellen Sicherung im Wochenverlauf](fig/11_inkrementell.png){alt='Diagramm, welches für jeden Wochentag einen Wert für den Speicherbedarf der inkrementellen Sicherung in TB anzeigt. Montags werden 4 TB benötigt. Dienstags wird nur 1 TB für neue Daten benötigt. Jede weitere Sicherung benötigt nur den Bedarf der an diesem Tag neu hinzugekommen Daten.'}

Neben der Art der Sicherung, muss auch überlegt werden, wie die einzelnen Sicherungsversionen aufgehoben werden. Im obigen Beispiel zu einer täglichen inkrementellen Sicherung und einer wöchentlichen Vollsicherung können z.B. die Vollsicherung und die inkrementellen Zwischensicherungen nur solange aufgehoben werden, bis eine neue Vollsicherung erstellt wurde. Möchte man jedoch gewährleisten, auch auf einen Datenstand von vor 6 Monaten zurück gehen zu können, sollten die Sicherungen länger aufgehoben werden. Z.B. könnte dann eine monatliche Vollsicherung in jeweils sechs Versionen aufbewahrt werden. Wird eine siebte Version erstellt, wird die älteste gelöscht.

Ein bekanntes Schema zur Versionierung von Sicherungen ist das Generationenprinzip (auch als Großvater-Vater-Sohn-Prinzip bezeichnet). Bei diesem Prinzip werden täglich Backups erstellt. Diese werden eine Woche lang aufbewahrt. Anschließend werden die täglichen Versionen zu einem Wochenbackup zusammengefasst. Die wöchentlichen Backups werden für einen Monat aufbewahrt und nach einem Monat zu einer Monatssicherung zusammen gefasst. Diese monatlichen Sicherungen werden für 12 Monate aufbewahrt. Dadurch bestehen für die letzten sieben Tage jeweils tägliche Versionen, für den letzten Monat wöchentliche Versionen und für das letzte Jahr noch monatliche Versionen. Graphisch ist dieses Verfahren [hier](https://images.vogel.de/infodienste/smimagedata/1/4/1/6/5/9/53.jpg) dargestellt.

#### Wo muss gesichert werden?

Ist geklärt, was und wie gesichert werden soll, muss noch geklärt werden, wo gespeichert werden soll. Grundlegend sollten Sicherungen nicht auf demselben physischen Datenträger wie die Originaldaten gespeichert werden. Die **3-2-1-Regel** gilt als ein guter Richtwert: 3 Kopien auf 2 unterschiedlichen Medien, 1 Offsite-Kopie. Speichert man auf unterschiedlichen Medien, hat man mehr Felxibilität bei der Wiederherstellung. Die Offsite-Kopie an einem anderen Ort wird wichtig, wenn am ursprünglichen Serverstandort ein größerer Schaden Eintritt (z.B. Feuer, Wasser, Kurzschluss oder Einbruch).

Mehr zum Thema Datensicherung findet sich z.B. auch bei [Ubuntuusers](https://wiki.ubuntuusers.de/Datensicherung/) oder bei [Netzwelt](https://www.netzwelt.de/sicherheit/backup/backup-arten-erklaert.html).

### Der eigene Backupplan

Die zuvor dargestellten Methoden und Standards sind nicht immer einfach umzusetzen. Das ist mit ein Grund dafür, dass in vielen Fällen keine Sicherungen gemacht werden, da der Aufwand für die Implementierung einer Sicherungsstrategie zu groß erscheint. Deshalb ist es insbesondere für Heimanwender und kleinere Organisationen mit wenig zeitkritischen Daten oftmals besser ein mittelmäßiges Backup zu haben als gar keines und dafür nicht alle der zuvor genannten Regeln zu befolgen.

::::::challenge
### Backup für den Nextcloud-Server

Überlegen Sie sich, wie Sie Ihren Nextcloud-Server sichern können. Was (welche Daten) sollten Sie sichern? Wie sichern Sie (mit welcher Variante)? Suchen Sie im Internet nach Programmen oder Workflows, um eine Nextcloud-Instanz (Bare-Metal, Docker und VM) zu sichern. Wo speichern Sie die Sicherungen?

:::solution

Das [Handbuch](https://docs.nextcloud.com/server/stable/admin_manual/maintenance/backup.html) listet die grundlegenden Schritte auf, um den Nextcloud-Server zu sichern: 1. das Konfigurationsverzeichnis unter `/var/www/nextcloud/config`, 2. das Datenverzeichnis, z.B. unter `/mnt/data/ncdata`, 3. der Theme-Folder unter `/var/www/nextcloud/themes` (nur wichtig wenn eigene Themes genutzt werden) und 4. die Nextcloud-Datenbank des MariaDB-Servers.

Sinnvollerweise wird man eine inkrementelle Sicherung wählen, um Zeit und Speicherplatz zu sparen. Während das Handbuch zwar die einzelnen manuellen Schritte aufzeigt (Maintanance-Modus aktivieren, Ordner mit rsync sichern, Datenbank mit mysqldump sichern) gibt es viele Tools mit denen Nextcloud gesichert werden kann. Z.B. [Borg-Backup](https://www.c-rieger.de/backup-mit-de-duplizierung/), [Duplicati](https://www.youtube.com/watch?v=7ZayfpZsgk0) oder die Nextcloud-integrierte [Backup-App](https://apps.nextcloud.com/apps/backup). Eine weitere Möglichkeit besteht im schreiben eines eigenen Skripts (eines Mini-Programms), welches leicht an die eigenen Bedürfnisse angepasst werden kann.

Die Sicherungen können zunächst auf einer zweiten Festplatte, die im Server eingebunden werden kann, gespeichert werden. Mehr Unabhängigkeit vom Hauptsystem erhält man, wenn man die Sicherung über das Netzwerk auf einem zweiten Gerät speichert. Das kann z.B. per [Netzlaufwerk im Heimnetz](https://wiki.ubuntuusers.de/Samba_Server/) geschehen oder per SSH auf entfernte Rechner ([medium.com](https://medium.com/@techfocuspro/raspberry-pi-remote-backup-ensuring-your-datas-safety-4b50848f4817) oder [bioslevel.com](https://bioslevel.com/article/backing-up-to-a-remote-server-with-ssh-and-rsync/)). In größeren Netzwerken bestehen weitere Möglichkeiten, um Daten auf entfernten Rechnern zu speichern (NFS, iSCSI oder verteilte Dateisysteme wie DFS oder Ceph), die aber für kleine Setups (Heimserver, kleines Büro etc) häufig zu komplex sind. Es besteht aber häufig auch die Möglichkeit Speicherplatz bei einem anderen Cloud-Dienstleister zu mieten und diesen im eigenen Server einzubinden. Dabei muss dann der Datenschutz und die Datensicherheit im Blick behalten werden, z.B. indem die Backup-Daten vor dem Transfer verschlüsselt werden.

:::
::::::

#### Nextcloud AIO Backup-Funktion

In Nextcloud AIO ist bereits eine [Backup-Programm](https://github.com/nextcloud/all-in-one?tab=readme-ov-file#backup) enthalten. Dieses muss jedoch zu Beginn konfiguriert werden. Da es auf dem weit verbreiteten Backup-Programm BorgBackup basiert, kann das Backup entweder auf einen lokalen Datenträger (lokales BorgBackup-Repository) erstellt werden. Oder auf einem entfernten Computer wird eine BorgBackup-Repository manuell erstellt und dieses Remote-Repository wird als Backup-Destination gewählt. Für die Grundlagen können die oben verlinkten Hinweise bezüglich Backup in AIO genutzt werden. Wer mehr Informationen zur Nutzung von BorgBackup benötigt (z.B. um ein Remote-Repositiory zu erstellen), kann sich direkt bei [BorgBackup](https://borgbackup.readthedocs.io/en/1.4-maint/) informieren. Mit [Vorta](https://vorta.borgbase.com/) existiert für Desktop-Betriebssysteme (Linux und MacOS) auch eine graphische Oberfläche.

::::::::::::::::::::::::::::::::::::: keypoints 

- Nach der Installation von Nextcloud AIO erfolgt die Konfiguration

- Wichtig: kümmern Sie sich um ein ordentliches Backup

- Nextcloud AIO bringt mit BorgBackup eine anpassbare Backup-Lösung mit

::::::::::::::::::::::::::::::::::::::::::::::::

