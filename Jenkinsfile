pipeline {
    agent any

    tools {
        maven 'MAVEN_HOME'   // Vérifie que ce nom correspond à Maven dans Jenkins
        jdk 'JDK-17'         // Vérifie que ce nom correspond au JDK installé
    }

    environment {
        MAVEN_OPTS = "-Dfile.encoding=UTF-8"
        LANG = "en_US.UTF-8"
        LC_ALL = "en_US.UTF-8"
    }

    stages {

        stage('Checkout') {
            steps {
                echo "=== Récupération du projet depuis GitHub ==="
                git branch: 'hejer', url: 'https://github.com/hajerKhazri/ProjetDevops.git'
            }
        }

        stage('Build') {
            steps {
                echo "=== Compilation du projet ==="
                sh '''
                    export LANG=en_US.UTF-8
                    export LC_ALL=en_US.UTF-8
                    mvn clean install -DskipTests -Dproject.build.sourceEncoding=UTF-8 -Dfile.encoding=UTF-8
                '''
            }
        }

        stage('Tests') {
            steps {
                echo "=== Exécution des tests ==="
                sh '''
                    export LANG=en_US.UTF-8
                    export LC_ALL=en_US.UTF-8
                    mvn test -Dproject.build.sourceEncoding=UTF-8 -Dfile.encoding=UTF-8
                '''
            }
        }

        stage('Package') {
            steps {
                echo "=== Génération du fichier JAR ==="
                sh '''
                    export LANG=en_US.UTF-8
                    export LC_ALL=en_US.UTF-8
                    mvn package -Dproject.build.sourceEncoding=UTF-8 -Dfile.encoding=UTF-8
                '''
            }
        }

        stage('Finish') {
            steps {
                echo "=== Pipeline terminé avec succès à ${new Date()} ==="
            }
        }
    }

    post {
        success {
            echo "Le build s'est terminé avec succès !"
        }
        failure {
            echo "Le build a échoué. Vérifie les logs."
        }
    }
}