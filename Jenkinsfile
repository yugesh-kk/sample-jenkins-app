pipeline {
    agent any
	   tools {
        maven 'Maven 3.9.9'  // Match your Maven version; configure this in Jenkins
        jdk 'jdk-21'        // Match your JDK; configure in Jenkins Global Tool Config
    }

    environment {
        MAJOR_VERSION = "1"
        MINOR_VERSION = "0"
        BUILD_DATE = new Date().format('ddMMyy')  // evaluated in script block
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
           stage('tag')
		    {
              steps {
                script {		   
                    // Dynamically build version with date and Jenkins build number
                    def buildDate = new Date().format('ddMMyy')
                    def customVersion = "${env.MAJOR_VERSION}.${env.MINOR_VERSION}.${env.BUILD_NUMBER}-${buildDate}"
                    echo "Custom Build Version: ${customVersion}"

                    // Save custom version to environment for later use if needed
                    env.CUSTOM_BUILD_VERSION = customVersion

                    // Tag only if on 'master' branch
                //def branch = bat(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                    if (${env.BRANCH}== 'master') {
                        def tagName = "v${customVersion}"
                        echo "Creating Git tag: ${tagName}"

                        bat """
                            git config user.name "jenkins"
                            git config user.email "jenkins@example.com"
                            git tag ${tagName}
                            git push origin ${tagName}
                        """
                    } else {
                        echo "Skipping tag creation. Current branch is ${env.BRANCH}."
                    }
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

        stage('Post Build Info') {
            steps {
                echo "✅ Build completed with custom version: ${env.CUSTOM_BUILD_VERSION}"
            }
        }
    }
}
