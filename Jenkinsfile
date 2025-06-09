pipeline {
    agent any

    tools {
        maven 'Maven 3.9.9'
        jdk 'jdk-21'
    }

    environment {
        MAJOR_VERSION = "1"
        MINOR_VERSION = "0"
        SETTINGS_PATH = "C:\\ProgramData\\Jenkins\\.m2\\settings.xml"
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

    /*stage('Approval') {
    steps {
        input message: 'Proceed to Deploy?'
       }
    }*/
      /*  stage('Tag') {
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
        }*/

    stage('Ansible AWX Deployment') {
    steps {
        withCredentials([string(credentialsId: 'anisble_token', variable: 'AWX_TOKEN')]) {
            script {
                def awxHost = "http://16.16.94.149/"  // Replace with your AWX host
                def jobTemplateId = 9                        // Replace with your Job Template ID

                
                echo "🎯 Triggering AWX Job Template #${jobTemplateId}"

                curl -X POST \
				  -H "Accept: application/json" \
				  -H "Content-Type: application/json" \
				  -H "Authorization: Bearer ${AWX_TOKEN}" \
				  "${awxHost}/api/v2/job_templates/${jobTemplateId}/launch/"


                echo "AWX Response: ${response.content}"
            }
        }
    }
}


    stage('Build & Deploy') {
            steps {
                bat "mvn clean deploy -DskipTests=true -s %SETTINGS_PATH%"
            }
        }

        //stage to call Ansible Tower job template - yml Download from Nexus and deploy into the ec2 server and stop-start service.

        stage('Post Build Info') {
            steps {
                echo "✅ Build completed with custom version: ${env.CUSTOM_BUILD_VERSION}"
            }
        }
    }
}
