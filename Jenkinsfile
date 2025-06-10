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
        BRANCH_NAME = "master"
    }

    stages {
        stage('Checkout & Tag') {
            steps {
                script {
                    deleteDir()
                    checkout scm
                    echo "trigger configure"
                    echo "${env.BRANCH_NAME}"
                }
            }
        }
        stage('Build & Deploy') {
            steps {
                bat "mvn clean deploy -DskipTests=true -s %SETTINGS_PATH%"
            }
            post {
                success {
                    echo "✅ Build completed"
                    // buildAnsibleStage() // Uncomment if you want to call this function on success
                }
            }
        }
        // Uncomment the following stage if you want to deploy the Jar in Server within the pipeline
        
        stage('Deploy the Jar in Server') {
            when { expression {
            "${env.BRANCH_NAME}" == "master"
            } }
            steps {
                // Add your deployment steps here
                echo "Deploying Jar to server..."
                timeout(time: 72, unit: 'HOURS') {
                    input(id: 'uat', message: 'Deploy to UAT?', ok: 'Deploy')
                }
            }
            buildAnsibleStage()
            post {
                success {
                    echo "🚀 Jar deployed successfully!"
                }
                failure {
                    echo "❌ Jar deployment failed!"
                }
            }
        }
        
    }
}

// Define the buildAnsibleStage function outside the pipeline block
// This function is currently not called in the pipeline above,
// but can be uncommented in the 'Build & Deploy' stage's post section.
def buildAnsibleStage() {
    withCredentials([string(credentialsId: 'ansible_token', variable: 'AWX_TOKEN')]) {
        script {
            def awxHost = "http://16.16.94.149"
            def jobTemplateId = 10

            echo "🎯 Triggering AWX Job Template #${jobTemplateId}"

            // Using powershell for curl on Windows agents for better compatibility
            // For Linux/Unix agents, you'd typically use 'sh' instead of 'bat'
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
