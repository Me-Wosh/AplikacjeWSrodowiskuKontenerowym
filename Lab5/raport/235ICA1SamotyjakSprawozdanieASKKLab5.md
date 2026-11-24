### Sprawozdanie z laboratorium nr 5

**Przedmiot:** Aplikacje w środowisku kontenerowym  

**Temat:** Docker Compose — podstawy

**Data wykonania:** 24.11.2026

**Autor:** Miłosz Samotyjak

**Numer indeksu:** 25988

**Grupa:** 235IC A1

---

#### 1. Cel laboratorium

Praktyczne poznanie Docker Compose: definiowanie usług, sieci, wolumenów w pliku YAML, zarządzanie stosem aplikacji wielokontenerowych.

---

#### 2. Wstęp teoretyczny

**Docker Compose**

Oficjalne narzędzie do definiowania i uruchamiania wielokontenerowych aplikacji w środowisku Docker. Zamiast zarządzać każdym kontenerem osobno za pomocą rozbudowanych komend w terminalu, całą architekturę systemu opisuje się w 1 pliku konfiguracyjnym w formacie YAML.
W nowoczesnej inżynierii oprogramowania aplikacje rzadko działają jako pojedynczy proces. Typowy system składa się z kilku współpracujących ze sobą komponentów, na przykład:
- frontendu - aplikacja w React lub serwer Nginx,
- backendu - API w Pythonie, Node.js lub Javie,
- bazy danych - PostgreSQL lub MongoDB,
- systemu cache lub kolejkowania - Redis, RabbitMQ.
Uruchamianie każdego z tych elementów ręcznie przy użyciu polecenia `docker run` wraz z ręcznym konfigurowaniem sieci i wolumenów jest podatne na błędy i trudne do odtworzenia. Docker Compose pozwala powołać do życia lub zatrzymać całe takie środowisko pojedynczym poleceniem (`docker compose up` / `docker compose down`).

Najważniejsze aspekty Docker Compose:
- plik konfiguracyjny `docker-compose.yaml` - centralny punkt definicji środowiska. Określa się w nim, jakie obrazy mają zostać pobrane lub zbudowane, jakie porty udostępnić, jakie zmienne środowiskowe przekazać i jak połączyć poszczególne elementy,
- usługi - odpowiadają poszczególnym kontenerom (lub grupom identycznych kontenerów) wchodzącym w skład aplikacji, np. usługa web oraz usługa db,
- sieci - Docker Compose automatycznie tworzy domyślną, izolowaną sieć dla projektu. Dzięki wbudowanemu mechanizmowi DNS kontenery mogą komunikować się ze sobą bezpośrednio po nazwach swoich usług np. backend łączy się z bazą danych pod adresem db:5432, bez konieczności znajomości jej adresu IP,
- wolumeny - mechanizm zapewniający trwałość danych. Kontenery są z natury ulotne i po ich usunięciu dane wewnątrz nich przepadają natomiast wolumeny pozwalają na bezpieczne przechowywanie plików (np. danych z bazy) na dysku maszyny hosta,
- zależności `depends_on` - pozwalają określić kolejność uruchamiania oraz zatrzymywania usług np. wymuszenie, aby kontener z bazą danych wystartował przed kontenerem aplikacji.

Główne zastosowania i zalety:

| Zaleta / Zastosowanie | Opis w praktyce |
|---------|-------------|
| Infrastruktura jako kod | Plik `docker-compose.yaml` można przechowywać w systemie kontroli wersji (np. Git) razem z kodem źródłowym aplikacji. |
| Powtarzalność środowisk | Każdy programista w zespole uruchamia identyczny stos technologiczny na własnym komputerze, co eliminuje problem "u mnie działa". |
| Szybkie prototypowanie i testy | Łatwe tworzenie izolowanych środowisk do testów integracyjnych oraz CI/CD, które można usunąć natychmiast po zakończeniu pracy. |
| Prostota zarządzania | Kontrola nad cyklem życia całej aplikacji (budowanie, start, podgląd logów, skalowanie liczby replik danej usługi) z jednego miejsca. |

---

#### 3. Przebieg ćwiczeń

##### Ćwiczenie 1.1 — Prosty serwer Nginx

**Opis:** Stworzono prosty plik `docker-compose.yaml` dla serwera Nginx, uruchomiono go, sprawdzono jego status, logi i stronę startową a na koniec zatrzymano serwer.

**Użyte polecenia:**

```zsh
mkdir -p ~/VSCodes/ASKK-25988/Lab5/ex1 && cd ~/VSCodes/ASKK-25988/Lab5/ex1

# Uruchomienie
docker compose up -d

# Status
docker compose ps

# Logi
docker compose logs

# Sprawdzenie
curl http://localhost:8080

# Zatrzymanie
docker compose down
```

**Wynik działania:**

```zsh
~/VSCodes/ASKK-25988/Lab4 % mkdir -p ~/VSCodes/ASKK-25988/Lab5/ex1 && cd ~/VSCodes/ASKK-25988/Lab5/ex1

~/VSCodes/ASKK-25988/Lab5/ex1 % docker compose up -d
[+] Running 2/2
 ✔ Network ex1_default  Created                                                                   0.0s 
 ✔ Container ex1-web-1  Started                                                                   0.2s 

~/VSCodes/ASKK-25988/Lab5/ex1 % docker compose ps
NAME        IMAGE          COMMAND                  SERVICE   CREATED         STATUS         PORTS
ex1-web-1   nginx:alpine   "/docker-entrypoint.…"   web       8 seconds ago   Up 7 seconds   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp

~/VSCodes/ASKK-25988/Lab5/ex1 % docker compose logs
web-1  | /docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
web-1  | /docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
web-1  | /docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
web-1  | 10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
web-1  | 10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
web-1  | /docker-entrypoint.sh: Sourcing /docker-entrypoint.d/15-local-resolvers.envsh
web-1  | /docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
web-1  | /docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
web-1  | /docker-entrypoint.sh: Configuration complete; ready for start up
web-1  | 2026/11/23 15:19:05 [notice] 1#1: using the "epoll" event method
web-1  | 2026/11/23 15:19:05 [notice] 1#1: nginx/1.31.7
web-1  | 2026/11/23 15:19:05 [notice] 1#1: built by gcc 15.2.0 (Alpine 15.2.0) 
web-1  | 2026/11/23 15:19:05 [notice] 1#1: OS: Linux 6.12.54-linuxkit
web-1  | 2026/11/23 15:19:05 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
web-1  | 2026/11/23 15:19:05 [notice] 1#1: start worker processes
web-1  | 2026/11/23 15:19:05 [notice] 1#1: start worker process 30
web-1  | 2026/11/23 15:19:05 [notice] 1#1: start worker process 31
web-1  | 2026/11/23 15:19:05 [notice] 1#1: start worker process 32
web-1  | 2026/11/23 15:19:05 [notice] 1#1: start worker process 33
web-1  | 2026/11/23 15:19:05 [notice] 1#1: start worker process 34
web-1  | 2026/11/23 15:19:05 [notice] 1#1: start worker process 35
web-1  | 2026/11/23 15:19:05 [notice] 1#1: start worker process 36
web-1  | 2026/11/23 15:19:05 [notice] 1#1: start worker process 37

~/VSCodes/ASKK-25988/Lab5/ex1 % curl http://localhost:8080
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, nginx is successfully installed and working.
Further configuration is required for the web server, reverse proxy, 
API gateway, load balancer, content cache, or other features.</p>

<p>For online documentation and support please refer to
<a href="https://nginx.org/">nginx.org</a>.<br/>
To engage with the community please visit
<a href="https://community.nginx.org/">community.nginx.org</a>.<br/>
For enterprise grade support, professional services, additional 
security features and capabilities please refer to
<a href="https://f5.com/nginx">f5.com/nginx</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>

~/VSCodes/ASKK-25988/Lab5/ex1 % docker compose down
[+] Running 2/2
 ✔ Container ex1-web-1  Removed                                                                   0.3s 
 ✔ Network ex1_default  Removed
```

**Screenshot:**

![Wynik docker compose ps](images/image.png)

Rys. 1 - Wynik `docker compose ps`.

---

##### Ćwiczenie 1.2 — Wiele usług

**Opis:** Uruchomiono 3 usługi: Nginx, bazę danych PostgreSQL i Redis w ramach jednego `docker-compose` oraz sprawdzono logi i wersję bazy PostgreSQL.

**Użyte polecenia:**

```zsh
mkdir -p ~/VSCodes/ASKK-25988/Lab5/ex2 && cd ~/VSCodes/ASKK-25988/Lab5/ex2

docker compose up -d
docker compose ps
docker compose logs db
docker compose exec db psql -U postgres -c "SELECT version();"
docker compose down
```

**Wynik działania:**

```zsh
~/VSCodes/ASKK-25988/Lab5/ex1 % mkdir -p ~/VSCodes/ASKK-25988/Lab5/ex2 && cd ~/VSCodes/ASKK-25988/Lab5/ex2

~/VSCodes/ASKK-25988/Lab5/ex2 % docker compose up -d
[+] Running 4/4
 ✔ Network ex2_default    Created                                                                 0.0s 
 ✔ Container ex2-web-1    Started                                                                 0.3s 
 ✔ Container ex2-cache-1  Started                                                                 0.3s 
 ✔ Container ex2-db-1     Started                                                                 0.3s 

~/VSCodes/ASKK-25988/Lab5/ex2 % docker compose ps
NAME          IMAGE                COMMAND                  SERVICE   CREATED         STATUS         PORTS
ex2-cache-1   redis:7-alpine       "docker-entrypoint.s…"   cache     6 seconds ago   Up 6 seconds   6379/tcp
ex2-db-1      postgres:16-alpine   "docker-entrypoint.s…"   db        6 seconds ago   Up 6 seconds   5432/tcp
ex2-web-1     nginx:alpine         "/docker-entrypoint.…"   web       6 seconds ago   Up 6 seconds   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp

~/VSCodes/ASKK-25988/Lab5/ex2 % docker compose logs db
db-1  | The files belonging to this database system will be owned by user "postgres".
db-1  | This user must also own the server process.
db-1  | 
db-1  | The database cluster will be initialized with locale "en_US.utf8".
db-1  | The default database encoding has accordingly been set to "UTF8".
db-1  | The default text search configuration will be set to "english".
db-1  | 
db-1  | Data page checksums are disabled.
db-1  | 
db-1  | fixing permissions on existing directory /var/lib/postgresql/data ... ok
db-1  | creating subdirectories ... ok
db-1  | selecting dynamic shared memory implementation ... posix
db-1  | selecting default max_connections ... 100
db-1  | selecting default shared_buffers ... 128MB
db-1  | selecting default time zone ... UTC
db-1  | creating configuration files ... ok
db-1  | running bootstrap script ... ok
db-1  | sh: locale: not found
db-1  | 2026-11-23 15:26:22.437 UTC [35] WARNING:  no usable system locales were found
db-1  | performing post-bootstrap initialization ... ok
db-1  | syncing data to disk ... ok
db-1  | 
db-1  | 
db-1  | Success. You can now start the database server using:
db-1  | 
db-1  |     pg_ctl -D /var/lib/postgresql/data -l logfile start
db-1  | 
db-1  | initdb: warning: enabling "trust" authentication for local connections
db-1  | initdb: hint: You can change this by editing pg_hba.conf or using the option -A, or --auth-local and --auth-host, the next time you run initdb.
db-1  | waiting for server to start....2026-11-23 15:26:22.732 UTC [41] LOG:  starting PostgreSQL 16.15 on aarch64-unknown-linux-musl, compiled by gcc (Alpine 15.2.0) 15.2.0, 64-bit
db-1  | 2026-11-23 15:26:22.732 UTC [41] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
db-1  | 2026-11-23 15:26:22.734 UTC [44] LOG:  database system was shut down at 2026-11-23 15:26:22 UTC
db-1  | 2026-11-23 15:26:22.736 UTC [41] LOG:  database system is ready to accept connections
db-1  |  done
db-1  | server started
db-1  | CREATE DATABASE
db-1  | 
db-1  | 
db-1  | /usr/local/bin/docker-entrypoint.sh: ignoring /docker-entrypoint-initdb.d/*
db-1  | 
db-1  | waiting for server to shut down....2026-11-23 15:26:22.870 UTC [41] LOG:  received fast shutdown request
db-1  | 2026-11-23 15:26:22.871 UTC [41] LOG:  aborting any active transactions
db-1  | 2026-11-23 15:26:22.872 UTC [41] LOG:  background worker "logical replication launcher" (PID 47) exited with exit code 1
db-1  | 2026-11-23 15:26:22.872 UTC [42] LOG:  shutting down
db-1  | 2026-11-23 15:26:22.873 UTC [42] LOG:  checkpoint starting: shutdown immediate
db-1  | 2026-11-23 15:26:22.897 UTC [42] LOG:  checkpoint complete: wrote 926 buffers (5.7%); 0 WAL file(s) added, 0 removed, 0 recycled; write=0.007 s, sync=0.016 s, total=0.025 s; sync files=301, longest=0.006 s, average=0.001 s; distance=4283 kB, estimate=4283 kB; lsn=0/1925D18, redo lsn=0/1925D18
db-1  | 2026-11-23 15:26:22.899 UTC [41] LOG:  database system is shut down
db-1  |  done
db-1  | server stopped
db-1  | 
db-1  | PostgreSQL init process complete; ready for start up.
db-1  | 
db-1  | 2026-11-23 15:26:22.991 UTC [1] LOG:  starting PostgreSQL 16.15 on aarch64-unknown-linux-musl, compiled by gcc (Alpine 15.2.0) 15.2.0, 64-bit
db-1  | 2026-11-23 15:26:22.991 UTC [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
db-1  | 2026-11-23 15:26:22.991 UTC [1] LOG:  listening on IPv6 address "::", port 5432
db-1  | 2026-11-23 15:26:22.993 UTC [1] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
db-1  | 2026-11-23 15:26:22.995 UTC [57] LOG:  database system was shut down at 2026-11-23 15:26:22 UTC
db-1  | 2026-11-23 15:26:22.997 UTC [1] LOG:  database system is ready to accept connections

~/VSCodes/ASKK-25988/Lab5/ex2 % docker compose exec db psql -U postgres -c "SELECT version();"
                                            version                                             
------------------------------------------------------------------------------------------------
 PostgreSQL 16.15 on aarch64-unknown-linux-musl, compiled by gcc (Alpine 15.2.0) 15.2.0, 64-bit
(1 row)

~/VSCodes/ASKK-25988/Lab5/ex2 % docker compose down
[+] Running 4/4
 ✔ Container ex2-web-1    Removed                                                                 0.2s 
 ✔ Container ex2-db-1     Removed                                                                 0.1s 
 ✔ Container ex2-cache-1  Removed                                                                 0.3s 
 ✔ Network ex2_default    Removed                                                                 0.2s
```

**Screenshot:**

![Trzy usługi działające jednocześnie](images/image-1.png)

Rys. 2 - Trzy usługi działające jednocześnie.

---

##### Ćwiczenie 2.1 — Flask + PostgreSQL

**Opis:** Stworzono plik `docker-compose.yaml` z aplikacją Flask i bazą danych PostgreSQL, uruchomiono cały stos i przetestowano działanie wszystkich endpointów.

**Użyte polecenia:**

```zsh
mkdir -p ~/VSCodes/ASKK-25988/Lab5/flask-app && cd ~/VSCodes/ASKK-25988/Lab5/flask-app

docker compose up -d --build
docker compose ps
curl http://localhost:5001
curl http://localhost:5001/db
curl http://localhost:5001/health
```

**Wynik działania:**

```zsh
~/VSCodes/ASKK-25988/Lab5/ex2 % mkdir -p ~/VSCodes/ASKK-25988/Lab5/flask-app && cd ~/VSCodes/ASKK-25988/Lab5/flask-app

~/VSCodes/ASKK-25988/Lab5/flask-app % docker compose up -d --build
[+] Building 0.4s (12/12) FINISHED                                                                     
 => [internal] load local bake definitions                                                        0.0s
 => => reading from stdin 539B                                                                    0.0s
 => [internal] load build definition from Dockerfile                                              0.0s
 => => transferring dockerfile: 195B                                                              0.0s
 => [internal] load metadata for docker.io/library/python:3.11-slim                               0.0s
 => [internal] load .dockerignore                                                                 0.0s
 => => transferring context: 2B                                                                   0.0s
 => [1/5] FROM docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f245004868  0.0s
 => => resolve docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f245004868  0.0s
 => [internal] load build context                                                                 0.0s
 => => transferring context: 684B                                                                 0.0s
 => CACHED [2/5] WORKDIR /app                                                                     0.0s
 => CACHED [3/5] COPY requirements.txt .                                                          0.0s
 => CACHED [4/5] RUN pip install --no-cache-dir -r requirements.txt                               0.0s
 => [5/5] COPY . .                                                                                0.0s
 => exporting to image                                                                            0.1s
 => => exporting layers                                                                           0.0s
 => => exporting manifest sha256:875bfdc994b8f6bfdf8b418a58a6eb7f0e82dc3cd4533f0794884fa545d5d0d  0.0s
 => => exporting config sha256:aab6dd97dd88f98b4ed2387e93c507572401a4d6a6a287a1423fa86a98bca463   0.0s
 => => exporting attestation manifest sha256:342cc50e6436e713cd67775c34e502779f609d8221202040499  0.0s
 => => exporting manifest list sha256:0f7ba12346c894ae0fde5fcf8a76c231cb2565b677ff5464e255e16f16  0.0s
 => => naming to docker.io/library/flask-app-app:latest                                           0.0s
 => => unpacking to docker.io/library/flask-app-app:latest                                        0.0s
 => resolving provenance for metadata file                                                        0.0s
[+] Running 4/4
 ✔ flask-app-app              Built                                                               0.0s 
 ✔ Network flask-app_default  Created                                                             0.0s 
 ✔ Container flask-app-db-1   Healthy                                                             5.8s 
 ✔ Container flask-app-app-1  Started                                                             5.8s 

~/VSCodes/ASKK-25988/Lab5/flask-app % docker compose ps
NAME              IMAGE                COMMAND                  SERVICE   CREATED          STATUS                    PORTS
flask-app-app-1   flask-app-app        "python app.py"          app       12 seconds ago   Up 6 seconds              0.0.0.0:5001->5000/tcp, [::]:5001->5000/tcp
flask-app-db-1    postgres:16-alpine   "docker-entrypoint.s…"   db        12 seconds ago   Up 11 seconds (healthy)   5432/tcp

~/VSCodes/ASKK-25988/Lab5/flask-app % curl http://localhost:5001
<h1>Flask + PostgreSQL w Docker Compose</h1>%

~/VSCodes/ASKK-25988/Lab5/flask-app % curl http://localhost:5001/db
{"status":"connected","version":"PostgreSQL 16.16 on aarch64-unknown-linux-musl, compiled by gcc (Alpine 15.2.0) 15.2.0, 64-bit"}

~/VSCodes/ASKK-25988/Lab5/flask-app % curl http://localhost:5001/health
{"status":"ok"}
```

**Screenshot:**

![Aplikacja Flask połączona z PostgreSQL](images/image-2.png)

Rys. 3 - Aplikacja Flask połączona z PostgreSQL.

---

##### Ćwiczenie 2.2 — Dodanie Adminer

**Opis:** Dodano usługę Adminer do istniejącego pliku `docker-compose.yaml` i za jej pomocą połączono się z bazą danych.

**Użyte polecenia:**

```zsh
docker compose up -d
# Otwórz http://localhost:8080 — Server: db, User: postgres, Password: secret
```

**Wynik działania:**

```zsh
~/VSCodes/ASKK-25988/Lab5/flask-app % docker compose up -d
[+] Running 3/3
 ✔ Container flask-app-db-1       Healthy                                                         0.6s 
 ✔ Container flask-app-app-1      Running                                                         0.0s 
 ✔ Container flask-app-adminer-1  Started                                                         0.2s 
```

**Screenshot:**

![Adminer połączony z bazą danych](images/image-3.png)

Rys. 4 - Adminer połączony z bazą danych.

---

##### Ćwiczenie 3.1 — Plik .env

**Opis:** Stworzono plik `.env` dla Docker Compose i sprawdzono interpolację zmiennych środowiskowych (automatyczne podstawienie wartości pod placeholdery typu `${POSTGRES_PASSWORD}`).

**Użyte polecenia:**

```zsh
mkdir -p ~/VSCodes/ASKK-25988/Lab5/env-test && cd ~/VSCodes/ASKK-25988/Lab5/env-test

# Sprawdź interpolację zmiennych
docker compose config

# Uruchom
docker compose up -d
docker compose exec db psql -U admin -d production_db -c "SELECT current_user, current_database();"
docker compose down
```

**Wynik działania:**

```zsh
~/VSCodes/ASKK-25988/Lab5/env-test % docker compose config
name: env-test
services:
  adminer:
    image: adminer
    networks:
      default: null
    ports:
      - mode: ingress
        target: 8080
        published: "5002"
        protocol: tcp
  db:
    environment:
      POSTGRES_DB: production_db
      POSTGRES_PASSWORD: super_secret_123
      POSTGRES_USER: admin
    image: postgres:16-alpine
    networks:
      default: null
    ports:
      - mode: ingress
        target: 5432
        published: "5432"
        protocol: tcp
networks:
  default:
    name: env-test_default

~/VSCodes/ASKK-25988/Lab5/env-test % docker compose up -d 
[+] Running 3/3
 ✔ Network env-test_default      Created                                                          0.0s 
 ✔ Container env-test-adminer-1  Started                                                          0.2s 
 ✔ Container env-test-db-1       Started                                                          0.2s 

~/VSCodes/ASKK-25988/Lab5/env-test % docker compose exec db psql -U admin -d production_db -c "SELECT current_user, current_database();"
 current_user | current_database 
--------------+------------------
 admin        | production_db
(1 row)

~/VSCodes/ASKK-25988/Lab5/env-test % docker compose down
[+] Running 3/3
 ✔ Container env-test-db-1       Removed                                                          0.3s 
 ✔ Container env-test-adminer-1  Removed                                                          0.2s 
 ✔ Network env-test_default      Removed                                                          0.2s
```

**Screenshot:**

![Zmienne z .env użyte w konfiguracji](images/image-4.png)

Rys. 5 - Zmienne z .env użyte w konfiguracji.

---

##### Ćwiczenie 3.2 — env_file

**Opis:** Stworzono i wstrzyknięto plik `.env` dla aplikacji Python a następnie odczytano wartości wstrzykniętych zmiennych środowiskowych za pomocą prostego skryptu.

**Użyte polecenia:**

```zsh
docker compose run --rm app
```

**Wynik działania:**

```zsh
~/VSCodes/ASKK-25988/Lab5/env-test % docker compose run --rm app
[+] Creating 1/1
 ✔ Network env-test_default  Created                                                              0.0s 
SECRET_KEY=my-secret-key-123
LOG_LEVEL=debug
DEBUG=true
```

---

##### Ćwiczenie 4.1 — Izolacja sieciowa

**Opis:** Stworzono plik `docker-compose.yaml` z dwoma sieciami: `frontend` i `backend` (z czego 1 wewnętrzną) i 3 aplikacjami: Nginx, Alpine i PostgreSQL. Kontener z Nginx podłączono do sieci `frontend`, PostgreSQL do sieci `backend` a Alpine do obydwu sieci. Następnie sprawdzono, czy kontener Alpine znajdujący się w obydwu sieciach jest w stanie komunikować się z pozostałymi kontenerami oraz zweryfikowano czy Nginx nie widzi bazy danych, jak również czy baza danych znajdująca się w wewnętrznej sieci nie może nawiązać połączenia z Internetem.

**Użyte polecenia:**

```zsh
mkdir -p ~/VSCodes/ASKK-25988/Lab5/networks && cd ~/VSCodes/ASKK-25988/Lab5/networks

docker compose up -d

# App widzi nginx i db
docker compose exec app ping -c 2 nginx
docker compose exec app ping -c 2 db

# Nginx NIE widzi db
docker compose exec nginx ping -c 2 db  # FAIL

# Backend nie ma internetu
docker compose exec db ping -c 2 8.8.8.8  # FAIL

docker compose down
```

**Wynik działania:**

```zsh
~/VSCodes/ASKK-25988/Lab5/env-test % mkdir -p ~/VSCodes/ASKK-25988/Lab5/networks && cd ~/VSCodes/ASKK-25988/Lab5/networks

~/VSCodes/ASKK-25988/Lab5/networks % docker compose up -d
[+] Running 5/5
 ✔ Network networks_frontend   Created                                                            0.0s 
 ✔ Network networks_backend    Created                                                            0.0s 
 ✔ Container networks-app-1    Started                                                            0.3s 
 ✔ Container networks-nginx-1  Started                                                            0.3s 
 ✔ Container networks-db-1     Started                                                            0.2s 

~/VSCodes/ASKK-25988/Lab5/networks % docker compose exec app ping -c 2 nginx
PING nginx (172.20.0.2): 56 data bytes
64 bytes from 172.20.0.2: seq=0 ttl=64 time=0.102 ms
64 bytes from 172.20.0.2: seq=1 ttl=64 time=0.143 ms

--- nginx ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max = 0.102/0.122/0.143 ms

~/VSCodes/ASKK-25988/Lab5/networks % docker compose exec app ping -c 2 db
PING db (172.21.0.3): 56 data bytes
64 bytes from 172.21.0.3: seq=0 ttl=64 time=0.104 ms
64 bytes from 172.21.0.3: seq=1 ttl=64 time=0.134 ms

--- db ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max = 0.104/0.119/0.134 ms

~/VSCodes/ASKK-25988/Lab5/networks % docker compose exec nginx ping -c 2 db
ping: bad address 'db'

~/VSCodes/ASKK-25988/Lab5/networks % docker compose exec db ping -c 2 8.8.8.8
PING 8.8.8.8 (8.8.8.8): 56 data bytes
ping: sendto: Network unreachable

~/VSCodes/ASKK-25988/Lab5/networks % docker compose down
[+] Running 5/5
 ✔ Container networks-app-1    Removed                                                            1.2s 
 ✔ Container networks-db-1     Removed                                                            0.1s 
 ✔ Container networks-nginx-1  Removed                                                            0.2s 
 ✔ Network networks_backend    Removed                                                            0.1s 
 ✔ Network networks_frontend   Removed                                                            0.3s
```

**Screenshot:**

![Izolacja sieciowa w Docker Compose](images/image-5.png)

Rys. 6 - Izolacja sieciowa w Docker Compose.

---

##### Ćwiczenie 4.2 — Wolumeny nazwane

**Opis:** Utworzono plik `docker-compose.yaml` z PostgreSQL, wolumenem i skryptem inicjalizującym tabelę `tasks` oraz sprawdzono, czy dane w wolumenie przetrwają wyłączenie całego stosu Docker Compose.

**Użyte polecenia:**

```zsh
mkdir -p ~/VSCodes/ASKK-25988/Lab5/named-volumes && cd ~/VSCodes/ASKK-25988/Lab5/named-volumes

docker compose up -d
sleep 3
docker compose exec db psql -U postgres -c "SELECT * FROM tasks;"

# Dane przetrwają docker compose down (bez -v)
docker compose down
docker compose up -d
sleep 3
docker compose exec db psql -U postgres -c "SELECT * FROM tasks;"

# Usunięcie z wolumenami
docker compose down -v
```

**Wynik działania:**

```zsh
~/VSCodes/ASKK-25988/Lab5/networks % mkdir -p ~/VSCodes/ASKK-25988/Lab5/named-volumes && cd ~/VSCodes/ASKK-25988/Lab5/named-volumes

~/VSCodes/ASKK-25988/Lab5/named-volumes % docker compose up -d
[+] Running 3/3
 ✔ Network named-volumes_default  Created                                                         0.0s 
 ✔ Volume named-volumes_pgdata    Created                                                         0.0s 
 ✔ Container named-volumes-db-1   Started                                                         0.1s 

~/VSCodes/ASKK-25988/Lab5/named-volumes % docker compose exec db psql -U postgres -c "SELECT * FROM tasks;"
 id |           title            | done 
----+----------------------------+------
  1 | Nauczyć się Docker Compose | f
  2 | Zrobić projekt             | f
(2 rows)

~/VSCodes/ASKK-25988/Lab5/named-volumes % docker compose down
[+] Running 2/2
 ✔ Container named-volumes-db-1   Removed                                                         0.1s 
 ✔ Network named-volumes_default  Removed                                                         0.2s 

~/VSCodes/ASKK-25988/Lab5/named-volumes % docker compose up -d
[+] Running 2/2
 ✔ Network named-volumes_default  Created                                                         0.0s 
 ✔ Container named-volumes-db-1   Started                                                         0.1s 

~/VSCodes/ASKK-25988/Lab5/named-volumes % docker compose exec db psql -U postgres -c "SELECT * FROM tasks;"
 id |           title            | done 
----+----------------------------+------
  1 | Nauczyć się Docker Compose | f
  2 | Zrobić projekt             | f
(2 rows)

~/VSCodes/ASKK-25988/Lab5/named-volumes % docker compose down -v
[+] Running 3/3
 ✔ Container named-volumes-db-1   Removed                                                         0.1s 
 ✔ Network named-volumes_default  Removed                                                         0.2s 
 ✔ Volume named-volumes_pgdata    Removed                                                         0.0s
```

**Screenshot:**

![Dane z init.sql załadowane automatycznie](images/image-6.png)

Rys. 7 - Dane z init.sql załadowane automatycznie.

---

##### Ćwiczenie 5.1 — Przegląd komend

**Opis:** Sprawdzono różne komendy `docker compose`: `build` (buduje lub przebudowuje obrazy kontenerów), `up` (tworzy i uruchamia kontenery dla zdefiniowanych usług), `logs` (wyświetla strumień logów z uruchomionych kontenerów), `exec` (wykonuje polecenie wewnątrz już działającego kontenera), `run` (uruchamia jednorazowe polecenie w nowym, tymczasowym kontenerze), `ps` (wyświetla listę kontenerów należących do projektu wraz z ich statusem), `port` (wyświetla publiczny port na hoście zmapowany do prywatnego portu kontenera), `restart` (ponownie uruchamia zatrzymane lub działające usługi), `stop` (zatrzymuje działające kontenery bez ich usuwania), `start` (uruchamia istniejące, wcześniej zatrzymane kontenery), `down` (zatrzymuje i usuwa kontenery, sieci oraz opcjonalnie wolumeny).

**Użyte polecenia:**

```zsh
cd ~/VSCodes/ASKK-25988/Lab5/flask-app

docker compose up -d

# Build
docker compose build
docker compose build --no-cache app

# Up z budowaniem
docker compose up -d --build

# Logi konkretnej usługi
docker compose logs -f app
# Ctrl+C

# Exec
docker compose exec app python -c "print('Hello from app')"
docker compose exec db psql -U postgres -c "SELECT 1;"

# Run (jednorazowe uruchomienie)
docker compose run --rm app python -c "print('One-time command')"

# Skalowanie (najpierw zmień mapowanie portów — patrz uwaga poniżej)
docker compose up -d --scale app=3
docker compose ps
docker compose port --index=2 app 5001   # port hosta 2. repliki

# Restart
docker compose restart app

# Powrót do jednej repliki
docker compose up -d --scale app=1

# Stop vs Down
docker compose stop    # zatrzymuje, nie usuwa
docker compose start   # uruchamia ponownie
docker compose down    # zatrzymuje i usuwa
docker compose down -v # + usuwa wolumeny
```

**Wynik działania:**

```zsh
~/VSCodes/ASKK-25988/Lab5/named-volumes % cd ~/VSCodes/ASKK-25988/Lab5/flask-app

~/VSCodes/ASKK-25988/Lab5/flask-app % docker compose up -d
[+] Running 3/3
 ✔ Container flask-app-db-1       Healthy                                                         1.8s 
 ✔ Container flask-app-adminer-1  Running                                                         0.0s 
 ✔ Container flask-app-app-1      Started                                                         1.9s 

~/VSCodes/ASKK-25988/Lab5/flask-app % docker compose build
[+] Building 0.4s (12/12) FINISHED                                                                     
 => [internal] load local bake definitions                                                        0.0s
 => => reading from stdin 539B                                                                    0.0s
 => [internal] load build definition from Dockerfile                                              0.0s
 => => transferring dockerfile: 195B                                                              0.0s
 => [internal] load metadata for docker.io/library/python:3.11-slim                               0.0s
 => [internal] load .dockerignore                                                                 0.0s
 => => transferring context: 2B                                                                   0.0s
 => [1/5] FROM docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f245004868  0.0s
 => => resolve docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f245004868  0.0s
 => [internal] load build context                                                                 0.0s
 => => transferring context: 836B                                                                 0.0s
 => CACHED [2/5] WORKDIR /app                                                                     0.0s
 => CACHED [3/5] COPY requirements.txt .                                                          0.0s
 => CACHED [4/5] RUN pip install --no-cache-dir -r requirements.txt                               0.0s
 => [5/5] COPY . .                                                                                0.0s
 => exporting to image                                                                            0.1s
 => => exporting layers                                                                           0.0s
 => => exporting manifest sha256:9e7fb618645e0f2836cb4db73c05db649d337ff8d179aa9f0125255c6f783be  0.0s
 => => exporting config sha256:d5a14d3bf51e8d3bb0f9117b5fc0917a53c4875e2b7bd64f6f1d6ee368aede65   0.0s
 => => exporting attestation manifest sha256:f4d957fba104ec2259d2700744c631c3d63c40e65d9d768c050  0.0s
 => => exporting manifest list sha256:31941ee23a9a4b8df79241858555abcaaa3c9440360a3f2c936ab0c32b  0.0s
 => => naming to docker.io/library/flask-app-app:latest                                           0.0s
 => => unpacking to docker.io/library/flask-app-app:latest                                        0.0s
 => resolving provenance for metadata file                                                        0.0s
[+] Building 1/1
 ✔ flask-app-app  Built                                                                           0.0s 

~/VSCodes/ASKK-25988/Lab5/flask-app % docker compose build --no-cache app
[+] Building 5.2s (12/12) FINISHED                                                                     
 => [internal] load local bake definitions                                                        0.0s
 => => reading from stdin 563B                                                                    0.0s
 => [internal] load build definition from Dockerfile                                              0.0s
 => => transferring dockerfile: 195B                                                              0.0s
 => [internal] load metadata for docker.io/library/python:3.11-slim                               0.0s
 => [internal] load .dockerignore                                                                 0.0s
 => => transferring context: 2B                                                                   0.0s
 => [1/5] FROM docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f245004868  0.0s
 => => resolve docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f245004868  0.0s
 => [internal] load build context                                                                 0.0s
 => => transferring context: 132B                                                                 0.0s
 => CACHED [2/5] WORKDIR /app                                                                     0.0s
 => [3/5] COPY requirements.txt .                                                                 0.0s
 => [4/5] RUN pip install --no-cache-dir -r requirements.txt                                      4.1s
 => [5/5] COPY . .                                                                                0.0s 
 => exporting to image                                                                            0.8s 
 => => exporting layers                                                                           0.6s 
 => => exporting manifest sha256:5785a60ee4296f968a13535e8d98433eb98c45c408e82ad7ce475de8e315856  0.0s 
 => => exporting config sha256:fdded166f2a16142de824a8fd9cd54d50b7cb5a35d0d8df013edd66765ca9f86   0.0s 
 => => exporting attestation manifest sha256:7f4be562c0e6207588c6d6b025461a78c3ecd94b08fede42412  0.0s 
 => => exporting manifest list sha256:82a419210e402d625acd2425e8cb33c0ae08fa116892fbeea8a5833754  0.0s
 => => naming to docker.io/library/flask-app-app:latest                                           0.0s
 => => unpacking to docker.io/library/flask-app-app:latest                                        0.1s
 => resolving provenance for metadata file                                                        0.0s
[+] Building 1/1
 ✔ flask-app-app  Built                                                                           0.0s 

~/VSCodes/ASKK-25988/Lab5/flask-app % docker compose up -d --build
[+] Building 0.3s (12/12) FINISHED                                                                     
 => [internal] load local bake definitions                                                        0.0s
 => => reading from stdin 539B                                                                    0.0s
 => [internal] load build definition from Dockerfile                                              0.0s
 => => transferring dockerfile: 195B                                                              0.0s
 => [internal] load metadata for docker.io/library/python:3.11-slim                               0.0s
 => [internal] load .dockerignore                                                                 0.0s
 => => transferring context: 2B                                                                   0.0s
 => [1/5] FROM docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f245004868  0.0s
 => => resolve docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f245004868  0.0s
 => [internal] load build context                                                                 0.0s
 => => transferring context: 132B                                                                 0.0s
 => CACHED [2/5] WORKDIR /app                                                                     0.0s
 => CACHED [3/5] COPY requirements.txt .                                                          0.0s
 => CACHED [4/5] RUN pip install --no-cache-dir -r requirements.txt                               0.0s
 => CACHED [5/5] COPY . .                                                                         0.0s
 => exporting to image                                                                            0.0s
 => => exporting layers                                                                           0.0s
 => => exporting manifest sha256:5785a60ee4296f968a13535e8d98433eb98c45c408e82ad7ce475de8e315856  0.0s
 => => exporting config sha256:fdded166f2a16142de824a8fd9cd54d50b7cb5a35d0d8df013edd66765ca9f86   0.0s
 => => exporting attestation manifest sha256:9db0ef70385635df9767bad1850185aef16d235dc0dc5222500  0.0s
 => => exporting manifest list sha256:4e929e132dfcf632386435025607b5c54f155cbe7f3c9ee1efec19d99e  0.0s
 => => naming to docker.io/library/flask-app-app:latest                                           0.0s
 => => unpacking to docker.io/library/flask-app-app:latest                                        0.0s
 => resolving provenance for metadata file                                                        0.0s
[+] Running 4/4
 ✔ flask-app-app                  Built                                                           0.0s 
 ✔ Container flask-app-db-1       Healthy                                                         1.9s 
 ✔ Container flask-app-adminer-1  Running                                                         0.0s 
 ✔ Container flask-app-app-1      Started                                                         2.0s 

~/VSCodes/ASKK-25988/Lab5/flask-app % docker compose logs -f app
app-1  |  * Serving Flask app 'app'
app-1  |  * Debug mode: off
app-1  | WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
app-1  |  * Running on all addresses (0.0.0.0)
app-1  |  * Running on http://127.0.0.1:5000
app-1  |  * Running on http://172.18.0.3:5000
app-1  | Press CTRL+C to quit
^C

~/VSCodes/ASKK-25988/Lab5/flask-app % docker compose exec app python -c "print('Hello from app')"
Hello from app

~/VSCodes/ASKK-25988/Lab5/flask-app % docker compose exec db psql -U postgres -c "SELECT 1;"
 ?column? 
----------
        1
(1 row)

~/VSCodes/ASKK-25988/Lab5/flask-app % docker compose run --rm app python -c "print('One-time command')" 
[+] Creating 1/1
 ✔ Container flask-app-db-1  Running                                                              0.0s 
One-time command

~/VSCodes/ASKK-25988/Lab5/flask-app % docker compose up -d --scale app=3
[+] Running 5/5
 ✔ Container flask-app-db-1       Healthy                                                         0.6s 
 ✔ Container flask-app-app-1      Running                                                         0.0s 
 ✔ Container flask-app-app-3      Started                                                         0.7s 
 ✔ Container flask-app-adminer-1  Running                                                         0.0s 
 ✔ Container flask-app-app-2      Started                                                         0.8s 

~/VSCodes/ASKK-25988/Lab5/flask-app % docker compose ps
NAME                  IMAGE                COMMAND                  SERVICE   CREATED          STATUS                 PORTS
flask-app-adminer-1   adminer              "entrypoint.sh docke…"   adminer   5 hours ago      Up 5 hours             0.0.0.0:8080->8080/tcp, [::]:8080->8080/tcp
flask-app-app-1       flask-app-app        "python app.py"          app       56 seconds ago   Up 54 seconds          0.0.0.0:5002->5000/tcp, [::]:5002->5000/tcp
flask-app-app-2       flask-app-app        "python app.py"          app       10 seconds ago   Up 8 seconds           0.0.0.0:5001->5000/tcp, [::]:5001->5000/tcp
flask-app-app-3       flask-app-app        "python app.py"          app       10 seconds ago   Up 8 seconds           0.0.0.0:5003->5000/tcp, [::]:5003->5000/tcp
flask-app-db-1        postgres:16-alpine   "docker-entrypoint.s…"   db        5 hours ago      Up 5 hours (healthy)   5432/tcp

~/VSCodes/ASKK-25988/Lab5/flask-app % docker compose port --index=2 app 5000
0.0.0.0:5001

~/VSCodes/ASKK-25988/Lab5/flask-app % docker compose restart app
[+] Restarting 3/3
 ✔ Container flask-app-app-1  Started                                                             1.4s 
 ✔ Container flask-app-app-3  Started                                                             1.4s 
 ✔ Container flask-app-app-2  Started                                                             1.4s 

~/VSCodes/ASKK-25988/Lab5/flask-app % docker compose up -d --scale app=1
[+] Running 5/5
 ✔ Container flask-app-db-1       Healthy                                                         1.8s 
 ✔ Container flask-app-adminer-1  Running                                                         0.0s 
 ✔ Container flask-app-app-1      Running                                                         0.0s 
 ✔ Container flask-app-app-3      Removed                                                         1.3s 
 ✔ Container flask-app-app-2      Removed                                                         1.2s 

~/VSCodes/ASKK-25988/Lab5/flask-app % docker compose stop
[+] Stopping 3/3
 ✔ Container flask-app-app-1      Stopped                                                         1.2s 
 ✔ Container flask-app-adminer-1  Stopped                                                         0.2s 
 ✔ Container flask-app-db-1       Stopped                                                         0.1s 

~/VSCodes/ASKK-25988/Lab5/flask-app % docker compose start
[+] Running 3/3
 ✔ Container flask-app-db-1       Healthy                                                         5.6s 
 ✔ Container flask-app-adminer-1  Started                                                         0.1s 
 ✔ Container flask-app-app-1      Started                                                         0.1s 

~/VSCodes/ASKK-25988/Lab5/flask-app % docker compose down
[+] Running 4/4
 ✔ Container flask-app-app-1      Removed                                                         1.2s 
 ✔ Container flask-app-adminer-1  Removed                                                         0.2s 
 ✔ Container flask-app-db-1       Removed                                                         0.1s 
 ✔ Network flask-app_default      Removed                                                         0.2s 

~/VSCodes/ASKK-25988/Lab5/flask-app % docker compose down -v
[+] Running 1/1
 ✔ Volume flask-app_db-data  Removed                                                              0.0s 
```

**Screenshot:**

![Skalowanie usługi (--scale app=3)](images/image-7.png)

Rys. 8 - Skalowanie usługi (`--scale app=3`).

---

##### Ćwiczenie 6.1 — Prawidłowa kolejność uruchamiania

**Opis:** Stworzono plik `docker-compose.yaml` z 3 usługami: Redis, PostgreSQL i Alpine oraz prostym healthcheckiem i kolejnością uruchamiania serwisów - najpierw bazy danych a dopiero potem Alpine.

**Użyte polecenia:**

```zsh
mkdir -p ~/VSCodes/ASKK-25988/Lab5/depends && cd ~/VSCodes/ASKK-25988/Lab5/depends

docker compose up -d
docker compose ps  # Obserwuj kolumnę STATUS (healthy)
docker compose logs app  # App uruchomiony po db i cache
docker compose down
```

**Wynik działania:**

```zsh
~/VSCodes/ASKK-25988/Lab5/flask-app % mkdir -p ~/VSCodes/ASKK-25988/Lab5/depends && cd ~/VSCodes/ASKK-25988/Lab5/depends

~/VSCodes/ASKK-25988/Lab5/depends % docker compose up -d
[+] Running 3/3
 ✔ app Pulled                                                                                     3.3s 
 ✔ db Pulled                                                                                      3.3s 
 ✔ cache Pulled                                                                                   3.3s 
[+] Running 4/4
 ✔ Network depends_default    Created                                                             0.0s 
 ✔ Container depends-db-1     Healthy                                                             5.9s 
 ✔ Container depends-cache-1  Healthy                                                             3.9s 
 ✔ Container depends-app-1    Started                                                             5.9s 

~/VSCodes/ASKK-25988/Lab5/depends % docker compose ps
NAME              IMAGE                COMMAND                  SERVICE   CREATED         STATUS                   PORTS
depends-app-1     alpine               "sh -c 'echo 'App st…"   app       7 seconds ago   Up 1 second              
depends-cache-1   redis:7-alpine       "docker-entrypoint.s…"   cache     7 seconds ago   Up 6 seconds (healthy)   6379/tcp
depends-db-1      postgres:16-alpine   "docker-entrypoint.s…"   db        7 seconds ago   Up 6 seconds (healthy)   5432/tcp

~/VSCodes/ASKK-25988/Lab5/depends % docker compose logs app
app-1  | App started at:
app-1  | Mon Nov 23 21:09:20 UTC 2026

~/VSCodes/ASKK-25988/Lab5/depends % docker compose down
[+] Running 4/4
 ✔ Container depends-app-1    Removed                                                             1.1s 
 ✔ Container depends-cache-1  Removed                                                             0.3s 
 ✔ Container depends-db-1     Removed                                                             0.2s 
 ✔ Network depends_default    Removed                                                             0.2s
```

**Screenshot:**

![Usługi z healthcheck (healthy)](images/image-8.png)

Rys. 9 - Usługi z healthcheck (healthy).

---

##### Ćwiczenie 7.1 — PHP + MySQL

**Opis:** Uruchomiono plik `docker-compose.yaml` z usługą PHP i MySQL wykorzystujący zmienne środowiskowe, healthchecki i wolumeny. Rolą aplikacji PHP było umożliwienie tworzenia i wyświetlania notatek.

**Użyte polecenia:**

```zsh
cd ~/VSCodes/ASKK-25988/Lab5/supporting-materials/examples/02-php-mysql
cat docker-compose.yaml
cat src/index.php

docker compose up -d
# Otwórz http://localhost:8080
docker compose down
```

**Wynik działania:**

```zsh
~/VSCodes/ASKK-25988/Lab5/depends % cd ~/VSCodes/ASKK-25988/Lab5/supporting-materials/examples/02-php-mysql

~/VSCodes/ASKK-25988/Lab5/supporting-materials/examples/02-php-mysql % cat docker-compose.yaml
version: "3.9"

services:
  app:
    image: php:8.2-apache
    container_name: php-app
    ports:
      - "8080:80"
    volumes:
      - ./src:/var/www/html
    environment:
      - APP_ENV=local
      - DB_HOST=db
      - DB_NAME=appdb
      - DB_USER=appuser
      - DB_PASSWORD=apppass
    depends_on:
      db:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost"]
      interval: 10s
      timeout: 3s
      retries: 5
    # Install mysqli extension at container start (simple demo approach)
    command: bash -lc "docker-php-ext-install mysqli && apache2-foreground"

  db:
    image: mysql:8.0
    container_name: mysql-db
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: rootpass
      MYSQL_DATABASE: appdb
      MYSQL_USER: appuser
      MYSQL_PASSWORD: apppass
    volumes:
      - db_data:/var/lib/mysql
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-prootpass"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  db_data:

# Usage:
#   docker compose up -d
#   Open http://localhost:8080

~/VSCodes/ASKK-25988/Lab5/supporting-materials/examples/02-php-mysql % cat src/index.php
<?php
$host = getenv('DB_HOST') ?: 'db';
$db   = getenv('DB_NAME') ?: 'appdb';
$user = getenv('DB_USER') ?: 'appuser';
$pass = getenv('DB_PASSWORD') ?: 'apppass';

$mysqli = @new mysqli($host, $user, $pass, $db);

header('Content-Type: text/html; charset=UTF-8');

echo '<!doctype html><html><head><meta charset="utf-8"><title>PHP + MySQL Demo</title>';
echo '<style>body{font-family:Arial,sans-serif;margin:2rem;}code,pre{background:#f4f4f4;padding:.25rem .5rem;border-radius:4px;}table{border-collapse:collapse}td,th{border:1px solid #ddd;padding:.4rem .6rem}</style>';
echo '</head><body>';
echo '<h1>PHP + MySQL (docker-compose) — simple demo</h1>';

echo '<p><strong>DB connection status:</strong> ';
if ($mysqli->connect_errno) {
    echo '<span style="color:#b00">Failed: (' . $mysqli->connect_errno . ') ' . htmlspecialchars($mysqli->connect_error) . '</span></p>';
    echo '<p>Check that the database container is healthy and credentials match.</p>';
    echo '</body></html>';
    exit;
}

echo '<span style="color:#070">OK</span></p>';

$mysqli->query("CREATE TABLE IF NOT EXISTS notes (id INT AUTO_INCREMENT PRIMARY KEY, message VARCHAR(255) NOT NULL) ENGINE=InnoDB;");

if (isset($_POST['message']) && $_POST['message'] !== '') {
    $stmt = $mysqli->prepare('INSERT INTO notes (message) VALUES (?)');
    $stmt->bind_param('s', $_POST['message']);
    $stmt->execute();
    $stmt->close();
}

$result = $mysqli->query('SELECT id, message FROM notes ORDER BY id DESC');

echo '<h2>Add a note</h2>';
echo '<form method="post"><input name="message" placeholder="Type a message" required> <button type="submit">Save</button></form>';

echo '<h2>Notes</h2>';
echo '<table><tr><th>ID</th><th>Message</th></tr>';
while ($row = $result->fetch_assoc()) {
    echo '<tr><td>' . (int)$row['id'] . '</td><td>' . htmlspecialchars($row['message']) . '</td></tr>';
}
echo '</table>';

$result->free();
$mysqli->close();

echo '<p style="margin-top:2rem;color:#555">Open this app at <code>http://localhost:8080</code>. DB host: <code>' . htmlspecialchars($host) . "</code></p>";
echo '</body></html>';

~/VSCodes/ASKK-25988/Lab5/supporting-materials/examples/02-php-mysql % docker compose up -d
WARN[0000] /Users/mewosh/VSCodes/ASKK-25988/Lab5/supporting-materials/examples/02-php-mysql/docker-compose.yaml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion 
[+] Running 31/31
 ✔ db Pulled                                                                                     29.0s 
   ✔ 4fcb28d1dfcf Pull complete                                                                   0.2s 
   ✔ 7ce425b17caf Pull complete                                                                   0.6s 
   ✔ e9b2852d2a9d Pull complete                                                                   0.6s 
   ✔ ad770837e789 Pull complete                                                                  17.8s 
   ✔ 605b7f42ac6e Pull complete                                                                  18.6s 
   ✔ 70a53223cb4c Pull complete                                                                   0.6s 
   ✔ 1959e4a06a1c Pull complete                                                                   0.6s 
   ✔ 7b9f24d93d52 Pull complete                                                                   1.4s 
   ✔ fa30ab141b5a Pull complete                                                                  24.9s 
   ✔ 11c0b299cb47 Pull complete                                                                  17.8s 
   ✔ 42505e6e6b91 Pull complete                                                                   0.3s 
   ✔ 7a0e30178db8 Download complete                                                               0.0s 
   ✔ 578f543767f0 Download complete                                                               9.5s 
 ✔ app Pulled                                                                                    19.6s 
   ✔ 4f4fb700ef54 Pull complete                                                                   0.1s 
   ✔ c1363f51e904 Pull complete                                                                   0.6s 
   ✔ 40f5c8deac62 Pull complete                                                                  15.3s 
   ✔ 4ed0a975ee11 Pull complete                                                                   0.6s 
   ✔ 1821e282738e Pull complete                                                                   0.3s 
   ✔ 2e96d1399db5 Pull complete                                                                  15.7s 
   ✔ c53079927c1d Pull complete                                                                   0.6s 
   ✔ 3d57342d1655 Pull complete                                                                   0.3s 
   ✔ 851a50d3a339 Pull complete                                                                   0.6s 
   ✔ 029e6c18e668 Pull complete                                                                   0.7s 
   ✔ 57d9130ed8b0 Pull complete                                                                   0.6s 
   ✔ dea618341d4f Pull complete                                                                   0.6s 
   ✔ 1269e25d0255 Pull complete                                                                  15.5s 
   ✔ 49e3cd2478b5 Pull complete                                                                  15.4s 
   ✔ 5eaf29de6c95 Download complete                                                               0.0s 
   ✔ 8402aea66faa Download complete                                                               5.8s 
[+] Running 4/4
 ✔ Network 02-php-mysql_default  Created                                                          0.0s 
 ✔ Volume 02-php-mysql_db_data   Created                                                          0.0s 
 ✔ Container mysql-db            Healthy                                                         11.3s 
 ✔ Container php-app             Started                                                         10.8s 

~/VSCodes/ASKK-25988/Lab5/supporting-materials/examples/02-php-mysql % docker compose down
WARN[0000] /Users/mewosh/VSCodes/ASKK-25988/Lab5/supporting-materials/examples/02-php-mysql/docker-compose.yaml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion 
[+] Running 3/3
 ✔ Container php-app             Removed                                                          1.3s 
 ✔ Container mysql-db            Removed                                                          1.2s 
 ✔ Network 02-php-mysql_default  Removed                                                          0.2s 
```

---

##### Ćwiczenie 7.2 — Node.js + MongoDB

**Opis:** Uruchomiono plik `docker-compose.yaml` dla aplikacji Node.js (to-do app) i bazy MongoDB zawierający healthchecki i własny obraz w pliku `.Dockerfile`.

**Użyte polecenia:**

```zsh
cd ~/VSCodes/ASKK-25988/Lab5/supporting-materials/examples/05-mongodb-v1
cat docker-compose.yaml
cat Dockerfile

docker compose up -d --build
docker compose ps
docker compose logs
docker compose down
```

**Wynik działania:**

```zsh
~/VSCodes/ASKK-25988/Lab5/supporting-materials/examples/02-php-mysql % cd ~/VSCodes/ASKK-25988/Lab5/supporting-materials/examples/05-mongodb-v1

~/VSCodes/ASKK-25988/Lab5/supporting-materials/examples/05-mongodb-v1 % cat docker-compose.yaml
services:
  web:
    build: .
    image: todo-mongodb-v1:latest
    container_name: todo-web
    environment:
      - PORT=3000
      - MONGODB_URI=mongodb://mongo:27017/todos
    ports:
      - "3000:3000"
    depends_on:
      mongo:
        condition: service_healthy

  mongo:
    image: mongo:7
    container_name: todo-mongo
    ports:
      - "27017:27017"
    volumes:
      - mongo_data:/data/db
    healthcheck:
      test: ["CMD", "mongosh", "--quiet", "--eval", "db.runCommand({ ping: 1 })"]
      interval: 5s
      timeout: 3s
      retries: 20

  mongo-express:
    image: mongo-express:1.0.2-20
    container_name: todo-mongo-express
    environment:
      - ME_CONFIG_MONGODB_SERVER=mongo
      - ME_CONFIG_BASICAUTH=false
    ports:
      - "8081:8081"
    depends_on:
      - mongo

volumes:
  mongo_data:

~/VSCodes/ASKK-25988/Lab5/supporting-materials/examples/05-mongodb-v1 % cat Dockerfile
# Simple Node.js Express + MongoDB To-Do app
FROM node:20-alpine

# Create app directory
WORKDIR /app

# Install app dependencies
COPY package*.json ./
RUN npm install --omit=dev

# Bundle app source
COPY src ./src

EXPOSE 3000

ENV NODE_ENV=production \
    PORT=3000

CMD ["node", "src/app.js"]

~/VSCodes/ASKK-25988/Lab5/supporting-materials/examples/05-mongodb-v1 % docker compose up -d --build
[+] Running 22/22
 ✔ mongo Pulled                                                                                  17.7s 
   ✔ 5fdecea930c4 Pull complete                                                                   0.3s 
   ✔ df1009b622ff Pull complete                                                                   0.4s 
   ✔ 77864af5d0e2 Pull complete                                                                   0.4s 
   ✔ 0c6d38513c5d Pull complete                                                                  13.8s 
   ✔ 6cd2d5ff7309 Pull complete                                                                   0.4s 
   ✔ f74d428f3a50 Pull complete                                                                  11.3s 
   ✔ c5ed0f667499 Pull complete                                                                   0.5s 
   ✔ e092b83388a9 Pull complete                                                                   0.3s 
   ✔ 5b56f425ba42 Download complete                                                               0.0s 
   ✔ 7f61ac204c93 Download complete                                                               0.2s 
 ✔ mongo-express Pulled                                                                          13.1s 
   ✔ 7a6391dab4f4 Pull complete                                                                   0.3s 
   ✔ 0d6bbcfe9ab8 Pull complete                                                                   0.2s 
   ✔ b81bf146f4e8 Pull complete                                                                   0.7s 
   ✔ c6b39de5b339 Pull complete                                                                   0.9s 
   ✔ 0bda9e678917 Pull complete                                                                   1.3s 
   ✔ 6eacfc2ffce9 Pull complete                                                                   9.3s 
   ✔ 79650a799acd Pull complete                                                                   8.7s 
   ✔ 8d2dc1586913 Pull complete                                                                   1.3s 
   ✔ 5d0c143a0a86 Download complete                                                               0.0s 
   ✔ a6a026c66788 Download complete                                                               0.0s 
[+] Building 6.6s (13/13) FINISHED                                                                     
 => [internal] load local bake definitions                                                        0.0s
 => => reading from stdin 620B                                                                    0.0s
 => [internal] load build definition from Dockerfile                                              0.0s
 => => transferring dockerfile: 336B                                                              0.0s
 => [internal] load metadata for docker.io/library/node:20-alpine                                 1.0s
 => [auth] library/node:pull token for registry-1.docker.io                                       0.0s
 => [internal] load .dockerignore                                                                 0.0s
 => => transferring context: 2B                                                                   0.0s
 => [1/5] FROM docker.io/library/node:20-alpine@sha256:fb4cd12c85ee03686f6af5362a0b0d56d50c58a04  0.0s
 => => resolve docker.io/library/node:20-alpine@sha256:fb4cd12c85ee03686f6af5362a0b0d56d50c58a04  0.0s
 => [internal] load build context                                                                 0.0s
 => => transferring context: 5.68kB                                                               0.0s
 => CACHED [2/5] WORKDIR /app                                                                     0.0s
 => [3/5] COPY package*.json ./                                                                   0.4s
 => [4/5] RUN npm install --omit=dev                                                              3.9s
 => [5/5] COPY src ./src                                                                          0.0s
 => exporting to image                                                                            0.9s 
 => => exporting layers                                                                           0.6s 
 => => exporting manifest sha256:d615c5df0c2b8dfe3c9e19a66dbbfabee7a81e99c0479150dce07ecdc4f054c  0.0s
 => => exporting config sha256:0db3f494dc3246800ec3b5eb82a213e67182613b47ae408606102ee2753329b8   0.0s
 => => exporting attestation manifest sha256:a1bd77c3006d9ceb782a349a7e748bfabd8633ba2347e2cffa2  0.0s
 => => exporting manifest list sha256:f5912c0000dfad92b4a91547055afc426ceb1e70c15ee342b90f42a9bc  0.0s
 => => naming to docker.io/library/todo-mongodb-v1:latest                                         0.0s
 => => unpacking to docker.io/library/todo-mongodb-v1:latest                                      0.2s
 => resolving provenance for metadata file                                                        0.0s
[+] Running 6/6
 ✔ todo-mongodb-v1:latest           Built                                                         0.0s 
 ✔ Network 05-mongodb-v1_default    Created                                                       0.0s 
 ✔ Volume 05-mongodb-v1_mongo_data  Created                                                       0.0s 
 ✔ Container todo-mongo             Healthy                                                       5.9s 
 ✔ Container todo-web               Started                                                       5.8s 
 ✔ Container todo-mongo-express     Started                                                       0.3s 

~/VSCodes/ASKK-25988/Lab5/supporting-materials/examples/05-mongodb-v1 % docker compose ps
NAME                 IMAGE                    COMMAND                  SERVICE         CREATED         STATUS                   PORTS
todo-mongo           mongo:7                  "docker-entrypoint.s…"   mongo           8 seconds ago   Up 8 seconds (healthy)   0.0.0.0:27017->27017/tcp, [::]:27017->27017/tcp
todo-mongo-express   mongo-express:1.0.2-20   "/sbin/tini -- /dock…"   mongo-express   8 seconds ago   Up 8 seconds             0.0.0.0:8081->8081/tcp, [::]:8081->8081/tcp
todo-web             todo-mongodb-v1:latest   "docker-entrypoint.s…"   web             8 seconds ago   Up 2 seconds             0.0.0.0:3000->3000/tcp, [::]:3000->3000/tcp

~/VSCodes/ASKK-25988/Lab5/supporting-materials/examples/05-mongodb-v1 % docker compose logs
todo-mongo-express  | Waiting for mongo:27017...
todo-mongo-express  | /docker-entrypoint.sh: connect: Connection refused
todo-mongo-express  | /docker-entrypoint.sh: line 15: /dev/tcp/mongo/27017: Connection refused
todo-mongo-express  | Mon Nov 23 21:44:31 UTC 2026 retrying to connect to mongo:27017 (2/10)
todo-mongo-express  | No custom config.js found, loading config.default.js
todo-mongo-express  | Welcome to mongo-express 1.0.2
todo-mongo-express  | ------------------------
todo-mongo-express  | 
todo-mongo-express  | 
todo-mongo-express  | Mongo Express server listening at http://0.0.0.0:8081
todo-mongo-express  | Server is open to allow connections from anyone (0.0.0.0)
todo-mongo-express  | Basic authentication is disabled. It is recommended to set the useBasicAuth to true in the config.js.
todo-web            | Połączono z MongoDB
todo-web            | Dodano przykładowe zadania.
todo-web            | Serwer działa na porcie 3000
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:30.849+00:00"},"s":"I",  "c":"CONTROL",  "id":23285,   "ctx":"main","msg":"Automatically disabling TLS 1.0, to force-enable TLS 1.0 specify --sslDisabledProtocols 'none'"}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:30.849+00:00"},"s":"I",  "c":"NETWORK",  "id":4915701, "ctx":"main","msg":"Initialized wire specification","attr":{"spec":{"incomingExternalClient":{"minWireVersion":0,"maxWireVersion":21},"incomingInternalClient":{"minWireVersion":0,"maxWireVersion":21},"outgoing":{"minWireVersion":6,"maxWireVersion":21},"isInternalClient":true}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:30.849+00:00"},"s":"I",  "c":"EXECUTOR", "id":11280000,"ctx":"main","msg":"Starting thread pool","attr":{"poolName":"parallel execution pool","numThreads":0,"minThreads":0,"maxThreads":128}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:30.850+00:00"},"s":"I",  "c":"NETWORK",  "id":4648601, "ctx":"main","msg":"Implicit TCP FastOpen unavailable. If TCP FastOpen is required, set tcpFastOpenServer, tcpFastOpenClient, and tcpFastOpenQueueSize."}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:30.850+00:00"},"s":"I",  "c":"EXECUTOR", "id":11280000,"ctx":"main","msg":"Starting thread pool","attr":{"poolName":"ThreadPool1","numThreads":0,"minThreads":0,"maxThreads":1}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:30.850+00:00"},"s":"I",  "c":"EXECUTOR", "id":11280000,"ctx":"main","msg":"Starting thread pool","attr":{"poolName":"OCSPCache","numThreads":0,"minThreads":0,"maxThreads":8}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:30.850+00:00"},"s":"I",  "c":"EXECUTOR", "id":11280000,"ctx":"main","msg":"Starting thread pool","attr":{"poolName":"ThreadPool2","numThreads":0,"minThreads":0,"maxThreads":1}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:30.851+00:00"},"s":"I",  "c":"EXECUTOR", "id":11280000,"ctx":"main","msg":"Starting thread pool","attr":{"poolName":"AuthorizationManager","numThreads":0,"minThreads":0,"maxThreads":1000000000}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:30.851+00:00"},"s":"I",  "c":"EXECUTOR", "id":11280000,"ctx":"main","msg":"Starting thread pool","attr":{"poolName":"IndexBuildsCoordinatorMongod","numThreads":0,"minThreads":0,"maxThreads":1000000000}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:30.851+00:00"},"s":"I",  "c":"REPL",     "id":5123008, "ctx":"main","msg":"Successfully registered PrimaryOnlyService","attr":{"service":"TenantMigrationDonorService","namespace":"config.tenantMigrationDonors"}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:30.851+00:00"},"s":"I",  "c":"REPL",     "id":5123008, "ctx":"main","msg":"Successfully registered PrimaryOnlyService","attr":{"service":"TenantMigrationRecipientService","namespace":"config.tenantMigrationRecipients"}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:30.851+00:00"},"s":"W",  "c":"NETWORK",  "id":11621101,"ctx":"main","msg":"Overriding max connections to honor `capMemoryConsumptionForPreAuthBuffers` settings","attr":{"limit":100313}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:30.851+00:00"},"s":"I",  "c":"CONTROL",  "id":5945603, "ctx":"main","msg":"Multi threading initialized"}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:30.851+00:00"},"s":"I",  "c":"EXECUTOR", "id":11280000,"ctx":"main","msg":"Starting thread pool","attr":{"poolName":"ReadWriteConcernDefaults","numThreads":0,"minThreads":0,"maxThreads":1}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:30.851+00:00"},"s":"I",  "c":"TENANT_M", "id":7091600, "ctx":"main","msg":"Starting TenantMigrationAccessBlockerRegistry"}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:30.851+00:00"},"s":"I",  "c":"EXECUTOR", "id":11280000,"ctx":"main","msg":"Starting thread pool","attr":{"poolName":"TenantMigrationBlockerAsyncThreadPool","numThreads":0,"minThreads":0,"maxThreads":4}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:30.851+00:00"},"s":"I",  "c":"CONTROL",  "id":4615611, "ctx":"initandlisten","msg":"MongoDB starting","attr":{"pid":1,"port":27017,"dbPath":"/data/db","architecture":"64-bit","host":"26836c7159b4"}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:30.851+00:00"},"s":"I",  "c":"CONTROL",  "id":23403,   "ctx":"initandlisten","msg":"Build Info","attr":{"buildInfo":{"version":"7.0.48","gitVersion":"6937736f0539a5d4c8edb2970255b9369cb385a5","openSSLVersion":"OpenSSL 3.0.2 15 Mar 2022","modules":[],"allocator":"tcmalloc","environment":{"distmod":"ubuntu2204","distarch":"aarch64","target_arch":"aarch64"}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:30.851+00:00"},"s":"I",  "c":"CONTROL",  "id":51765,   "ctx":"initandlisten","msg":"Operating System","attr":{"os":{"name":"Ubuntu","version":"22.04"}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:30.851+00:00"},"s":"I",  "c":"CONTROL",  "id":21951,   "ctx":"initandlisten","msg":"Options set by command line","attr":{"options":{"net":{"bindIp":"*"}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:30.851+00:00"},"s":"W",  "c":"NETWORK",  "id":11621101,"ctx":"initandlisten","msg":"Overriding max connections to honor `capMemoryConsumptionForPreAuthBuffers` settings","attr":{"limit":100313}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:30.851+00:00"},"s":"I",  "c":"EXECUTOR", "id":11280000,"ctx":"initandlisten","msg":"Starting thread pool","attr":{"poolName":"OCSPManagerHTTP","numThreads":0,"minThreads":1,"maxThreads":10}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:30.852+00:00"},"s":"I",  "c":"STORAGE",  "id":22297,   "ctx":"initandlisten","msg":"Using the XFS filesystem is strongly recommended with the WiredTiger storage engine. See http://dochub.mongodb.org/core/prodnotes-filesystem","tags":["startupWarnings"]}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:30.853+00:00"},"s":"I",  "c":"STORAGE",  "id":22315,   "ctx":"initandlisten","msg":"Opening WiredTiger","attr":{"config":"create,cache_size=3406M,session_max=33000,eviction=(threads_min=4,threads_max=4),config_base=false,statistics=(fast),log=(enabled=true,remove=true,path=journal,compressor=snappy),builtin_extension_config=(zstd=(compression_level=6)),file_manager=(close_idle_time=600,close_scan_interval=10,close_handle_minimum=2000),statistics_log=(wait=0),json_output=(error,message),verbose=[recovery_progress:1,checkpoint_progress:1,compact_progress:1,backup:0,checkpoint:0,compact:0,evict:0,history_store:0,recovery:0,rts:0,salvage:0,tiered:0,timestamp:0,transaction:0,verify:0,log:0],"}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.538+00:00"},"s":"I",  "c":"WTRECOV",  "id":22430,   "ctx":"initandlisten","msg":"WiredTiger message","attr":{"message":{"ts_sec":1795470271,"ts_usec":538723,"thread":"1:0xffff89fdc040","session_name":"txn-recover","category":"WT_VERB_RECOVERY_PROGRESS","category_id":30,"verbose_level":"DEBUG_1","verbose_level_id":1,"msg":"recovery log replay has successfully finished and ran for 0 milliseconds"}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.538+00:00"},"s":"I",  "c":"WTRECOV",  "id":22430,   "ctx":"initandlisten","msg":"WiredTiger message","attr":{"message":{"ts_sec":1795470271,"ts_usec":538802,"thread":"1:0xffff89fdc040","session_name":"txn-recover","category":"WT_VERB_RECOVERY_PROGRESS","category_id":30,"verbose_level":"DEBUG_1","verbose_level_id":1,"msg":"Set global recovery timestamp: (0, 0)"}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.538+00:00"},"s":"I",  "c":"WTRECOV",  "id":22430,   "ctx":"initandlisten","msg":"WiredTiger message","attr":{"message":{"ts_sec":1795470271,"ts_usec":538814,"thread":"1:0xffff89fdc040","session_name":"txn-recover","category":"WT_VERB_RECOVERY_PROGRESS","category_id":30,"verbose_level":"DEBUG_1","verbose_level_id":1,"msg":"Set global oldest timestamp: (0, 0)"}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.538+00:00"},"s":"I",  "c":"WTRECOV",  "id":22430,   "ctx":"initandlisten","msg":"WiredTiger message","attr":{"message":{"ts_sec":1795470271,"ts_usec":538830,"thread":"1:0xffff89fdc040","session_name":"txn-recover","category":"WT_VERB_RECOVERY_PROGRESS","category_id":30,"verbose_level":"DEBUG_1","verbose_level_id":1,"msg":"recovery was completed successfully and took 0ms, including 0ms for the log replay, 0ms for the rollback to stable, and 0ms for the checkpoint."}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.542+00:00"},"s":"I",  "c":"STORAGE",  "id":4795906, "ctx":"initandlisten","msg":"WiredTiger opened","attr":{"durationMillis":689}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.542+00:00"},"s":"I",  "c":"RECOVERY", "id":23987,   "ctx":"initandlisten","msg":"WiredTiger recoveryTimestamp","attr":{"recoveryTimestamp":{"$timestamp":{"t":0,"i":0}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.548+00:00"},"s":"W",  "c":"CONTROL",  "id":22120,   "ctx":"initandlisten","msg":"Access control is not enabled for the database. Read and write access to data and configuration is unrestricted","tags":["startupWarnings"]}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.548+00:00"},"s":"W",  "c":"CONTROL",  "id":9068900, "ctx":"initandlisten","msg":"For customers running MongoDB 7.0, we suggest changing the contents of the following sysfsFile","attr":{"sysfsFile":"/sys/kernel/mm/transparent_hugepage","currentValue":"always","desiredValue":"never"},"tags":["startupWarnings"]}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.548+00:00"},"s":"I",  "c":"STORAGE",  "id":20320,   "ctx":"initandlisten","msg":"createCollection","attr":{"namespace":"admin.system.version","uuidDisposition":"provided","uuid":{"uuid":{"$uuid":"b0340b2b-00b0-46b3-8fb3-ee258db2dd48"}},"options":{"uuid":{"$uuid":"b0340b2b-00b0-46b3-8fb3-ee258db2dd48"}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.552+00:00"},"s":"I",  "c":"INDEX",    "id":20345,   "ctx":"initandlisten","msg":"Index build: done building","attr":{"buildUUID":null,"collectionUUID":{"uuid":{"$uuid":"b0340b2b-00b0-46b3-8fb3-ee258db2dd48"}},"namespace":"admin.system.version","index":"_id_","ident":"index-1--5134334182977428502","collectionIdent":"collection-0--5134334182977428502","commitTimestamp":null}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.552+00:00"},"s":"I",  "c":"REPL",     "id":20459,   "ctx":"initandlisten","msg":"Setting featureCompatibilityVersion","attr":{"newVersion":"7.0"}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.552+00:00"},"s":"I",  "c":"REPL",     "id":5853300, "ctx":"initandlisten","msg":"current featureCompatibilityVersion value","attr":{"featureCompatibilityVersion":"7.0","context":"setFCV"}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.552+00:00"},"s":"I",  "c":"NETWORK",  "id":4915702, "ctx":"initandlisten","msg":"Updated wire specification","attr":{"oldSpec":{"incomingExternalClient":{"minWireVersion":0,"maxWireVersion":21},"incomingInternalClient":{"minWireVersion":0,"maxWireVersion":21},"outgoing":{"minWireVersion":6,"maxWireVersion":21},"isInternalClient":true},"newSpec":{"incomingExternalClient":{"minWireVersion":0,"maxWireVersion":21},"incomingInternalClient":{"minWireVersion":21,"maxWireVersion":21},"outgoing":{"minWireVersion":21,"maxWireVersion":21},"isInternalClient":true}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.552+00:00"},"s":"I",  "c":"NETWORK",  "id":4915702, "ctx":"initandlisten","msg":"Updated wire specification","attr":{"oldSpec":{"incomingExternalClient":{"minWireVersion":0,"maxWireVersion":21},"incomingInternalClient":{"minWireVersion":21,"maxWireVersion":21},"outgoing":{"minWireVersion":21,"maxWireVersion":21},"isInternalClient":true},"newSpec":{"incomingExternalClient":{"minWireVersion":0,"maxWireVersion":21},"incomingInternalClient":{"minWireVersion":21,"maxWireVersion":21},"outgoing":{"minWireVersion":21,"maxWireVersion":21},"isInternalClient":true}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.552+00:00"},"s":"I",  "c":"REPL",     "id":5853300, "ctx":"initandlisten","msg":"current featureCompatibilityVersion value","attr":{"featureCompatibilityVersion":"7.0","context":"startup"}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.552+00:00"},"s":"I",  "c":"STORAGE",  "id":5071100, "ctx":"initandlisten","msg":"Clearing temp directory"}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.552+00:00"},"s":"I",  "c":"CONTROL",  "id":6608200, "ctx":"initandlisten","msg":"Initializing cluster server parameters from disk"}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.552+00:00"},"s":"I",  "c":"CONTROL",  "id":20536,   "ctx":"initandlisten","msg":"Flow Control is enabled on this deployment"}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.553+00:00"},"s":"I",  "c":"FTDC",     "id":20625,   "ctx":"initandlisten","msg":"Initializing full-time diagnostic data capture","attr":{"dataDirectory":"/data/db/diagnostic.data"}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.553+00:00"},"s":"I",  "c":"EXECUTOR", "id":11280000,"ctx":"initandlisten","msg":"Starting thread pool","attr":{"poolName":"deferred writer pool","numThreads":0,"minThreads":0,"maxThreads":1}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.553+00:00"},"s":"I",  "c":"EXECUTOR", "id":11280000,"ctx":"initandlisten","msg":"Starting thread pool","attr":{"poolName":"StandaloneThreadPool","numThreads":0,"minThreads":1,"maxThreads":1000000000}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.554+00:00"},"s":"I",  "c":"EXECUTOR", "id":11280000,"ctx":"initandlisten","msg":"Starting thread pool","attr":{"poolName":"WaitForMajorityServiceReadThreadPool","numThreads":0,"minThreads":0,"maxThreads":2}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.554+00:00"},"s":"I",  "c":"EXECUTOR", "id":11280000,"ctx":"initandlisten","msg":"Starting thread pool","attr":{"poolName":"WaitForMajorityServiceWriteThreadPool","numThreads":0,"minThreads":0,"maxThreads":2}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.554+00:00"},"s":"I",  "c":"STORAGE",  "id":20320,   "ctx":"initandlisten","msg":"createCollection","attr":{"namespace":"local.startup_log","uuidDisposition":"generated","uuid":{"uuid":{"$uuid":"a73992e4-2a6e-44ec-bf21-f48c301d6c38"}},"options":{"capped":true,"size":10485760}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.558+00:00"},"s":"I",  "c":"INDEX",    "id":20345,   "ctx":"initandlisten","msg":"Index build: done building","attr":{"buildUUID":null,"collectionUUID":{"uuid":{"$uuid":"a73992e4-2a6e-44ec-bf21-f48c301d6c38"}},"namespace":"local.startup_log","index":"_id_","ident":"index-3--5134334182977428502","collectionIdent":"collection-2--5134334182977428502","commitTimestamp":null}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.558+00:00"},"s":"I",  "c":"REPL",     "id":6015317, "ctx":"initandlisten","msg":"Setting new configuration state","attr":{"newState":"ConfigReplicationDisabled","oldState":"ConfigPreStart"}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.558+00:00"},"s":"I",  "c":"EXECUTOR", "id":11280000,"ctx":"initandlisten","msg":"Starting thread pool","attr":{"poolName":"TTLMonitorMetadataRefresh","numThreads":0,"minThreads":0,"maxThreads":5}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.558+00:00"},"s":"I",  "c":"STORAGE",  "id":22262,   "ctx":"initandlisten","msg":"Timestamp monitor starting"}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.559+00:00"},"s":"I",  "c":"EXECUTOR", "id":11280000,"ctx":"initandlisten","msg":"Starting thread pool","attr":{"poolName":"StatsCache","numThreads":0,"minThreads":0,"maxThreads":2}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.559+00:00"},"s":"I",  "c":"EXECUTOR", "id":11280000,"ctx":"initandlisten","msg":"Starting thread pool","attr":{"poolName":"ServiceExecutorFixed","numThreads":0,"minThreads":0,"maxThreads":1000}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.559+00:00"},"s":"I",  "c":"CONTROL",  "id":20712,   "ctx":"LogicalSessionCacheReap","msg":"Sessions collection is not set up; waiting until next sessions reap interval","attr":{"error":"NamespaceNotFound: config.system.sessions does not exist"}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.559+00:00"},"s":"I",  "c":"NETWORK",  "id":23015,   "ctx":"listener","msg":"Listening on","attr":{"address":"/tmp/mongodb-27017.sock"}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.559+00:00"},"s":"I",  "c":"NETWORK",  "id":23015,   "ctx":"listener","msg":"Listening on","attr":{"address":"0.0.0.0"}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.559+00:00"},"s":"I",  "c":"NETWORK",  "id":23016,   "ctx":"listener","msg":"Waiting for connections","attr":{"port":27017,"ssl":"off"}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.559+00:00"},"s":"I",  "c":"STORAGE",  "id":20320,   "ctx":"LogicalSessionCacheRefresh","msg":"createCollection","attr":{"namespace":"config.system.sessions","uuidDisposition":"generated","uuid":{"uuid":{"$uuid":"dfe86056-cae6-4af5-b58b-27f7430b13ec"}},"options":{}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.559+00:00"},"s":"I",  "c":"CONTROL",  "id":8423403, "ctx":"initandlisten","msg":"mongod startup complete","attr":{"Summary of time elapsed":{"Startup from clean shutdown?":true,"Statistics":{"Transport layer setup":"0 ms","Run initial syncer crash recovery":"0 ms","Create storage engine lock file in the data directory":"0 ms","Get metadata describing storage engine":"0 ms","Create storage engine":"694 ms","Write current PID to file":"0 ms","Write a new metadata for storage engine":"0 ms","Initialize FCV before rebuilding indexes":"0 ms","Drop abandoned idents and get back indexes that need to be rebuilt or builds that need to be restarted":"0 ms","Rebuild indexes for collections":"0 ms","Load cluster parameters from disk for a standalone":"0 ms","Build user and roles graph":"0 ms","Set up the background thread pool responsible for waiting for opTimes to be majority committed":"0 ms","Initialize information needed to make a mongod instance shard aware":"0 ms","Start up the replication coordinator":"0 ms","Start transport layer":"0 ms","_initAndListen total elapsed time":"708 ms"}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.563+00:00"},"s":"I",  "c":"REPL",     "id":7360102, "ctx":"LogicalSessionCacheRefresh","msg":"Added oplog entry for create to transaction","attr":{"namespace":"config.$cmd","uuid":{"uuid":{"$uuid":"dfe86056-cae6-4af5-b58b-27f7430b13ec"}},"object":{"create":"system.sessions","idIndex":{"v":2,"key":{"_id":1},"name":"_id_"}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.563+00:00"},"s":"I",  "c":"REPL",     "id":7360100, "ctx":"LogicalSessionCacheRefresh","msg":"Added oplog entry for createIndexes to transaction","attr":{"namespace":"config.$cmd","uuid":{"uuid":{"$uuid":"dfe86056-cae6-4af5-b58b-27f7430b13ec"}},"object":{"createIndexes":"system.sessions","v":2,"key":{"lastUse":1},"name":"lsidTTLIndex","expireAfterSeconds":1800}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.565+00:00"},"s":"I",  "c":"INDEX",    "id":20345,   "ctx":"LogicalSessionCacheRefresh","msg":"Index build: done building","attr":{"buildUUID":null,"collectionUUID":{"uuid":{"$uuid":"dfe86056-cae6-4af5-b58b-27f7430b13ec"}},"namespace":"config.system.sessions","index":"_id_","ident":"index-5--5134334182977428502","collectionIdent":"collection-4--5134334182977428502","commitTimestamp":null}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.565+00:00"},"s":"I",  "c":"INDEX",    "id":20345,   "ctx":"LogicalSessionCacheRefresh","msg":"Index build: done building","attr":{"buildUUID":null,"collectionUUID":{"uuid":{"$uuid":"dfe86056-cae6-4af5-b58b-27f7430b13ec"}},"namespace":"config.system.sessions","index":"lsidTTLIndex","ident":"index-6--5134334182977428502","collectionIdent":"collection-4--5134334182977428502","commitTimestamp":null}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.895+00:00"},"s":"I",  "c":"NETWORK",  "id":22943,   "ctx":"listener","msg":"Connection accepted","attr":{"remote":"172.18.0.3:46604","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"a10a371d-553c-4366-aeb2-df83aff8f693"}},"connectionId":1,"connectionCount":1}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:31.895+00:00"},"s":"I",  "c":"NETWORK",  "id":22944,   "ctx":"conn1","msg":"Connection ended","attr":{"remote":"172.18.0.3:46604","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"a10a371d-553c-4366-aeb2-df83aff8f693"}},"connectionId":1,"connectionCount":0}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:32.282+00:00"},"s":"I",  "c":"NETWORK",  "id":22943,   "ctx":"listener","msg":"Connection accepted","attr":{"remote":"172.18.0.3:46620","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"93d5de52-6518-43a7-b88c-de7beaffd9a4"}},"connectionId":2,"connectionCount":1}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:32.284+00:00"},"s":"I",  "c":"NETWORK",  "id":51800,   "ctx":"conn2","msg":"client metadata","attr":{"remote":"172.18.0.3:46620","client":"conn2","negotiatedCompressors":[],"doc":{"driver":{"name":"nodejs","version":"4.13.0"},"os":{"type":"Linux","name":"linux","architecture":"arm64","version":"6.12.54-linuxkit"},"platform":"Node.js v20.13.1, LE (unified)|Node.js v20.13.1, LE (unified)"}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:32.284+00:00"},"s":"I",  "c":"ACCESS",   "id":10483900,"ctx":"conn2","msg":"Connection not authenticating","attr":{"client":"172.18.0.3:46620","doc":{"driver":{"name":"nodejs","version":"4.13.0"},"os":{"type":"Linux","name":"linux","architecture":"arm64","version":"6.12.54-linuxkit"},"platform":"Node.js v20.13.1, LE (unified)|Node.js v20.13.1, LE (unified)"}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:32.288+00:00"},"s":"I",  "c":"NETWORK",  "id":22943,   "ctx":"listener","msg":"Connection accepted","attr":{"remote":"172.18.0.3:46622","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"a76165f0-272b-4e43-8bf7-ad6e85a0beb3"}},"connectionId":3,"connectionCount":2}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:32.288+00:00"},"s":"I",  "c":"NETWORK",  "id":51800,   "ctx":"conn3","msg":"client metadata","attr":{"remote":"172.18.0.3:46622","client":"conn3","negotiatedCompressors":[],"doc":{"driver":{"name":"nodejs","version":"4.13.0"},"os":{"type":"Linux","name":"linux","architecture":"arm64","version":"6.12.54-linuxkit"},"platform":"Node.js v20.13.1, LE (unified)|Node.js v20.13.1, LE (unified)"}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:32.288+00:00"},"s":"I",  "c":"ACCESS",   "id":10483900,"ctx":"conn3","msg":"Connection not authenticating","attr":{"client":"172.18.0.3:46622","doc":{"driver":{"name":"nodejs","version":"4.13.0"},"os":{"type":"Linux","name":"linux","architecture":"arm64","version":"6.12.54-linuxkit"},"platform":"Node.js v20.13.1, LE (unified)|Node.js v20.13.1, LE (unified)"}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:32.289+00:00"},"s":"I",  "c":"NETWORK",  "id":6788700, "ctx":"conn3","msg":"Received first command on ingress connection since session start or auth handshake","attr":{"elapsedMillis":1}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.138+00:00"},"s":"I",  "c":"NETWORK",  "id":22943,   "ctx":"listener","msg":"Connection accepted","attr":{"remote":"127.0.0.1:33302","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"b6fc646a-1612-468b-add4-1d03dee6be54"}},"connectionId":4,"connectionCount":3}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.139+00:00"},"s":"I",  "c":"NETWORK",  "id":51800,   "ctx":"conn4","msg":"client metadata","attr":{"remote":"127.0.0.1:33302","client":"conn4","negotiatedCompressors":[],"doc":{"application":{"name":"mongosh 2.14.3"},"driver":{"name":"nodejs|mongosh","version":"7.5.0|2.14.3"},"platform":"Node.js v24.22.2, LE","os":{"name":"linux","architecture":"arm64","version":"5.10.271-272.1121.amzn2.aarch64","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.139+00:00"},"s":"I",  "c":"ACCESS",   "id":10483900,"ctx":"conn4","msg":"Connection not authenticating","attr":{"client":"127.0.0.1:33302","doc":{"application":{"name":"mongosh 2.14.3"},"driver":{"name":"nodejs|mongosh","version":"7.5.0|2.14.3"},"platform":"Node.js v24.22.2, LE","os":{"name":"linux","architecture":"arm64","version":"5.10.271-272.1121.amzn2.aarch64","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.141+00:00"},"s":"I",  "c":"NETWORK",  "id":22943,   "ctx":"listener","msg":"Connection accepted","attr":{"remote":"127.0.0.1:33316","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"b226e4ed-f94d-4897-93bb-e4b2ba5bdc90"}},"connectionId":5,"connectionCount":4}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.141+00:00"},"s":"I",  "c":"NETWORK",  "id":51800,   "ctx":"conn5","msg":"client metadata","attr":{"remote":"127.0.0.1:33316","client":"conn5","negotiatedCompressors":[],"doc":{"application":{"name":"mongosh 2.14.3"},"driver":{"name":"nodejs|mongosh","version":"7.5.0|2.14.3"},"platform":"Node.js v24.22.2, LE","os":{"name":"linux","architecture":"arm64","version":"5.10.271-272.1121.amzn2.aarch64","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.141+00:00"},"s":"I",  "c":"ACCESS",   "id":10483900,"ctx":"conn5","msg":"Connection not authenticating","attr":{"client":"127.0.0.1:33316","doc":{"application":{"name":"mongosh 2.14.3"},"driver":{"name":"nodejs|mongosh","version":"7.5.0|2.14.3"},"platform":"Node.js v24.22.2, LE","os":{"name":"linux","architecture":"arm64","version":"5.10.271-272.1121.amzn2.aarch64","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.149+00:00"},"s":"I",  "c":"NETWORK",  "id":6788700, "ctx":"conn5","msg":"Received first command on ingress connection since session start or auth handshake","attr":{"elapsedMillis":8}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.212+00:00"},"s":"I",  "c":"NETWORK",  "id":22943,   "ctx":"listener","msg":"Connection accepted","attr":{"remote":"127.0.0.1:33330","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"e823403c-b866-45eb-9d78-50d2571a53a3"}},"connectionId":6,"connectionCount":5}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.212+00:00"},"s":"I",  "c":"NETWORK",  "id":22943,   "ctx":"listener","msg":"Connection accepted","attr":{"remote":"127.0.0.1:33346","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"ba3a2849-922f-4f31-862b-b896aa32eba8"}},"connectionId":7,"connectionCount":6}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.215+00:00"},"s":"I",  "c":"NETWORK",  "id":51800,   "ctx":"conn6","msg":"client metadata","attr":{"remote":"127.0.0.1:33330","client":"conn6","negotiatedCompressors":[],"doc":{"application":{"name":"mongosh 2.14.3"},"driver":{"name":"nodejs|mongosh","version":"7.5.0|2.14.3"},"platform":"Node.js v24.22.2, LE","os":{"name":"linux","architecture":"arm64","version":"5.10.271-272.1121.amzn2.aarch64","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.215+00:00"},"s":"I",  "c":"ACCESS",   "id":10483900,"ctx":"conn6","msg":"Connection not authenticating","attr":{"client":"127.0.0.1:33330","doc":{"application":{"name":"mongosh 2.14.3"},"driver":{"name":"nodejs|mongosh","version":"7.5.0|2.14.3"},"platform":"Node.js v24.22.2, LE","os":{"name":"linux","architecture":"arm64","version":"5.10.271-272.1121.amzn2.aarch64","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.215+00:00"},"s":"I",  "c":"NETWORK",  "id":51800,   "ctx":"conn7","msg":"client metadata","attr":{"remote":"127.0.0.1:33346","client":"conn7","negotiatedCompressors":[],"doc":{"application":{"name":"mongosh 2.14.3"},"driver":{"name":"nodejs|mongosh","version":"7.5.0|2.14.3"},"platform":"Node.js v24.22.2, LE","os":{"name":"linux","architecture":"arm64","version":"5.10.271-272.1121.amzn2.aarch64","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.215+00:00"},"s":"I",  "c":"ACCESS",   "id":10483900,"ctx":"conn7","msg":"Connection not authenticating","attr":{"client":"127.0.0.1:33346","doc":{"application":{"name":"mongosh 2.14.3"},"driver":{"name":"nodejs|mongosh","version":"7.5.0|2.14.3"},"platform":"Node.js v24.22.2, LE","os":{"name":"linux","architecture":"arm64","version":"5.10.271-272.1121.amzn2.aarch64","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.216+00:00"},"s":"I",  "c":"NETWORK",  "id":22943,   "ctx":"listener","msg":"Connection accepted","attr":{"remote":"127.0.0.1:33362","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"161e1537-3158-4d74-a6b1-a52de121f018"}},"connectionId":8,"connectionCount":7}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.217+00:00"},"s":"I",  "c":"NETWORK",  "id":6788700, "ctx":"conn7","msg":"Received first command on ingress connection since session start or auth handshake","attr":{"elapsedMillis":2}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.217+00:00"},"s":"I",  "c":"NETWORK",  "id":51800,   "ctx":"conn8","msg":"client metadata","attr":{"remote":"127.0.0.1:33362","client":"conn8","negotiatedCompressors":[],"doc":{"application":{"name":"mongosh 2.14.3"},"driver":{"name":"nodejs|mongosh","version":"7.5.0|2.14.3"},"platform":"Node.js v24.22.2, LE","os":{"name":"linux","architecture":"arm64","version":"5.10.271-272.1121.amzn2.aarch64","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.217+00:00"},"s":"I",  "c":"ACCESS",   "id":10483900,"ctx":"conn8","msg":"Connection not authenticating","attr":{"client":"127.0.0.1:33362","doc":{"application":{"name":"mongosh 2.14.3"},"driver":{"name":"nodejs|mongosh","version":"7.5.0|2.14.3"},"platform":"Node.js v24.22.2, LE","os":{"name":"linux","architecture":"arm64","version":"5.10.271-272.1121.amzn2.aarch64","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.220+00:00"},"s":"I",  "c":"NETWORK",  "id":6788700, "ctx":"conn8","msg":"Received first command on ingress connection since session start or auth handshake","attr":{"elapsedMillis":2}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.222+00:00"},"s":"I",  "c":"NETWORK",  "id":22944,   "ctx":"conn4","msg":"Connection ended","attr":{"remote":"127.0.0.1:33302","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"b6fc646a-1612-468b-add4-1d03dee6be54"}},"connectionId":4,"connectionCount":6}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.222+00:00"},"s":"I",  "c":"NETWORK",  "id":22944,   "ctx":"conn8","msg":"Connection ended","attr":{"remote":"127.0.0.1:33362","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"161e1537-3158-4d74-a6b1-a52de121f018"}},"connectionId":8,"connectionCount":5}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.222+00:00"},"s":"I",  "c":"NETWORK",  "id":22944,   "ctx":"conn7","msg":"Connection ended","attr":{"remote":"127.0.0.1:33346","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"ba3a2849-922f-4f31-862b-b896aa32eba8"}},"connectionId":7,"connectionCount":4}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.222+00:00"},"s":"I",  "c":"NETWORK",  "id":22944,   "ctx":"conn6","msg":"Connection ended","attr":{"remote":"127.0.0.1:33330","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"e823403c-b866-45eb-9d78-50d2571a53a3"}},"connectionId":6,"connectionCount":3}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.222+00:00"},"s":"I",  "c":"NETWORK",  "id":22944,   "ctx":"conn5","msg":"Connection ended","attr":{"remote":"127.0.0.1:33316","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"b226e4ed-f94d-4897-93bb-e4b2ba5bdc90"}},"connectionId":5,"connectionCount":2}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.575+00:00"},"s":"I",  "c":"NETWORK",  "id":22943,   "ctx":"listener","msg":"Connection accepted","attr":{"remote":"172.18.0.4:43908","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"6d95d070-db71-4f5c-a4b8-53d02b63aee0"}},"connectionId":9,"connectionCount":3}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.577+00:00"},"s":"I",  "c":"NETWORK",  "id":51800,   "ctx":"conn9","msg":"client metadata","attr":{"remote":"172.18.0.4:43908","client":"conn9","negotiatedCompressors":[],"doc":{"driver":{"name":"nodejs|Mongoose","version":"6.20.0|8.24.11"},"platform":"Node.js v20.20.2, LE","os":{"name":"linux","architecture":"arm64","version":"6.12.54-linuxkit","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.577+00:00"},"s":"I",  "c":"ACCESS",   "id":10483900,"ctx":"conn9","msg":"Connection not authenticating","attr":{"client":"172.18.0.4:43908","doc":{"driver":{"name":"nodejs|Mongoose","version":"6.20.0|8.24.11"},"platform":"Node.js v20.20.2, LE","os":{"name":"linux","architecture":"arm64","version":"6.12.54-linuxkit","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.583+00:00"},"s":"I",  "c":"NETWORK",  "id":22943,   "ctx":"listener","msg":"Connection accepted","attr":{"remote":"172.18.0.4:43920","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"8cd4fb6c-65d9-4679-93a1-4b22c2f380b4"}},"connectionId":10,"connectionCount":4}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.583+00:00"},"s":"I",  "c":"NETWORK",  "id":22943,   "ctx":"listener","msg":"Connection accepted","attr":{"remote":"172.18.0.4:43932","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"53cdee4a-68ae-429e-ad18-bc7ffce684bc"}},"connectionId":11,"connectionCount":5}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.584+00:00"},"s":"I",  "c":"NETWORK",  "id":51800,   "ctx":"conn10","msg":"client metadata","attr":{"remote":"172.18.0.4:43920","client":"conn10","negotiatedCompressors":[],"doc":{"driver":{"name":"nodejs|Mongoose","version":"6.20.0|8.24.11"},"platform":"Node.js v20.20.2, LE","os":{"name":"linux","architecture":"arm64","version":"6.12.54-linuxkit","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.584+00:00"},"s":"I",  "c":"ACCESS",   "id":10483900,"ctx":"conn10","msg":"Connection not authenticating","attr":{"client":"172.18.0.4:43920","doc":{"driver":{"name":"nodejs|Mongoose","version":"6.20.0|8.24.11"},"platform":"Node.js v20.20.2, LE","os":{"name":"linux","architecture":"arm64","version":"6.12.54-linuxkit","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.584+00:00"},"s":"I",  "c":"NETWORK",  "id":51800,   "ctx":"conn11","msg":"client metadata","attr":{"remote":"172.18.0.4:43932","client":"conn11","negotiatedCompressors":[],"doc":{"driver":{"name":"nodejs|Mongoose","version":"6.20.0|8.24.11"},"platform":"Node.js v20.20.2, LE","os":{"name":"linux","architecture":"arm64","version":"6.12.54-linuxkit","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.584+00:00"},"s":"I",  "c":"ACCESS",   "id":10483900,"ctx":"conn11","msg":"Connection not authenticating","attr":{"client":"172.18.0.4:43932","doc":{"driver":{"name":"nodejs|Mongoose","version":"6.20.0|8.24.11"},"platform":"Node.js v20.20.2, LE","os":{"name":"linux","architecture":"arm64","version":"6.12.54-linuxkit","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.585+00:00"},"s":"I",  "c":"NETWORK",  "id":6788700, "ctx":"conn10","msg":"Received first command on ingress connection since session start or auth handshake","attr":{"elapsedMillis":1}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.585+00:00"},"s":"I",  "c":"STORAGE",  "id":20320,   "ctx":"conn10","msg":"createCollection","attr":{"namespace":"todos.todos","uuidDisposition":"generated","uuid":{"uuid":{"$uuid":"5bc145af-2a8b-47c6-87a7-a63952628915"}},"options":{}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.586+00:00"},"s":"I",  "c":"NETWORK",  "id":6788700, "ctx":"conn11","msg":"Received first command on ingress connection since session start or auth handshake","attr":{"elapsedMillis":2}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.592+00:00"},"s":"I",  "c":"REPL",     "id":7360102, "ctx":"conn10","msg":"Added oplog entry for create to transaction","attr":{"namespace":"todos.$cmd","uuid":{"uuid":{"$uuid":"5bc145af-2a8b-47c6-87a7-a63952628915"}},"object":{"create":"todos","idIndex":{"v":2,"key":{"_id":1},"name":"_id_"}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:36.592+00:00"},"s":"I",  "c":"INDEX",    "id":20345,   "ctx":"conn10","msg":"Index build: done building","attr":{"buildUUID":null,"collectionUUID":{"uuid":{"$uuid":"5bc145af-2a8b-47c6-87a7-a63952628915"}},"namespace":"todos.todos","index":"_id_","ident":"index-8--5134334182977428502","collectionIdent":"collection-7--5134334182977428502","commitTimestamp":null}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:41.498+00:00"},"s":"I",  "c":"NETWORK",  "id":22943,   "ctx":"listener","msg":"Connection accepted","attr":{"remote":"127.0.0.1:45954","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"74c05c12-3590-49be-8c8e-42248f7834df"}},"connectionId":12,"connectionCount":6}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:41.499+00:00"},"s":"I",  "c":"NETWORK",  "id":51800,   "ctx":"conn12","msg":"client metadata","attr":{"remote":"127.0.0.1:45954","client":"conn12","negotiatedCompressors":[],"doc":{"application":{"name":"mongosh 2.14.3"},"driver":{"name":"nodejs|mongosh","version":"7.5.0|2.14.3"},"platform":"Node.js v24.22.2, LE","os":{"name":"linux","architecture":"arm64","version":"5.10.271-272.1121.amzn2.aarch64","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:41.499+00:00"},"s":"I",  "c":"ACCESS",   "id":10483900,"ctx":"conn12","msg":"Connection not authenticating","attr":{"client":"127.0.0.1:45954","doc":{"application":{"name":"mongosh 2.14.3"},"driver":{"name":"nodejs|mongosh","version":"7.5.0|2.14.3"},"platform":"Node.js v24.22.2, LE","os":{"name":"linux","architecture":"arm64","version":"5.10.271-272.1121.amzn2.aarch64","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:41.501+00:00"},"s":"I",  "c":"NETWORK",  "id":22943,   "ctx":"listener","msg":"Connection accepted","attr":{"remote":"127.0.0.1:45968","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"06945ffa-65b5-4f37-823f-2bf88dd2a27e"}},"connectionId":13,"connectionCount":7}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:41.502+00:00"},"s":"I",  "c":"NETWORK",  "id":51800,   "ctx":"conn13","msg":"client metadata","attr":{"remote":"127.0.0.1:45968","client":"conn13","negotiatedCompressors":[],"doc":{"application":{"name":"mongosh 2.14.3"},"driver":{"name":"nodejs|mongosh","version":"7.5.0|2.14.3"},"platform":"Node.js v24.22.2, LE","os":{"name":"linux","architecture":"arm64","version":"5.10.271-272.1121.amzn2.aarch64","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:41.502+00:00"},"s":"I",  "c":"ACCESS",   "id":10483900,"ctx":"conn13","msg":"Connection not authenticating","attr":{"client":"127.0.0.1:45968","doc":{"application":{"name":"mongosh 2.14.3"},"driver":{"name":"nodejs|mongosh","version":"7.5.0|2.14.3"},"platform":"Node.js v24.22.2, LE","os":{"name":"linux","architecture":"arm64","version":"5.10.271-272.1121.amzn2.aarch64","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:41.509+00:00"},"s":"I",  "c":"NETWORK",  "id":6788700, "ctx":"conn13","msg":"Received first command on ingress connection since session start or auth handshake","attr":{"elapsedMillis":7}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:41.568+00:00"},"s":"I",  "c":"NETWORK",  "id":22943,   "ctx":"listener","msg":"Connection accepted","attr":{"remote":"127.0.0.1:45972","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"8f3e7121-1ce5-405e-9205-8c5f20e52aa3"}},"connectionId":14,"connectionCount":8}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:41.568+00:00"},"s":"I",  "c":"NETWORK",  "id":22943,   "ctx":"listener","msg":"Connection accepted","attr":{"remote":"127.0.0.1:45988","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"c24fa58e-82ba-4815-bcbd-44b83e87a11f"}},"connectionId":15,"connectionCount":9}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:41.570+00:00"},"s":"I",  "c":"NETWORK",  "id":51800,   "ctx":"conn14","msg":"client metadata","attr":{"remote":"127.0.0.1:45972","client":"conn14","negotiatedCompressors":[],"doc":{"application":{"name":"mongosh 2.14.3"},"driver":{"name":"nodejs|mongosh","version":"7.5.0|2.14.3"},"platform":"Node.js v24.22.2, LE","os":{"name":"linux","architecture":"arm64","version":"5.10.271-272.1121.amzn2.aarch64","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:41.570+00:00"},"s":"I",  "c":"ACCESS",   "id":10483900,"ctx":"conn14","msg":"Connection not authenticating","attr":{"client":"127.0.0.1:45972","doc":{"application":{"name":"mongosh 2.14.3"},"driver":{"name":"nodejs|mongosh","version":"7.5.0|2.14.3"},"platform":"Node.js v24.22.2, LE","os":{"name":"linux","architecture":"arm64","version":"5.10.271-272.1121.amzn2.aarch64","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:41.570+00:00"},"s":"I",  "c":"NETWORK",  "id":51800,   "ctx":"conn15","msg":"client metadata","attr":{"remote":"127.0.0.1:45988","client":"conn15","negotiatedCompressors":[],"doc":{"application":{"name":"mongosh 2.14.3"},"driver":{"name":"nodejs|mongosh","version":"7.5.0|2.14.3"},"platform":"Node.js v24.22.2, LE","os":{"name":"linux","architecture":"arm64","version":"5.10.271-272.1121.amzn2.aarch64","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:41.570+00:00"},"s":"I",  "c":"ACCESS",   "id":10483900,"ctx":"conn15","msg":"Connection not authenticating","attr":{"client":"127.0.0.1:45988","doc":{"application":{"name":"mongosh 2.14.3"},"driver":{"name":"nodejs|mongosh","version":"7.5.0|2.14.3"},"platform":"Node.js v24.22.2, LE","os":{"name":"linux","architecture":"arm64","version":"5.10.271-272.1121.amzn2.aarch64","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:41.572+00:00"},"s":"I",  "c":"NETWORK",  "id":22943,   "ctx":"listener","msg":"Connection accepted","attr":{"remote":"127.0.0.1:46002","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"53a8a729-b80d-4857-ac80-899e87a6ce57"}},"connectionId":16,"connectionCount":10}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:41.573+00:00"},"s":"I",  "c":"NETWORK",  "id":6788700, "ctx":"conn15","msg":"Received first command on ingress connection since session start or auth handshake","attr":{"elapsedMillis":2}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:41.573+00:00"},"s":"I",  "c":"NETWORK",  "id":51800,   "ctx":"conn16","msg":"client metadata","attr":{"remote":"127.0.0.1:46002","client":"conn16","negotiatedCompressors":[],"doc":{"application":{"name":"mongosh 2.14.3"},"driver":{"name":"nodejs|mongosh","version":"7.5.0|2.14.3"},"platform":"Node.js v24.22.2, LE","os":{"name":"linux","architecture":"arm64","version":"5.10.271-272.1121.amzn2.aarch64","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:41.573+00:00"},"s":"I",  "c":"ACCESS",   "id":10483900,"ctx":"conn16","msg":"Connection not authenticating","attr":{"client":"127.0.0.1:46002","doc":{"application":{"name":"mongosh 2.14.3"},"driver":{"name":"nodejs|mongosh","version":"7.5.0|2.14.3"},"platform":"Node.js v24.22.2, LE","os":{"name":"linux","architecture":"arm64","version":"5.10.271-272.1121.amzn2.aarch64","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:41.575+00:00"},"s":"I",  "c":"NETWORK",  "id":6788700, "ctx":"conn16","msg":"Received first command on ingress connection since session start or auth handshake","attr":{"elapsedMillis":2}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:41.577+00:00"},"s":"I",  "c":"NETWORK",  "id":22944,   "ctx":"conn12","msg":"Connection ended","attr":{"remote":"127.0.0.1:45954","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"74c05c12-3590-49be-8c8e-42248f7834df"}},"connectionId":12,"connectionCount":9}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:41.577+00:00"},"s":"I",  "c":"NETWORK",  "id":22944,   "ctx":"conn16","msg":"Connection ended","attr":{"remote":"127.0.0.1:46002","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"53a8a729-b80d-4857-ac80-899e87a6ce57"}},"connectionId":16,"connectionCount":8}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:41.577+00:00"},"s":"I",  "c":"NETWORK",  "id":22944,   "ctx":"conn15","msg":"Connection ended","attr":{"remote":"127.0.0.1:45988","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"c24fa58e-82ba-4815-bcbd-44b83e87a11f"}},"connectionId":15,"connectionCount":7}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:41.577+00:00"},"s":"I",  "c":"NETWORK",  "id":22944,   "ctx":"conn13","msg":"Connection ended","attr":{"remote":"127.0.0.1:45968","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"06945ffa-65b5-4f37-823f-2bf88dd2a27e"}},"connectionId":13,"connectionCount":6}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:41.577+00:00"},"s":"I",  "c":"NETWORK",  "id":22944,   "ctx":"conn14","msg":"Connection ended","attr":{"remote":"127.0.0.1:45972","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"8f3e7121-1ce5-405e-9205-8c5f20e52aa3"}},"connectionId":14,"connectionCount":5}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:42.807+00:00"},"s":"I",  "c":"NETWORK",  "id":22943,   "ctx":"listener","msg":"Connection accepted","attr":{"remote":"172.18.0.3:50428","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"743170e8-4d9a-404a-934e-729a44a484bb"}},"connectionId":17,"connectionCount":6}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:42.809+00:00"},"s":"I",  "c":"NETWORK",  "id":51800,   "ctx":"conn17","msg":"client metadata","attr":{"remote":"172.18.0.3:50428","client":"conn17","negotiatedCompressors":[],"doc":{"driver":{"name":"nodejs","version":"4.13.0"},"os":{"type":"Linux","name":"linux","architecture":"arm64","version":"6.12.54-linuxkit"},"platform":"Node.js v20.13.1, LE (unified)|Node.js v20.13.1, LE (unified)"}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:42.809+00:00"},"s":"I",  "c":"ACCESS",   "id":10483900,"ctx":"conn17","msg":"Connection not authenticating","attr":{"client":"172.18.0.3:50428","doc":{"driver":{"name":"nodejs","version":"4.13.0"},"os":{"type":"Linux","name":"linux","architecture":"arm64","version":"6.12.54-linuxkit"},"platform":"Node.js v20.13.1, LE (unified)|Node.js v20.13.1, LE (unified)"}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:46.837+00:00"},"s":"I",  "c":"NETWORK",  "id":22943,   "ctx":"listener","msg":"Connection accepted","attr":{"remote":"127.0.0.1:46004","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"df35a01b-ced9-45af-81cd-b3d4373f0c5f"}},"connectionId":18,"connectionCount":7}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:46.838+00:00"},"s":"I",  "c":"NETWORK",  "id":51800,   "ctx":"conn18","msg":"client metadata","attr":{"remote":"127.0.0.1:46004","client":"conn18","negotiatedCompressors":[],"doc":{"application":{"name":"mongosh 2.14.3"},"driver":{"name":"nodejs|mongosh","version":"7.5.0|2.14.3"},"platform":"Node.js v24.22.2, LE","os":{"name":"linux","architecture":"arm64","version":"5.10.271-272.1121.amzn2.aarch64","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:46.838+00:00"},"s":"I",  "c":"ACCESS",   "id":10483900,"ctx":"conn18","msg":"Connection not authenticating","attr":{"client":"127.0.0.1:46004","doc":{"application":{"name":"mongosh 2.14.3"},"driver":{"name":"nodejs|mongosh","version":"7.5.0|2.14.3"},"platform":"Node.js v24.22.2, LE","os":{"name":"linux","architecture":"arm64","version":"5.10.271-272.1121.amzn2.aarch64","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:46.840+00:00"},"s":"I",  "c":"NETWORK",  "id":22943,   "ctx":"listener","msg":"Connection accepted","attr":{"remote":"127.0.0.1:46018","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"eb6a0c77-88cd-420e-aaed-a4397b083fd8"}},"connectionId":19,"connectionCount":8}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:46.840+00:00"},"s":"I",  "c":"NETWORK",  "id":51800,   "ctx":"conn19","msg":"client metadata","attr":{"remote":"127.0.0.1:46018","client":"conn19","negotiatedCompressors":[],"doc":{"application":{"name":"mongosh 2.14.3"},"driver":{"name":"nodejs|mongosh","version":"7.5.0|2.14.3"},"platform":"Node.js v24.22.2, LE","os":{"name":"linux","architecture":"arm64","version":"5.10.271-272.1121.amzn2.aarch64","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:46.840+00:00"},"s":"I",  "c":"ACCESS",   "id":10483900,"ctx":"conn19","msg":"Connection not authenticating","attr":{"client":"127.0.0.1:46018","doc":{"application":{"name":"mongosh 2.14.3"},"driver":{"name":"nodejs|mongosh","version":"7.5.0|2.14.3"},"platform":"Node.js v24.22.2, LE","os":{"name":"linux","architecture":"arm64","version":"5.10.271-272.1121.amzn2.aarch64","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:46.846+00:00"},"s":"I",  "c":"NETWORK",  "id":6788700, "ctx":"conn19","msg":"Received first command on ingress connection since session start or auth handshake","attr":{"elapsedMillis":6}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:46.902+00:00"},"s":"I",  "c":"NETWORK",  "id":22943,   "ctx":"listener","msg":"Connection accepted","attr":{"remote":"127.0.0.1:46022","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"6f4dcb84-bd8d-42ce-9daa-899cf3f46838"}},"connectionId":20,"connectionCount":9}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:46.902+00:00"},"s":"I",  "c":"NETWORK",  "id":22943,   "ctx":"listener","msg":"Connection accepted","attr":{"remote":"127.0.0.1:46024","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"dca36ae3-046a-40c1-a0be-600abb55374e"}},"connectionId":21,"connectionCount":10}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:46.904+00:00"},"s":"I",  "c":"NETWORK",  "id":51800,   "ctx":"conn20","msg":"client metadata","attr":{"remote":"127.0.0.1:46022","client":"conn20","negotiatedCompressors":[],"doc":{"application":{"name":"mongosh 2.14.3"},"driver":{"name":"nodejs|mongosh","version":"7.5.0|2.14.3"},"platform":"Node.js v24.22.2, LE","os":{"name":"linux","architecture":"arm64","version":"5.10.271-272.1121.amzn2.aarch64","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:46.904+00:00"},"s":"I",  "c":"ACCESS",   "id":10483900,"ctx":"conn20","msg":"Connection not authenticating","attr":{"client":"127.0.0.1:46022","doc":{"application":{"name":"mongosh 2.14.3"},"driver":{"name":"nodejs|mongosh","version":"7.5.0|2.14.3"},"platform":"Node.js v24.22.2, LE","os":{"name":"linux","architecture":"arm64","version":"5.10.271-272.1121.amzn2.aarch64","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:46.905+00:00"},"s":"I",  "c":"NETWORK",  "id":51800,   "ctx":"conn21","msg":"client metadata","attr":{"remote":"127.0.0.1:46024","client":"conn21","negotiatedCompressors":[],"doc":{"application":{"name":"mongosh 2.14.3"},"driver":{"name":"nodejs|mongosh","version":"7.5.0|2.14.3"},"platform":"Node.js v24.22.2, LE","os":{"name":"linux","architecture":"arm64","version":"5.10.271-272.1121.amzn2.aarch64","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:46.905+00:00"},"s":"I",  "c":"ACCESS",   "id":10483900,"ctx":"conn21","msg":"Connection not authenticating","attr":{"client":"127.0.0.1:46024","doc":{"application":{"name":"mongosh 2.14.3"},"driver":{"name":"nodejs|mongosh","version":"7.5.0|2.14.3"},"platform":"Node.js v24.22.2, LE","os":{"name":"linux","architecture":"arm64","version":"5.10.271-272.1121.amzn2.aarch64","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:46.906+00:00"},"s":"I",  "c":"NETWORK",  "id":22943,   "ctx":"listener","msg":"Connection accepted","attr":{"remote":"127.0.0.1:46034","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"a505b48f-6340-4b71-80fe-a474908553e8"}},"connectionId":22,"connectionCount":11}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:46.907+00:00"},"s":"I",  "c":"NETWORK",  "id":6788700, "ctx":"conn21","msg":"Received first command on ingress connection since session start or auth handshake","attr":{"elapsedMillis":2}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:46.907+00:00"},"s":"I",  "c":"NETWORK",  "id":51800,   "ctx":"conn22","msg":"client metadata","attr":{"remote":"127.0.0.1:46034","client":"conn22","negotiatedCompressors":[],"doc":{"application":{"name":"mongosh 2.14.3"},"driver":{"name":"nodejs|mongosh","version":"7.5.0|2.14.3"},"platform":"Node.js v24.22.2, LE","os":{"name":"linux","architecture":"arm64","version":"5.10.271-272.1121.amzn2.aarch64","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:46.907+00:00"},"s":"I",  "c":"ACCESS",   "id":10483900,"ctx":"conn22","msg":"Connection not authenticating","attr":{"client":"127.0.0.1:46034","doc":{"application":{"name":"mongosh 2.14.3"},"driver":{"name":"nodejs|mongosh","version":"7.5.0|2.14.3"},"platform":"Node.js v24.22.2, LE","os":{"name":"linux","architecture":"arm64","version":"5.10.271-272.1121.amzn2.aarch64","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:46.909+00:00"},"s":"I",  "c":"NETWORK",  "id":6788700, "ctx":"conn22","msg":"Received first command on ingress connection since session start or auth handshake","attr":{"elapsedMillis":2}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:46.911+00:00"},"s":"I",  "c":"NETWORK",  "id":22944,   "ctx":"conn18","msg":"Connection ended","attr":{"remote":"127.0.0.1:46004","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"df35a01b-ced9-45af-81cd-b3d4373f0c5f"}},"connectionId":18,"connectionCount":10}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:46.911+00:00"},"s":"I",  "c":"NETWORK",  "id":22944,   "ctx":"conn22","msg":"Connection ended","attr":{"remote":"127.0.0.1:46034","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"a505b48f-6340-4b71-80fe-a474908553e8"}},"connectionId":22,"connectionCount":9}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:46.911+00:00"},"s":"I",  "c":"NETWORK",  "id":22944,   "ctx":"conn21","msg":"Connection ended","attr":{"remote":"127.0.0.1:46024","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"dca36ae3-046a-40c1-a0be-600abb55374e"}},"connectionId":21,"connectionCount":8}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:46.911+00:00"},"s":"I",  "c":"NETWORK",  "id":22944,   "ctx":"conn20","msg":"Connection ended","attr":{"remote":"127.0.0.1:46022","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"6f4dcb84-bd8d-42ce-9daa-899cf3f46838"}},"connectionId":20,"connectionCount":7}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:46.911+00:00"},"s":"I",  "c":"NETWORK",  "id":22944,   "ctx":"conn19","msg":"Connection ended","attr":{"remote":"127.0.0.1:46018","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"eb6a0c77-88cd-420e-aaed-a4397b083fd8"}},"connectionId":19,"connectionCount":6}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:47.098+00:00"},"s":"I",  "c":"NETWORK",  "id":22943,   "ctx":"listener","msg":"Connection accepted","attr":{"remote":"172.18.0.4:58642","isLoadBalanced":false,"uuid":{"uuid":{"$uuid":"28123c92-c505-4f73-9642-1590b3411123"}},"connectionId":23,"connectionCount":7}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:47.102+00:00"},"s":"I",  "c":"NETWORK",  "id":51800,   "ctx":"conn23","msg":"client metadata","attr":{"remote":"172.18.0.4:58642","client":"conn23","negotiatedCompressors":[],"doc":{"driver":{"name":"nodejs|Mongoose","version":"6.20.0|8.24.11"},"platform":"Node.js v20.20.2, LE","os":{"name":"linux","architecture":"arm64","version":"6.12.54-linuxkit","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}
todo-mongo          | {"t":{"$date":"2026-11-23T21:44:47.102+00:00"},"s":"I",  "c":"ACCESS",   "id":10483900,"ctx":"conn23","msg":"Connection not authenticating","attr":{"client":"172.18.0.4:58642","doc":{"driver":{"name":"nodejs|Mongoose","version":"6.20.0|8.24.11"},"platform":"Node.js v20.20.2, LE","os":{"name":"linux","architecture":"arm64","version":"6.12.54-linuxkit","type":"Linux"},"env":{"container":{"runtime":"docker"}}}}}

~/VSCodes/ASKK-25988/Lab5/supporting-materials/examples/05-mongodb-v1 % docker compose down
[+] Running 4/4
 ✔ Container todo-web             Removed                                                         1.2s 
 ✔ Container todo-mongo-express   Removed                                                         0.2s 
 ✔ Container todo-mongo           Removed                                                         0.2s 
 ✔ Network 05-mongodb-v1_default  Removed                                                         0.2s
```

**Screenshot:**

![Przykład z repozytorium uruchomiony](images/image-9.png)

Rys. 10 - Przykład z repozytorium uruchomiony.

---

##### Zadania do samodzielnego wykonania

##### Zadanie 1 — WordPress + MySQL

**Opis:** Stworzono plik `docker-compose.yaml` zawierający usługę WordPress i MySQL wraz z wolumenami na dane WordPressa i bazy danych oraz zawierający healthchecki, wykorzystujący interpolację zmiennych środowiskowych i posiadający odpowiednią izolację sieciową (baza danych nie ma dostępu do Internetu).

**Użyte polecenia:**

```zsh
mkdir -p ~/VSCodes/ASKK-25988/Lab5/wordpress-mysql && cd ~/VSCodes/ASKK-25988/Lab5/wordpress-mysql

docker-compose up -d

docker exec mysql_db curl -I --connect-timeout 3 https://1.1.1.1

docker-compose down -v
```

**Wynik działania:**

```zsh
~/VSCodes/ASKK-25988/Lab5/supporting-materials/examples/05-mongodb-v1 % mkdir -p ~/VSCodes/ASKK-25988/Lab5/wordpress-mysql && cd ~/VSCodes/ASKK-25988/Lab5/wordpress-mysql

~/VSCodes/ASKK-25988/Lab5/wordpress-mysql % docker-compose up -d
[+] Running 40/40
 ✔ wordpress Pulled                                                                              39.8s 
 ✔ db Pulled                                                                                          
                                                                              
[+] Running 5/5
 ✔ Network wordpress-mysql_backend   Created                                                      0.0s 
 ✔ Network wordpress-mysql_frontend  Created                                                      0.0s 
 ✔ Volume wordpress-mysql_wp_data    Created                                                      0.0s 
 ✔ Volume wordpress-mysql_db_data    Created                                                      0.0s 
 ✔ Container mysql_db                Healthy                                                      11.3s 
 ✔ Container wordpress_app           Started                                                      10.8s 

~/VSCodes/ASKK-25988/Lab5/wordpress-mysql % docker exec mysql_db curl -I --connect-timeout 3 https://1.1.1.1
curl: (7) Couldn't connect to server

~/VSCodes/ASKK-25988/Lab5/wordpress-mysql % docker-compose down -v
[+] Running 6/6
 ✔ Container wordpress_app           Removed                                                      1.3s 
 ✔ Container mysql_db                Removed                                                      0.8s 
 ✔ Volume wordpress-mysql_wp_data    Removed                                                      0.1s 
 ✔ Volume wordpress-mysql_db_data    Removed                                                      0.0s 
 ✔ Network wordpress-mysql_frontend  Removed                                                      0.2s 
 ✔ Network wordpress-mysql_backend   Removed                                                      0.3s
```

**Screenshot:**

![uruchomiony wordpress](images/image-10.png)

Rys. 11 - Uruchomiony stos WordPress + MySQL.

---

##### Zadanie 2 — Stos MEAN/MERN

**Opis:** Stworzono plik `docker-compose.yaml` dla stosu MEAN (MongoDB + Express.js + Angular.js + Node.js) wykorzystujący wolumeny, interpolację zmiennych środowiskowych i healthchecki. Ze względu na architekturę SPA aplikacji frontendowych (kompilacja do statycznych plików zamiast ciągle działającego procesu), do serwowania frontendu użyto serwer Nginx, który nasłuchuje na konkretnym porcie i wysyła statyczne pliki. Działanie całego stosu zweryfikowano przez odpytanie 2 backendowych endpointów, weryfikację braku możliwości połączenia z Internetem przez bazę danych i uruchomienie aplikacji Angular serwowanej na porcie 8080.

**Użyte polecenia:**

```zsh
mkdir -p ~/VSCodes/ASKK-25988/Lab5/mean && cd ~/VSCodes/ASKK-25988/Lab5/mean

ng new

mkdir backend && cd backend
npm init -y
npm install express mongoose
npm pkg set scripts.start="node server.js"

cd ../frontend
npm run build

cd ..

docker-compose up -d

curl -i http://localhost:8080/api/health
curl -i http://localhost:8080/api/db-check
docker exec mean_mongo bash -c "timeout 3 bash -c '</dev/tcp/1.1.1.1/80'"

docker-compose down -v
```

**Wynik działania:**

```zsh
~/VSCodes/ASKK-25988/Lab5/wordpress-mysql % mkdir -p ~/VSCodes/ASKK-25988/Lab5/mean && cd ~/VSCodes/ASKK-25988/Lab5/mean

~/VSCodes/ASKK-25988/Lab5/mean % mkdir backend && cd backend

~/VSCodes/ASKK-25988/Lab5/mean/backend % npm init -y
Wrote to /Users/mewosh/VSCodes/ASKK-25988/Lab5/mean/backend/package.json:

{
  "name": "backend",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "type": "commonjs"
}

~/VSCodes/ASKK-25988/Lab5/mean/backend % npm install express mongoose

added 83 packages, and audited 84 packages in 2s

32 packages are looking for funding
  run `npm fund` for details

found 0 vulnerabilities

~/VSCodes/ASKK-25988/Lab5/mean/backend % npm pkg set scripts.start="node server.js"

~/VSCodes/ASKK-25988/Lab5/mean/backend % cd ../frontend 

~/VSCodes/ASKK-25988/Lab5/mean/frontend % npm run build

> frontend@0.0.0 build
> ng build

Initial chunk files | Names         |  Raw size | Estimated transfer size
main-5DDD6G7Z.js    | main          | 214.34 kB |                58.62 kB
styles-5INURTSO.css | styles        |   0 bytes |                 0 bytes

                    | Initial total | 214.34 kB |                58.62 kB

Application bundle generation complete. [2.754 seconds] - 2026-11-24T14:27:53.798Z

Output location: /Users/mewosh/VSCodes/ASKK-25988/Lab5/mean/frontend/dist/frontend

~/VSCodes/ASKK-25988/Lab5/mean/frontend % cd ..

~/VSCodes/ASKK-25988/Lab5/mean % docker-compose up -d
[+] Running 2/13
 ✔ backend Pulled                                                                                 8.5s 
   ⠋ d7c36ecc3656 Pulling fs layer                                                               25.0s 
   ⠋ bec7aaabd7f9 Pulling fs layer                                                               25.0s 
   ⠋ 1d0a73052429 Pulling fs layer                                                               25.0s 
 ✔ mongo Pulled                                                                                  25.8s 
   ⠋ e2466c1301be Pulling fs layer                                                               25.0s 
   ⠋ 6542099f24f2 Pulling fs layer                                                               25.0s 
   ⠋ 9d8f20245f08 Pulling fs layer                                                               25.0s 
   ⠋ 393a84798015 Pulling fs layer                                                               25.0s 
   ⠋ 8764daa87340 Pulling fs layer                                                               25.0s 
   ⠋ 9b09b5bba328 Pulling fs layer                                                               25.0s 
   ⠋ b5fa2b74439e Pulling fs layer                                                               25.0s 
   ⠋ 346907a65c6e Pulling fs layer                                                               25.0s 
[+] Running 6/6
 ✔ Network mean_frontend   Created                                                                0.0s 
 ✔ Network mean_backend    Created                                                                0.0s 
 ✔ Volume mean_mongo_data  Created                                                                0.0s 
 ✔ Container mean_mongo    Healthy                                                                6.3s 
 ✔ Container mean_express  Healthy                                                               11.4s
 ✔ Container mean_angular  Created                                                                0.1s 

~/VSCodes/ASKK-25988/Lab5/mean % curl -i http://localhost:8080/api/health
HTTP/1.1 200 OK
Server: nginx/1.31.7
Date: Tue, 24 Nov 2026 14:35:04 GMT
Content-Type: application/json; charset=utf-8
Content-Length: 37
Connection: keep-alive
X-Powered-By: Express
ETag: W/"25-q3fETjJqNoUytG4EcspRfWl2tmA"

{"status":"OK","uptime":16.067499174}%                                                                 

~/VSCodes/ASKK-25988/Lab5/mean % curl -i http://localhost:8080/api/db-check
HTTP/1.1 200 OK
Server: nginx/1.31.7
Date: Tue, 24 Nov 2026 14:35:11 GMT
Content-Type: application/json; charset=utf-8
Content-Length: 38
Connection: keep-alive
X-Powered-By: Express
ETag: W/"26-YuZ3VKlr4+Z8ik+YgCW6avX/x+A"

{"database":"connected","ping":"pong"}%                                                                

~/VSCodes/ASKK-25988/Lab5/mean % docker exec mean_mongo bash -c "timeout 3 bash -c '</dev/tcp/1.1.1.1/80'"
bash: connect: Network is unreachable
bash: line 1: /dev/tcp/1.1.1.1/80: Network is unreachable

~/VSCodes/ASKK-25988/Lab5/mean % docker-compose down -v
[+] Running 6/6
 ✔ Container mean_angular  Removed                                                                0.3s 
 ✔ Container mean_express  Removed                                                                1.2s 
 ✔ Container mean_mongo    Removed                                                                0.1s 
 ✔ Network mean_backend    Removed                                                                0.1s 
 ✔ Volume mean_mongo_data  Removed                                                                0.0s 
 ✔ Network mean_frontend   Removed                                                                0.3s
```

**Screenshot:**

![angular z kontenera](images/image-11.png)

Rys. 12 - Aplikacja Angular uruchomiona z kontenera.

---

##### Zadanie 3 — Override files

**Opis:** Stworzono plik `docker-compose.yaml` z usługami Node i PostgreSQL, wolumenami, interpolacją zmiennych środowiskowych, healthcheckami i izolacją sieciową. Następnie stworzono plik `docker-compose.override.yaml` zawierający konfigurację dla trybu development nadpisujący plik `docker-compose.yaml` i przetestowano 2 scenariusze: scenariusz 1 - wystartowanie stosu z `docker-compose.yaml` w trybie production, gdzie przy edycji pliku zmiana nie była widoczna aż do restartu kontenera oraz scenariusz 2 - wystartowanie stosu z `docker-compose.yaml` w trybie development, gdzie przy edycji pliku zmiana była natychmiast widoczna (hot reload).

**Użyte polecenia:**

```zsh
mkdir -p ~/VSCodes/ASKK-25988/Lab5/override && cd ~/VSCodes/ASKK-25988/Lab5/override

npm init -y

npm pkg set scripts.start="node index.js"
npm pkg set scripts.dev="node --watch index.js"

docker compose -f docker-compose.yaml up --build -d
curl http://localhost:8000
sed -i '' 's/Wersja 1: Działa!/Wersja 2: Działa!/g' index.js # Zamiana "Wersja 1:" na "Wersja 2:"
curl http://localhost:8000 # Zmiana niewidoczna do momentu restartu kontenera
docker compose -f docker-compose.yaml down

docker compose up --build -d
curl http://localhost:8000
sed -i '' 's/Wersja 2: Działa!/Wersja 3: Działa!/g' index.js index.js # Zamiana "Wersja 2:" na "Wersja 3:"
curl http://localhost:8000 # Zmiana od razu widoczna

docker compose exec db ping -c 2 8.8.8.8 # fail: baza danych nie ma dostępu do Internetu

docker compose down -v
```

**Wynik działania:**

```zsh
~/VSCodes/ASKK-25988/Lab5/mean % mkdir -p ~/VSCodes/ASKK-25988/Lab5/override && cd ~/VSCodes/ASKK-25988/Lab5/override

~/VSCodes/ASKK-25988/Lab5/override % npm init -y
Wrote to /Users/mewosh/VSCodes/ASKK-25988/Lab5/override/package.json:

{
  "name": "override",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "type": "commonjs"
}

~/VSCodes/ASKK-25988/Lab5/override % npm pkg set scripts.start="node index.js"

~/VSCodes/ASKK-25988/Lab5/override % npm pkg set scripts.dev="node --watch index.js"

~/VSCodes/ASKK-25988/Lab5/override % docker compose -f docker-compose.yaml up --build -d
[+] Building 1.1s (12/12) FINISHED                                                                     
 => [internal] load local bake definitions                                                        0.0s
 => => reading from stdin 536B                                                                    0.0s
 => [internal] load build definition from Dockerfile                                              0.0s
 => => transferring dockerfile: 382B                                                              0.0s
 => [internal] load metadata for docker.io/library/node:22-alpine                                 0.0s
 => [internal] load .dockerignore                                                                 0.0s
 => => transferring context: 2B                                                                   0.0s
 => [base 1/4] FROM docker.io/library/node:22-alpine@sha256:1314fb30ec37592d5845e5a160d522c0e680  0.0s
 => => resolve docker.io/library/node:22-alpine@sha256:1314fb30ec37592d5845e5a160d522c0e680972aa  0.0s
 => [internal] load build context                                                                 0.0s
 => => transferring context: 2.48kB                                                               0.0s
 => [base 2/4] WORKDIR /app                                                                       0.0s
 => [base 3/4] COPY package*.json ./                                                              0.0s
 => [base 4/4] RUN npm install                                                                    0.5s
 => [production 1/1] COPY . .                                                                     0.0s
 => exporting to image                                                                            0.2s
 => => exporting layers                                                                           0.1s
 => => exporting manifest sha256:4b0865ec8c71872aa14cb58b81bcbe3ddfe6ae89f3de3852e134f40552ac5a1  0.0s
 => => exporting config sha256:703a504db19165e0cffb72bd84e38ffc3d9d84cf185d6ee46968d354ed22b34e   0.0s
 => => exporting attestation manifest sha256:152b3b6e1e7ce83808bdfad24106884a569121a91dc83f5f858  0.0s
 => => exporting manifest list sha256:5c824e2ae4b6b5d06e19fa1ed7ecd659bee851fe1d4b56ddaec270e47f  0.0s
 => => naming to docker.io/library/my-app:latest                                                  0.0s
 => => unpacking to docker.io/library/my-app:latest                                               0.0s
 => resolving provenance for metadata file                                                        0.0s
[+] Running 6/6
 ✔ my-app:latest                      Built                                                       0.0s 
 ✔ Network override_backend-network   Created                                                     0.0s 
 ✔ Network override_frontend-network  Created                                                     0.0s 
 ✔ Volume override_postgres_data      Created                                                     0.0s 
 ✔ Container override-db-1            Healthy                                                     5.9s 
 ✔ Container override-app-1           Started                                                     5.9s 

~/VSCodes/ASKK-25988/Lab5/override % curl http://localhost:8000
{
  "message": "Wersja 1: Działa!",
  "environment": "production",
  "debugMode": "false",
  "timestamp": "2026-11-24T15:01:27.379Z"
}%                                                                        

~/VSCodes/ASKK-25988/Lab5/override % sed -i '' 's/Wersja 1: Działa!/Wersja 2: Działa!/g' index.js

~/VSCodes/ASKK-25988/Lab5/override % curl http://localhost:8000
{
  "message": "Wersja 1: Działa!",
  "environment": "production",
  "debugMode": "false",
  "timestamp": "2026-11-24T15:09:22.751Z"
}%                                                                                                     

~/VSCodes/ASKK-25988/Lab5/override % docker compose -f docker-compose.yaml down
[+] Running 4/4
 ✔ Container override-app-1           Removed                                                     0.8s 
 ✔ Container override-db-1            Removed                                                     0.1s 
 ✔ Network override_frontend-network  Removed                                                     0.3s 
 ✔ Network override_backend-network   Removed                                                     0.1s 

~/VSCodes/ASKK-25988/Lab5/override % docker compose up --build -d
[+] Building 0.4s (12/12) FINISHED                                                                     
 => [internal] load local bake definitions                                                        0.0s
 => => reading from stdin 567B                                                                    0.0s
 => [internal] load build definition from Dockerfile                                              0.0s
 => => transferring dockerfile: 382B                                                              0.0s
 => [internal] load metadata for docker.io/library/node:22-alpine                                 0.0s
 => [internal] load .dockerignore                                                                 0.0s
 => => transferring context: 2B                                                                   0.0s
 => [base 1/4] FROM docker.io/library/node:22-alpine@sha256:1314fb30ec37592d5845e5a160d522c0e680  0.0s
 => => resolve docker.io/library/node:22-alpine@sha256:1314fb30ec37592d5845e5a160d522c0e680972aa  0.0s
 => [internal] load build context                                                                 0.0s
 => => transferring context: 806B                                                                 0.0s
 => CACHED [base 2/4] WORKDIR /app                                                                0.0s
 => CACHED [base 3/4] COPY package*.json ./                                                       0.0s
 => CACHED [base 4/4] RUN npm install                                                             0.0s
 => [development 1/1] COPY . .                                                                    0.0s
 => exporting to image                                                                            0.1s
 => => exporting layers                                                                           0.0s
 => => exporting manifest sha256:71a27e74697690d9e4edf70352cda7b370e888711471372eacd040fb81a7030  0.0s
 => => exporting config sha256:3561a8384c08356e357fc4ed8afce24139c2003ef55a520ebadde8a37fd6a5ea   0.0s
 => => exporting attestation manifest sha256:3466eaca6be899b8e0c7e2e4b3cdbc9105b2b9f1af519240f70  0.0s
 => => exporting manifest list sha256:6beb9899ea188eb6b2da48964174b258e73e15b1fe2eb1c6246ac3c695  0.0s
 => => naming to docker.io/library/my-app:latest                                                  0.0s
 => => unpacking to docker.io/library/my-app:latest                                               0.0s
 => resolving provenance for metadata file                                                        0.0s
[+] Running 5/5
 ✔ my-app:latest                      Built                                                       0.0s 
 ✔ Network override_backend-network   Created                                                     0.0s 
 ✔ Network override_frontend-network  Created                                                     0.0s 
 ✔ Container override-db-1            Healthy                                                     9.8s 
 ✔ Container override-app-1           Started                                                     9.9s 

~/VSCodes/ASKK-25988/Lab5/override % curl http://localhost:8000
{
  "message": "Wersja 2: Działa!",
  "environment": "development",
  "debugMode": "true",
  "timestamp": "2026-11-24T15:09:44.280Z"
}%                                                                                                     

~/VSCodes/ASKK-25988/Lab5/override % sed -i '' 's/Wersja 2: Działa!/Wersja 3: Działa!/g' index.js index.js

~/VSCodes/ASKK-25988/Lab5/override % curl http://localhost:8000
{
  "message": "Wersja 3: Działa!",
  "environment": "development",
  "debugMode": "true",
  "timestamp": "2026-11-24T15:09:55.787Z"
}%                                                                                                     

~/VSCodes/ASKK-25988/Lab5/override % docker compose exec db ping -c 2 8.8.8.8
PING 8.8.8.8 (8.8.8.8): 56 data bytes
ping: sendto: Network unreachable

~/VSCodes/ASKK-25988/Lab5/override % docker compose down -v
[+] Running 5/5
 ✔ Container override-app-1           Removed                                                     0.3s 
 ✔ Container override-db-1            Removed                                                     0.1s 
 ✔ Network override_backend-network   Removed                                                     0.3s 
 ✔ Volume override_postgres_data      Removed                                                     0.0s 
 ✔ Network override_frontend-network  Removed                                                     0.2s
```

**Screenshot:**

![dev](images/image-12.png)

Rys. 13 - Natychmiastowa aktualizacja zawartości pliku po jego edycji na serwerze Node uruchomionym w trybie development.

---

#### 4. Pliki konfiguracyjne

##### Dockerfile

##### Zadanie 1

```dockerfile
# Etap bazowy
FROM node:22-alpine AS base
WORKDIR /app
COPY package*.json ./
RUN npm install

# Etap deweloperski (wykorzystywany przez docker-compose.override.yaml)
FROM base AS development
COPY . .
CMD ["npm", "run", "dev"]

# Etap produkcyjny (domyślny dla samego docker-compose.yaml)
FROM base AS production
COPY . .
CMD ["npm", "start"]
```

##### docker-compose.yaml

##### Zadanie 1

```yaml
services:
  db:
    image: mysql:8.4
    container_name: mysql_db
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    volumes:
      - db_data:/var/lib/mysql
    networks:
      - backend
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-p${MYSQL_ROOT_PASSWORD}"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 30s

  wordpress:
    image: wordpress:latest
    container_name: wordpress_app
    restart: unless-stopped
    ports:
      - "${WP_PORT}:80"
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_NAME: ${MYSQL_DATABASE}
      WORDPRESS_DB_USER: ${MYSQL_USER}
      WORDPRESS_DB_PASSWORD: ${MYSQL_PASSWORD}
    volumes:
      - wp_data:/var/www/html
    networks:
      - frontend
      - backend
    depends_on:
      db:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:80/wp-admin/install.php"]
      interval: 15s
      timeout: 5s
      retries: 5
      start_period: 30s

volumes:
  db_data:
  wp_data:

networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge
    internal: true
```

##### Zadanie 2

```yaml
services:
  mongo:
    image: mongo:8.0
    container_name: mean_mongo
    restart: unless-stopped
    environment:
      MONGO_INITDB_ROOT_USERNAME: ${MONGO_ROOT_USER}
      MONGO_INITDB_ROOT_PASSWORD: ${MONGO_ROOT_PASSWORD}
      MONGO_INITDB_DATABASE: ${MONGO_DB}
    volumes:
      - mongo_data:/data/db
    networks:
      - backend
    healthcheck:
      test: ["CMD", "mongosh", "--quiet", "--eval", "db.adminCommand('ping').ok"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 20s

  backend:
    image: node:22-alpine
    container_name: mean_express
    restart: unless-stopped
    working_dir: /app
    volumes:
      - ./backend:/app
    command: ["node", "server.js"]
    environment:
      NODE_ENV: ${NODE_ENV}
      PORT: ${BACKEND_PORT}
      MONGO_URI: mongodb://${MONGO_ROOT_USER}:${MONGO_ROOT_PASSWORD}@mongo:27017/${MONGO_DB}?authSource=admin
    networks:
      - backend
    depends_on:
      mongo:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "node", "-e", "fetch('http://localhost:${BACKEND_PORT}/api/health').then(r => process.exit(r.ok ? 0 : 1)).catch(() => process.exit(1))"]
      interval: 15s
      timeout: 5s
      retries: 5
      start_period: 15s

  frontend:
    image: nginx:alpine
    container_name: mean_angular
    restart: unless-stopped
    ports:
      - "${FRONTEND_PORT}:80"
    volumes:
      - ./frontend/dist/frontend/browser:/usr/share/nginx/html:ro
      - ./nginx.conf:/etc/nginx/conf.d/default.conf:ro
    networks:
      - frontend
      - backend
    depends_on:
      backend:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:80/"]
      interval: 15s
      timeout: 5s
      retries: 5
      start_period: 10s

volumes:
  mongo_data:

networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge
    internal: true
```

##### Zadanie 3

```yaml
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    image: my-app:latest
    restart: unless-stopped
    ports:
      - "8000:8000"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@db:5432/${POSTGRES_DB}
    depends_on:
      db:
        condition: service_healthy
    networks:
      - frontend-network
      - backend-network

  db:
    image: postgres:16-alpine
    restart: unless-stopped
    environment:
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: ${POSTGRES_DB}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB}"]
      interval: 5s
      timeout: 5s
      retries: 5
    networks:
      - backend-network

volumes:
  postgres_data:

networks:
  frontend-network:
    driver: bridge
  backend-network:
    driver: bridge
    internal: true
```

docker-compose.override.yaml
```yaml
services:
  app:
    build:
      context: .
      target: development # Wskazuje etap dev w multi-stage Dockerfile
    restart: "no"
    ports:
      - "8000:8000"
      - "9229:9229" # Port debuggera (np. 9229 dla Node.js, 5678 dla Python debugpy)
    environment:
      - NODE_ENV=development
      - DEBUG=true
    volumes:
      # Bind mount całego katalogu projektu dla hot-reloadingu
      - .:/app
      # Anonimowy wolumen chroniący zależności kontenera przed nadpisaniem przez pusty/inny katalog hosta
      - /app/node_modules
    # Nadpisanie komendy startowej na tryb watch + nasłuchiwanie debuggera
    command: npm run dev -- --inspect=0.0.0.0:9229

  db:
    restart: "no"
    # Wystawienie portu bazy na hosta (np. dla DBeaver / TablePlus)
    ports:
      - "5432:5432"
```

##### Inne pliki

##### Zadanie 1

.env
```
# Konfiguracja bazy danych
MYSQL_ROOT_PASSWORD=root_secret
MYSQL_DATABASE=wordpress_db
MYSQL_USER=wp_user
MYSQL_PASSWORD=secret

# Konfiguracja WordPressa
WP_PORT=8080
```

##### Zadanie 2

.env
```
# Konfiguracja MongoDB
MONGO_ROOT_USER=admin
MONGO_ROOT_PASSWORD=secret
MONGO_DB=mean_db

# Konfiguracja Backend (Node/Express)
NODE_ENV=production
BACKEND_PORT=3000

# Konfiguracja Frontend (Nginx + Angular)
FRONTEND_PORT=8080
```

nginx.conf
```
server {
    listen 80;
    server_name localhost;
    root /usr/share/nginx/html;
    index index.html;

    # Obsługa routingu Angulara (SPA fallback)
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Przekierowanie zapytań /api do kontenera backend
    location /api/ {
        proxy_pass http://backend:3000;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

backend/server.js
```js
const express = require('express');
const mongoose = require('mongoose');

const app = express();
const PORT = process.env.PORT || 3000;
const MONGO_URI = process.env.MONGO_URI || 'mongodb://localhost:27017/mean_app';

// Nawiązanie połączenia z MongoDB
mongoose.connect(MONGO_URI)
  .then(() => console.log('Połączono z MongoDB'))
  .catch((err) => console.error('Błąd połączenia z MongoDB:', err));

// Healthcheck
app.get('/api/health', (req, res) => {
  res.status(200).json({ status: 'OK', uptime: process.uptime() });
});

// 2. Endpoint weryfikujący połączenie z bazą danych
app.get('/api/db-check', async (req, res) => {
  // mongoose.connection.readyState: 0 = disconnected, 1 = connected, 2 = connecting, 3 = disconnecting
  const isConnected = mongoose.connection.readyState === 1;

  if (!isConnected) {
    return res.status(503).json({
      database: 'disconnected',
      readyState: mongoose.connection.readyState
    });
  }

  try {
    await mongoose.connection.db.admin().ping();
    res.status(200).json({ database: 'connected', ping: 'pong' });
  } catch (error) {
    res.status(500).json({ database: 'error', message: error.message });
  }
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Serwer Express działa na porcie ${PORT}`);
});
```

##### Zadanie 3

.env
```
POSTGRES_USER=user
POSTGRES_PASSWORD=secret
POSTGRES_DB=app_db
```

index.js
```js
const http = require('http');

const PORT = 8000;
const ENV = process.env.NODE_ENV || 'brak';
const DEBUG = process.env.DEBUG || 'false';

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8' });
  res.end(JSON.stringify({
    message: 'Wersja 3: Działa!',
    environment: ENV,
    debugMode: DEBUG,
    timestamp: new Date().toISOString()
  }, null, 2));
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`Serwer uruchomiony na porcie ${PORT} (ENV: ${ENV}, DEBUG: ${DEBUG})`);
});
```

---

#### 5. Napotkane problemy i ich rozwiązania

| Problem | Rozwiązanie |
|---------|-------------|
| - brak - | - brak - |

---

#### 6. Wnioski

W ramach laboratorium nauczyłem się pisać pliki `docker-compose.yaml`, definiować usługi, sieci i wolumeny, używać zmiennych środowiskowych i plików `.env`, konfigurować `depends_on` z `healthchecks`, zarządzać stosem komendami `docker compose`, izolować usługi w osobnych sieciach i skalować usługi. W trakcie laboratorium nie napotkano większych problemów a najciekawsze było przygotowanie kompletnego pliku `docker-compose.yaml` zawierającego cały stos technologiczny MEAN i weryfikacja jego działania.

---

#### 7. Bibliografia / źródła

- [Docker Documentation](https://docs.docker.com/)
