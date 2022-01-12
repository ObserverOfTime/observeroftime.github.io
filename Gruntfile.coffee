module.exports = (grunt) ->
  grunt.initConfig
    concurrent:
      options: logConcurrentOutput: true
      lint: ["stylint", "puglint"]
      build: ["stylus", "pug"]
    pug:
      options:
        pretty: true
        filters:
          img2obj: (text) -> text.replace(
            /<img .*src=(.+?)>/g,
            "<object type=\"image/svg+xml\" data=$1></object>"
          )
      dist: files: [
        expand: true
        cwd: "views"
        src: ["**/*.pug", "!_mixins.pug"]
        dest: "build"
        ext: ".html"
      ]
    puglint: pug:
      options: extends: ".pug-lintrc.json"
      src: ["views/**/*.pug"]
    stylus: compile:
      options: compress: true
      files:
        "build/styles/main.css": "stylus/main.styl"
        "build/styles/sciadv.css": "stylus/sciadv.styl"
    stylint:
      options: configFile: ".stylintrc.json"
      src: ["stylus/*.styl"]

  Object.keys((require "./package").devDependencies).filter (dep) =>
    grunt.task.loadNpmTasks dep if dep.startsWith "grunt-"

  grunt.registerTask "default", ["concurrent:build"]
  return
