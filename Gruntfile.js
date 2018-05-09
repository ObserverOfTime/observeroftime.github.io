module.exports = function(grunt) {

  grunt.initConfig({
    browserSync: {
      serve: {
        options: {
          notify: false,
          watchTask: true,
          host: 'localhost',
          server: './',
          snippetOptions: {
            rule: {
              match: /<\/head>/i,
              fn: (snippet) => snippet
            }
          }
        },
        bsFiles: {
          src: [
            './styles/css/*.css',
            './*.html',
            './SciADVLists/*.html'
          ]
        }
      }
    },
    concurrent: {
      options: {
        logConcurrentOutput: true
      },
      lint: ['stylelint', 'htmlhintplus']
    },
    htmlhintplus: {
      options: {
        htmlhintrc: 'config/htmlhintrc.json',
        output: ['console'],
        newer: true
      },
      html: [
        './index.html',
        './SciADVLists/*.html'
      ]
    },
    sass: {
      options: {
        outputStyle: 'expanded',
        indentType: 'space',
        indentWidth: 2,
        linefeed: 'lf',
        sourceMap: false
      },
      dist: {
        files: {
          './styles/css/sciadv.css': './styles/scss/sciadv.scss'
        }
      }
    },
    stylelint: {
      scss: {
        options: {
          configFile: 'config/stylelintrc.json',
          formatter: 'string',
          failOnError: true,
          syntax: 'scss'
        },
        src: ['./styles/scss/*.scss']
      }
    },
    watch: {
      options: {
        spawn: false,
      },
      scss: {
        files: './styles/scss/*.scss',
        tasks: ['sass']
      },
      html: {
        files: ['./index.html', './SciADVLists/*.html'],
        tasks: ['htmlhintplus']
      }
    }
  });

  grunt.loadNpmTasks('grunt-browser-sync');
  grunt.loadNpmTasks('grunt-concurrent');
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-htmlhint-plus');
  grunt.loadNpmTasks('grunt-sass');
  grunt.loadNpmTasks('grunt-stylelint');

  grunt.registerTask('build', ['sass']);
  grunt.registerTask('lint', ['concurrent:lint']);
  grunt.registerTask('default', ['browserSync', 'watch']);
};
