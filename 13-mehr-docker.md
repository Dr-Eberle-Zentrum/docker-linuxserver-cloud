---
title: 'Mehr Docker'
teaching: 45
exercises: 90
---

:::::::::::::::::::::::::::::::::::::: questions 

- Wie kann ein fertiges Dockerimage angepasst werden?

- Wie verknüpfte ich ein DOCKERFILE in einem Docker Compose Projekt?

- Muss ich Docker immer über die Kommandozeile bedienen?

- Welche Alternativen zu Docker gibt es?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Dockerimage mit DOCKERFILES anpassen

- den `docker compose build` Befehl nutzen

- Portainer als GUI für Docker

- Docker Swarm, Podman und Kubernetes als Alternativen zu Docker

::::::::::::::::::::::::::::::::::::::::::::::::

## Anpassung von Dockerimages

Im bisherigen Verlauf des Kurses wurden fertige Dockerimages genutzt. Diese wurden in der Compose-Datei mit dem Key `image:` angebene. Es kommt jedoch vor, dass diese fertigen Images nicht ganz den eigenen Bedürfnissen entsprechen. Häufig fehlen bestimmte Programme oder Dateien im Image. Um diese zu ergänzen kann ein Image angepasst werden.

### Das DOCKERFILE als Bauanleitung

Ein Dockerimage kann mithilfe eines sog. `Dockerfile` erstellt und angepasst werden. Das `Dockerfile` enthält eine Reihe von Anweisungen, die Docker befolgt, um das Image zu bauen. Hier sind einige grundlegende Anweisungen, die in einem `Dockerfile` verwendet werden können:

- `FROM`: Gibt das Basisimage an, von dem abgeleitet wird.
- `RUN`: Führt Befehle im Container aus.
- `COPY`: Kopiert Dateien oder Verzeichnisse vom Host in das Image.
- `CMD`: Gibt den Befehl an, der ausgeführt wird, wenn der Container startet.

Ein einfaches Beispiel für ein `Dockerfile` kann wie folgt aussehen:

```Dockerfile
FROM ubuntu:latest
RUN apt-get update && apt-get install -y python3
COPY . /app
WORKDIR /app
CMD ["python3", "/app/app.py"]
```

Dieses `Dockerfile` erstellt ein Image basierend auf dem neuesten Ubuntu-Image, installiert Python 3, kopiert die Dateien des aktuellen Arbeitsverzeichnisses in das Verzeichnis `/app` im Container und führt die Datei `app.py` aus, wenn der Container startet.

### Der `docker compose build` Befehl

Um die erstellte Bauanleitung im `Dockerfile` zu nutzen, wird die Compose-Datei abgeändert und statt des fertigen Images mit dem build-Befehl das `Dockerfile` genutzt. 

```yaml
services:
  web:
    build:
      dockerfile: DOCKERFILE
    ports:
      - "5000:5000"
  redis:
    image: "redis:alpine"
```

In diesem Beispiel wird ein Webservice definiert, der das Dockerimage basierend auf dem dockerfile mit Namen `DOCKERFILE` baut und den Port 5000 des Hosts auf den Port 5000 des Containers weiterleitet. Ein weiterer Service namens `redis` wird aus dem vorgefertigten `redis:alpine`-Image erstellt (ohne angepasst zu werden).

Um die Images zu bauen, wird der folgende Befehl verwendet:

```sh
docker compose build
```
Ist der Build-Prozess erfolgreich abgeschlossen (dies kann je nach `DOCKERFILE` sehr lange dauern), kann das Compose-Projekt wie gewohnt gestarte werden: `sudo docker compose up -d`

## Docker Images aktualisieren

Wenn neue Versionen eines Docker-Images veröffentlicht werden, muss das bestehende Image aktualisiert werden. Um ein neues Image zu laden und das alte zu ersetzen, wird wie folgt vorgegangen:

1. **Definiton eines neuen Images**: Stellen Sie sicher, dass Ihre `compose.yml`-Datei auf das neue Image verweist. Ändern Sie die ggf. die Versionsangabe in der `image`-Zeile entsprechend. 

Zum Beispiel wird aus Version 10:

```yaml
    services:
      web:
        image: myapp:10
```
    
Version 11:    
    
```yaml
    services:
      web:
        image: myapp:11
```
    
Häufig wird auf die `latest` oder `stable`-Version verwiesen. Diese Angabe bewirkt, dass bei der Aktualisierung immer die dann aktuelle Version geladen wird. Ist dies nicht gewünscht, muss die Version wie oben im Beispiel gezeigt explizit angegeben werden.

2. **Herunterladen des neuen Images**: Führen Sie den Befehl `docker compose pull` aus, um das neue Image herunterzuladen. Dieser Befehl aktualisiert die Images, die in der `compose.yml`-Datei definiert sind. Der Download kann in Abhängigkeit der Anzahl und Größe der enthaltenen Images einige Zeit dauern.

3. **Starten des neuen Images**: Nachdem das neue Image heruntergeladen wurde, können Sie die Container mit dem neuen Image neu starten: `sudo docker compose up -d --remove-orphans`

4. **Löschen des alten Images**: Um das alte Image zu löschen und Speicherplatz freizugeben, können Sie den Befehl `docker image rm` verwenden. Zuerst müssen Sie jedoch sicherstellen, dass keine Container mehr das alte Image verwenden. Verwenden Sie den Befehl `docker image ls`, um die Liste der Images anzuzeigen, und dann `docker image rm <image_id>`, um das alte Image zu löschen.

    ```sh
    docker image ls
    docker image rm <image_id>
    ```
Etwas schneller aber weniger Umsichtig können die alten Images mit dem Befehl `sudo docker image prune` gelöscht werden.

<!--überprüfen-->
Wird in der Compose-Datei der Build-Befehl genutzt, muss vor dem `docker pull`-Befehl noch der `build`-Befehl wie [oben](#der-docker-compose-build-befehl) neu ausgeführt werden.

Weitere Informationen zu diesem Prozess finden sich auch bei [Stack Overflow](https://stackoverflow.com/questions/49316462/how-to-update-existing-images-with-docker-compose).

Um auch andere Docker-Komponenten zu löschen, empfiehlt es ich, den docker prune-Befehl regelmäßig auszuführen. Siehe dazu die offizielle [Anleitung](https://docs.docker.com/engine/manage-resources/pruning/).

## Portainer als GUI für Docker

[Portainer](https://docs.portainer.io/) ist eine benutzerfreundliche grafische Benutzeroberfläche (GUI) für die Verwaltung von Docker-Containern. Mit Portainer können Sie Container starten, stoppen, verwalten und überwachen, ohne die Docker-Befehlszeile verwenden zu müssen.

Portainer wird selbst als Docker Container installiert und gestartet:

```sh
sudo docker volume create portainer_data
sudo docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:lts
```

Nach der Installation kann Portainer über einen Webbrowser unter `http://<Server-IP-oder-URL>:9000` erreicht werden (vorausgesetzt der Proxy Host ist eingerichtet).

Mehr Informationen finden sich in der [Dokumentation von Portainer](https://docs.portainer.io/start/install-ce/server/docker/linux).

## Docker Swarm, Podman und Kubernetes als Alternativen zu Docker

Neben Docker gibt es mehrere alternative Technologien, die ähnliche Funktionen bieten:

1. **Docker Swarm**: Docker Swarm ist eine native Clustering- und Orchestrierungslösung für Docker. Sie ermöglicht es, mehrere Docker-Hosts zu einem Cluster zusammenzufassen und Anwendungen darauf zu verteilen. Docker Swarm ist einfach zu verwenden und in Docker integriert.

2. **Podman**: Podman ist eine daemonlose Alternative zu Docker, die kompatibel mit Docker-Images und -Containern ist. Podman bietet eine ähnliche Befehlszeilensyntax wie Docker, arbeitet jedoch ohne einen zentralen Daemon, was die Sicherheit und Isolierung verbessert. So benötigt Podman standardmäßig keine Root-Rechte zum starten der der Container.

3. **Kubernetes**: Kubernetes ist eine leistungsstarke Orchestrierungsplattform für Container, die eine umfassende Verwaltung und Skalierung von Containeranwendungen ermöglicht. Kubernetes ist komplexer als Docker Swarm, bietet jedoch mehr Funktionen und Flexibilität für große und komplexe Anwendungen.


::::::::::::::::::::::::::::::::::::: keypoints 

- Dockerimages könne mit Dockerfiles angepasst werden

- ein Dockerfile ist die Bauanleitung für ein Dockerimage

- Dockerimages müssen regelmäßig aktualisiert werden

- Portainer bietet eine Weboberfläche zur Verwaltung von Docker

::::::::::::::::::::::::::::::::::::::::::::::::

