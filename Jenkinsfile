pipeline {
  agent any

  triggers {
    pollSCM('H/45 * * * *') // Polls the git rep every 45 mins  
  }

  tools {
    maven 'Maven 3.9.9'
    jdk 'jdk-21'
  }

  environment{
    MAJOR_VERSION = "1"
    MINOR_VERSION = "0"
    SETTINGS_PATH = "C:\\ProgramData\\Jenkins\\.m2\\settings.xml"
    BRANCH_NAME = "master"
  }
  
  stages {
    stage ('Checkout & Tag'){
      steps {
        script{
          deleteDir()
          checkout scm
          def utils = load 'utils.groovy'
          utils.branchName('${env.BRANCH_NAME}')
        }
      }
    }

    stage('Build & Deploy') {
      steps{
        bat "mvn clean deploy -DskipTests=true -s %SETTINGS_PATH%"
      }
      post {
        success {
          echo "✅ Build completed successfully! 🏗️"
        }
      }
    }

    stage ('Deploy Success Confirmation') {
      when {
        expression {
          env.BRANCH_NAME == "master"
        }
      }
      steps {
        echo "🚚 Ready to deploy to DEV..."
        timeout(time: 2, unit: 'MINUTES') {
          input(id:'master', message:'Click for confirmation message', ok:'Deploy')
        }
                echo "Message printed below"
      }
                post{
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
    

    // stages & pipeline
  }
}
