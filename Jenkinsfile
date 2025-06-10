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

        stage('Build & Deploy') {
            steps {
                bat "mvn clean deploy -DskipTests=true -s %SETTINGS_PATH%"
            }
            post {
                success {
                    buildAnsibleStage()
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

            def curlCommand = """
            curl -X POST ^
              -H "Accept: application/json" ^
              -H "Content-Type: application/json" ^
              -H "Authorization: Bearer ${AWX_TOKEN}" ^
              "${awxHost}/api/v2/job_templates/${jobTemplateId}/launch/"
            """

            bat curlCommand
        }
    }
}
