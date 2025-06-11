// Jenkinsfile for building, deploying, and promoting a Java application
pipeline {
    agent any

    // Define tools used in the pipeline
    tools {
        maven 'Maven 3.9.9' // Specify the Maven version
        jdk 'jdk-21'        // Specify the JDK version
    }

    // Define environment variables for the pipeline
    environment {
        // Application versioning
        MAJOR_VERSION = "1"
        MINOR_VERSION = "0"
        
        // Maven settings path (adjust for Linux/Unix if needed)
        SETTINGS_PATH = "C:\\ProgramData\\Jenkins\\.m2\\settings.xml" 
        
        // Branch name for conditional deployments
        BRANCH_NAME = "master"
    }

    stages {
        // Stage 1: Checkout and prepare the workspace
        stage('Checkout & Clean') {
            steps {
                script {
                    echo "🧹 Cleaning workspace and checking out SCM..."
                    deleteDir() // Clean the workspace to ensure a fresh build
                    checkout scm // Checkout the source code from SCM
                    echo "Current branch: ${env.BRANCH_NAME}"
                }
            }
        }

        // Stage 2: Build and deploy the application artifact
        stage('Build & Deploy Artifact') {
            steps {
                // Execute Maven clean and deploy, skipping tests for speed
                // Using bat for Windows commands, replace with 'sh' for Linux
                bat "mvn clean deploy -DskipTests=true -s \"${env.SETTINGS_PATH}\""
            }
            post {
                success {
                    echo "✅ Build and artifact deployment completed successfully!"
                    // Uncomment the following line to trigger Ansible deployment automatically on build success
                    // buildAnsibleStage() 
                }
                failure {
                    echo "❌ Build or artifact deployment failed. Check logs for details. 💥"
                }
            }
        }
        
        // --- Deployment Stages (Conditional on Branch) ---

        // Stage 3: Deploy to DEV Server
        stage('Deploy to DEV Server') {
            when {
                // Only deploy to DEV if on the master branch
                expression { return env.BRANCH_NAME == "master" }
            }
            steps {
                echo "🚀 Preparing to deploy Jar to DEV server..."
                timeout(time: 72, unit: 'HOURS') { // Long timeout for manual approval
                    input(id: 'devDeployConfirmation', message: 'Proceed with deployment to DEV?', ok: 'Deploy to DEV')
                }
                // Call the Ansible deployment function
                buildAnsibleStage() 
            }
            post {
                success {
                    echo "✅ Jar successfully deployed to DEV! 🎉"
                }
                failure {
                    echo "❌ Jar deployment to DEV failed! 🚨"
                }
                aborted {
                    echo "⚠️ Jar deployment to DEV aborted! 🛑"
                }
            }
        }

        // Stage 4: Deploy to QA Server
        stage('Deploy to QA Server') {
            when {
                // Only deploy to QA if on the master branch
                expression { return env.BRANCH_NAME == "master" }
            }
            steps {
                echo "🚀 Preparing to deploy Jar to QA server..."
                timeout(time: 72, unit: 'HOURS') {
                    input(id: 'qaDeployConfirmation', message: 'Proceed with deployment to QA?', ok: 'Deploy to QA')
                }
                // Call the Ansible deployment function
                buildAnsibleStage()
            }
            post {
                success {
                    echo "✅ Jar successfully deployed to QA! 🎉"
                }
                failure {
                    echo "❌ Jar deployment to QA failed! 🚨"
                }
                aborted {
                    echo "⚠️ Jar deployment to QA aborted! 🛑"
                }
            }
        }

        // Stage 5: Deploy to UAT Server
        stage('Deploy to UAT Server') {
            when {
                // Only deploy to UAT if on the master branch
                expression { return env.BRANCH_NAME == "master" }
            }
            steps {
                echo "🚀 Preparing to deploy Jar to UAT server..."
                timeout(time: 72, unit: 'HOURS') {
                    input(id: 'uatDeployConfirmation', message: 'Proceed with deployment to UAT?', ok: 'Deploy to UAT')
                }
                // Call the Ansible deployment function
                buildAnsibleStage()
            }
            post {
                success {
                    echo "✅ Jar successfully deployed to UAT! 🎉"
                }
                failure {
                    echo "❌ Jar deployment to UAT failed! 🚨"
                }
                aborted {
                    echo "⚠️ Jar deployment to UAT aborted! 🛑"
                }
            }
        }
    }
}

// --- Helper Functions ---

/**
 * Function to trigger an Ansible AWX job template.
 * This function uses a credential ID 'ansible_token' for authentication.
 * Ensure this credential is configured in Jenkins.
 */
def buildAnsibleStage() {
    // Ensure the AWX_TOKEN credential is available securely
    withCredentials([string(credentialsId: 'ansible_token', variable: 'AWX_TOKEN')]) {
        script {
            def awxHost = "http://16.16.94.149" // Your AWX server URL
            def jobTemplateId = 10             // The ID of your AWX job template

            echo "🎯 Triggering AWX Job Template #${jobTemplateId} on ${awxHost}..."

            // Using 'bat' for Windows agents; use 'sh' for Linux/Unix
            bat """
            curl -X POST ^
              -H "Accept: application/json" ^
              -H "Content-Type: application/json" ^
              -H "Authorization: Bearer ${AWX_TOKEN}" ^
              "${awxHost}/api/v2/job_templates/${jobTemplateId}/launch/"
            """
            echo "AWX job trigger command executed. Check AWX for status."
        }
    }
}
