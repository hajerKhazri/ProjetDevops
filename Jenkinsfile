pipeline {
    agent any
    triggers {
            githubPush()
        }
    stages {
        stage('GitHub') {
            steps {
                echo '1. Clonage du projet depuis GitHub'
               git branch: 'fares',
                url: 'https://github.com/hajerKhazri/ProjetDevops.git'
                script {
                    // Afficher les informations du commit
                    sh 'git log -1 --oneline'
                }
            }
        }
        stage('Build') {
            steps {
                script {
                    echo "2. Building Spring Boot application..."
                    sh 'mvn clean compile -DskipTests'
                }
            }
        }


}