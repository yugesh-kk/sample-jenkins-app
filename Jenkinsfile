pipeline {
    agent any

    tools {
        maven 'Maven 3.9.9'    // Configure this in Jenkins Global Tool Config
        jdk 'jdk-21'           // Configure this too
    }

    environment {
        MAJOR_VERSION = "1"
        MINOR_VERSION = "0"
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    deleteDir()
                    checkout scm
                }
            }
        }

        stage('Tag') {
            steps {
                script {
                    def buildDate = new Date().format('ddMMyy')
                    def customVersion = "${env.MAJOR_VERSION}.${env.MINOR_VERSION}.${env.BUILD_NUMBER}-${buildDate}"
                    echo "🔖 Custom Build Version: ${customVersion}"
                    env.CUSTOM_BUILD_VERSION = customVersion

                    def tagName = "v${customVersion}"
                    echo "Creating Git tag: ${tagName}"

                    bat """
                        git config user.name "jenkins"
                        git config user.email "jenkins@example.com"
                        git tag ${tagName}
                        git push origin ${tagName}
                    """
                }
            }
        }

        stage('Build') {
            steps {
                dir('sysinfo-jenkins-app/sysinfo-jenkins-app') { // adjust this path if needed
                    bat 'mvn clean package'
                }
            }
        }

        stage('Post Build Info') {
            steps {
                echo "✅ Build completed successfully with version: ${env.CUSTOM_BUILD_VERSION}"
            }
        }
    }
}
