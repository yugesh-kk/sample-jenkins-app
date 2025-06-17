pipeline {
  agent any

  environment {
    EC2_USER = 'ubuntu'
    EC2_HOST = '13.49.230.232'
    SSH_KEY = credentials('ec2-ssh-key')  // Upload PEM as Jenkins credential
    REPO_URL = 'https://github.com/your-username/my-python-app.git'
  }

  stages {
    stage('Clone Repository') {
      steps {
        git url: "${REPO_URL}"
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          docker.build('my-python-app')
        }
      }
    }

    stage('Install Python File on EC2') {
      steps {
        echo "⚙️ Copying app.py to EC2 instance..."
        sh """
          chmod 400 ${SSH_KEY}
          scp -o StrictHostKeyChecking=no -i ${SSH_KEY} app.py ${EC2_USER}@${EC2_HOST}:/home/ubuntu/
          ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${EC2_USER}@${EC2_HOST} 'python3 /home/ubuntu/app.py'
        """
      }
    }
  }
}
