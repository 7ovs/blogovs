module.exports = (grunt) ->
  grunt.loadNpmTasks("grunt-contrib-coffee")
  grunt.loadNpmTasks("grunt-contrib-copy")
  grunt.loadNpmTasks("grunt-contrib-less")
  grunt.loadNpmTasks("grunt-contrib-concat")
  grunt.loadNpmTasks("grunt-contrib-cssmin")
  grunt.loadNpmTasks("grunt-contrib-uglify")
  grunt.loadNpmTasks("grunt-contrib-clean")
  grunt.loadNpmTasks("grunt-contrib-watch")


  APP_DIR = 'app'
  TMP_DIR = 'tmp'
  DEV_DIR = 'dev'
  DST_DIR = 'dst'
  BOWER = 'bower_components'

  grunt.initConfig

    #=== COFFEE
    coffee:
      client:
        files:
          "#{TMP_DIR}/js/app.js": "#{APP_DIR}/scripts/app.coffee"

      server:
        options:
          bare: yes
        files:
          "#{DEV_DIR}/web.js": "#{APP_DIR}/app.coffee"


    #=== LESS
    less:
      core:
        options:
          paths: [
            "#{APP_DIR}/styles"
            "bower_components/uikit/src/less"
          ]
        files:
          "#{DEV_DIR}/pub/css/uikit.css": "#{APP_DIR}/styles/uikit.less"


      app:
        options:
          paths: [
            "#{APP_DIR}/styles"
            "bower_components/uikit/less"
          ]
        files:
          "#{DEV_DIR}/pub/css/app.css": "#{APP_DIR}/styles/app.less"


    #=== CONCAT
    concat:

      core:
        src: [
          "#{BOWER}/jquery/dist/jquery.js"
          "#{BOWER}/lodash/dist/lodash.js"
          "#{BOWER}/angular/angular.js"
          "#{BOWER}/moment/min/moment.min.js"
          "#{BOWER}/moment/min/langs.min.js"
          "#{BOWER}/uikit/dist/js/uikit.js"
          "#{BOWER}/uikit/dist/js/uikit-icons.js"
        ]
        dest: "#{DEV_DIR}/pub/js/core.js"


      app:
        src: [
          "#{TMP_DIR}/js/app.js"
        ]
        dest: "#{DEV_DIR}/pub/js/app.js"


    copy:
      dev:
        files: [
            expand: yes
            cwd: "#{APP_DIR}/static/"
            src: "**"
            dest: "#{DEV_DIR}/pub/"
          ,
            expand: yes
            cwd: "#{BOWER}/uikit/fonts/"
            src: "**"
            dest: "#{DEV_DIR}/pub/fonts"
          ,
            expand: yes
            src: ["package.json", "Procfile"]
            dest: "dev"
            filter: 'isFile'
        ]
      views:
        files: [
            expand: yes
            cwd: "#{APP_DIR}/views/"
            src: "**"
            dest: "#{DEV_DIR}/views"
        ]


    clean:
      dev: [
        "#{DEV_DIR}/**"
      ]
      temp: ["tmp"]
      pub: ["#{DEV_DIR}/pub/**", "#{DEV_DIR}/views/**"]

    watch:
      styles:
        files: ["#{APP_DIR}/styles/*.less"]
        tasks: ["less"]
        options:
          spawn: no

      coffee_client:
        files: ["#{APP_DIR}/scripts/*.coffee"]
        tasks: ["coffee"]
        options:
          spawn: no

      coffee_server:
        files: ["#{APP_DIR}/app.coffee"]
        tasks: ["coffee:server"]
        options:
          spawn: no

      view:
        files: ["#{APP_DIR}/views/**"]
        tasks: ["copy:views"]
        options:
          spawn: no

      gruntfile:
          files: ["Gruntfile.coffee"]
          tasks: ["default"]
          options:
            reload: yes

    grunt.registerTask "default", ["clean:pub", "coffee", "less", "concat", "copy", "clean:temp"]