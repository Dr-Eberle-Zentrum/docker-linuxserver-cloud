---
title: 'Grundlegendes zu Docker'
teaching: 45
exercises: 90
---

:::::::::::::::::::::::::::::::::::::: questions 

- Was ist Virtualisierung

- Was sind Container

- Wie nutze ich Docker

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Theoretische Grundlagen von Virtualisierungstechnologien

- Vergleich von Containern und virtuellen Maschinen

- Installation und Nutzung der Docker Engine

::::::::::::::::::::::::::::::::::::::::::::::::

## Virtualisierungsstrategien:

### Bereitstellung von Serverdiensten

Die traditionelle Bereitstellung von Serverdiensten erfolgt durch die Installation eines Betriebssystems direkt auf der Hardware, gefolgt von der Installation der benötigten Anwendungen. Diese Methode hat jedoch einige Nachteile: Es erfolgt keine Trennung der Anwendungen und Prozesse, wodurch bei Kompromittierung einer Anwendung das gesamte System betroffen ist. Zudem werden die Hardwareressourcen ineffizient genutzt, was zu höheren Kosten bei Hardwarebeschaffung und Stromverbrauch führt und damit auch den Prinzipien der Green-IT widerspricht.

Heute wird daher häufiger auf Virtualisierung gesetzt. Virtualisierung bedeutet, dass Hardwareressourcen wie Prozessor, Arbeitsspeicher, Festplattenspeicher, Netzwerk oder Grafikkarte durch spezielle Virtualisierungsprogramme unterteilt werden und virtuellen Maschinen zugeteilt werden. Dies führt zu einer effizienteren Nutzung der Hardware und erhöht die Sicherheit durch die Trennung der Anwendungen.

Dabei wird das System mit der physischen Hardware, auf welchem die Virtualisierungsprogramme laufen, als *Host* oder Wirt bezeichnet. Als *Gast* wird die virtualisierte Umgebung bezeichnet.

### Unterschiedliche Typen der Virtualisierung:

- **Typ-1**: Hierbei handelt es sich um spezielle Betriebssysteme, die primär der Virtualisierung dienen. Solche Systeme werden auch als Hypervisor bezeichnet. Bei diesen Systemen werden der virtuellen Maschine die Hardwareressourcen direkt zugeteilt. Diese Methode ist performanter als Typ-2 und wird hauptsächlich für die Servervirtualisierung in Rechenzentren oder Unternehmensnetzwerken verwendet.

- **Typ-2**: Bei dieser Methode läuft ein normales Desktop-Betriebssystem (Windows, Linux, MacOS) auf der physischen Hardware. Innerhalb dieses Systems wird die Virtualisierungssoftware installiert und diese Software verwaltet die Zuteilung der Hardwareressourcen auf die virtuellen Maschinen. Diese Methode wird häufig für lokale Tests, in der Entwicklung oder für die parallele Nutzung von (unterschiedlichen) Betriebssystemen verwendet. Sie ist einfacher in der Handhabung, bietet aber weniger Leistung und Funktion.

- **Containervirtualisierung**: Hierbei haben die virtualisierten Anwendungen direkten Zugriff auf die Hardware und den Kernel des Betriebssystems. Anstatt die Hardware zu virtualisieren wird nur die Software virtualisiert. Dabei wird nicht das gesamte Betriebssystem virtualisiert, sondern nur die benötigte Anwendung und deren Abhängigkeiten. Man spricht hier auch von Microservices. Dies führt zu einer geringeren Trennung der Anwendungen und reduziert damit die sicherheitstechnischen Vorteile einer virtuellen Maschine. Die Containervirtualisierung bietet jedoch eine höhere Performance, da sie "näher" an der Hardware des Hosts arbeitet. Containervirtualisierung wird häufig für die Bereitstellung von Anwendungen in komplexen Serverumgebungen oder als Entwicklungsumgebung verwendet. Ein Beispiel für Containervirtualisierung ist Docker: Dockercontainer haben ihr eigenes Dateisystem mit eigenen Benutzerrechten, nutzen jedoch direkt den Kernel des Hosts.

### Weiterführende Quellen

- [Virtualisierung allgemein (IBM 1)](https://www.ibm.com/de-de/think/topics/virtualization)
- [Container vs. virtuelle Maschinen (IBM 2)](https://www.ibm.com/think/topics/containers-vs-vms)
- [Containervirtualisierung (IBM 3)](https://www.ibm.com/de-de/think/topics/containerization)

::::::challenge
## Virtualisierungstypen

Recherchieren Sie zu den folgenden Produkten und ordnen Sie diese den entsprechenden Virtualisierungstechnologien zu:

- Proxmox
- VirtualBox
- Docker
- Kubernetes
- Hyper-V

:::solution

1. Proxmox: Typ-1-Virtualisierung basierend auf dem Betriebssystem Debian und aufbauend auf der KVM-Technologie.

2. VirtualBox: Typ-2-Virtualisierung. VirtualBox ist eine Open-Source-Virtualisierungssoftware, die auf einem bestehenden Betriebssystem läuft und es ermöglicht, mehrere Gastbetriebssysteme zu betreiben.

3. Docker: Containervirtualisierung. Docker ist eine Plattform, die es ermöglicht, Anwendungen in Container zu verpacken, die unabhängig von der zugrunde liegenden Infrastruktur ausgeführt werden können.

4. Kubernetes: Containervirtualisierung. Kubernetes ist ein von Google entwickeltes Open-Source-System zur Automatisierung der Bereitstellung, Skalierung und Verwaltung von containerisierten Anwendungen.

5. Hyper-V: Typ-1-Virtualisierung. Hyper-V ist eine Virtualisierungsplattform von Microsoft, die es ermöglicht, mehrere Betriebssysteme auf einem einzigen physischen Server zu betreiben.

:::

::::::

## Docker Engine

Docker ist eine bekannte und weit verbreitete Open-Source-Software für Containervirtualisierung. Die Docker Engine läuft als Hintergrundprozess auf dem Betriebssystem (Daemon), um die Container zu steuern. Dieser Prozess muss aktiv sein, um Docker nutzen zu können.

### Komponenten
Einige wichtige Komponenten der Docker Engine sind die folgenden:

#### Images

Images bilden die Grundlage eines Containers. Ein Image enthält alle notwendigen Dateien und Abhängigkeiten, die benötigt werden, um eine Anwendung auszuführen. Dies umfasst das Betriebssystem, die Anwendungssoftware, Bibliotheken und Konfigurationsdateien. Images werden über Registries wie [Docker Hub](https://hub.docker.com/) oder [GitHub](https://github.com/) zur Verfügung gestellt, wo sie heruntergeladen und verwendet werden können.

#### Container

Ein Container ist eine aktive Instanz, die aus einem Image erstellt wird. Aus einem einzigen Image können mehrere Container erstellt werden. Jeder Container ist eine isolierte Umgebung, die unabhängig von anderen Containern läuft. Dies ermöglicht es, mehrere Anwendungen auf demselben Host-System auszuführen, ohne dass sie sich gegenseitig beeinflussen.

#### Volumes

Volumes sind persistente Datenspeicher, die verwendet werden, um Daten dauerhaft zu speichern. Im Gegensatz zu den Dateien innerhalb eines Containers, die bei der Beendigung des Containers verloren gehen, bleiben die Daten in einem Volume erhalten. Volumes sind besonders nützlich für Anwendungen, die Daten über mehrere Container-Instanzen hinweg speichern müssen, wie z.B. Datenbanken oder Log-Dateien.

### Installation

Die Installation der Docker Engine auf Ubuntu kann mittels einer von Docker zur Verfügung gestellten Fremdquelle erfolgen. Die Schritte sind dem offiziellen [Handbuch](  https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository) zu entnehmen. Nutzen Sie die Installationsvariante mittels apt-Repository und installieren Sie die aktuellste Version ("Latest").

Überprüfen Sie anschließend die Installation mit dem Befehl `docker -v`. Dieser Befehl sollte Ihnen die aktuelle Versionsnummer von Docker zurück liefern.

### Konfiguration

Nach der Installation der Docker Engine sind einige Konfigurationsschritte notwendig, um die Docker-Umgebung optimal zu nutzen.

Der Docker Daemon kann mit der Datei `/etc/docker/daemon.json` angepasst werden. Diese muss manuell erstellt werden (`sudo nano /etc/docker/daemon.json`). Die Konfigurationsoptionen für den Docker Daemon werden in dieser Datei im JSON-Format eingetragen. Eine wichtige Konfiguration ist die Logrotation, die sicherstellt, dass die Log-Dateien nicht unbegrenzt wachsen.

#### Logrotation

Um die Logrotation zu konfigurieren, fügen Sie die die folgenden Zeilen der `daemon.json`-Datei hinzu.

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
```
Weitere Informationen zur Logrotation finden Sie in der offiziellen Dokumentation: [Docker Logging Drivers](https://docs.docker.com/engine/logging/drivers/json-file/).

#### Autostart einrichten

Um sicherzustellen, dass der Docker-Dienst beim Systemstart automatisch gestartet wird, müssen Sie den Autostart einrichten. Dies erfoglt unter Ubuntu mit Systemd:
```bash
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
```

Weitere Informationen dazu finden Sie in der [Dokumentation](https://docs.docker.com/engine/install/linux-postinstall/#configure-docker-to-start-on-boot-with-systemd).

::::::challenge

# Die Qual der Wahl

Sie haben den Auftrag erhalten, an Ihrem Institut für eine kleine Arbeitsgruppe eine Website und eine Webapplikation zum Dateiaustausch ("Cloud") zu betreiben. Dazu wird Ihnen ein kleiner Server mit Ubuntu-Betriebssystem zur Verfügung gestellt. Ihr Institut hat mehrere Arbeitsgruppen, die bislang Ihre Daten nur auf lokalen Festplatten speichern.

Welche Installationsvariante wählen Sie?

1. Ich installiere einen Webserver in Ubuntu ("bare metal"). Dieser stellt sowohl die Website als auch auf einer zweiten Internetseite die Webapplikation zum Datenaustausch bereit.

2. Ich installiere einen Webserver in Ubuntu und einen Docker-Container für die Webapplikation. Der Webserver stellt die Website bereit und leitet Anfragen an die Webapplikation an den Docker-Container weiter.

3. Ich installiere einen Webserver in Ubuntu und je einen Docker-Container für die Webapplikation und die Website. Der Webserver leitet alle Anfragen an den jeweiligen Docker-Container weiter.

4. Ich installiere drei Docker-Container: Webserver, Website und Webapplikation. Der Webserver-Container leitet die Anfragen an den Website- oder Webapplikations-Container weiter.

5. Ich installiere eine virtuelle Maschine für die Webapplikation und betreibe die Website direkt im Ubuntu-System ("Bare metal")

:::solution
In Anbetracht der weiteren Arbeitsgruppen, die evtl. zukünftig ebenfalls eine Plattform zum Datenaustausch benötigen, erscheint es sinnvoll, diese Plattform als Docker-Container zu betreiben. Dadurch besteht die später die Möglichkeit, diesen Container einfach zu duplizieren und damit weiteren Arbeitsgruppen eine Instanz zur Verfügung zu stellen.

Der Webserver kann ebenfalls als Docker-Container betrieben werden. Dadurch ist das gesamte Setup unabhängig vom Host-Betriebssystem und kann wenn nötig einfacher auf andere Hardware migriert werden.

Demnach erscheint Antwort 4 passend. Die genaue Wahl hängt aber auch von individuellen Gegebenheiten ab (Know-How des IT-Teams, Performance des Servers, Vorgaben der Organisation, vorhandene Strukturen, künftige Projekte).

:::

::::::

### Steuerung der Docker Engine

Die Steuerung von Docker erfolgt über den `docker` Befehl, der in der Regel mit `sudo` ausgeführt werden muss, um die notwendigen administrativen Rechte zu haben. Hier sind einige wichtige Befehle und ihre Funktionen:

#### `docker ps`
Der Befehl `docker ps` listet alle aktiven Container auf. Dies ist nützlich, um einen Überblick über die laufenden Container zu erhalten und deren Status zu überprüfen.

#### `docker run`
Der Befehl `docker run` wird verwendet, um einen neuen Container aus einem Image zu starten. Dieser Befehl erfordert mindestens das Image, aus dem der Container erstellt werden soll, und kann zusätzliche Optionen enthalten, wie z.B. die Zuweisung von Ressourcen oder die Angabe von Umgebungsvariablen.

#### `docker cp`
Der Befehl `docker cp` wird verwendet, um Dateien oder Verzeichnisse zwischen dem Host-System und einem Container zu kopieren. Dies ist nützlich, um Daten in einen Container zu importieren oder aus einem Container zu exportieren.

#### `docker network`
Der Befehl `docker network` bietet verschiedene Unterbefehle zur Verwaltung von Docker-Netzwerken:
- `docker network ls` listet alle vorhandenen Netzwerke auf.
- `docker network inspect <Netzwerkname>` zeigt detaillierte Informationen über ein bestimmtes Netzwerk an, z.B. IP-Adressen und verbundene Container
- `docker network create <Netzwerkname>` erstellt ein neues Netzwerk (standardmäßig als sog. Bridge-Netzwerk).

Siehe dazu auch [Dockernetzwerke](#kommunikation-im-dockerversum-dockernetzwerke)

#### `docker prune`
Der Befehl `docker prune` bietet verschiedene Unterbefehle zur Bereinigung von Docker-Ressourcen:
- `docker system prune` entfernt alle ungenutzten Daten (Images, Container, Netzwerke und Volumes).
- `docker image prune` entfernt alle ungenutzten Images.
- `docker network prune` entfernt alle ungenutzten Netzwerke.
- `docker volume prune` entfernt alle ungenutzten Volumes.

#### `docker exec`
Der Befehl `docker exec` wird verwendet, um einen Befehl in einem laufenden Container auszuführen. Dies ist nützlich, um administrative Aufgaben innerhalb eines Containers durchzuführen, ohne den Container neu starten zu müssen.

### Kommunikation im "Dockerversum": Dockernetzwerke

Um Containern die Kommunikation im Netzwerk zu ermöglichen, erstellt die Docker beim Start der Container standardmäßig auch **virtuelle Netzwerke**. In der Standardkonfiguration haben Container Internetzugriff über die Internetschnittstelle des Hosts. Allerdings kommunizieren Sie in einem eigenen Subnetz und sind daher nicht von außen erreichbar.

#### Docker-Netzwerke

Es gibt verschiedene Netzwerktypen, die von der Docker Engine oder manuell erstellt werden können. Die wichtigsten sind Bridge, Host und Overlay.

**Bridge-Netzwerke** sind virtuelle Netzwerke, an welche Container gebunden werden können. Alle Container innerhalb desselben Bridge-Netzwerks können miteinander kommunizieren, entweder über ihre IP-Adressen oder über ihre Container-Namen. Auf dem Host ist das Bridg-Netzwerk ebenfalls sichtbar, allerdings ist das Bridge-Netzwerk nicht direkt mit der Netzwerkschnittstelle des Hosts verbunden, sondern befindet sich hinter der Netzwerkschnittstelle des Hosts. Damit hat das Bridge-Netzwerk keinen Zugriff auf das LAN des Hosts. Über [Portmapping](#portmapping) kann aber die Kommunikation mit dem LAN-Netzwerk des Hosts ermöglicht werden.

**Host-Netzwerke** verbinden Container auf derselben physischen Netzwerkschnittstelle wie den Host. Dadurch befindet sich das Host-Netzwerk "neben" dem Host selbst und hat direkten Zugriff auf das LAN des Hosts und erhält auch dort eine IP-Adresse. Dies hat zwar den Vorteil des direkten Zugriffs, ist aber aufgrund der geringeren Isolierung des der verbundenen Container auch weniger sicher.

**Overlay-Netzwerke** dienen der Verbindung von Containern über unterschiedliche Hosts hinweg. So ist es z.B. möglich Docker-Container, die auf zwei unterschiedlichen Servern laufen und dort jeweils in einem Bridge-Netzwerk isoliert sind, zusätzlich mit einem Overlay-Netzwerk kommunizieren zu lassen.

#### Portmapping
Um die Kommunikation von Host zu Gast zu ermöglichen können Anfragen an bestimmte Ports des Hosts an bestimmte Ports des Gasts weitergeleitet werden. Dadurch können Container von außerhalb eines Bridge-Netzwerks erreicht werden. Es ist jedoch wichtig zu beachten, dass dadurch die Regeln der UFW umgangen werden. Deshalb sind für im Internet exponierte Container ggf. eigene Firewallregeln zu erstellen (siehe dazu das [Handbuch](https://docs.docker.com/engine/network/packet-filtering-firewalls/)). Um Ports des Containers auf dem Host verfügbar zu machen (zu veröffentlichen ("publish")) dient der Parameter `-p` des `docker run`-Befehls.

Mehr Informationen zu Docker-Netzwerken findet sich im [Handbuch](https://docs.docker.com/engine/network/).

### Container mit der Docker Engine erstellen

Der Befehl `docker run <Imagename>:<Image-Tag>` wird verwendet, um einen neuen Container aus einem Image zu starten. Wenn das angegebene Image nicht lokal vorhanden ist, wird es automatisch aus einer Registry wie *Docker Hub* heruntergeladen und der Container wird gestartet. Dabei gibt es verschiedene Parameter, die die Konfiguration des Containers beeinflussen können. Einige wichtig Parameter sind dabei die Folgenden:

- **`-p` für Portfreigaben**:
  Dieser Parameter wird verwendet, um Ports auf dem Host-System an Ports im Container zu binden. Dies ermöglicht es, auf Dienste im Container von außerhalb zuzugreifen. Beispiel: `docker run -p 80:80 nginx`. Dieser Befehl startet einen Docker-Container basierend auf dem nginx-Image. Dabei wird der Port `80` auf dem Host-System auf den Port `80` innerhalb des Containers weitergeleitet. Dadurch kann von außerhalb des Containers auf Port `80` innerhalb des Containers zugegriffen werden. Es ist aber auch möglich unterschiedliche Ports zu nutzen: `docker run -p 12000:80 nginx`

- **`-v` für Volumes**:
  Dieser Parameter wird verwendet, um Verzeichnisse oder Dateien zwischen dem Host-System und dem Container zu teilen. Dies ist nützlich, um Daten persistent zu speichern oder Konfigurationsdateien zu teilen.

- **Weitere Parameter**:
  Eine vollständige Liste der verfügbaren Parameter kann mit dem Befehl `docker run --help` angezeigt werden.

- **tag**:
  Der tag gibt die Version des Images an. Wenn kein tag angegeben wird, wird standardmäßig das Image mit dem tag `latest` verwendet.

#### Beispiel: Apache Webserver

Um einen Apache Webserver in einem Docker-Container zu starten, können Sie den folgenden Befehl verwenden:

- **Starten des Containers**: `sudo docker run -dit --name apache -p 8080:80 -v "$PWD":/usr/local/apache2/htdocs/ httpd:2.4`
  - `-dit`: Startet den Container im Hintergrund und behält die Terminalsitzung offen.
  - `--name apache`: Gibt dem Container den Namen `apache`.
  - `-p 8080:80`: Bindet den Port 8080 auf dem Host-System an den Port 80 im Container.
  - `-v "$PWD":/usr/local/apache2/htdocs/`: Bindet das aktuelle Arbeitsverzeichnis ("Working directory: `pwd`) auf dem Host-System an das Verzeichnis `/usr/local/apache2/htdocs/` im Container.
  - `httpd:2.4`: Verwendet das Image `httpd` mit dem tag `2.4`.

- **Ansprechen des Containers**:
  Um zu überprüfen, ob der Apache Webserver läuft, können Sie den folgenden Befehl verwenden:  `curl localhost:8080` Dieser Befehl sendet eine HTTP-Anfrage an den Apache-Container und gibt die Antwort auf der Kommandozeile zurück.

- **Stoppen des Containers**:
  Um den Apache Webserver-Container zu stoppen, können Sie den folgenden Befehl verwenden: `docker stop apache`

::::::::::::::::::::::::::::::::::::: keypoints 

- durch Virtualisierung können Ressourcen effektiver genutzt werden
- Container bieten eine performante Virtualisierungslösung an
- mit Docker können verschiedene Anwendungen in isolierten Umgebungen (Containern) auf demselben System betrieben werden
- Mit Docker Netzwerken kann die Kommunikation zwischen Containern und dem Host gesteuert werden

::::::::::::::::::::::::::::::::::::::::::::::::

