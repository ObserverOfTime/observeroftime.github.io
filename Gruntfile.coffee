module.exports = (grunt) ->
  paths =
    config:
      htmlhint: './config/htmlhintrc.json'
      stylelint: './config/stylelintrc.json'
    code:
      css: './styles/css/*.css'
      html:
        root: './index.html'
        sciadv: './SciADVLists/*.html'
      scss:
        full: './styles/scss/*.scss'
        part: './styles/scss/partials/*.scss'
      allFiles: -> @noPartials().concat [@scss.part]
      noPartials: -> Object.values(@html).concat [@css, @scss.full]
  pkg = require './package'

  grunt.initConfig
    browserSync: serve:
      options:
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
      lint: ['stylelint', 'htmlhintplus']
    htmlhintplus:
      options:
        htmlhintrc: paths.config.htmlhint
        output: ['console']
        newer: true
      html: Object.values paths.code.html
    sass:
      options:
        implementation: require 'node-sass'
        outputStyle: 'expanded'
        indentType: 'space'
        indentWidth: 2
        linefeed: 'lf'
        sourceMap: false
      dist: files:
        './styles/css/main.css': './styles/scss/main.scss'
        './styles/css/sciadv.css': './styles/scss/sciadv.scss'
    stylelint: scss:
      options:
        configFile: paths.config.stylelint
        formatter: 'string'
        failOnError: true
        syntax: 'scss'
      src: paths.code.scss.full
    watch:
      options: spawn: false
      scss:
        files: paths.code.scss.full
        tasks: ['sass:dist', 'bsReload:css']
      html:
        files: Object.values paths.code.html
        tasks: ['htmlhintplus', 'bsReload:html']

  Object.keys(pkg.devDependencies).filter (dep) =>
    grunt.loadNpmTasks dep if dep.startsWith 'grunt-'

  grunt.registerTask 'build', ['sass']
  grunt.registerTask 'lint', ['concurrent:lint']
  grunt.registerTask 'default', ['browserSync', 'watch']
  return

