pipeline {
    agent any

    tools {
        maven 'Maven 3.9.9'
        jdk 'jdk-21'
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
                withCredentials([usernamePassword(credentialsId: 'github_token', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
                    script {
                        def buildDate = new Date().format('ddMMyy')
                        def customVersion = "${env.MAJOR_VERSION}.${env.MINOR_VERSION}.${env.BUILD_NUMBER}-${buildDate}"
                        env.CUSTOM_BUILD_VERSION = customVersion
                        def tagName = "v${customVersion}"

                        echo "Creating Git tag: ${tagName}"

                        bat """
                            git config user.name "jenkins"
                            git config user.email "jenkins@example.com"
                            git remote set-url origin https://${GIT_USER}:${GIT_PASS}@github.com/yugesh-kk/sample-jenkins-app.git
                            git tag ${tagName}
                            git push origin ${tagName}
                        """
                    }
                }
            }
        }

        stage('Build & Deploy to Nexus') {
            steps {
                
                    withCredentials([usernamePassword(credentialsId: 'nexus', usernameVariable: 'NEXUS_USER', passwordVariable: 'NEXUS_PASS')]) {
                        bat """
                            mvn clean deploy -DskipTests=true -Dnexus.username=%NEXUS_USER% -Dnexus.password=%NEXUS_PASS%
                        """
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
