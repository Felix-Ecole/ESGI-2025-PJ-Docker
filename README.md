# TP-EXAM : Projet Docker
Ce projet met en œuvre une architecture **Docker** orientée production pour exécuter une application **Laravel** dans un environnement **multi-conteneurs**. Grâce à **Docker Compose**, tous les services sont définis dans un fichier YAML centralisé, facilitant leur déploiement et leur orchestration. L'ensemble constitue une **stack Docker**, c'est-à-dire un groupe de services interconnectés fonctionnant ensemble : serveur web, moteur PHP, base de données, proxy HTTPS, et outils de développement.

La stack inclut notamment **Caddy**, qui permet de gérer automatiquement du HTTPS via des certificats auto-signés, tout en assurant les rôles de **reverse proxy** et de **load balancing**. Dans ce projet, Caddy est utilisé pour équilibrer la charge entre les serveurs NGINX et pour avoir du HTTPS.

### Services inclus :
- 1 serveur **Caddy** (HTTPS et load balancing)
- 1 serveur **MySQL** (base de données relationnelle)
- 2 serveurs **PHP-FPM** (exécution de l'application Laravel)
- 2 serveurs **NGINX** (optimisation et reverse proxy vers PHP-FPM)
- 1 serveur **Mailhog** (visualisation des e-mails de test)

-----

## ✨ Installation
### Configuration du hostname (mDNS)
Permet d'accéder à la machine via son nom local grâce au multicast DNS (mDNS).
```bash
# Service mDNS à diffusion automatique.
apt install avahi-daemon -y
```

Petit bonus optionnel : ce code permet de définir un nom de machine plus clair pour le réseau.
```bash
hostnamectl set-hostname my-server.local
sed -z "s/127.0.1.1\t.*/127.0.1.1\t$(hostname)/" -i /etc/hosts

reboot
```

### Configuration du SSHD (à manipuler avec précaution)
Si nécessaire, vous pouvez autoriser les connexions SSH avec le root par mot de passe.
```bash
# Modifie la configuration du "sshd" pour se connecter en root via mot de passe.
sed -z "s/prohibit-password/prohibit-password\nPermitRootLogin yes/" -i /etc/ssh/sshd_config

# Redémarre le service "sshd" pour appliquer les changements.
# Attention : cela peut fermer les connexions SSH en cours.
systemctl restart sshd
```

### Clonage du projet et déploiement des conteneurs
Clonez le projet avec ses sous-modules, puis ce placez dedans afin de déployer les services.
```bash
git clone --recurse-submodules https://github.com/Felix-Ecole/ESGI-2025-PJ-Docker.git
cd ESGI-2025-PJ-Docker

cp .env.example .env
docker compose up --build -d
```

---

## 🗂️ Structure du dépôt

Voici les principaux fichiers et dossiers du projet :

- `app/` : code source de l'application Laravel (prévu pour être monté avec Git)
- `conf/` : fichiers de configuration pour les différents services (NGINX, CADDY...)
- `custom/` : fichiers personnalisés pour le dossier `app/` appliqué via le `docker-compose`
- `.env.example` : fichier d'exemple pour la configuration des variables d'environnement
- `.gitmodules` : fichier de mappage entre l'URL du projet de submodule et le répertoire local
- `docker-compose.yaml` : orchestration de l'ensemble des services
- `docker-entrypoint.sh` : script d'initialisation personnalisé
- `Dockerfile` : instructions de construction pour les conteneurs PHP
- `README.md` : ce fichier de documentation

-----

## 🧰 Ressources & Références

Quelques liens utiles pour comprendre, compléter ou dépanner votre projet :

- [Documentation officielle Docker](https://docs.docker.com/)
- [Référence Docker Compose](https://docs.docker.com/compose/)
- [Caddy - Site officiel](https://caddyserver.com/docs/)
- [Mailhog - GitHub](https://github.com/mailhog/MailHog)
- [Portainer - Docker Stacks](https://docs.portainer.io/user/docker/stacks)
- [Laravel - Documentation](https://laravel.com/docs)

-----

## 📅 Exigences de Soumission
- Créez un dépôt **GitHub public** contenant votre projet.
- Incluez les fichiers `.env` nécessaires à son bon fonctionnement.
- Soumettez une archive **ZIP** sur **MyGES**.
- Fournissez une **vidéo de présentation** comme si vous exposiez votre projet à l'oral. L'humour et la créativité sont les bienvenus !

## 📃 Critères d'Évaluation
1. **Complexité & Fonctionnalités additionnelles (5 pts)**
   - Niveau de complexité et pertinence des ajouts techniques.

2. **Compréhension du Dockerfile (5 pts)**
   - Qualité de la structure et des personnalisations apportées aux Dockerfiles PHP.

3. **Maîtrise de Docker Compose (5 pts)**
   - Organisation logique des services, gestion des réseaux, volumes, etc.

4. **Automatisation & logique du système (5 pts)**
   - Degré d'automatisation et cohérence globale du déploiement.
