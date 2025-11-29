pipeline {
    agent {
        label 'master'
    }
    stages {
        stage('Test Master') {
            steps {
                sh 'echo "🚀 BUILD SUR MASTER!"'
                sh 'mvn --version'
                sh 'docker --version'
            }
        }
    }
}