/*
 * Copyright:: Copyright (c) 2017-present Sonatype, Inc. Apache License, Version 2.0.
 */
@Library(['ci-pipeline-library@INT-add-version-tools', 'jenkins-shared']) _
import com.sonatype.jenkins.pipeline.GitHub
import com.sonatype.jenkins.pipeline.OsTools
import com.sonatype.jenkins.pipeline.VersionTools

properties([
  parameters([
    string(defaultValue: '', description: 'New Nexus IQ Version', name: 'nexus_iq_version'),
    string(defaultValue: '', description: 'New Nexus IQ Version Sha256', name: 'nexus_iq_version_sha'),
    string(defaultValue: '20', description: 'Kitchen concurrency', name: 'KITCHEN_TEST_CONCURRENCY'),
    string(defaultValue: '', description: 'Kitchen additional parameters', name: 'KITCHEN_TEST_PARAMS')
  ])
])
node('ubuntu-chef-zion') {
  def commitId, version, imageId, apiToken, branch, defaultsFileLocation, majorMinorVersion
  def organization = 'sonatype',
      repository = 'chef-nexus-iq-server',
      credentialsId = 'integrations-github-api',
      archiveName = 'chef-nexus-iq-server.tar.gz',
      cookbookName = 'nexus_iq_server'
  GitHub gitHub
  VersionTools versionTools

  try {
    stage('Preparation') {
      deleteDir()

      versionTools = new VersionTools(this, currentBuild)

      def checkoutDetails = checkout scm
      branch = checkoutDetails.GIT_BRANCH == 'origin/master' ? 'master' : checkoutDetails.GIT_BRANCH
      commitId = checkoutDetails.GIT_COMMIT

      majorMinorVersion = readVersion().split('-')[0]
      version = versionTools.getCommitVersion(majorMinorVersion, commitId)
      setBuildDisplayName Version: version

      OsTools.runSafe(this, 'git config --global user.email sonatype-ci@sonatype.com')
      OsTools.runSafe(this, 'git config --global user.name Sonatype CI')

      withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: credentialsId,
                        usernameVariable: 'GITHUB_API_USERNAME', passwordVariable: 'GITHUB_API_PASSWORD']]) {
        apiToken = env.GITHUB_API_PASSWORD
      }
      gitHub = new GitHub(this, "${organization}/${repository}", apiToken)
    }
    if (params.nexus_iq_version && params.nexus_iq_version_sha) {
      stage('Update IQ Version') {
        OsTools.runSafe(this, "git checkout ${branch}")
        defaultsFileLocation = "${pwd()}/attributes/default.rb"
        def defaultsFile = readFile(file: defaultsFileLocation)

        def versionRegex = /(default\['nexus_iq_server'\]\['version'\] = ')(\d\.\d{1,3}\.\d\-\d{2})(')/
        def shaRegex = /(default\['nexus_iq_server'\]\['checksum'\] = ')([A-Fa-f0-9]{64})(')/

        defaultsFile = defaultsFile.replaceAll(versionRegex, "\$1${params.nexus_iq_version}\$3")
        defaultsFile = defaultsFile.replaceAll(shaRegex, "\$1${params.nexus_iq_version_sha}\$3")

        writeFile(file: defaultsFileLocation, text: defaultsFile)
      }
    }
    stage('Build') {
      gitHub.statusUpdate commitId, 'pending', 'build', 'Build is running'

      def gemInstallDirectory = getGemInstallDirectory()
      withEnv(["PATH+GEMS=${gemInstallDirectory}/bin"]) {
        OsTools.runSafe(this, 'berks package')
        dir('build/target') {
          OsTools.runSafe(this, "mv ${WORKSPACE}/cookbooks-*.tar.gz ${archiveName}")
        }
      }

      if (currentBuild.result == 'FAILURE') {
        gitHub.statusUpdate commitId, 'failure', 'build', 'Build failed'
        return
      } else {
        gitHub.statusUpdate commitId, 'success', 'build', 'Build succeeded'
      }
    }
    stage('Test') {
      gitHub.statusUpdate commitId, 'pending', 'test', 'Tests are running'

      dir('build/target') {
        OsTools.runSafe(this, "tar -zxvf ${archiveName}")
      }

      OsTools.runSafe(this, 'chef gem install kitchen-docker')
      sh 'kitchen test -c ${KITCHEN_TEST_CONCURRENCY} -d always --no-color ${KITCHEN_TEST_PARAMS}'

      if (currentBuild.result == 'FAILURE') {
        gitHub.statusUpdate commitId, 'failure', 'test', 'Tests failed'
        return
      } else {
        gitHub.statusUpdate commitId, 'success', 'test', 'Tests succeeded'
      }
    }
    if (currentBuild.result == 'FAILURE') {
      return
    }
    if (params.nexus_iq_version && params.nexus_iq_version_sha) {
      stage('Commit IQ Version Update') {
        withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'integrations-github-api',
                        usernameVariable: 'GITHUB_API_USERNAME', passwordVariable: 'GITHUB_API_PASSWORD']]) {
          OsTools.runSafe(this, """
            git add ${defaultsFileLocation}
            git commit -m 'Update IQ Server to ${params.nexus_iq_version}'
            git push https://${env.GITHUB_API_USERNAME}:${env.GITHUB_API_PASSWORD}@github.com/${organization}/${repository}.git ${branch}
          """)

          version = versionTools.getCommitVersion(majorMinorVersion, OsTools.runSafe(this, "git rev-parse HEAD"))
          setBuildDisplayName Version: version
        }
      }
    }
    stage('Archive') {
      dir('build/target') {
        archiveArtifacts artifacts: "${archiveName}", onlyIfSuccessful: true
      }
    }
    if (branch != 'master') {
      return
    }
    input 'Push tags?'
    stage('Push tags') {
      withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: credentialsId,
                        usernameVariable: 'GITHUB_API_USERNAME', passwordVariable: 'GITHUB_API_PASSWORD']]) {
        OsTools.runSafe(this, "git tag \"release-${version}\"")
        OsTools.runSafe(this, """
          git push \
          https://${env.GITHUB_API_USERNAME}:${env.GITHUB_API_PASSWORD}@github.com/${organization}/${repository}.git \
            release-${version}
        """)
      }
    }
    stage('Create release') {
      response = httpRequest customHeaders: [[name: 'Authorization', value: "token ${apiToken}"]],
          acceptType: 'APPLICATION_JSON', contentType: 'APPLICATION_JSON', httpMode: 'POST',
          requestBody: "{\"tag_name\": \"release-${version}\"}",
          url: "https://api.github.com/repos/${organization}/${repository}/releases"

      def release = readJSON text: response.content
      def releaseId = release.id

      response = OsTools.runSafe(this, """
        curl -H "Authorization: token ${apiToken}" \
             -H "Accept: application/vnd.github.manifold-preview" \
             -H "Content-Type: application/gzip" \
             --data-binary @build/target/${archiveName} \
             "https://uploads.github.com/repos/${organization}/${repository}/releases/${releaseId}/assets?name=${archiveName}"
      """)
    }
  } finally {
    OsTools.runSafe(this, 'git clean -f && git reset --hard origin/master')
  }
}
def readVersion() {
  readFile('version').split('\n')[0]
}
def getGemInstallDirectory() {
  def content = OsTools.runSafe(this, "gem env")
  for (line in content.split('\n')) {
    if (line.startsWith('  - USER INSTALLATION DIRECTORY: ')) {
      return line.substring(33)
    }
  }
  error 'Could not determine user gem install directory.'
}
