---
title: 'Docker compose'
teaching: 45
exercises: 90
---

:::::::::::::::::::::::::::::::::::::: questions 

- Muss ich Container immer mit dem komplexen `docker run`-Befehl starten?

- Wie kann ich mehrere Container auf einmal starten?

- Wie funktioniert Docker Compose?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Grundlegende Befehle für docker compose
- Syntax von docker-compose.yml-Dateien
- Docker-Projekte mit mehreren Containern als Docker-Compose-Projekt

::::::::::::::::::::::::::::::::::::::::::::::::

## `docker run` versus `docker compose`

In [Lektion 6: Docker Grundlagen](06-docker-basics.Rmd) wurde gezeigt, wie mit dem `docker run`-Befehl einzelne Container erstellt werden können. Allerdings kann der Befehl recht  komplex werden, wenn Portmappings, Volumes, Umgebungsvariablen und Netzwerk hinzukommen. Um die langen Befehle nicht immer von neuem zu tippen, können sie in eine Konfigurationsdatei (`compose.yaml` oder `docker-compose.yaml`) geschrieben werden. Diese wiederum kann mit dem `docker compose`-Befehl gelesen und ausgeführt werden. Um Docker Compose nutzen zu können, muss dies installiert werden. Folgt man der offiziellen Installationsanleitung für die Docker Engine (siehe [Lektion 6](06-docker-basics.Rmd#installation)), ist docker compose bereits installiert. Dies kann z.B. mit `docker compose -v` überprüft werden.

Allerdings müssen die Befehle in einer bestimmten Syntax, der YAML-Syntax geschrieben werden.

### Vorteile:

- **Gemeinsame Verwaltung mehrerer Container:** Mit Docker Compose können mehrere Container in einer einzigen YAML-Datei definiert werden.

- **Verwaltung:** Mit Docker Compose können alle Container der YAML-Datei mit einem einzigen Befehl verwaltet werden. Dies macht es einfacher, Container zu starten, zu stoppen oder zu aktualisieren.

- **Kommunikation:** Alle Container der YAML-Datei sind standardmäßig in einem dedizierten Bridge-Netzwerk isoliert. Dies erleichtert die Kommunikation zwischen den Containern und erhöht gleichzeitig die Sicherheit durch die Trennung von anderen Compose-Projekten.

- **Nachhaltiger:** Da die YAML-Datei leicht einsehbar ist und weitergegeben werden kann, ist Docker Compose eine nachhaltigere Lösung als der `docker run`-Befehl.

- **Anpassbar:** Docker Compose ist einfach anpassbar, da nur die YAML-Datei geändert werden muss, um die Konfiguration der Container anzupassen.

- **Gut steuerbar:** Mit der Docker CLI besteht durch den `docker compose`-Befehl eine einfache Möglichkeit, die Docker-Container des Compose-Projekts zu starten, zu stoppen oder zu aktualisieren: `docker compose up`, `docker compose down`, `docker compose restart`, `docker compose start` und `docker compose stop`.

### Nachteile:

Der größte Nachteil von docker compose ist, dass zum Starten eines Containers erst eine Konfigurationsdatei im YAML-Syntax erstellt werden muss. Sobald diese einmal erstellt ist, ist dieser Nachteil aber überwunden.

### YAML-Syntax

YAML ist eine einfache und leicht lesbares Dateiformat zur strukturierten Abbildung von Daten. Die YAML-Syntax wird in vielen Bereichen, einschließlich Docker, verwendet um Konfigurationsdateien zu verfassen.

Die grundlegende Syntax von YAML besteht aus Key-Value-Paaren: `key: value`, z.B. `image: nginx`. Dabei wird auch von Maps gesprochen. Im vorhergehenden Beispiel wird die Map "Image" erstellt. Eine Map kann aber außer einem Value auch eine Liste enthalten: 
```yaml
services:
  image: <image>
  ports:
    - 80:80
    - 443:443
```
Dieser Auszug einer compose-Datei zeigt die "ports"-Map mit zwei Listeneinträgen. Der entsprechende `docker run`-Befehl würde wie folgt lauten: `docker run <image> -p 80:80 -p 443:443`

Um der Konfigurationsdatei Informationen und Erklärungen hinzuzufügen, erlaubt die YAML-Syntax Kommentare: alle Zeilen, die mit `#` beginnen werden als Kommentar betrachet.

Wichtige Keys in Docker Compose sind:

- `services`: Top-Level-Map, die eine pro zu startendem Service eine weitere Map enthält. Ein Service entspricht dabei einem Container.
-  Die Maps pro Service haben dann weitere Parameter, teils als weitere Maps, teils als Liste. Wichtig sind dabei:
  - `image` für die Angabe des Dockerimages
  - `dockerfile` für die Angabe eines manuell erstellten Dockerfiles (mehr dazu später)
  - `ports` für die Angabe des Portmappings
  - `networks` für die Angabe des Netzwerks, in welchem der Container sich befinden soll
  - `environment` um Umgebungsvariablen zu definieren 
  - `volumes` um Dateien/Ordner des Hosts in den Container zu binden
- `networks`: Findet sich der Key `networks` auf obererster Ebene, dient er der Erstellung eines Docker-Netzwerks oder der Verbindung zu einem zuvor außerhalb von Compose erstellten Docker-Netzwerks.

Ein Beispiel für eine `compose.yaml`-Datei könnte wie folgt aussehen:

```YAML
services:
  frontend:
    image: nginx:latest
    ports:
      - "80:80"
    networks:
      - web
    environment:
      - NGINX_PORT=80
    volumes:
      - ./html:/usr/share/nginx/html
networks:
  web:
    name: web
    external: true
```

In diesem Beispiel definiert die `compose.yaml`-Datei einen Service namens `frontend`, der auf einem Nginx-Image basiert und auf Port 80 hört. Der Service ist Teil des Netzwerks `web` und hat eine Umgebungsvariable namens `NGINX_PORT`. Der Service hat auch einen Volume-Mount, der auf eine lokale Datei `./html` verweist. Am Ende wird in der Network-Map das Netzwerk web als extern definiert (es muss also zuvor mit `docker network create web` erstellt worden sein).

Viele Softwareprojekte stellen compose.yaml-Dateien für ihre Dienste bereits in Handbüchern oder als Teil des Source-Codes zur Verfügung (z.B. [Jellyfin](https://jellyfin.org/docs/general/installation/container/?method=docker-compose), [Nextcloud](https://github.com/nextcloud/docker/blob/master/.examples/docker-compose/with-nginx-proxy/mariadb/fpm/compose.yaml) oder [Nginx Proxy Manager](https://nginxproxymanager.com/setup/)). Diese Vorlagen müssen meistens noch den eigenen Gegebenheiten angepasst werden oder können mit weiteren Services ergänzt werden.

Weitere Informationen zur YAML-Syntax finden sich z.B: bei [Red Hat](https://www.redhat.com/de/topics/automation/what-is-yaml) und dockerspezifische Infos im [Handbuch](https://docs.docker.com/compose/intro/compose-application-model/)

### Umgebungsvariablen

Docker ermöglicht es, einem Container beim Start vordefinierte Werte für bestimmte Einstellungsparameter mitzugeben, z.B. Verbindungsinformationen für eine Datenbank. Diese Umgebungsvariablen können entweder in der compose.yaml-Datei als Liste innerhalb der Map `environment` genannt werden oder in einer eigenen Konfigurationsdatei auflistet werden. Standardmäßig sucht Docker Compose nach der Datei mit dem Nachem `.env`. Man kann diese aber auch anders bennenen und in der Compose-Datei darauf verweisen. Die Variablen können dann an mehreren Stellen der Compose-Datei als Platzhalter verwendet werden.

#### Compose.yaml mit environment-Map

Hier ein Beispiel für eine `compose.yaml`-Datei für einen Webservice, welcher sich mit einer Datenbank verbindet. Dei Verbindungsinformationen kommen aus einem environment Eintrag, müssen jedoch für beide Services erklärt werden.

```yaml
version: '3'
services:
  web:
    image: web-app
    ports:
      - "5000:5000"
    environment:
      - DATABASE_USER=db_user
      - DATABASE_PASSWORD=db_password
      - DATABASE_HOST=db
      - DATABASE_NAME=my_db
    depends_on:
      - db
  db:
    image: mariadb
    environment:
      - MYSQL_USER=db_user
      - MYSQL_PASSWORD=db_password
      - MYSQL_DATABASE=my_db
      - MYSQL_ROOT_PASSWORD=root_password
```

In diesem Beispiel gibt es zwei Dienste: `web` und `db`. Der `web`-Dienst verwendet das (erfundene) `web-app`-Image und macht den Port 5000 verfügbar. Der `db`-Dienst verwendet das `mariadb`-Image und erstellt eine Datenbank mit dem Namen `my_db`.

Der `web`-Dienst hat einen `environment`-Eintrag, der die `DATABASE_USER`, `DATABASE_PASSWORD`, `DATABASE_HOST` und `DATABASE_NAME`-Variablen setzt. Diese Variablen werden verwendet, um die Verbindung zur Datenbank herzustellen.

Der `db`-Dienst hat auch einen `environment`-Eintrag, der die `MYSQL_USER`, `MYSQL_PASSWORD`, `MYSQL_DATABASE` und `MYSQL_ROOT_PASSWORD`-Variablen setzt. Diese Variablen werden verwendet, um den Benutzernamen, das Passwort, den Datenbanknamen und das Root-Passwort für die MariaDB-Datenbank zu konfigurieren.

Der `web`-Dienst hat auch einen `depends_on`-Eintrag, der angibt, dass er vom `db`-Dienst abhängig ist. Das bedeutet, dass der `db`-Dienst gestartet wird, bevor der `web`-Dienst gestartet wird.

#### Compose.yaml mit externer .env-Datei für Variablen

Eleganter ist in diesem Beispiel die Nutzung einer dedizierten `.env`-Datei (hier mit dem Namen `variables.env` ):

```YAML
DATABASE_USER=db_user
DATABASE_PASSWORD=db_password
DATABASE_HOST=db
DATABASE_NAME=my_db
MYSQL_USER=db_user
MYSQL_PASSWORD=db_password
MYSQL_DATABASE=my_db
MYSQL_ROOT_PASSWORD=root_password
```
Durch den Verweis auf diese Datei in der compose.yaml-Datei, müssen die Variablen nur einmal geschrieben werden:

```yaml
version: '3'
services:
  web:
    image: my-web-app
    ports:
      - "5000:5000"
    env_file:
      - variables.env
    depends_on:
      - db
  db:
    image: mariadb
    env_file:
      - variables.env
```
Ändert sich der Wert einer der genannten Variablen, genügt es bei diesem Setup, nur in der variables.env-Datei die Änderung einzutragen.

### Compose Projekte steuern

Mit dem `docker compose`-Befehl können die in der compose.yaml-Datei definierten Services gesteuert werden.

Die grundlegenden docker-compose-Befehle sind:

- `docker compose up`: Startet alle in der `docker-compose.yml`-Datei definierten Dienste im Vordergrund
- `docker compose down`: Beendet alle Dienste und entfernt alle Container.
- `docker compose restart`: Beendet alle Dienste und startet sie neu.
- `docker compose start`: Startet alle Dienste.
- `docker compose stop`: Beendet alle Dienste.
- `docker compose up -d`: startet alle Container im Hintergrund
- `docker compose ps`: zeigt den Status der Dienste an
- `docker compose exec`: ermöglicht es, einen Befehl in einem Docker-Container auszuführen. Zum Beispiel: `docker-compose exec <container-name> bash`.

Allen Befehlen kann auch ein expliziter Container-Name mitgegeben, um die Aktion nur auf diesen Container anzuwenden, z.B. `docker compose restart nginx`

::::::::::::::::::::::::::::::::::::: keypoints 

- Mit Docker Compose können Dockercontainer effektiver verwaltet werden

- Docker Compose benötigt die compose.yaml-Konfigurationsdatei

- Diese compose.yaml-Datei verwendet den YAML-Syntax

- die Steuerung erfolgt mit dem Befehl `docker compose`
::::::::::::::::::::::::::::::::::::::::::::::::

