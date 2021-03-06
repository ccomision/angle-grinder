grails.plugin.location.angleGrinder = "../ag-plugin"

grails {
    forkConfig = [maxMemory: 1024, minMemory: 512, debug: false, perm: 256, maxPerm: 512]
    project.fork = [
            test: forkConfig, // configure settings for the test-app JVM
            run : forkConfig, // configure settings for the run-app JVM
            war : forkConfig, // configure settings for the run-war JVM
            console: forkConfig // configure settings for the Swing console JVM
    ]
    tomcat { // settings for run-app and run-war
        classpath = "../9ci-app-conf"    // Put 9ci-config.groovy and such here
        jvmArgs = ["-Xms256m", "-Xmx1024m", "-XX:PermSize=256m", "-XX:MaxPermSize=512m"]
    }
    project {
        dependency.resolver = "maven"
        dependency.resolution = {
            inherits("global") {
                //excludes "yyy:0.1.5"
            }
            log "verbose" // log level of Ivy resolver, either "error", "warn", "info", "debug" or "verbose"
            repositories {
                //inherits true
                grailsPlugins()
                grailsHome()
                grailsCentral()
                mavenLocal()
                mavenCentral()
                mavenRepo(id: '9ci-artifactory', url: 'http://repo.9ci.com/artifactory/repo')
            }

            dependencies {
                // specify dependencies here under either "build", "compile", "runtime", "test" or "provided" scopes eg.
                build "commons-io:commons-io:2.3"
                compile "org.jadira.usertype:usertype.jodatime:2.0.1" //2.x for hibernate 4
            }
            plugins {
                // grails standard
                build ":tomcat:7.0.70"

                // plugin dependencies
                compile ":asset-pipeline:2.7.4"
                compile ":coffee-asset-pipeline:2.7.2"
                compile ":scaffolding:2.1.2"
                compile ':dao:1.0.3'
                compile(':audit-trail:2.1.2')
                compile ":plugin-config:0.1.8"
                compile ":faker:0.7"
                compile ":joda-time:1.5"

                test ":code-coverage:1.2.6"
            }
        }
        work.dir = ".grails"
    }
}
