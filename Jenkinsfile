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
                docker build --no-cache  -t labapp:dev .
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
                response=$(curl -s http://localhost:8080)

                echo "$response"

                echo "$response" | grep -qi STAGING
                '''
            }
        }

        stage('Promote to MAIN') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'github-creds',
                    usernameVariable: 'GIT_USER',
                    passwordVariable: 'GIT_PASS'
                )]) {
                    sh '''
                    git config user.email "jenkins@example.com"
                    git config user.name "Jenkins"

                    git remote set-url origin https://$GIT_USER:$GIT_PASS@github.com/notTheFinal/labajenkins.git

                    git checkout main
                    git pull origin main --rebase
                    git merge dev
                    git push origin main
                    '''
                }
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
                docker run -d -p 8081:80 --name labapp -e ENV=PROD labapp:main
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