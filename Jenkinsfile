pipeline {
    agent any

    triggers{
        pollSCM('H/40 * * * *') // Polls the Git repo every 5 mins
    }

    tools {
        maven 'Maven 3.9.9'
        jdk 'jdk-21'
    }

    environment {
        MAJOR_VERSION = "1"
        MINOR_VERSION = "0"
        SETTINGS_PATH = "C:\\ProgramData\\Jenkins\\.m2\\settings.xml"
        BRANCH_NAME = "master"
    }

    stages {
        stage('Checkout & Tag') {
            steps {
                script {
                    deleteDir()
                    checkout scm
                    echo "🔁 Repository checked out"
                    echo "🔀 Branch: ${env.BRANCH_NAME}"
                }
            }
        }

        stage('Build & Deploy') {
            steps {
                bat "mvn clean deploy -DskipTests=true -s %SETTINGS_PATH%"
            }
            post {
                success {
                    echo "✅ Build completed successfully! 🏗️"
                    // buildAnsibleStage() // Uncomment if you want to trigger Ansible here
                }
            }
        }

        stage('Deploy the Jar in DEV Server') {
            when {
                expression {
                    env.BRANCH_NAME == "master"
                }
            }
            steps {
                echo "🚚 Ready to deploy to DEV..."
                timeout(time: 72, unit: 'HOURS') {
                    input(id: 'dev', message: 'Deploy to DEV?', ok: 'Deploy')
                }
                buildAnsibleStage()
            }
            post {
                success {
                    echo "✅ DEV Deployment successful! 🚀"
                }
                failure {
                    echo "❌ DEV Deployment failed! 💥"
                }
                aborted {
                    echo "⚠️ DEV Deployment aborted! ⛔"
                }
            }
        }

        stage('Deploy the Jar in QA Server') {
            when {
                expression {
                    env.BRANCH_NAME == "master"
                }
            }
            steps {
                echo "🚚 Ready to deploy to QA..."
                timeout(time: 72, unit: 'HOURS') {
                    input(id: 'qa', message: 'Deploy to QA?', ok: 'Deploy')
                }
                buildAnsibleStage()
            }
            post {
                success {
                    echo "✅ QA Deployment successful! 🚀"
                }
                failure {
                    echo "❌ QA Deployment failed! 💥"
                }
                aborted {
                    echo "⚠️ QA Deployment aborted! ⛔"
                }
            }
        }

        stage('Deploy the Jar in UAT Server') {
            when {
                expression {
                    env.BRANCH_NAME == "master"
                }
            }
            steps {
                echo "🚚 Ready to deploy to UAT..."
                timeout(time: 72, unit: 'HOURS') {
                    input(id: 'uat', message: 'Deploy to UAT?', ok: 'Deploy')
                }
                buildAnsibleStage()
            }
            post {
                success {
                    echo "✅ UAT Deployment successful! 🚀"
                }
                failure {
                    echo "❌ UAT Deployment failed! 💥"
                }
                aborted {
                    echo "⚠️ UAT Deployment aborted! ⛔"
                }
            }
        }
    }
}

// Define the buildAnsibleStage function outside the pipeline block
def buildAnsibleStage() {
    withCredentials([string(credentialsId: 'ansible_token', variable: 'AWX_TOKEN')]) {
        script {
            def awxHost = "http://16.16.94.149"
            def jobTemplateId = 10

            echo "🎯 Triggering AWX Job Template #${jobTemplateId}"

            bat """
                curl -X POST ^
                  -H "Accept: application/json" ^
                  -H "Content-Type: application/json" ^
                  -H "Authorization: Bearer ${AWX_TOKEN}" ^
                  "${awxHost}/api/v2/job_templates/${jobTemplateId}/launch/"
            """
        }
    }
}
