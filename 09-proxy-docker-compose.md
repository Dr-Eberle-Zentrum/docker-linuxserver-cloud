---
title: 'Proxysrever mit docker compose'
teaching: 45
exercises: 90
---

:::::::::::::::::::::::::::::::::::::: questions 

- Gibt es auch eine vereinfachte Möglichkeit für TLS-Zertifikate

- Wie installiere ich NGINX-Proxy-Manager

- Wie erstelle ich einen Proxy Host zur Weiterleitung an einen Upstream-Server

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- NGINX Proxy Manager installieren und konfigurieren

- TLS-Zertifikate mit dem NGINX-Proxy Manager erhalten

- Upstream-Server im Docker Netzwerk erreichen

::::::::::::::::::::::::::::::::::::::::::::::::

## Reverse Proxy: Logistikhub für Webapplikationen

Ein **Reverse Proxy** ist ein (Web)Server, der Anfragen von Clients entgegennimmt und sie an einen oder mehrere **Backend-Server** weiterleitet. Der Client weiß dabei nicht, dass die eigentliche Antwort von einem anderen Server kommt – er kommuniziert nur mit dem Reverse Proxy.

**Wozu wird ein Reverse Proxy eingesetzt?**  
- **Lastverteilung:** Verteilt Anfragen auf mehrere Server, um Überlastung zu vermeiden.  
- **Sicherheit:** Versteckt die eigentlichen Server hinter dem Proxy und kann Angriffe abwehren (z. B. DDoS-Schutz).  
- **Verschlüsselung (SSL/TLS):** Kann die HTTPS-Verschlüsselung zentral übernehmen (z. B. mit Let’s Encrypt).  
- **Caching:** Speichert häufig abgerufene Inhalte, um die Ladezeiten zu verbessern.  
- **URL-Routing:** Leitet Anfragen basierend auf der URL an unterschiedliche Anwendungen weiter (z. B. `/api` → Backend-Service, `/` → Webseite).

**Beispiele für Einsatzszenarien:**  
- Ein Unternehmen verwendet einen Reverse Proxy (z. B. **Nginx** oder **Apache HTTP Server**) zur zentralen Verwaltung mehrerer Webanwendungen auf einem Server.  
- Eine große Website nutzt einen Reverse Proxy, um Traffic über mehrere Server zu verteilen und die Verfügbarkeit zu erhöhen.  
- Eine Firma setzt einen Reverse Proxy ein, um HTTPS für alle Dienste zu aktivieren, ohne dass die einzelnen Anwendungen selbst SSL konfigurieren müssen.

In der vorherigen Sitzung wurde ein Apache-Webserver betrieben, der alle Anfragen direkt verarbeitet hat und die HTML-Datei an die Client geliefert hat. Möchte man jedoch mehrere Webapplikationen parallel betreiben, empfiehlt sich die Nutzung eines Reverse Proxies. Der Apache-Webserver kann dafür konfiguriert werden. Im Docker Compose Projekt der vorherigen Sitzung müsste dafür die [Konfigurationsdatei](08-webserver-docker-compose#Webserver-von-http-auf-https-umstellen) angepasst werden.

## NGINX-Proxy-Manager

Für den NGINX-Webserver existiert mit dem [NGINX-Proxy-Manager](https://nginxproxymanager.com/) jedoch ein Softwareprojekt, dass eine graphische Oberfläche für den NGINX-Webserver bereitstellt. Der NGINX-Proxy-Manager verfügt über die meisten Funktionen, die für das Betreiben eines Reverse Proxy notwendig sind. Allerdings bietet er nicht die volle Funktionalität, die NGINX hat, wenn dieser händisch (ohne graphische Oberfläche) konfiguriert und betrieben wird.

### Installation

1. Der NGINX-Proxy-Manager wird ebenfalls als Docker Compose Projekt erstellt. Dazu gehen Sie zunächst wie in der vorhergehenden Sitzung geschildert vor (Verzeichnis erstellen, Berechtigungen anpassen, compose.yaml-Datei erstellen). 

2. Nun lesen Sie das [Handbuch](https://nginxproxymanager.com/setup/) durch.

3. Übernehmen Sie die Vorlagen-Dateien und passen Sie die folgenden Punkte an:

  - Netzwerk: Datenbank und Webapp bekommen ihr eigenes Netzwerk: proxy-db und proxy-web. Der Webapp-Container ist mit beiden Netzwerken verbunden

  - Umgebunsvariablen: ersetzen Sie die Standardpasswörter und Usernamen

4. Starten Sie das Projekt: `sudo docker compose up -d

5. Öffnen Sie im Webbrowser den NGINX-Proxy-Manager mit der URL: `http://server.ddns-provider.de:81`

:::challenge

Was bedeutet die angehängte Nummer in der URL `http://server.ddns-provider.de:81` und warum ist sie wichtig?

::::::solution

Die Nummer in einer URL gibt den spezifischen Port an, über den der Client (z.B. ein Webbrowser) mit dem Webserver kommunizieren soll. Standardmäßig verwenden Webserver Port 80 für HTTP und Port 443 für HTTPS. Wenn eine andere Portnummer angegeben wird – wie in diesem Fall Port 81 – bedeutet das, dass der Server auf diesem Port angefragt wird.

Die Portnummer ist wichtig, weil ein Server auf einem Gerät (z.B. einem Rechner) gleichzeitig mehrere Dienste betreiben kann, die jeweils auf einer anderen Portnummer laufen. In unserem Fall wollen wir die Weboberfläche des NGINX-Proxy-Managers erreichen, welche auf Port 81 läuft (vergleiche dazu auch die compose.yaml-Datei). Port 80 wird benötigt werden, um Zertifikate von Letsencrypt zu beantragen.

::::::
:::

### Nutzung

Die Nutzung des NGINX-Proxy-Managers ist (zumindest in den Grundlagen) recht einfach. Um Anfragen an eine Webapplikation weiterzuleiten, wird ein Proxy-Host erstellt. Um diesen mit einem TLS-Zertifikat abzusichern wird ein solches bei der Erstellung gleich mit beantragt. Damit der NGINX-Proxy-Manager weiß, wohin die Daten weiter geleitet werden sollen, muss das Ziel angegeben werden.

Als ersten Proxy-Host erstellen Sie einen Eintrag für NGINX-Proxy-Manager selbst, um den Zugriff darauf ebenfalls per HTTPS zu sichern. Folgende Screenshots zeigen die Konfiguration.

![Grundkonfiguration mit Domain und Weiterleitungsziel. Optional können Zugriffslisten erstellt werden, um z.B. den Zugriff nur von einem bestimmten Netzwerk aus zu erlauben (z.B. dem [Uninetzwerk](https://netzkarte.zdv.uni-tuebingen.de/SubnetInfo/Table134))](fig/09_npm_proxy_01.png){alt='NGINX-Proxy-Manager: Eingabemaske für Proxy-Host, Detail-Tab'}

![Konfiguration des TLS-Zertifikats und weiterer Parameter für das HTTPS](fig/09_npm_proxy_02.png){alt='NGINX-Proxy-Manager: Eingabemaske für Proxy-Host, SSL-Tab für TLS-Zertifikate'}

### Weitere Upstream Server konfigurieren

:::challenge

## Proxy-Hostkonfiguration

Was bewirken die vorgenommenen Einstellungen für den ersten Proxy-Host?

::::::solution

Die IP-Adresse 127.0.0.1 bedeutet, dass sämtliche Anfragen an die konfigurierte Domain an die lokale Netzwerkkarte (also ohne den Server zu verlassen) mit Port 81 weitergeleitet werden. D.h. Sie können die Weboberfläche jetzt über das HTTPS ansteuern: https://server.ddns-provider.de

Die weiteren Parameter im SSL-Tab bewirken, dass eine unverschlüsselte Kommunikation über das HTTP-Protokoll unterbunden wird.

::::::

:::

:::callout

Sobald NGINX-Proxy Manager per HTTPS erreichbar ist, müssen Sie Ihr Passwort ändern, da Sie dieses zuvor unverschlüsselt per HTTP übertragen haben.

:::

Für jeden weiteren Proxy-Host benötigen Sie eine eigene Domain. D.h. Sie müssen entweder bei Ihrem DDNS-Anbieter eine weitere Domain registrieren oder, sollten Sie eine eigene Domain besitzen, für diese zusätzliche Subdomains erstellen.

Anschließend können Sie für diese Domains weitere Proxy-Hosts erstellen und TLS-Zertifikate beantragen. Voraussetzung ist dabei natürlich, dass 1. die Domain auf die richtige IP-Adresse verweist (die öffentliche IP-Adresse, unter welcher Ihr Server erreichbar ist) und 2. dass Ihre Firewall die Kommunikation über Port 80 für die Zertifikatsausstellung und Port 443 für die HTTPS-Verbindung erlaubt.

:::challenge

## Apache als Upstream-Server

Erstellen Sie einen weiteren Proxy Host. Registrieren Sie dafür eine weitere (Sub-)Domain und beantragen Sie ein TLS-Zertifikat.

Als Ziel dient der Apache-Webserver, welcher in der vorherigen Sitzung konfiguriert wurde. Die Weiterleitung kann dabei über das HTTP-Protokoll erfolgen, da die Kommunikation zwischen Proxy und Apache-Webserver auf demselben Gerät erfolgt. Unter welcher Adresse (IP oder URL) erreicht NGINX den Apache-Container?

Wie müssen Sie dafür die Apache-Konfigurationsdatei und die compose.yaml-Datei des Apache-Projekts anpassen?

::::::solution
Da die Kommunikation für die Beispiel-Internetseite jetzt wieder per HTTP erfolgt, kann die Apache-Konfigurationsdatei wieder vereinfacht werden:

```apacheconf
<VirtualHost *:80>
  DocumentRoot /usr/local/apache2/htdocs
  ServerName  server.ddns-provider.de
</VirtualHost>
```
Aus der compose.yaml-Datei kann der certbot-Container und dessen Volumes entfernt werden. Um die Kommunikation mit dem Proxy zu ermöglichen, muss das Netzwerk angepasst werden.

```YAML
services:
  apache:
    image: httpd:latest
    container_name: apache
    ports:
    - '80:80'
    volumes:
    #Beispiel-Internetseite
    - ./website:/usr/local/apache2/htdocs
    networks:
      - proxy-web

networks:
  proxy:
    name: proxy-web
    external: true
```

Wenn beide Container (Apache und NGINX) im Selben Netzwerk eingebunden sind, kann die Weiterleitung über den Container-Namen erfolgen.
::::::

:::

::::::::::::::::::::::::::::::::::::: keypoints 

- Mit dem NGINX-Proxy Manager besteht eine vereinfachte Möglichkeit für den Erhalt von TLS-Zertifikaten

- Mit einem Reverse Proxy können mehrere Webapplikationen parallel betrieben werden

- Mit korrekter Docker Netzwerkkonfiguration ist die Kommunikation zwischen Containern schnell hergestellt

::::::::::::::::::::::::::::::::::::::::::::::::

