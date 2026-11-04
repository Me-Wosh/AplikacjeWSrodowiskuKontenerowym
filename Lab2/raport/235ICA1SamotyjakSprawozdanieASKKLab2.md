### Sprawozdanie z laboratorium nr 2

**Przedmiot:** Aplikacje w środowisku kontenerowym  

**Temat:** Budowanie obrazów z Dockerfile

**Data wykonania:** 04.11.2026

**Autor:** Miłosz Samotyjak

**Numer indeksu:** 25988

**Grupa:** 235IC A1

---

#### 1. Cel laboratorium

Nauka tworzenia własnych obrazów Docker za pomocą Dockerfile — od prostych do zaawansowanych, z wykorzystaniem multi-stage builds.

---

#### 2. Wstęp teoretyczny

**Dockerfile**

Tekstowy skrypt zawierający sekwencję instrukcji używaną przez Dockera do automatycznego zbudowania obrazu. Służy za szkielet środowiska aplikacji, precyzuje wszystko, zaczynając od systemu operacyjnego i środowiska uruchomieniowego języka, kończąc na plikach z kodem, zmiennych środowiskowych i poleceniach uruchomieniowych.

Najpopularniejsze komendy Dockerfile:
- `FROM` - ustawia bazowy obraz, na podstawie którego będzie budowany nasz obraz, 
- `WORKDIR` - ustawia bazowy katalog wewnątrz kontenera, na którym będą wykonywane operacje,
- `COPY` - kopiuje pliki lub katalogi z maszyny hosta do systemu plików kontenera,
- `ADD` - działa podobnie do `COPY`. Potrafi dodatkowo pobierać dane z zewnętrznych URL i rozpakowywać archiwa,
- `RUN` - wykonuje komendy podczas budowania obrazu,
- `ENV` - ustawia zmienne środowiskowe dostępne podczas budowania i w uruchomionym kontenerze,
- `EXPOSE` - ustawia porty sieciowe, na których nasłuchuje kontener w trakcie jego działania,
- `USER` - zmienia użytkownika wewnątrz kontenera, który będzie wykonywał kolejne polecenia,
- `CMD` - precyzuje domyślny skrypt uruchomieniowy i jego argumenty dla uruchomionego kontenera,
- `ENTRYPOINT` - konfiguruje stałą komendę, która zawsze zostaje uruchomiona na starcie kontenera.

**.dockerignore**

Plik działający podobnie do pliku `.gitignore`, będącego częścią systemu kontroli wersji Git, zawierający listę plików i katalogów, które nie mają znaleźć się w końcowym obrazie, np. zależności `node_modules`, niepotrzebne kontenerowi pliki takie jak `.git` lub dane wrażliwe takie jak zmienne środowiskowe.

**Multi-stage builds**

Pozwalają na wielokrotne używanie komendy `FROM`, z czego każda komenda może używać innego obrazu. Artefakty budowania można kopiować między etapami, pomijając te, które są już zbędne. Głównym celem wieloetapowego budowania jest zmniejszenie rozmiaru finalnego obrazu.

**Caching**

Docker wykonuje instrukcje z `Dockerfile` linijka po linijce a każda instrukcja tworzy warstwę pośrednią. Docker lokalnie cachuje te warstwy w celu przyspieszenia przyszłych buildów. Jeśli instrukcja i pliki, na których ona polega nie zmieniły się od czasu ostatniego budowania, Docker całkowicie pomija uruchamianie tej instrukcji i korzysta ze zcachowanej warstwy. Zaleca się oddzielenie rzadko zmieniających się instrukcji (np. kopiowania zależności) od reszty instrukcji (np. kopiowania kodu źródłowego) w celu efektywnego wykorzystania mechanizmu cachowania.

**Docker Hub**

Publiczny chmurowy rejestr hostowany przez Dockera służący do przechowywania, znajdowania i udostępniania obrazów. Można na niego wrzucać własnoręcznie stworzone obrazy i uczynić je prywatnymi lub publicznymi. Docker Hub zawiera również oficjalne, dobrze utrzymywane obrazy dla popularnych systemów operacyjnych, języków programowania lub aplikacji. Integruje się z wierszem poleceń i pipeline'ami CI/CD w celu automatyzacji budowania i dystrybucji obrazów.

---

#### 3. Przebieg ćwiczeń

##### Ćwiczenie 1.1 — Prosty obraz z Pythonem

**Opis:** Stworzono prosty skrypt Python wraz z plikiem `Dockerfile` i uruchomiono go z kontenera.

**Użyte polecenia:**

```zsh
mkdir -p hello-python && cd hello-python

docker build -t hello-python:v1 .
docker run --rm hello-python:v1
```

**Wynik działania:**

```zsh
mewosh@mioszs-macbook-air Lab2 % mkdir -p hello-python && cd hello-python
mewosh@mioszs-macbook-air hello-python % 
```

```zsh
mewosh@mioszs-macbook-air hello-python % docker build -t hello-python:v1 .
docker run --rm hello-python:v1
[+] Building 0.3s (8/8) FINISHED                                                                     docker:desktop-linux
 => [internal] load build definition from Dockerfile                                                                 0.0s
 => => transferring dockerfile: 111B                                                                                 0.0s
 => [internal] load metadata for docker.io/library/python:3.11-slim                                                  0.0s
 => [internal] load .dockerignore                                                                                    0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [1/3] FROM docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea  0.0s
 => => resolve docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea  0.0s
 => [internal] load build context                                                                                    0.0s
 => => transferring context: 340B                                                                                    0.0s
 => [2/3] WORKDIR /app                                                                                               0.0s
 => [3/3] COPY app.py .                                                                                              0.0s
 => exporting to image                                                                                               0.1s
 => => exporting layers                                                                                              0.0s
 => => exporting manifest sha256:bb314cfad2fea239eefccdc66b654b62d045bcd6cd9f0d1933d911c595e591a6                    0.0s
 => => exporting config sha256:c96ad95ae27471968b557eea5139ce6ecfbbca6d164b007ad43f4e05c5a18dbd                      0.0s
 => => exporting attestation manifest sha256:92c94d199c1acc505dc54c4bf60c7a2c25f78935d1d1f57487e97ba6e299a003        0.0s
 => => exporting manifest list sha256:4a169700acc1f9b0ea47a3f4df81f0debcb88297d37e3388ad63c603f023ac85               0.0s
 => => naming to docker.io/library/hello-python:v1                                                                   0.0s
 => => unpacking to docker.io/library/hello-python:v1                                                                0.0s
========================================
Witaj z kontenera Docker!
Python: 3.11.17
System: Linux 6.12.54-linuxkit
Hostname: 986283ef809e
Użytkownik: nieznany
========================================
```

**Screenshot:**

![Wynik budowania i uruchomienia obrazu python](images/image.png)

Rys. 1 - Wynik budowania i uruchomienia obrazu Python.

---

##### Ćwiczenie 1.2 — Analiza warstw

**Opis:** Wyświetlono historię warstw utworzonego kontenera Python i sprawdzono rozmiar obrazu. Polecenie `docker history hello-python:v1` zastępiono poleceniem `docker history 4a169700acc1` ze względu na problem opisany już w laboratorium 1, czyli zmianę funkcjonowania mechanizmu przechowywania obrazów (obecnie `containerd`) wymagającą podania ID obrazu lub nazwy obrazu wraz z jego platformą sprzętową, aby został on znaleziony.

**Użyte polecenia:**

```zsh
# Historia warstw
docker history 4a169700acc1

# Rozmiar obrazu
docker images hello-python
```

**Wynik działania:**

```zsh
~/VSCodes/ASKK-25988/Lab2/hello-python % docker history 4a169700acc1
IMAGE          CREATED          CREATED BY                                      SIZE      COMMENT
4a169700acc1   18 minutes ago   CMD ["python" "app.py"]                         0B        buildkit.dockerfile.v0
<missing>      18 minutes ago   COPY app.py . # buildkit                        12.3kB    buildkit.dockerfile.v0
<missing>      18 minutes ago   WORKDIR /app                                    8.19kB    buildkit.dockerfile.v0
<missing>      3 weeks ago      CMD ["python3"]                                 0B        buildkit.dockerfile.v0
<missing>      3 weeks ago      RUN /bin/sh -c set -eux;  for src in idle3 p…   16.4kB    buildkit.dockerfile.v0
<missing>      3 weeks ago      RUN /bin/sh -c set -eux;   savedAptMark="$(a…   52.1MB    buildkit.dockerfile.v0
<missing>      3 weeks ago      ENV PYTHON_SHA256=bfb74ad39efae27cda510f134a…   0B        buildkit.dockerfile.v0
<missing>      3 weeks ago      ENV PYTHON_VERSION=3.11.17                      0B        buildkit.dockerfile.v0
<missing>      3 weeks ago      ENV GPG_KEY=A035C8C19219BA821ECEA86B64E628F8…   0B        buildkit.dockerfile.v0
<missing>      3 weeks ago      RUN /bin/sh -c set -eux;  apt-get update;  a…   4.99MB    buildkit.dockerfile.v0
<missing>      3 weeks ago      ENV LANG=C.UTF-8                                0B        buildkit.dockerfile.v0
<missing>      3 weeks ago      ENV PATH=/usr/local/bin:/usr/local/sbin:/usr…   0B        buildkit.dockerfile.v0
<missing>      3 weeks ago      # debian.sh --arch 'arm64' out/ 'trixie' '@1…   110MB     debuerreotype 0.17
```

```zsh
~/VSCodes/ASKK-25988/Lab2/hello-python % docker images hello-python
                                                                                                      i Info →   U  In Use
IMAGE             ID             DISK USAGE   CONTENT SIZE   EXTRA
hello-python:v1   4a169700acc1        213MB         45.9MB  
```

---

##### Ćwiczenie 1.3 — Obraz z zależnościami

**Opis:** Utworzono obraz aplikacji Flask z 2 prostymi endpointami i zależnościami. Zmieniono port hosta z 5000 na 5001, ponieważ port 5000 jest zarezerwowany dla jednej z usług systemu macOS.

**Użyte polecenia:**

```zsh
docker build -t flask-app:v1 .
docker run -d --name flask-test -p 5001:5000 flask-app:v1
curl http://localhost:5001
curl http://localhost:5001/health
```

**Wynik działania:**

```zsh
~/VSCodes/ASKK-25988/Lab2/hello-python % docker build -t flask-app:v1 .
[+] Building 5.2s (10/10) FINISHED                                                                   docker:desktop-linux
 => [internal] load build definition from Dockerfile                                                                 0.0s
 => => transferring dockerfile: 195B                                                                                 0.0s
 => [internal] load metadata for docker.io/library/python:3.11-slim                                                  0.0s
 => [internal] load .dockerignore                                                                                    0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [1/5] FROM docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea  0.0s
 => => resolve docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea  0.0s
 => [internal] load build context                                                                                    0.0s
 => => transferring context: 662B                                                                                    0.0s
 => CACHED [2/5] WORKDIR /app                                                                                        0.0s
 => [3/5] COPY requirements.txt .                                                                                    0.0s
 => [4/5] RUN pip install --no-cache-dir -r requirements.txt                                                         4.4s
 => [5/5] COPY . .                                                                                                   0.0s 
 => exporting to image                                                                                               0.7s 
 => => exporting layers                                                                                              0.5s 
 => => exporting manifest sha256:bbfffa79f3d303e137627e2c3c73d0868c1f3cfc17fab52a4c57e7fc5601e6c5                    0.0s 
 => => exporting config sha256:21d597f79d2b0f74e73c70b6861907e5c7ab9318194c3770f31879b61140ff69                      0.0s 
 => => exporting attestation manifest sha256:1f54723c4a66090f230a44671d07a34973f4e948fc280f554c7cf9fc5cc2a5bc        0.0s 
 => => exporting manifest list sha256:b5456745e1afab3f003202b6bfbaeeb270625ae733debcb40d4d0ff7ba204075               0.0s
 => => naming to docker.io/library/flask-app:v1                                                                      0.0s
 => => unpacking to docker.io/library/flask-app:v1                                                                   0.1s
```

```zsh
~/VSCodes/ASKK-25988/Lab2/hello-python % docker run -d --name flask-test -p 5001:5000 flask-app:v1
04640b1c0d6628de1a6255d7f3f212542411f8e089a739d32dda13988862aa31
```

```zsh
~/VSCodes/ASKK-25988/Lab2/hello-python % curl http://localhost:5001
<h1>Witaj z kontenera 04640b1c0d66!</h1><p>Flask działa w Dockerze.</p>% 
```

```zsh
~/VSCodes/ASKK-25988/Lab2/hello-python % curl http://localhost:5001/health
{"status":"ok"}
```

**Screenshot:**

![Aplikacja Flask działająca w kontenerze](images/image-1.png)

Rys. 2 - Aplikacja Flask działająca w kontenerze.

---

##### Ćwiczenie 2.1 — WORKDIR, COPY, ADD

**Opis:** Przetestowano tworzenie struktury katalogów w systemie plików obrazu Docker i kopiowanie katalogów (wraz z rozpakowaniem archiwum) między hostem i obrazem.

**Użyte polecenia:**

```zsh
mkdir -p ~/VSCodes/ASKK-25988/Lab2/workdir-test && cd ~/VSCodes/ASKK-25988/Lab2/workdir-test

mkdir -p src config
echo "print('Hello from src')" > src/main.py
echo "DEBUG=true" > config/app.conf
echo "Dane testowe" > data.txt
tar czf archive.tar.gz data.txt

docker build -t workdir-test .
docker run --rm workdir-test
```

**Wynik działania:**

```zsh
~/VSCodes/ASKK-25988/Lab2/hello-python % mkdir -p ~/VSCodes/ASKK-25988/Lab2/workdir-test && cd ~/VSCodes/ASKK-25988/Lab2/workdir-test
~/VSCodes/ASKK-25988/Lab2/workdir-test % 
```

```zsh
~/VSCodes/ASKK-25988/Lab2/workdir-test % mkdir -p src config
echo "print('Hello from src')" > src/main.py
echo "DEBUG=true" > config/app.conf
echo "Dane testowe" > data.txt
tar czf archive.tar.gz data.txt
~/VSCodes/ASKK-25988/Lab2/workdir-test % 
```

```zsh
~/VSCodes/ASKK-25988/Lab2/workdir-test % docker build -t workdir-test .
[+] Building 0.4s (11/11) FINISHED                                                                   docker:desktop-linux
 => [internal] load build definition from Dockerfile                                                                 0.0s
 => => transferring dockerfile: 376B                                                                                 0.0s
 => [internal] load metadata for docker.io/library/python:3.11-slim                                                  0.0s
 => [internal] load .dockerignore                                                                                    0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [1/6] FROM docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea  0.0s
 => => resolve docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea  0.0s
 => [internal] load build context                                                                                    0.0s
 => => transferring context: 343B                                                                                    0.0s
 => CACHED [2/6] WORKDIR /app                                                                                        0.0s
 => [3/6] COPY src/ ./src/                                                                                           0.0s
 => [4/6] COPY config/app.conf ./config/                                                                             0.0s
 => [5/6] ADD archive.tar.gz ./extracted/                                                                            0.0s
 => [6/6] RUN ls -la /app/ && ls -la /app/extracted/                                                                 0.1s
 => exporting to image                                                                                               0.1s
 => => exporting layers                                                                                              0.0s
 => => exporting manifest sha256:e7f4bf5feb645ba82d0488cf4fffe1250c39e3c435c4323c5cfd2ab930c59b37                    0.0s
 => => exporting config sha256:f72877b25c2a4f4e7a8b886b75dc6a64681f0f06e41071bba1ac9db5285c1fa6                      0.0s
 => => exporting attestation manifest sha256:00eabf42068246679fc701fd27e6db77bc00fc3d11256bba3f5f2fdcb05df96d        0.0s
 => => exporting manifest list sha256:2a7bde38b51d34d0ef922b0c748c0d25f5c1754bfdccaf8d033ac8e37b431c84               0.0s
 => => naming to docker.io/library/workdir-test:latest                                                               0.0s
 => => unpacking to docker.io/library/workdir-test:latest                                                            0.0s
```

```zsh
~/VSCodes/ASKK-25988/Lab2/workdir-test % docker run --rm workdir-test
Hello from src
```

---

##### Ćwiczenie 2.2 — ENV i ARG

**Opis:** Stworzono prosty skrypt Python odczytujący wartość zmiennych środowiskowych oraz plik `Dockerfile`, któremu przekazano dodatkowe argumenty do budowania i wartości zmiennych środowiskowych przy jego uruchamianiu. Na koniec porównano wartości zmiennych środowiskowych odczytanych skryptem Python między dwoma wywołaniami polecania `docker run`.

**Użyte polecenia:**

```zsh
mkdir -p ~/VSCodes/ASKK-25988/Lab2/env-test && cd ~/VSCodes/ASKK-25988/Lab2/env-test

# Budowanie z argumentami
docker build --build-arg BUILD_DATE=$(date +%Y-%m-%d) -t env-test:v1 .

# Uruchomienie z domyślnymi ENV
docker run --rm env-test:v1

# Nadpisanie ENV z CLI
docker run --rm -e ENVIRONMENT=development -e DEBUG=true env-test:v1
```

**Wynik działania:**

```zsh
~/VSCodes/ASKK-25988/Lab2/workdir-test % mkdir -p ~/VSCodes/ASKK-25988/Lab2/env-test && cd ~/VSCodes/ASKK-25988/Lab2/env-test
~/VSCodes/ASKK-25988/Lab2/env-test % 
```

```zsh
~/VSCodes/ASKK-25988/Lab2/env-test % docker build --build-arg BUILD_DATE=$(date +%Y-%m-%d) -t env-test:v1 .
[+] Building 0.2s (8/8) FINISHED                                                                     docker:desktop-linux
 => [internal] load build definition from Dockerfile                                                                 0.0s
 => => transferring dockerfile: 412B                                                                                 0.0s
 => [internal] load metadata for docker.io/library/python:3.11-slim                                                  0.0s
 => [internal] load .dockerignore                                                                                    0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [1/3] FROM docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea  0.0s
 => => resolve docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea  0.0s
 => [internal] load build context                                                                                    0.0s
 => => transferring context: 259B                                                                                    0.0s
 => CACHED [2/3] WORKDIR /app                                                                                        0.0s
 => [3/3] COPY app.py .                                                                                              0.0s
 => exporting to image                                                                                               0.1s
 => => exporting layers                                                                                              0.0s
 => => exporting manifest sha256:6c98521b7d34bc91ed109abbb6d635f3d4399af3d95f0bab2493f5e6fc5e92b6                    0.0s
 => => exporting config sha256:94e0d17bc313a8389cd8f8da4cdf329acd9ca7027899488367f73538c5bee9c7                      0.0s
 => => exporting attestation manifest sha256:fb91dfb83769aef5402bfdcfccb450e4bff0fa0a3f4f0d737793be05ad5de409        0.0s
 => => exporting manifest list sha256:ffdd58f6173990e729ac5c0aace0e941888eff68580f987269689a374e1faf9a               0.0s
 => => naming to docker.io/library/env-test:v1                                                                       0.0s
 => => unpacking to docker.io/library/env-test:v1                                                                    0.0s
```

```zsh
~/VSCodes/ASKK-25988/Lab2/env-test % docker run --rm env-test:v1
APP_NAME: Moja Aplikacja
APP_VERSION: 1.0.0
ENVIRONMENT: production
DEBUG: brak
```

```zsh
APP_NAME: Moja Aplikacja
APP_VERSION: 1.0.0
ENVIRONMENT: development
DEBUG: true
```

**Screenshot:**

![Różnica między domyślnymi a nadpisanymi zmiennymi](images/image-2.png)

Rys. 3 - Różnica między domyślnymi a nadpisanymi zmiennymi - inna wartość zmiennej ENVIRONMENT (`production` vs `development`) oraz inna wartość zmiennej DEBUG (`brak` vs `true`).

---

##### Ćwiczenie 2.3 — CMD vs ENTRYPOINT

**Opis:** Porównano polecenia Dockera: CMD i ENTRYPOINT. CMD służy do zdefiniowania domyślnej komendy lub listy argumentów, które można całkowicie nadpisać argumentami podanymi po poleceniu `docker run`. ENTRYPOINT natomiast definiuje główny punkt uruchomieniowy, który ma zostać uruchomiony przez kontener bez możliwości jego nadpisania (o ile jawnie nie zostanie podana flaga `--entrypoint`). Poleceń ENTRYPOINT i CMD często używa się razem - ENTRYPOINT jako główny punkt uruchomieniowy a CMD jako domyślna lista argumentów.

**Użyte polecenia:**

```zsh
mkdir -p ~/VSCodes/ASKK-25988/Lab2/cmd-test && cd ~/VSCodes/ASKK-25988/Lab2/cmd-test

docker build -t greet-cmd .
docker run --rm greet-cmd                    # Cześć, Świat!
docker run --rm greet-cmd echo "nadpisane"   # echo nadpisane (CMD nadpisany!)

docker build -t greet-entry -f Dockerfile.entry .
docker run --rm greet-entry              # Cześć, Świat!
docker run --rm greet-entry "Docker"     # Cześć, Docker!
docker run --rm greet-entry "Student"    # Cześć, Student!
```

**Wynik działania:**

```zsh
~/VSCodes/ASKK-25988/Lab2/env-test % mkdir -p ~/VSCodes/ASKK-25988/Lab2/cmd-test && cd ~/VSCodes/ASKK-25988/Lab2/cmd-test
~/VSCodes/ASKK-25988/Lab2/cmd-test %  
```

```zsh
~/VSCodes/ASKK-25988/Lab2/cmd-test % docker build -t greet-cmd .
docker run --rm greet-cmd                                   
docker run --rm greet-cmd echo "nadpisane"                                 
[+] Building 0.2s (8/8) FINISHED                                                                     docker:desktop-linux
 => [internal] load build definition from Dockerfile                                                                 0.0s
 => => transferring dockerfile: 115B                                                                                 0.0s
 => [internal] load metadata for docker.io/library/python:3.11-slim                                                  0.0s
 => [internal] load .dockerignore                                                                                    0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [1/3] FROM docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea  0.0s
 => => resolve docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea  0.0s
 => [internal] load build context                                                                                    0.0s
 => => transferring context: 127B                                                                                    0.0s
 => CACHED [2/3] WORKDIR /app                                                                                        0.0s
 => [3/3] COPY greet.py .                                                                                            0.0s
 => exporting to image                                                                                               0.1s
 => => exporting layers                                                                                              0.0s
 => => exporting manifest sha256:1a117b99ad0ac4aef1955bcc7a6e496b326f59b78e50aab3d759a9fadcbfb8f5                    0.0s
 => => exporting config sha256:56774a427cf2659cf5f7ab3c882f01a3e13ed5c1a5c5923661c99282dec86439                      0.0s
 => => exporting attestation manifest sha256:029d7872a82adfca0ab3a85f3bc84f6c1759f3a0780d6305c0e7dc1ced2b7a50        0.0s
 => => exporting manifest list sha256:0c9b68a3d21c438599829f02fa43805b9cb8e7e004c0b1563047dea7e9ace310               0.0s
 => => naming to docker.io/library/greet-cmd:latest                                                                  0.0s
 => => unpacking to docker.io/library/greet-cmd:latest                                                               0.0s
Cześć, Świat!
nadpisane
```

```zsh
~/VSCodes/ASKK-25988/Lab2/cmd-test % docker build -t greet-entry -f Dockerfile.entry .
docker run --rm greet-entry                             
docker run --rm greet-entry "Docker"                     
docker run --rm greet-entry "Student"                     
[+] Building 0.1s (8/8) FINISHED                                                                     docker:desktop-linux
 => [internal] load build definition from Dockerfile.entry                                                           0.0s
 => => transferring dockerfile: 143B                                                                                 0.0s
 => [internal] load metadata for docker.io/library/python:3.11-slim                                                  0.0s
 => [internal] load .dockerignore                                                                                    0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [1/3] FROM docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea  0.0s
 => => resolve docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea  0.0s
 => [internal] load build context                                                                                    0.0s
 => => transferring context: 29B                                                                                     0.0s
 => CACHED [2/3] WORKDIR /app                                                                                        0.0s
 => CACHED [3/3] COPY greet.py .                                                                                     0.0s
 => exporting to image                                                                                               0.1s
 => => exporting layers                                                                                              0.0s
 => => exporting manifest sha256:f88b4d9bcc6ed0b0759c3ecc8a04a044c4b1d2c87c260a6c5ca950848efc35bc                    0.0s
 => => exporting config sha256:d0ff671c37393196c7ce08c3900dbe6392e943b1c9a7043607c2020176324ed3                      0.0s
 => => exporting attestation manifest sha256:efecac3209346ab05db60b02893dd45fe27ee31ee9b65701a59f1449814d9a36        0.0s
 => => exporting manifest list sha256:d3fea53eef1462e09d98dc80df9f7f1102fb79bf41bfa116314347521e13a51b               0.0s
 => => naming to docker.io/library/greet-entry:latest                                                                0.0s
 => => unpacking to docker.io/library/greet-entry:latest                                                             0.0s
Cześć, Świat!
Cześć, Docker!
Cześć, Student!
```

**Screenshot:**

![Porównanie zachowania CMD vs ENTRYPOINT](images/image-3.png)

Rys. 4 - Porównanie zachowania CMD vs ENTRYPOINT (nadpisanie domyślnego polecenia vs przekazanie dodatkowych argumentów).

---

##### Ćwiczenie 2.4 — USER — użytkownik nie-root

**Opis:** Utworzono użytkownika i grupę w obrazie Docker i uruchomiono kontener jako nowo utworzony użytkownik. Porównano takie uruchomienie kontenera z uruchomieniem oryginalnego obrazu Python - w 1 przypadku kontener uruchomił się jako użytkownik `appuser`, natomiast w 2 jako `root`.

**Użyte polecenia:**

```zsh
mkdir -p ~/VSCodes/ASKK-25988/Lab2/user-test && cd ~/VSCodes/ASKK-25988/Lab2/user-test

echo "" > app.py
docker build -t user-test .
docker run --rm user-test
# Porównaj z:
docker run --rm python:3.11-slim python -c "import os; print(f'UID: {os.getuid()}')"
```

**Wynik działania:**

```zsh
~/VSCodes/ASKK-25988/Lab2/cmd-test % mkdir -p ~/VSCodes/ASKK-25988/Lab2/user-test && cd ~/VSCodes/ASKK-25988/Lab2/user-test
~/VSCodes/ASKK-25988/Lab2/user-test %
```

```zsh
~/VSCodes/ASKK-25988/Lab2/user-test % echo "" > app.py
docker build -t user-test .
docker run --rm user-test
[+] Building 0.4s (9/9) FINISHED                                                                     docker:desktop-linux
 => [internal] load build definition from Dockerfile                                                                 0.0s
 => => transferring dockerfile: 354B                                                                                 0.0s
 => [internal] load metadata for docker.io/library/python:3.11-slim                                                  0.0s
 => [internal] load .dockerignore                                                                                    0.0s
 => => transferring context: 2B                                                                                      0.0s
 => CACHED [1/4] FROM docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e57  0.0s
 => => resolve docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea  0.0s
 => [internal] load build context                                                                                    0.0s
 => => transferring context: 34B                                                                                     0.0s
 => [2/4] RUN groupadd -r appuser && useradd -r -g appuser -d /app appuser                                           0.1s
 => [3/4] WORKDIR /app                                                                                               0.0s
 => [4/4] COPY --chown=appuser:appuser app.py .                                                                      0.0s
 => exporting to image                                                                                               0.1s
 => => exporting layers                                                                                              0.0s
 => => exporting manifest sha256:51d0c56209bc0e1806f76bd1b5ac9000ec4eff4d8c0bb6e93a858809b1861f7b                    0.0s
 => => exporting config sha256:a3c2eb71715addd73f8b83846a4cfb6ec6cc0c0047b7ff90fca0a8888c1dfd2e                      0.0s
 => => exporting attestation manifest sha256:fd5456c9bdf1c1a9844f7e7089b25a5f2955cc3146ee83d254b34bf594e1c095        0.0s
 => => exporting manifest list sha256:2d4c57bd17f8ec52c15d9634686b9367f1db9476f697e8e0f0d45cbdbb01b727               0.0s
 => => naming to docker.io/library/user-test:latest                                                                  0.0s
 => => unpacking to docker.io/library/user-test:latest                                                               0.0s
UID: 999, User: appuser
```

```zsh
~/VSCodes/ASKK-25988/Lab2/user-test % docker run --rm python:3.11-slim python -c "import os; print(f'UID: {os.getuid()}')" 
UID: 0
```

---

##### Ćwiczenie 3.1 — Wpływ .dockerignore

**Opis:** Utworzono prostą strukturę katalogów wraz z plikiem `Dockerfile` i porównano wpływ pliku `.dockerignore` na rozmiar kontekstu.

**Użyte polecenia:**

```zsh
mkdir -p ~/VSCodes/ASKK-25988/Lab2/ignore-test && cd ~/VSCodes/ASKK-25988/Lab2/ignore-test

# Utwórz pliki
echo "print('app')" > app.py
mkdir -p node_modules .git __pycache__
dd if=/dev/zero of=node_modules/big-file bs=1M count=50 2>/dev/null
echo "secret" > .env

docker build -t ignore-test:without .
# Zwróć uwagę na "Sending build context to docker daemon"

docker build -t ignore-test:with .
# Porównaj rozmiar kontekstu
```

**Wynik działania:**

```zsh
~/VSCodes/ASKK-25988/Lab2/user-test % mkdir -p ~/VSCodes/ASKK-25988/Lab2/ignore-test && cd ~/VSCodes/ASKK-25988/Lab2/ignore-test
~/VSCodes/ASKK-25988/Lab2/ignore-test % 
```

```zsh
~/VSCodes/ASKK-25988/Lab2/ignore-test % echo "print('app')" > app.py
mkdir -p node_modules .git __pycache__
dd if=/dev/zero of=node_modules/big-file bs=1M count=50 2>/dev/null
echo "secret" > .env
~/VSCodes/ASKK-25988/Lab2/ignore-test % 
```

```zsh
~/VSCodes/ASKK-25988/Lab2/ignore-test % docker build -t ignore-test:without .
[+] Building 0.2s (8/8) FINISHED                                                                     docker:desktop-linux
 => [internal] load build definition from Dockerfile                                                                 0.0s
 => => transferring dockerfile: 111B                                                                                 0.0s
 => [internal] load metadata for docker.io/library/python:3.11-slim                                                  0.0s
 => [internal] load .dockerignore                                                                                    0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [1/3] FROM docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea  0.0s
 => => resolve docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea  0.0s
 => [internal] load build context                                                                                    0.0s
 => => transferring context: 46B                                                                                     0.0s
 => [2/3] WORKDIR /app                                                                                               0.0s
 => [3/3] COPY app.py .                                                                                              0.0s
 => exporting to image                                                                                               0.1s
 => => exporting layers                                                                                              0.0s
 => => exporting manifest sha256:757a436f35aa9158f6d32cf6be7c607b3b7ab75fee273a8fff4f4053596782b0                    0.0s
 => => exporting config sha256:b2f47150ef83be2d60160592e676352df26f9bc316f151124dfe32cba2b0f86d                      0.0s
 => => exporting attestation manifest sha256:4541808378e8d53185558f5db82f026ef3105ad2a0535162894257da2bbe854e        0.0s
 => => exporting manifest list sha256:2b699f8886b812916ae9b0dd220caffe36542fc0e161e7be2c53a26921fff9a9               0.0s
 => => naming to docker.io/library/ignore-test:without                                                               0.0s
 => => unpacking to docker.io/library/ignore-test:without                                                            0.0s
```

```zsh
~/VSCodes/ASKK-25988/Lab2/ignore-test % docker build -t ignore-test:with .
[+] Building 0.1s (8/8) FINISHED                                                                     docker:desktop-linux
 => [internal] load build definition from Dockerfile                                                                 0.0s
 => => transferring dockerfile: 111B                                                                                 0.0s
 => [internal] load metadata for docker.io/library/python:3.11-slim                                                  0.0s
 => [internal] load .dockerignore                                                                                    0.0s
 => => transferring context: 95B                                                                                     0.0s
 => [1/3] FROM docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea  0.0s
 => => resolve docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea  0.0s
 => [internal] load build context                                                                                    0.0s
 => => transferring context: 27B                                                                                     0.0s
 => CACHED [2/3] WORKDIR /app                                                                                        0.0s
 => CACHED [3/3] COPY app.py .                                                                                       0.0s
 => exporting to image                                                                                               0.0s
 => => exporting layers                                                                                              0.0s
 => => exporting manifest sha256:757a436f35aa9158f6d32cf6be7c607b3b7ab75fee273a8fff4f4053596782b0                    0.0s
 => => exporting config sha256:b2f47150ef83be2d60160592e676352df26f9bc316f151124dfe32cba2b0f86d                      0.0s
 => => exporting attestation manifest sha256:d8543695546ce2c62a7f2d885e092547d16b868df5b2d6e76b759797e7dca2bb        0.0s
 => => exporting manifest list sha256:c2d987908879352dfed40723b9e683d844ee40386f79f449066e92a781d651bd               0.0s
 => => naming to docker.io/library/ignore-test:with                                                                  0.0s
 => => unpacking to docker.io/library/ignore-test:with                                                               0.0s
```

**Screenshot:**

![Porównanie rozmiaru kontekstu z i bez .dockerignore](images/image-4.png)

Rys. 5 - Porównanie rozmiaru kontekstu z i bez `.dockerignore` - bez pliku `.dockerignore` `transferring context` zaraz po wczytaniu pliku `.dockerignore` ma wartość 2B a po dodaniu pliku `.dockerignore` 95B, natomiast kontekst samego buildu w 1 przypadku ma 46MB a w drugim jest mniejszy i wynosi 27B.

---

##### Ćwiczenie 4.1 — Multi-stage dla aplikacji Go

**Opis:** Stworzono prosty serwer HTTP za pomocą języka Go i porównano rozmiar obrazu dla single- i multi-stage buildów.

**Użyte polecenia:**

```zsh
mkdir -p ~/VSCodes/ASKK-25988/Lab2/go-multistage && cd ~/VSCodes/ASKK-25988/Lab2/go-multistage

docker build -t go-app:single -f Dockerfile.single .
docker build -t go-app:multi -f Dockerfile.multi .

# Porównaj rozmiary!
docker images go-app
```

**Wynik działania:**

```zsh
~/VSCodes/ASKK-25988/Lab2/ignore-test % mkdir -p ~/VSCodes/ASKK-25988/Lab2/go-multistage && cd ~/VSCodes/ASKK-25988/Lab2/go-multistage
~/VSCodes/ASKK-25988/Lab2/go-multistage % 
```

```zsh
~/VSCodes/ASKK-25988/Lab2/go-multistage % docker build -t go-app:single -f Dockerfile.single .
[+] Building 40.1s (9/9) FINISHED                                                                    docker:desktop-linux
 => [internal] load build definition from Dockerfile.single                                                          0.0s
 => => transferring dockerfile: 137B                                                                                 0.0s
 => [internal] load metadata for docker.io/library/golang:1.22                                                       2.1s
 => [internal] load .dockerignore                                                                                    0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [1/4] FROM docker.io/library/golang:1.22@sha256:1cf6c45ba39db9fd6db16922041d074a63c935556a05c5ccb62d181034df7f  31.3s
 => => resolve docker.io/library/golang:1.22@sha256:1cf6c45ba39db9fd6db16922041d074a63c935556a05c5ccb62d181034df7f0  0.0s
 => => sha256:57dbbf9ce594cc754a73fd4187ffcab90bc86d0666530017aa2cd0361f85d84c 126B / 126B                           0.2s
 => => sha256:90fc70e12d60da9fe07466871c454610a4e5c1031087182e69b164f64aacd1c4 66.29MB / 66.29MB                    26.7s
 => => sha256:5ac3f7121b9240f61d416dba8be2c96da4ffe9fe1f25831725071946bb7fc54f 86.38MB / 86.38MB                    28.8s
 => => sha256:c9d3572a68af0b860060b7ea84adfa8406fa20cfd1337c947dfb661aa965eee7 64.36MB / 64.36MB                    23.7s
 => => sha256:193c44006e77abbadfdd7be72b4ab6d7a5c08640ef575970f722b798ee7800ac 23.60MB / 23.60MB                    10.1s
 => => sha256:106abeaee908db66722312b3379ae398e2bcc5b2fdad0cc248509efa14a819ff 48.31MB / 48.31MB                     9.3s
 => => extracting sha256:106abeaee908db66722312b3379ae398e2bcc5b2fdad0cc248509efa14a819ff                            0.6s
 => => extracting sha256:193c44006e77abbadfdd7be72b4ab6d7a5c08640ef575970f722b798ee7800ac                            0.2s
 => => extracting sha256:c9d3572a68af0b860060b7ea84adfa8406fa20cfd1337c947dfb661aa965eee7                            0.8s
 => => extracting sha256:5ac3f7121b9240f61d416dba8be2c96da4ffe9fe1f25831725071946bb7fc54f                            0.9s
 => => extracting sha256:90fc70e12d60da9fe07466871c454610a4e5c1031087182e69b164f64aacd1c4                            1.5s
 => => extracting sha256:57dbbf9ce594cc754a73fd4187ffcab90bc86d0666530017aa2cd0361f85d84c                            0.0s
 => => extracting sha256:4f4fb700ef54461cfa02571ae0db9a0dc1e0cdb5577484a6d75e68dc38e8acc1                            0.0s
 => [internal] load build context                                                                                    0.0s
 => => transferring context: 829B                                                                                    0.0s
 => [2/4] WORKDIR /app                                                                                               0.6s
 => [3/4] COPY . .                                                                                                   0.0s
 => [4/4] RUN go build -o server .                                                                                   4.1s
 => exporting to image                                                                                               1.8s
 => => exporting layers                                                                                              1.5s
 => => exporting manifest sha256:9a7db2086b9e207e5f1cd58bf7a01566d57c9d345fc6b65ea84ea11557408de3                    0.0s
 => => exporting config sha256:c1ef7477af7cbfcd7b7faa6529e88a1e1d884a5f0dc1944a16f00bdade754192                      0.0s
 => => exporting attestation manifest sha256:db626a6a5b297f2c27f09f64d4366085f0f82ec6e5035a6d7240913152e81298        0.0s
 => => exporting manifest list sha256:538cd2b569c5cd677db8dee05bc5535f280b3d539189dbf20fc3fa6c8165fe37               0.0s
 => => naming to docker.io/library/go-app:single                                                                     0.0s
 => => unpacking to docker.io/library/go-app:single                                                                  0.2s
```

```zsh
~/VSCodes/ASKK-25988/Lab2/go-multistage % docker build -t go-app:multi -f Dockerfile.multi .
[+] Building 5.0s (11/11) FINISHED                                                                   docker:desktop-linux
 => [internal] load build definition from Dockerfile.multi                                                           0.0s
 => => transferring dockerfile: 286B                                                                                 0.0s
 => [internal] load metadata for docker.io/library/golang:1.22                                                       0.6s
 => [internal] load .dockerignore                                                                                    0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [builder 1/5] FROM docker.io/library/golang:1.22@sha256:1cf6c45ba39db9fd6db16922041d074a63c935556a05c5ccb62d181  0.0s
 => => resolve docker.io/library/golang:1.22@sha256:1cf6c45ba39db9fd6db16922041d074a63c935556a05c5ccb62d181034df7f0  0.0s
 => [internal] load build context                                                                                    0.0s
 => => transferring context: 54B                                                                                     0.0s
 => CACHED [builder 2/5] WORKDIR /app                                                                                0.0s
 => [builder 3/5] COPY go.mod .                                                                                      0.1s
 => [builder 4/5] COPY main.go .                                                                                     0.0s
 => [builder 5/5] RUN CGO_ENABLED=0 GOOS=linux go build -o server .                                                  3.9s
 => [stage-1 1/1] COPY --from=builder /app/server /server                                                            0.0s
 => exporting to image                                                                                               0.3s
 => => exporting layers                                                                                              0.2s
 => => exporting manifest sha256:3c86746c58cd91be56f18f193b1376be4214110ef12da3c1dbe4895b8528730c                    0.0s
 => => exporting config sha256:f50f6d956878e70839af3047ddd619ed10569132982483d10c15cefbc1ecc8b6                      0.0s
 => => exporting attestation manifest sha256:ff7e7a837dd3e4b4eccc8a4c2222fabf3524c32f8cf6210dfd9ed351a891fc20        0.0s
 => => exporting manifest list sha256:dea0ad62fc9af0fbbddc561ae2ba989218a2b8e8a675302f972560245d02364e               0.0s
 => => naming to docker.io/library/go-app:multi                                                                      0.0s
 => => unpacking to docker.io/library/go-app:multi                                                                   0.0s
```

```zsh
~/VSCodes/ASKK-25988/Lab2/go-multistage % docker images go-app
                                                                                                      i Info →   U  In Use
IMAGE           ID             DISK USAGE   CONTENT SIZE   EXTRA
go-app:multi    dea0ad62fc9a       10.5MB         3.79MB        
go-app:single   538cd2b569c5        1.3GB          308MB        
```

**Screenshot:**

![Porównanie rozmiarów obrazów single vs multi-stage](images/image-5.png)

Rys. 6 - Porównanie rozmiarów obrazów single vs multi-stage. Widoczny ogromny wpływ buildów multi-stage na rozmiar obrazu - zmniejszył się on o ponad 1GB.

---

##### Ćwiczenie 4.2 — Multi-stage dla Node.js

**Opis:** Stworzono plik `Dockerfile` z multi-stage buildem dla aplikacji Node.js i sprawdzono, czy aplikacja została prawidłowo uruchomiona.

**Użyte polecenia:**

```zsh
mkdir -p ~/VSCodes/ASKK-25988/Lab2/node-multistage && cd ~/VSCodes/ASKK-25988/Lab2/node-multistage

npm install

docker build -t node-app:v1 .
docker run -d --name node-test -p 3000:3000 node-app:v1
curl http://localhost:3000
```

**Wynik działania:**

```zsh
~/VSCodes/ASKK-25988/Lab2/go-multistage % mkdir -p ~/VSCodes/ASKK-25988/Lab2/node-multistage && cd ~/VSCodes/ASKK-25988/Lab2/node-multistage
~/VSCodes/ASKK-25988/Lab2/node-multistage % 
```

```zsh
~/VSCodes/ASKK-25988/Lab2/node-multistage % npm install

added 68 packages, and audited 69 packages in 4s

18 packages are looking for funding
  run `npm fund` for details

found 0 vulnerabilities
```

```zsh
~/VSCodes/ASKK-25988/Lab2/node-multistage % docker build -t node-app:v1 .
[+] Building 2.8s (13/13) FINISHED                                                                   docker:desktop-linux
 => [internal] load build definition from Dockerfile                                                                 0.0s
 => => transferring dockerfile: 385B                                                                                 0.0s
 => [internal] load metadata for docker.io/library/node:20-alpine                                                    1.1s
 => [internal] load .dockerignore                                                                                    0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [internal] load build context                                                                                    0.1s
 => => transferring context: 2.47MB                                                                                  0.1s
 => [builder 1/4] FROM docker.io/library/node:20-alpine@sha256:fb4cd12c85ee03686f6af5362a0b0d56d50c58a04632e6c0fb83  0.0s
 => => resolve docker.io/library/node:20-alpine@sha256:fb4cd12c85ee03686f6af5362a0b0d56d50c58a04632e6c0fb8363f60937  0.0s
 => CACHED [stage-1 2/5] RUN addgroup -S app && adduser -S -G app app                                                0.0s
 => CACHED [stage-1 3/5] WORKDIR /app                                                                                0.0s
 => CACHED [builder 2/4] WORKDIR /app                                                                                0.0s
 => [builder 3/4] COPY package*.json ./                                                                              0.0s
 => [builder 4/4] RUN npm ci --omit=dev                                                                              1.1s
 => [stage-1 4/5] COPY --from=builder /app/node_modules ./node_modules                                               0.0s
 => [stage-1 5/5] COPY --chown=app:app . .                                                                           0.1s
 => exporting to image                                                                                               0.2s 
 => => exporting layers                                                                                              0.1s
 => => exporting manifest sha256:cfbb78af3c5ba7ce5f65016ffd9841412b2a88400ca97f8f7f355f4d5e47fdfa                    0.0s
 => => exporting config sha256:e47ff7d850f915d2ff6c02d8000672460559b4e38e57cadccc64882194b47dd9                      0.0s
 => => exporting attestation manifest sha256:f89c34978d84273077e2f63967f18e90d43b33754c5767a3e0099eddff72597b        0.0s
 => => exporting manifest list sha256:f87d36f027e0b7572632ce2bfcf37ecf8e0e5ef76145dc3f0e7a788567ff82ef               0.0s
 => => naming to docker.io/library/node-app:v1                                                                       0.0s
 => => unpacking to docker.io/library/node-app:v1                                                                    0.1s
```

```zsh
~/VSCodes/ASKK-25988/Lab2/node-multistage % docker run -d --name node-test -p 3000:3000 node-app:v1
2a68c66b8609dae9767612315e586582a1649e544b29445abde8053956daf8ba
```

```zsh
~/VSCodes/ASKK-25988/Lab2/node-multistage % curl http://localhost:3000
Hello from Node.js v20.20.2!%     
```

---

##### Ćwiczenie 5.1 — Kolejność instrukcji

**Opis:** Sprawdzono wpływ cachowania na szybkość budowania obrazów Dockera i zaobserwowano znaczne skrócenie czasu budowania. Problemem pierwszego pliku `Dockerfile` (`Dockerfile.bad`) było to, że kopiował on jednocześnie wszystkie pliki hosta, łącznie z plikiem z zależnościami (`requirements.txt`), przez co Docker nie był w stanie wykryć czy nastąpiły zmiany w pliku z zależnościami. W prawidłowym pliku `Dockerfile.good` rozdzielono proces kopiowania zależności od kopiowania reszty plików, dzięki czemu Docker mógł wykryć, że nie nastąpiły żadne zmiany w pliku z zależnościami, skorzystać ze zcachowanego wyniku polecenia i całkowicie pominąć proces instalacji zależności.

**Użyte polecenia:**

```zsh
mkdir -p ~/VSCodes/ASKK-25988/Lab2/cache-test && cd ~/VSCodes/ASKK-25988/Lab2/cache-test

# Zbuduj oba warianty
docker build -t cache-bad -f Dockerfile.bad .
docker build -t cache-good -f Dockerfile.good .

# Zmień app.py (np. "Wersja 2")
sed -i "" 's/Wersja 1/Wersja 2/' app.py

# Przebuduj — obserwuj użycie cache
docker build -t cache-bad:v2 -f Dockerfile.bad .
docker build -t cache-good:v2 -f Dockerfile.good .
```

**Wynik działania:**

```zsh
~/VSCodes/ASKK-25988/Lab2/node-multistage % mkdir -p ~/VSCodes/ASKK-25988/Lab2/cache-test && cd ~/VSCodes/ASKK-25988/Lab2/cache-test
~/VSCodes/ASKK-25988/Lab2/cache-test % 
```

```zsh
~/VSCodes/ASKK-25988/Lab2/cache-test % docker build -t cache-bad -f Dockerfile.bad .
[+] Building 4.3s (9/9) FINISHED                                                                     docker:desktop-linux
 => [internal] load build definition from Dockerfile.bad                                                             0.0s
 => => transferring dockerfile: 161B                                                                                 0.0s
 => [internal] load metadata for docker.io/library/python:3.11-slim                                                  0.0s
 => [internal] load .dockerignore                                                                                    0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [1/4] FROM docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea  0.0s
 => => resolve docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea  0.0s
 => [internal] load build context                                                                                    0.0s
 => => transferring context: 615B                                                                                    0.0s
 => CACHED [2/4] WORKDIR /app                                                                                        0.0s
 => [3/4] COPY . .                                                                                                   0.0s
 => [4/4] RUN pip install --no-cache-dir -r requirements.txt                                                         3.5s
 => exporting to image                                                                                               0.6s
 => => exporting layers                                                                                              0.5s
 => => exporting manifest sha256:3656773a28a13492b31497f475b792950419b85038ca9d23fd94b9ab9efcd47e                    0.0s 
 => => exporting config sha256:e1a05d1810705b5d6752e39d6d6f316852141aabede43916a88a7f07294fd9a4                      0.0s 
 => => exporting attestation manifest sha256:4df508b709ba0b990ca3e1a71f103d2d20d8444f0d708344476b21732ebe663a        0.0s 
 => => exporting manifest list sha256:0fcad8372c934c88b6320f6523cf87b96730d87e0ce9a4dffe412fa295e0649f               0.0s 
 => => naming to docker.io/library/cache-bad:latest                                                                  0.0s
 => => unpacking to docker.io/library/cache-bad:latest                                                               0.1s
```

```zsh
~/VSCodes/ASKK-25988/Lab2/cache-test % docker build -t cache-good -f Dockerfile.good .
[+] Building 3.9s (10/10) FINISHED                                                                   docker:desktop-linux
 => [internal] load build definition from Dockerfile.good                                                            0.0s
 => => transferring dockerfile: 188B                                                                                 0.0s
 => [internal] load metadata for docker.io/library/python:3.11-slim                                                  0.0s
 => [internal] load .dockerignore                                                                                    0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [1/5] FROM docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea  0.0s
 => => resolve docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea  0.0s
 => [internal] load build context                                                                                    0.0s
 => => transferring context: 131B                                                                                    0.0s
 => CACHED [2/5] WORKDIR /app                                                                                        0.0s
 => [3/5] COPY requirements.txt .                                                                                    0.0s
 => [4/5] RUN pip install --no-cache-dir -r requirements.txt                                                         3.2s
 => [5/5] COPY . .                                                                                                   0.0s
 => exporting to image                                                                                               0.6s
 => => exporting layers                                                                                              0.4s
 => => exporting manifest sha256:0212dc5ecac9e9843c7cc9b045f7f5baaed2ccf133324f5e1c4dffd5c911e9cb                    0.0s 
 => => exporting config sha256:e276e6e1080565281a80fc4dbd856fd45db0bdac3da01a88d238d2bc3a19639d                      0.0s 
 => => exporting attestation manifest sha256:435251152159686d753ff4d73d80c04f1370172b5dfb5658ef0e9e853f34a5b7        0.0s 
 => => exporting manifest list sha256:75d2c18f62768c3802bbaebbb0baf457b9500266442360fffa682923f514c747               0.0s
 => => naming to docker.io/library/cache-good:latest                                                                 0.0s
 => => unpacking to docker.io/library/cache-good:latest                                                              0.1s
```

```zsh
~/VSCodes/ASKK-25988/Lab2/cache-test % sed -i "" 's/Wersja 1/Wersja 2/' app.py
~/VSCodes/ASKK-25988/Lab2/cache-test %
```

```zsh
~/VSCodes/ASKK-25988/Lab2/cache-test % docker build -t cache-bad:v2 -f Dockerfile.bad .
[+] Building 3.8s (9/9) FINISHED                                                                     docker:desktop-linux
 => [internal] load build definition from Dockerfile.bad                                                             0.0s
 => => transferring dockerfile: 161B                                                                                 0.0s
 => [internal] load metadata for docker.io/library/python:3.11-slim                                                  0.1s
 => [internal] load .dockerignore                                                                                    0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [1/4] FROM docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea  0.0s
 => => resolve docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea  0.0s
 => [internal] load build context                                                                                    0.0s
 => => transferring context: 311B                                                                                    0.0s
 => CACHED [2/4] WORKDIR /app                                                                                        0.0s
 => [3/4] COPY . .                                                                                                   0.0s
 => [4/4] RUN pip install --no-cache-dir -r requirements.txt                                                         3.0s
 => exporting to image                                                                                               0.6s
 => => exporting layers                                                                                              0.5s
 => => exporting manifest sha256:80287a21dd59be0f97979abb54b467323a5ff05b5bc1b4b86513abe31c6a79aa                    0.0s 
 => => exporting config sha256:3e38db0a383fa27cde5db131b6904c90aabb607d44b534a8e003761751350a45                      0.0s 
 => => exporting attestation manifest sha256:1b301ef56ea3de52d4f92651d106f056e7d4909e778f7ed5824051a2d84a5a14        0.0s 
 => => exporting manifest list sha256:749d3a07ab0cbf2b6a64e1e6293e4d9225094ba8965dcdce2f7d9137b7bf7c24               0.0s 
 => => naming to docker.io/library/cache-bad:v2                                                                      0.0s
 => => unpacking to docker.io/library/cache-bad:v2                                                                   0.1s
```

```zsh
~/VSCodes/ASKK-25988/Lab2/cache-test % docker build -t cache-good:v2 -f Dockerfile.good .
[+] Building 0.2s (10/10) FINISHED                                                                   docker:desktop-linux
 => [internal] load build definition from Dockerfile.good                                                            0.0s
 => => transferring dockerfile: 188B                                                                                 0.0s
 => [internal] load metadata for docker.io/library/python:3.11-slim                                                  0.0s
 => [internal] load .dockerignore                                                                                    0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [1/5] FROM docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea  0.0s
 => => resolve docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea  0.0s
 => [internal] load build context                                                                                    0.0s
 => => transferring context: 131B                                                                                    0.0s
 => CACHED [2/5] WORKDIR /app                                                                                        0.0s
 => CACHED [3/5] COPY requirements.txt .                                                                             0.0s
 => CACHED [4/5] RUN pip install --no-cache-dir -r requirements.txt                                                  0.0s
 => [5/5] COPY . .                                                                                                   0.0s
 => exporting to image                                                                                               0.1s
 => => exporting layers                                                                                              0.0s
 => => exporting manifest sha256:6424dbd7882d0c5fd58d38007e017cae236875d8b6eec6bf6296c3cda53a48d2                    0.0s
 => => exporting config sha256:5c1350efcf39f9500230ea3a90f624880187128e62b3b3c9ba8885d34c129c93                      0.0s
 => => exporting attestation manifest sha256:6a46dc8d558b718486f14ef0dc8a26bf2f798939665ac5eb4d3583204dddf56d        0.0s
 => => exporting manifest list sha256:c8a953f4f7c3a8d2a0e2671cef543085119c1ab1a851bcddfa6be514feacba53               0.0s
 => => naming to docker.io/library/cache-good:v2                                                                     0.0s
 => => unpacking to docker.io/library/cache-good:v2                                                                  0.0s
```

**Screenshot:**

![Porównanie użycia cache (CACHED vs brak)](images/image-6.png)

Rys. 7 - Porównanie użycia cache (CACHED vs brak) - cache znacznie przyspieszył proces budowania a nawet całkowicie pominął etap instalacji wcześniej zainstalowanych zależności.

---

##### Ćwiczenie 6.1 — Healthcheck

**Opis:** Uruchomiono kontener z aplikacją Flask wraz z healthcheckiem.

**Użyte polecenia:**

```zsh
mkdir -p ~/VSCodes/ASKK-25988/Lab2/health-test && cd ~/VSCodes/ASKK-25988/Lab2/health-test

docker build -t health-test .
docker run -d --name health-app -p 5001:5000 health-test

# Obserwuj status zdrowia
docker ps  # kolumna STATUS pokaże (health: starting) → (healthy)

# Po chwili:
docker inspect --format='{{.State.Health.Status}}' health-app
```

**Wynik działania:**

```zsh
~/VSCodes/ASKK-25988/Lab2/cache-test % mkdir -p ~/VSCodes/ASKK-25988/Lab2/health-test && cd ~/VSCodes/ASKK-25988/Lab2/health-test
~/VSCodes/ASKK-25988/Lab2/health-test % 
```

```zsh
~/VSCodes/ASKK-25988/Lab2/health-test % docker build -t health-test .
[+] Building 4.1s (9/9) FINISHED                                                                     docker:desktop-linux
 => [internal] load build definition from Dockerfile                                                                 0.0s
 => => transferring dockerfile: 351B                                                                                 0.0s
 => [internal] load metadata for docker.io/library/python:3.11-slim                                                  0.0s
 => [internal] load .dockerignore                                                                                    0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [1/4] FROM docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea  0.0s
 => => resolve docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea  0.0s
 => [internal] load build context                                                                                    0.0s
 => => transferring context: 273B                                                                                    0.0s
 => CACHED [2/4] WORKDIR /app                                                                                        0.0s
 => [3/4] RUN pip install --no-cache-dir flask==3.0.0                                                                3.4s
 => [4/4] COPY app.py .                                                                                              0.0s
 => exporting to image                                                                                               0.6s 
 => => exporting layers                                                                                              0.4s 
 => => exporting manifest sha256:9a9ea2337a37a91db3f6427f15cdf66db3b19b6e89400f0e4b24138db339cba3                    0.0s 
 => => exporting config sha256:29b66054c018f59e05d463f16a9f50eaed2c04769413c209f2de3795b2bde347                      0.0s 
 => => exporting attestation manifest sha256:adf1a5b552658ed8fbb7eeabe613d4f2573617c888fac502bff309146bafd442        0.0s 
 => => exporting manifest list sha256:2d1e6ac7caddcc1172c4d283770ff6614a6b18de9af0af7f690e36913324f48e               0.0s
 => => naming to docker.io/library/health-test:latest                                                                0.0s
 => => unpacking to docker.io/library/health-test:latest                                                             0.1s
```

```zsh
~/VSCodes/ASKK-25988/Lab2/health-test % docker run -d --name health-app -p 5001:5000 health-test
de8ef3af532df8ed7adce78716a08356fef657d5862d3accc4a7fbb18bb978fd
```

```zsh
~/VSCodes/ASKK-25988/Lab2/health-test % docker ps                                                        
CONTAINER ID   IMAGE         COMMAND           CREATED          STATUS                    PORTS                                         NAMES
de8ef3af532d   health-test   "python app.py"   47 seconds ago   Up 46 seconds (healthy)   0.0.0.0:5001->5000/tcp, [::]:5001->5000/tcp   health-app
```

```zsh
~/VSCodes/ASKK-25988/Lab2/health-test % docker inspect --format='{{.State.Health.Status}}' health-app
healthy
```

**Screenshot:**

![Kontener ze statusem healthy](images/image-7.png)

Rys. 8 - Kontener ze statusem `healthy`.

---

##### Ćwiczenie 7.1 — Tagowanie i push

**Opis:** Utworzono i otagowano obraz na podstawie `Dockerfile` z ćwiczenia 1.3, wrzucono go na Docker Hub i pobrano go.

**Użyte polecenia:**

```zsh
# Zaloguj się do Docker Hub
docker login

# Zbuduj obraz z tagiem
docker build -t flask-app:v1 ~/VSCodes/ASKK-25988/Lab2/hello-python/

# Otaguj dla Docker Hub (zamień USERNAME na swoje)
docker tag flask-app:v1 mewosh/flask-app:v1
docker tag flask-app:v1 mewosh/flask-app:latest

# Wyślij na Docker Hub
docker push mewosh/flask-app:v1
docker push mewosh/flask-app:latest

# Usuń lokalne obrazy
docker rmi mewosh/flask-app:v1 mewosh/flask-app:latest

# Pobierz z Docker Hub
docker pull mewosh/flask-app:v1
docker run --rm mewosh/flask-app:v1
```

**Wynik działania:**

```zsh
~/VSCodes/ASKK-25988/Lab2/health-test % docker login

USING WEB-BASED LOGIN

i Info → To sign in with credentials on the command line, use 'docker login -u <username>'
         

Your one-time device confirmation code is: XXXX-XXXX
Press ENTER to open your browser or submit your device code here: https://login.docker.com/activate

Waiting for authentication in the browser…
Login Succeeded
```

```zsh
~/VSCodes/ASKK-25988/Lab2/health-test % docker build -t flask-app:v1 ~/VSCodes/ASKK-25988/Lab2/hello-python/
[+] Building 5.6s (10/10) FINISHED                                                                   docker:desktop-linux
 => [internal] load build definition from Dockerfile                                                                 0.0s
 => => transferring dockerfile: 195B                                                                                 0.0s
 => [internal] load metadata for docker.io/library/python:3.11-slim                                                  0.0s
 => [internal] load .dockerignore                                                                                    0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [1/5] FROM docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea  0.0s
 => => resolve docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea  0.0s
 => [internal] load build context                                                                                    0.0s
 => => transferring context: 662B                                                                                    0.0s
 => CACHED [2/5] WORKDIR /app                                                                                        0.0s
 => [3/5] COPY requirements.txt .                                                                                    0.0s
 => [4/5] RUN pip install --no-cache-dir -r requirements.txt                                                         4.8s
 => [5/5] COPY . .                                                                                                   0.0s 
 => exporting to image                                                                                               0.7s 
 => => exporting layers                                                                                              0.5s 
 => => exporting manifest sha256:069d7a9b8f756d1c6b0f6f67b0822a1ed79a73164b89e0d6a494ac09275f9dd1                    0.0s 
 => => exporting config sha256:abf75881156061ad5d1078fc3ee0daff8a860be16a2afa3fb2d92300510baecd                      0.0s 
 => => exporting attestation manifest sha256:9dac2923fc2b4632d5b692904a295b9839ed3b1ac30874e5121a40e6658fe195        0.0s 
 => => exporting manifest list sha256:faa8dfcd2bb6f2a6e7512338245c4199f3637ef14bfddf73d30a87ebc3bbec70               0.0s
 => => naming to docker.io/library/flask-app:v1                                                                      0.0s
 => => unpacking to docker.io/library/flask-app:v1                                                                   0.1s
```

```zsh
~/VSCodes/ASKK-25988/Lab2/health-test % docker tag flask-app:v1 mewosh/flask-app:v1
~/VSCodes/ASKK-25988/Lab2/health-test % 
```

```zsh
~/VSCodes/ASKK-25988/Lab2/health-test % docker tag flask-app:v1 mewosh/flask-app:latest
~/VSCodes/ASKK-25988/Lab2/health-test % 
```

```zsh
~/VSCodes/ASKK-25988/Lab2/health-test % docker push mewosh/flask-app:v1
The push refers to repository [docker.io/mewosh/flask-app]
7ca0c331ecfd: Mounted from library/python 
5c8bd50a4801: Pushed 
1fa761c54cb1: Pushed 
d038218272df: Pushed 
bbeda6b4abb7: Mounted from library/postgres 
73cdf02a38bd: Pushed 
9eb0fb93ee08: Mounted from library/python 
a96ffb137eb3: Pushed 
73a63ac3ec4a: Mounted from library/python 
v1: digest: sha256:faa8dfcd2bb6f2a6e7512338245c4199f3637ef14bfddf73d30a87ebc3bbec70 size: 856
```

```zsh
~/VSCodes/ASKK-25988/Lab2/health-test % docker push mewosh/flask-app:latest
The push refers to repository [docker.io/mewosh/flask-app]
73a63ac3ec4a: Layer already exists 
bbeda6b4abb7: Layer already exists 
5c8bd50a4801: Layer already exists 
a96ffb137eb3: Layer already exists 
1fa761c54cb1: Already exists 
d038218272df: Layer already exists 
9eb0fb93ee08: Layer already exists 
7ca0c331ecfd: Layer already exists 
73cdf02a38bd: Layer already exists 
latest: digest: sha256:faa8dfcd2bb6f2a6e7512338245c4199f3637ef14bfddf73d30a87ebc3bbec70 size: 856
```

```zsh
~/VSCodes/ASKK-25988/Lab2/health-test % docker rmi mewosh/flask-app:v1 mewosh/flask-app:latest
Untagged: mewosh/flask-app:v1
Untagged: mewosh/flask-app:latest
```

```zsh
~/VSCodes/ASKK-25988/Lab2/health-test % docker pull mewosh/flask-app:v1
v1: Pulling from mewosh/flask-app
Digest: sha256:faa8dfcd2bb6f2a6e7512338245c4199f3637ef14bfddf73d30a87ebc3bbec70
Status: Downloaded newer image for mewosh/flask-app:v1
docker.io/mewosh/flask-app:v1
```

```zsh
~/VSCodes/ASKK-25988/Lab2/health-test % docker run --rm mewosh/flask-app:v1
 * Serving Flask app 'app'
 * Debug mode: off
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on all addresses (0.0.0.0)
 * Running on http://127.0.0.1:5000
 * Running on http://172.17.0.2:5000
Press CTRL+C to quit
```

**Screenshot:**

![Obraz na Docker Hub i pobranie go](images/image-8.png)

Rys. 9 - Obraz na Docker Hub i pobranie go.

![docker hub](images/image-9.png)

Rys. 10 - Obraz widoczny na portalu Docker Hub.

---

##### Zadania do samodzielnego wykonania

##### Zadanie 1 — Dockerfile dla Django

**Opis:** Stworzono plik `Dockerfile` dla aplikacji Django z folderu `supporting-materials/examples/04-django`, zbudowano obraz i uruchomiono kontener.

**Użyte polecenia:**

```zsh
cd ~/VSCodes/ASKK-25988/Lab2/04-django

docker build -t django-open-meteo .
docker run -d --name django-open-meteo -p 8000:8000 -e "DJANGO_SECRET_KEY=change-me-in-prod" django-open-meteo
```

**Wynik działania:**

```zsh
~/VSCodes/ASKK-25988/Lab2/health-test % cd ~/VSCodes/ASKK-25988/Lab2/04-django 
~/VSCodes/ASKK-25988/Lab2/04-django % 
```

```zsh
~/VSCodes/ASKK-25988/Lab2/04-django % docker build -t django-open-meteo .
[+] Building 24.0s (12/12) FINISHED                                                                  docker:desktop-linux
 => [internal] load build definition from Dockerfile                                                                 0.0s
 => => transferring dockerfile: 599B                                                                                 0.0s
 => [internal] load metadata for docker.io/library/python:3.12-slim                                                  1.8s
 => [auth] library/python:pull token for registry-1.docker.io                                                        0.0s
 => [internal] load .dockerignore                                                                                    0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [1/6] FROM docker.io/library/python:3.12-slim@sha256:b18b261e1b4974b4f321451ad5251ded85abb22c2b8b262da527dda1d  10.2s
 => => resolve docker.io/library/python:3.12-slim@sha256:b18b261e1b4974b4f321451ad5251ded85abb22c2b8b262da527dda1d0  0.0s
 => => sha256:64074ecd150a3526f7ef1af3128b9186744abfb9dc3d1c3e87c11c1ea880cbd0 251B / 251B                           0.2s
 => => sha256:b41621e272b0b306c196fabab6f5e0132d1c13f3c929bfb63455191fa509e311 12.06MB / 12.06MB                     3.1s
 => => sha256:0922d1fc1a5f7baa280015c744bb0be989e6e146a9181c04d2971e1273416844 1.27MB / 1.27MB                       3.3s
 => => sha256:2b70e040f7d132c8d366ee0223462552686510fb372ea5a83822973c30f19e36 30.21MB / 30.21MB                     9.6s
 => => extracting sha256:2b70e040f7d132c8d366ee0223462552686510fb372ea5a83822973c30f19e36                            0.4s
 => => extracting sha256:0922d1fc1a5f7baa280015c744bb0be989e6e146a9181c04d2971e1273416844                            0.0s
 => => extracting sha256:b41621e272b0b306c196fabab6f5e0132d1c13f3c929bfb63455191fa509e311                            0.2s
 => => extracting sha256:64074ecd150a3526f7ef1af3128b9186744abfb9dc3d1c3e87c11c1ea880cbd0                            0.0s
 => [internal] load build context                                                                                    0.0s
 => => transferring context: 155.83kB                                                                                0.0s
 => [2/6] RUN apt-get update && apt-get install -y --no-install-recommends     curl     ca-certificates     bash     4.9s
 => [3/6] WORKDIR /app                                                                                               0.0s 
 => [4/6] COPY requirements.txt /app/                                                                                0.0s 
 => [5/6] RUN pip install --no-cache-dir -r requirements.txt                                                         5.4s 
 => [6/6] COPY . /app/                                                                                               0.0s 
 => exporting to image                                                                                               1.6s 
 => => exporting layers                                                                                              0.9s 
 => => exporting manifest sha256:09b9d59947cb5c7454735ddbea8bc914eeef9b4158d83a41d98a43e5799b257a                    0.0s 
 => => exporting config sha256:fe038ccd710947737918bb21b009c6f277275c9d9bbf625a00585ed403ca791f                      0.0s 
 => => exporting attestation manifest sha256:30d5cf034a9f8fc4d0ecaec330b1e9f897d4dbf3a9e4525522dc07bac3a6b75c        0.0s 
 => => exporting manifest list sha256:1ee94125ecb5ae966d1e3f11e26726065f39ca76dad553765eeaf8f699430631               0.0s
 => => naming to docker.io/library/django-open-meteo:latest                                                          0.0s
 => => unpacking to docker.io/library/django-open-meteo:latest                                                       0.6s
```

```zsh
~/VSCodes/ASKK-25988/Lab2/04-django % docker run -d --name django-open-meteo -p 8000:8000 -e "DJANGO_SECRET_KEY=change-me-in-prod" django-open-meteo
0c7373b1ffa7d18ebbfcedc60a510edd9067390df38d079561a4afad077c2679
```

**Screenshot:**

![dzialajace django](images/image-10.png)

Rys. 11 - Działająca aplikacja Django.

---

##### Zadanie 2 — Multi-stage dla Pythona

**Opis:** Stworzono zoptymalizowany obraz multi-stage dla prostego skryptu Python z cachowaniem oraz tworzeniem użytkownika i grupy.

**Użyte polecenia:**

```zsh
mkdir -p ~/VSCodes/ASKK-25988/Lab2/python-multistage && cd ~/VSCodes/ASKK-25988/Lab2/python-multistage

docker build -t python-multistage .
docker run --rm --name python-multistage python-multistage
```

**Wynik działania:**

```zsh
~/VSCodes/ASKK-25988/Lab2/04-django % mkdir -p ~/VSCodes/ASKK-25988/Lab2/python-multistage && cd ~/VSCodes/ASKK-25988/Lab2/python-multistage
~/VSCodes/ASKK-25988/Lab2/python-multistage % 
```

```zsh
~/VSCodes/ASKK-25988/Lab2/python-multistage % docker build -t python-multistage .
[+] Building 8.1s (13/13) FINISHED                                                                   docker:desktop-linux
 => [internal] load build definition from Dockerfile                                                                 0.0s
 => => transferring dockerfile: 942B                                                                                 0.0s
 => [internal] load metadata for docker.io/library/python:3.11-slim                                                  0.0s
 => [internal] load .dockerignore                                                                                    0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [internal] load build context                                                                                    0.0s
 => => transferring context: 1.51kB                                                                                  0.0s
 => [builder 1/5] FROM docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5  0.0s
 => => resolve docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea  0.0s
 => CACHED [builder 2/5] WORKDIR /app                                                                                0.0s
 => [builder 3/5] RUN python -m venv /opt/venv                                                                       2.7s
 => [runner 3/5] RUN groupadd -g 10001 appuser &&     useradd -u 10001 -g appuser -s /bin/sh appuser                 0.2s
 => [builder 4/5] COPY requirements.txt .                                                                            0.0s
 => [builder 5/5] RUN pip install --no-cache-dir --upgrade pip &&     pip install --no-cache-dir -r requirements.tx  4.1s
 => [runner 4/5] COPY --from=builder /opt/venv /opt/venv                                                             0.1s
 => [runner 5/5] COPY --chown=appuser:appuser . .                                                                    0.0s 
 => exporting to image                                                                                               0.9s 
 => => exporting layers                                                                                              0.7s 
 => => exporting manifest sha256:7d5e2e0a0c06c7e2bddbafcaff634bea0d9bbb29980cf29c8be020dedc211248                    0.0s 
 => => exporting config sha256:76b90a6dcd92b951b471e919c1f0fbb5e4d3429773766c39eee9be31e4f1542d                      0.0s 
 => => exporting attestation manifest sha256:efee3df8d587c914f1c1c3e0f2254f5223036a1612720b8858d0d10855942b14        0.0s
 => => exporting manifest list sha256:930ad4b89bda198d44026e20ab3ce4103032d763e1b01e069ee918c84a2e77ac               0.0s
 => => naming to docker.io/library/python-multistage:latest                                                          0.0s
 => => unpacking to docker.io/library/python-multistage:latest                                                       0.2s
```

```zsh
~/VSCodes/ASKK-25988/Lab2/python-multistage % docker run --rm --name python-multistage python-multistage
Post title: sunt aut facere repellat provident occaecati excepturi optio reprehenderit
Post body: quia et suscipit
suscipit recusandae consequuntur expedita et cum
reprehenderit molestiae ut ut quas totam
nostrum rerum est autem sunt rem eveniet architecto
```

**Screenshot:**

![wynik skryptu](images/image-11.png)

Rys. 12 - Wynik uruchomienia prostego skryptu Python po multi-stage buildzie.

---

##### Zadanie 3 — Optymalizacja rozmiaru

**Opis:** Zoptymalizowano obraz z ćwiczenia 1.3 dodając do niego `.dockerignore`, używając multi-stage build i zmieniając obraz z wersji `slim` na `alpine`. Dzięki zastosowanym technikom uzyskano obraz prawie o połowę lżejszy.

**Użyte polecenia:**

```zsh
cd ~/VSCodes/ASKK-25988/Lab2/hello-python 

docker build -t hello-python:unoptimized -f Dockerfile .
docker build -t hello-python:optimized -f Dockerfile.optimized .

docker images hello-python
```

**Wynik działania:**

```zsh
~/VSCodes/ASKK-25988/Lab2/python-multistage % cd ~/VSCodes/ASKK-25988/Lab2/hello-python 
~/VSCodes/ASKK-25988/Lab2/hello-python % 
```

```zsh
~/VSCodes/ASKK-25988/Lab2/hello-python % docker build -t hello-python:unoptimized -f Dockerfile .
[+] Building 7.4s (10/10) FINISHED                                                                   docker:desktop-linux
 => [internal] load build definition from Dockerfile                                                                 0.0s
 => => transferring dockerfile: 195B                                                                                 0.0s
 => [internal] load metadata for docker.io/library/python:3.11-slim                                                  7.2s
 => [internal] load .dockerignore                                                                                    0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [1/5] FROM docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea  0.0s
 => => resolve docker.io/library/python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea  0.0s
 => [internal] load build context                                                                                    0.0s
 => => transferring context: 1.06kB                                                                                  0.0s
 => CACHED [2/5] WORKDIR /app                                                                                        0.0s
 => CACHED [3/5] COPY requirements.txt .                                                                             0.0s
 => CACHED [4/5] RUN pip install --no-cache-dir -r requirements.txt                                                  0.0s
 => [5/5] COPY . .                                                                                                   0.0s
 => exporting to image                                                                                               0.1s
 => => exporting layers                                                                                              0.0s
 => => exporting manifest sha256:09dc2b04391131df33588fff6c6035df09bfa92693bfcfeeb6656f23ffef3206                    0.0s
 => => exporting config sha256:8acc0fb3897a1552e6ca8b8022a09f8557c11e3b3ffd94d77ed8655af515a585                      0.0s
 => => exporting attestation manifest sha256:80a5c93fd0e3b9158fa24607f946e4df5db0c60686dc0892f70ca00fbea88025        0.0s
 => => exporting manifest list sha256:987022ff4d31fa6e28f19ca65648cbc4020ef8772790af717198f1f5f1c7721c               0.0s
 => => naming to docker.io/library/hello-python:unoptimized                                                          0.0s
 => => unpacking to docker.io/library/hello-python:unoptimized                                                       0.0s
```

```zsh
~/VSCodes/ASKK-25988/Lab2/hello-python % docker build -t hello-python:optimized -f Dockerfile.optimized .
[+] Building 0.3s (13/13) FINISHED                                                                   docker:desktop-linux
 => [internal] load build definition from Dockerfile.optimized                                                       0.0s
 => => transferring dockerfile: 974B                                                                                 0.0s
 => [internal] load metadata for docker.io/library/python:3.11-alpine                                                0.0s
 => [internal] load .dockerignore                                                                                    0.0s
 => => transferring context: 65B                                                                                     0.0s
 => [builder 1/5] FROM docker.io/library/python:3.11-alpine@sha256:d9368b3a5ac59afea7b5d4f2e2aea0941dbf9fdee9c369c5  0.0s
 => => resolve docker.io/library/python:3.11-alpine@sha256:d9368b3a5ac59afea7b5d4f2e2aea0941dbf9fdee9c369c5bec00b98  0.0s
 => [internal] load build context                                                                                    0.0s
 => => transferring context: 103B                                                                                    0.0s
 => CACHED [builder 2/5] WORKDIR /app                                                                                0.0s
 => CACHED [runner 3/5] RUN addgroup -g 10001 -S appuser &&     adduser -u 10001 -S -D -G appuser -h /app appuser    0.0s
 => CACHED [builder 3/5] RUN python -m venv /opt/venv                                                                0.0s
 => CACHED [builder 4/5] COPY requirements.txt .                                                                     0.0s
 => CACHED [builder 5/5] RUN pip install --no-cache-dir --upgrade pip &&     pip install --no-cache-dir -r requirem  0.0s
 => CACHED [runner 4/5] COPY --from=builder /opt/venv /opt/venv                                                      0.0s
 => [runner 5/5] COPY --chown=appuser:appuser . .                                                                    0.0s
 => exporting to image                                                                                               0.1s
 => => exporting layers                                                                                              0.0s
 => => exporting manifest sha256:2fa2a58ef2079a4507a864cbfada51f4a500bd7787956db63d2cafcd70362fe5                    0.0s
 => => exporting config sha256:3f2db547332edcb74db877b600c508d428569adcc737d6ebf3cd503f22355598                      0.0s
 => => exporting attestation manifest sha256:8ae2e17b2b091bb1752a84f5ba2f1cad36768c6ae86a87f63cd3e1c2b4c9e0fe        0.0s
 => => exporting manifest list sha256:897ae613839fd1cafac62c32d1aa72e59ea2b862f686079706c5d0569c3a23c6               0.0s
 => => naming to docker.io/library/hello-python:optimized                                                            0.0s
 => => unpacking to docker.io/library/hello-python:optimized                                                         0.0s
```

```zsh
~/VSCodes/ASKK-25988/Lab2/hello-python % docker images hello-python                                      
                                                                                                      i Info →   U  In Use
IMAGE                      ID             DISK USAGE   CONTENT SIZE   EXTRA
hello-python:optimized     897ae613839f        144MB         33.6MB        
hello-python:unoptimized   987022ff4d31        242MB         52.7MB        
hello-python:v1            4a169700acc1        213MB         45.9MB        
```

**Screenshot:**

![porownanie rozmiaru](images/image-13.png)

Rys. 13 - Porównanie niezoptymalizowanego obrazu z ćwiczenia 1.3 (`hello-python:unoptimized`) ze zoptymalizowaną wersją (`hello-python:optimized`) - widać znaczącą różnicę w rozmiarze (zoptymalizowany obraz jest o 98 MB lżejszy).

---

#### 4. Pliki konfiguracyjne

##### Dockerfile

##### Zadanie 1

```dockerfile
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    DJANGO_DEBUG=1 \
    DJANGO_ALLOWED_HOSTS=* \
    TZ=Europe/Warsaw

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    bash \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app/

EXPOSE 8000

CMD ["sh", "-c", "python manage.py migrate --noinput && python manage.py runserver 0.0.0.0:8000"]
```

##### Zadanie 2

```dockerfile
# Obraz do budowania
FROM python:3.11-slim AS builder

# Wyłączenie tworzenia skompilowanego kodu bajtowego, celem oszczędzania miejsca na dysku i zmniejszenia operacji I/O
ENV PYTHONDONTWRITEBYTECODE=1

WORKDIR /app

# Środowisko wirtualne
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Instalacja zależności w celu umożliwienia ich cachowania
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt


# Obraz dla runtime
FROM python:3.11-slim AS runner

ENV PYTHONDONTWRITEBYTECODE=1 \
    PATH="/opt/venv/bin:$PATH"

WORKDIR /app

# Utworzenie grupy i użytkownika niebędącego rootem dla bezpieczeństwa
RUN groupadd -g 10001 appuser && \
    useradd -u 10001 -g appuser -s /bin/sh appuser

COPY --from=builder /opt/venv /opt/venv
COPY --chown=appuser:appuser . .

USER appuser

CMD ["python", "main.py"]
```

##### Zadanie 3

`Dockerfile` przed optymalizacją:
```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 5000
CMD ["python", "app.py"]
```

`Dockerfile` po optymalizacji:
```dockerfile
# Obraz do budowania
FROM python:3.11-alpine AS builder

# Wyłączenie tworzenia skompilowanego kodu bajtowego, celem oszczędzania miejsca na dysku i zmniejszenia operacji I/O
ENV PYTHONDONTWRITEBYTECODE=1

WORKDIR /app

# Środowisko wirtualne
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Instalacja zależności w celu umożliwienia ich cachowania
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt


# Obraz dla runtime
FROM python:3.11-alpine AS runner

ENV PYTHONDONTWRITEBYTECODE=1 \
    PATH="/opt/venv/bin:$PATH"

WORKDIR /app

# Utworzenie grupy i użytkownika niebędącego rootem dla bezpieczeństwa
RUN addgroup -g 10001 -S appuser && \
    adduser -u 10001 -S -D -G appuser -h /app appuser

COPY --from=builder /opt/venv /opt/venv
COPY --chown=appuser:appuser . .

EXPOSE 5000

USER appuser

CMD ["python", "main.py"]
```

##### docker-compose.yaml

```yaml
# -brak-
```

##### Inne pliki

##### Zadanie 2

`main.py`:
```py
import requests

def fetch_sample_data():
    url = 'https://jsonplaceholder.typicode.com/posts/1'

    try:
        response = requests.get(url, timeout=10)
        response.raise_for_status()

        data = response.json()
        print(f"Post title: {data.get('title')}")
        print(f"Post body: {data.get('body')}")

    except requests.exceptions.RequestException as err:
        print(f'Error fetching data: {err}')


if __name__ == '__main__':
    fetch_sample_data()
```

`requirements.txt`:
```
requests==2.31.0
```

##### Zadanie 3

`.dockerignore`:
```dockerignore
Dockerfile
.dockerignore
```

---

#### 5. Napotkane problemy i ich rozwiązania

| Problem | Rozwiązanie |
|---------|-------------|
| Krok Dockerfile `RUN npm ci --only=production` w ćwiczeniu 4.2 zakończony błędem <br/> `=> ERROR [builder 4/4] RUN npm ci --only=production 0.4s` <br/> `=> [stage-1 3/5] WORKDIR /app 0.0s` <br/> `------` <br/> `> [builder 4/4] RUN npm ci --only=production:` <br/> ``0.202 npm warn config only Use `--omit=dev` to omit dev dependencies from the install.`` <br/> `0.376 npm error code EUSAGE` <br/> `0.376 npm error` <br/> ``0.376 npm error The `npm ci` command can only install with an existing package-lock.json or`` <br/> `0.376 npm error npm-shrinkwrap.json with lockfileVersion >= 1. Run an install with npm@5 or` <br/> `0.376 npm error later to generate a package-lock.json file, then try again.` | Wygenerowano plik `package-lock.json` na lokalnej maszynie poleceniem `npm install` i poprawiono plik `Dockerfile` aby polecenie `npm ci` korzystało z nowej konwencji `--omit=dev` zamiast przestarzałej `--only=production` |

---

#### 6. Wnioski

W ramach laboratorium nauczyłem się konstruować plik Dockerfile od podstaw, w tym używać instrukcji: `FROM`, `RUN`, `COPY`, `ADD`, `WORKDIR`, `ENV`, `ARG`, `CMD`, `ENTRYPOINT`. Zdobyłem również wiedzę jak optymalizować obrazy Dockera i publikować je na platformie Docker Hub. Podczas laboratorium udowodniono jak ważna jest kolejność instrukcji w `Dockerfile`. W momencie gdy jest ona prawidłowa, można skorzystać z mechanizmów cachowania, które znacznie przyspieszają czas budowania obrazu. Pokazano również jak ważna jest optymalizacja obrazów (w tym multi-stage build) w kontekście zmniejszenia rozmiaru obrazu. W trakcie laboratorium nie napotkano większych problemów a najciekszawszy był proces publikowania własnego obrazu na platformie Docker Hub i późniejsza weryfikacja, że rzeczywiście można go pobrać i uruchomić.

---

#### 7. Bibliografia / źródła

- [Docker Documentation](https://docs.docker.com/)
