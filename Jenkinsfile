#!/usr/bin/env groovy

def appName = env.JOB_NAME.split('/')[1]

node{
    // Run the tests
    stage('Run Tests'){
        docker.withServer(env.DOCKER_BUILD_HOST){
            sh "env"
            // Clean the workspace before each build
            deleteDir()
            // Get code
            checkout scm

            // Get commit hash since it isnt exposed by default
            sh "git rev-parse --short HEAD > .git/commit-id"
            commitId = readFile('.git/commit-id').trim()

            // Set image name
            imageId = "${appName}-test:${commitId}".trim()
            appEnv = docker.image(imageId)

            sh "docker build --tag ${imageId} --label BUILD_URL=${env.BUILD_URL} -f test.Dockerfile ."

            // Delete the test container
            sh "docker rmi ${imageId}"
        }
    }

    // If the tests pass, build the image if we're on master
    if (env.BRANCH_NAME == "master") {
        stage('Build Image') {
            docker.withServer(env.DOCKER_BUILD_HOST) {
                sh "env"

                // Get code
                checkout scm

                // Get commit hash since it isnt exposed by default
                sh "git rev-parse --short HEAD > .git/commit-id"
                commitId = readFile('.git/commit-id').trim()

                // Set image name
                imageId = "${appName}:${commitId}".trim()
                appEnv = docker.image(imageId)

                sh "docker build --tag ${imageId} --label BUILD_URL=${env.BUILD_URL} ."
            }
        }

//        stage('Publish Candidate Image') {
//            docker.withRegistry(env.DOCKER_REGISTRY_URL,
//                    "some-registry-secrets-for-your-environment") {
//                appEnv.push()
//                appEnv.push(env.BRANCH_NAME)
//            }
//        }

        // Call a job to deploy this to a development Kubernetes cluster:
//        stage('Deploy to DEV') {
//            build job: '../../k8s-deploy', parameters: [string(name: 'IMAGE', value: appName), string(name: 'VERSION', value: commitId)]
//        }

        stage('Cleanup') {
            sh "docker rmi ${imageId}"

            // Clean the workspace after each build.
            deleteDir()
        }
    }
}
