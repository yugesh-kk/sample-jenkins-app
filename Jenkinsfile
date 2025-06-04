pipeline {
    agent any

    tools {
        maven 'Maven 3.9.9'  // Match your Maven version; configure this in Jenkins
        jdk 'jdk-21'        // Match your JDK; configure in Jenkins Global Tool Config
    }

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'github_token', url: 'https://github.com/yugesh-kk/sample-jenkins-app.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
    }
}
