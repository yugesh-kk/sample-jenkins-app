pipeline {
    agent any

    tools {
        maven 'Maven 3.9.9'  // Match your Maven version; configure this in Jenkins
        jdk 'jdk-21'        // Match your JDK; configure in Jenkins Global Tool Config
    }

       environment {
        MAJOR_VERSION = "1"
        MINOR_VERSION = "0"
    }

    stages {
        stage('Checkout') {
            steps {
                //deleteDir()
                //checkout scm
                // git credentialsId: 'github_token', url: 'https://github.com/yugesh-kk/sample-jenkins-app.git'

                script {
                    deleteDir()
                    checkout scm

                    // Dynamically build version with date and Jenkins build number
                    def buildDate = new Date().format('ddMMyy')
                    def customVersion = "${env.MAJOR_VERSION}.${env.MINOR_VERSION}.${env.BUILD_NUMBER}-${buildDate}"
                    echo "Custom Build Version: ${customVersion}"

                    // Save custom version to environment for later use if needed
                    env.CUSTOM_BUILD_VERSION = customVersion

                    // Tag only if on 'master' branch
                    def branch = bat(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                    if (branch == 'master') {
                        def tagName = "v${customVersion}"
                        echo "Creating Git tag: ${tagName}"

                        bat """
                            git config user.name "jenkins"
                            git config user.email "jenkins@example.com"
                            git tag ${tagName}
                            git push origin ${tagName}
                        """
                    } else {
                        echo "Skipping tag creation. Current branch is '${branch}'."
                    }
                }
        }
     }

        stage('Build') {
            steps {
                bat 'mvn clean package'
            }
        }

        stage('Test') {
            steps {
                bat 'mvn test'
            }
        }
    }
}
