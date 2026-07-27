# =====================================================================
#  WARIANT NIEBEZPIECZNY (obiekt badawczy)
# =====================================================================
#  Ten plik celowo lamie dobre praktyki opisane w rozdziale 3.3 pracy.
#  Sluzy do zademonstrowania, ile podatnosci oraz bledow konfiguracyjnych
#  potrafia wykryc skanery (Trivy/Grype/Docker Scout) i linter (Hadolint).
#  NIE UZYWAC w srodowisku produkcyjnym.
# ---------------------------------------------------------------------

# BLAD 1: przestarzaly obraz bazowy (Debian 10 "buster" - koniec wsparcia),
#         dodatkowo tag niedeterministyczny bez sumy kontrolnej SHA-256.
FROM python:3.9-slim-buster

# BLAD 2: instalacja zbednych narzedzi systemowych zwiekszajacych
#         powierzchnie ataku (curl, wget, netcat, git, gcc).
# Uwaga: buster jest EOL, wiec repozytoria przeniesiono do archive.debian.org.
RUN echo "deb http://archive.debian.org/debian buster main" > /etc/apt/sources.list \
    && echo "deb http://archive.debian.org/debian-security buster/updates main" >> /etc/apt/sources.list \
    && apt-get -o Acquire::Check-Valid-Until=false update \
    && apt-get install -y \
    curl \
    wget \
    netcat \
    git \
    gcc \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# BLAD 3: uzycie ADD zamiast COPY (rozszerzona, ryzykowna funkcjonalnosc).
ADD app/requirements.txt /app/requirements.txt

RUN pip install --no-cache-dir -r requirements.txt

ADD app/ /app/

# BLAD 4: brak instrukcji USER - proces uruchamia sie jako root.

EXPOSE 5000

CMD ["python", "app.py"]
