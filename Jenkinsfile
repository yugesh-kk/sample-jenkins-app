pipeline {
  agent any

  triggers {
    pollSCM('H/45 * * * *')
  }

  environment {
    IMAGE_NAME = "python-app"
    EC2_HOST = "ubuntu@<EC2-IP>"
    PEM_KEY = "/path/to/your-key.pem"  // Jenkins should have access to this key
    PYTHON_FILE = "app.py"
    DOCKERFILE_PATH = "Dockerfile"
    GITHUB_REPO = "https://github.com/<your-org>/<repo-name>.git"
  }

  stages {
    stage('Checkout') {
      steps {
        deleteDir()
        git "${GITHUB_REPO}"
      }
    }

    stage('Build Docker Image') {
      steps {
        sh "docker build -t ${IMAGE_NAME} -f ${DOCKERFILE_PATH} ."
      }
    }

    stage('Save & Copy Image to EC2') {
      steps {
        sh """
        docker save -o ${IMAGE_NAME}.tar ${IMAGE_NAME}
        scp -i ${PEM_KEY} ${IMAGE_NAME}.tar ${EC2_HOST}:/home/ubuntu/
        """
      }
    }

    stage('Run on EC2') {
      steps {
        sh """
        ssh -i ${PEM_KEY} ${EC2_HOST} << 'EOF'
          docker load -i /home/ubuntu/${IMAGE_NAME}.tar
          docker run --rm ${IMAGE_NAME}
        EOF
        """
      }
    }
  }

  post {
    success {
      echo "✅ Python app deployed and executed on EC2!"
    }
    failure {
      echo "❌ Deployment failed!"
    }
  }
}
