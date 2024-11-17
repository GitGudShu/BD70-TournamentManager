# BD70 Tournament Manager

Ce projet est un **système de gestion de tournois** pour des jeux de société, composé de deux parties principales : le **client**, développé avec Quasar (framework Vue.js), et le **serveur**, développé avec Node.js. Le système permet aux utilisateurs de créer des tournois, d'enregistrer des joueurs, de suivre les résultats des matchs et de générer des classements pour divers jeux de société.

## Prérequis

Avant de commencer, assurez-vous d'avoir les versions suivantes :
- **Node.js** : v18.18.0
- **npm** : v9.8.1
- **Quasar CLI** : Voir ci-dessous

## Instructions de configuration

### Configuration de la base de données (MySQL)

Si MySQL n'est pas installé, vous devrez l'installer. Une fois installé, configurez la base de données en suivant ces étapes :

1. Ouvrez le terminal MySQL :

   ```bash
   mysql -u root -p
   ```

2. Créez la base de données `tournament_db` :

   ```sql
   CREATE DATABASE tournament_db;
   ```

3. Chargez les données du fichier `data.sql` dans la base de données :

   ```sql
   SOURCE ./data.sql;
   ```

Assurez-vous d'être dans le répertoire `server` lorsque vous exécutez la commande `SOURCE`, afin que le chemin vers le fichier `data.sql` soit correct.

### Serveur (Node.js)

Le côté serveur est développé avec Node.js. Suivez ces étapes pour le configurer :

1. Accédez au répertoire `server` et installez les dépendances :

    ```bash
    cd server
    npm install
    ```

2. Créez un fichier `.env` dans le répertoire `server` avec le contenu suivant :

    ```bash
    MYSQL_HOST='localhost'
    MYSQL_USER=your_user
    MYSQL_PASSWORD=your_password
    MYSQL_DATABASE="tournament_db"
    SESSION_SECRET="secret"
    ```

Remplacez `your_user` et `your_password` par vos vrais identifiants MySQL. Cette configuration permettra au serveur Node.js de se connecter à la base de données MySQL.

3. Lancez le serveur :

    ```bash
    npm run dev
    ```

### Client (Quasar Vuejs)

Le côté client est maintenant un projet Quasar. Suivez ces étapes pour le configurer :

1. Accédez au répertoire `client` :

    ```bash
    cd client
    ```

2. Installez les dépendances :

    ```bash
    npm install
    ```

3. Installez Quasar CLI (si ce n'est pas déjà fait) :

    ```bash
    npm i -g quasar
    npm install -g @quasar/cli
    ```

4. Lancez le serveur de développement Quasar :

    ```bash
    quasar dev
    ```

---

Votre **système de gestion de tournois** est maintenant prêt à être utilisé !