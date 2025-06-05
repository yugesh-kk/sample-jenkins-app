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
        withCredentials([string(credentialsId: 'github_write_token', variable: 'GITHUB_TOKEN')]) {
            script {
                def buildDate = new Date().format('ddMMyy')
                def customVersion = "${env.MAJOR_VERSION}.${env.MINOR_VERSION}.${env.BUILD_NUMBER}-${buildDate}"
                env.CUSTOM_BUILD_VERSION = customVersion
                def tagName = "v${customVersion}"
                echo "Creating Git tag: ${tagName}"

                def gitRepoUrl = "https://${GITHUB_TOKEN}@github.com/yugesh-kk/sample-jenkins-app.git"

                bat """
                    git config user.name "jenkins"
                    git config user.email "jenkins@example.com"
                    git remote set-url origin ${gitRepoUrl}
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
                    dir('sysinfo-jenkins-app/sysinfo-jenkins-app') {
                        writeFile file: 'settings.xml', text: """
                            <settings>
                              <servers>
                                <server>
                                  <id>nexus</id>
                                  <username>${NEXUS_USER}</username>
                                  <password>${NEXUS_PASS}</password>
                                </server>
                              </servers>
                            </settings>
                        """
                        bat 'mvn clean deploy --settings settings.xml'
                    }
                }
            }
        }

        stage('Post Build Info') {
            steps {
                echo "✅ Build completed and deployed with version: ${env.CUSTOM_BUILD_VERSION}"
            }
        }
    }
}
