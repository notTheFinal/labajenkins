pipeline {
    agent { label 'agent-1' }

    stages {

        stage('Checkout DEV') {
            steps {
                git branch: 'dev', url: 'https://github.com/notTheFinal/labajenkins.git'
            }
        }

        stage('Build DEV image') {
            steps {
                sh '''
                echo "DEV build"
                docker build -t labapp:dev .
                '''
            }
        }

        stage('Deploy STAGING') {
            steps {
                sh '''
                docker stop labapp || true
                docker rm labapp || true
                docker run -d -p 8080:80 --name labapp -e ENV=STAGING labapp:dev
                '''
            }
        }

        stage('Test STAGING') {
            steps {
                sh '''
                sleep 2
                curl -f http://localhost:8080 | grep "Hello"
                '''
            }
        }

        stage('Promote to MAIN') {
            steps {
                sh '''
                git checkout main
                git pull origin main
                git merge dev || true
                git push origin main
                '''
            }
        }

        stage('Build MAIN image') {
            steps {
                sh '''
                echo "MAIN build"
                docker build -t labapp:main .
                '''
            }
        }

        stage('Deploy MAIN') {
            steps {
                sh '''
                docker stop labapp || true
                docker rm labapp || true
                docker run -d -p 8080:80 --name labapp -e ENV=MAIN labapp:main
                '''
            }
        }
    }

    post {
        failure {
            echo "FAIL → rollback staging"

            sh '''
            docker stop labapp || true
            docker rm labapp || true
            '''
        }
    }
}