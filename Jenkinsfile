pipeline {
  agent {
    label "builder-python-slim"
  }

  environment {
    ORG = 'datarich'
    DATE = "${sh(script: 'date +"%Y%m%d-%H%m"', returnStdout: true).trim()}"
    APP_NAME = 'epoch-api'
  }
  parameters {
    string(name: 'EPOCH_API_VERSION', defaultValue: '1.0', description: 'specify semver of base image')
  }
  stages {
    stage('Build and publish') {
      steps {
        container('builder') {
          script {
            sh "docker build --no-cache --network=host --build-arg EPOCH_API_VERSION=${params.EPOCH_API_VERSION}} -t $DOCKER_REGISTRY/$ORG/$APP_NAME:latest ."
            sh "docker image tag $DOCKER_REGISTRY/$ORG/$APP_NAME:latest $DOCKER_REGISTRY/$ORG/$APP_NAME:$EPOCH_API_VERSION-$DATE"
            sh "docker image push $DOCKER_REGISTRY/$ORG/$APP_NAME:$EPOCH_API_VERSION-$DATE"
            sh "docker image push $DOCKER_REGISTRY/$ORG/$APP_NAME:latest"
          }
        }
      }
    }
  }
