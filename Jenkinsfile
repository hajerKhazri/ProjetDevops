pipeline {
    agent any

    tools {
        maven 'MAVEN_HOME'
        jdk 'JDK-17'
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

        // AJOUTER CETTE NOUVELLE ÉTAPE
        stage('Fix Encoding') {
            steps {
                echo "=== Correction de l'encodage du fichier application.properties ==="
                sh '''
                    # Supprimer le fichier problématique
                    rm -f src/main/resources/application.properties

                    # Recréer le fichier avec encodage UTF-8
                    cat > src/main/resources/application.properties << 'EOF'
spring.application.name=student-management
spring.datasource.url=jdbc:mysql://localhost:3306/studentdb?createDatabaseIfNotExist=true
spring.datasource.username=root
spring.datasource.password=
spring.jpa.show-sql=true
spring.jpa.hibernate.ddl-auto=update
server.port=8089
server.servlet.context-path=/student
EOF

                    # Vérifier que le fichier a été créé
                    ls -la src/main/resources/application.properties
                    file -i src/main/resources/application.properties
                '''
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