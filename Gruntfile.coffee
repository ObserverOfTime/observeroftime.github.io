module.exports = (grunt) ->
  paths =
    config:
      puglint: '.pug-lintrc.json'
      stylelint: '.stylelintrc.json'
    code:
      css: './styles/*.css'
      html:
        root: './index.html'
        sciadv: './SciADVLists/*.html'
      pug:
        root: './views/index.pug'
        sciadv: './views/SciADVLists/*.pug'
      scss:
        full: './scss/*.scss'
        part: './scss/partials/*.scss'
      allFiles: -> @noPartials().concat [@scss.part]
      noPartials: -> Object.values(@html).concat [@css, @pug, @scss.full]
  pkg = require './package'

  grunt.initConfig
    browserSync: serve:
      options:
        ui: false
        notify: false
        watchTask: true
        host: 'localhost'
        server: './'
        snippetOptions: rule:
          match: /<\/head>/i
          fn: (snippet) => snippet
      bsFiles: src: paths.code.noPartials()
    bsReload:
      css: reload: ['main.css', 'sciadv.css']
      html: reload: Object.values paths.code.html
    concurrent:
      options: logConcurrentOutput: true
      lint: ['stylelint', 'puglint']
      build: ['sass', 'pug']
    pug:
      options: pretty: true
      dist: files: [
        expand: true
        cwd: 'views'
        src: ['**/*.pug', '!_mixins.pug']
        dest: ''
        ext: '.html'
      ]
    puglint: pug:
      options: extends: paths.config.puglint
      src: ['./views/**/*.pug']
    sass:
      options:
        implementation: require 'node-sass'
        outputStyle: 'compressed'
        indentType: 'space'
        indentWidth: 2
        linefeed: 'lf'
        sourceMap: false
      dist: files: [
        expand: true
        cwd: 'scss'
        src: ['**/*.scss', '!partials/*.scss']
        dest: 'styles'
        ext: '.css'
      ]
    stylelint: scss:
      options:
        configFile: paths.config.stylelint
        formatter: 'string'
        failOnError: true
        syntax: 'scss'
      src: Object.values paths.code.scss
    watch:
      options: spawn: false
      pug:
        files: Object.values paths.code.pug
        tasks: ['pug:dist', 'bsReload:html']
      scss:
        files: paths.code.scss.full
        tasks: ['sass:dist', 'bsReload:css']

  Object.keys(pkg.devDependencies).filter (dep) =>
    grunt.loadNpmTasks dep if dep.startsWith 'grunt-'

  grunt.registerTask 'default', ['browserSync', 'watch']
  return
