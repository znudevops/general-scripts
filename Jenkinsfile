pipeline{
    agent any
    stages{
        stage('clone'){
            steps{
                git 'https://github.com/znudevops/maven.git'
            }
        }
        stage('build'){
            steps{
                sh 'mvn package'
            }
        }
        stage('upload-to-s3'){
            steps{
                sh 'aws s3 cp /var/lib/jenkins/workspace/dev/webapp/target/webapp.war s3://test-bucket-20-05'
            }
        }
        stage('deploy-QA'){
            steps{
                sh 'ssh ec2-user@12.0.0.84 aws s3 cp s3://test-bucket-20-05/webapp.war /opt/tomcat/latest/webapps/testapp.war'
            }
        }
    }
}
