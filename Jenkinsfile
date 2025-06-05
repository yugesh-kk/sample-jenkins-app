pipeline {
    agent any
    tools {
        maven 'Maven 3.9.9' // Match your Maven version
        jdk 'jdk-21'        // Match your JDK
    }

    environment {
        MAJOR_VERSION = "1"
        MINOR_VERSION = "0"
    }

    stages {
        stage('Checkout & Tag') {
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
                dir('sysinfo-jenkins-app/sysinfo-jenkins-app') {
                    bat 'mvn clean package'
                }
            }
        }

        stage('Deploy to Nexus') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'nexus', usernameVariable: 'NEXUS_USER', passwordVariable: 'NEXUS_PASS')]) {
                    script {
                        def jarFile = "sysinfo-jenkins-app/sysinfo-jenkins-app/target/sysinfo-jenkins-app-${env.CUSTOM_BUILD_VERSION}.jar"
                        def nexusRepo = "maven-releases"  // or "raw-repo" if using raw type
                        def nexusUrl = "http://localhost:8081/repository/${nexusRepo}/"

                        echo "Uploading ${jarFile} to Nexus at ${nexusUrl}"

                        bat """
                            curl -v -u %NEXUS_USER%:%NEXUS_PASS% --upload-file ${jarFile} ${nexusUrl}sysinfo-jenkins-app-${env.CUSTOM_BUILD_VERSION}.jar
                        """
                    }
                }
            }
        }

        stage('Post Build Info') {
            steps {
                echo "✅ Build completed with custom version: ${env.CUSTOM_BUILD_VERSION}"
            }
        }
    }
}
