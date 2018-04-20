'use strict';

const gulp = require('gulp');
const sass = require('gulp-sass');
const bs = require('browser-sync').create();

gulp.task('serve', ['sass'], function() {
    bs.init({
        notify: false,
        host: "localhost",
        server: "./",
        snippetOptions: {
            rule: {
                match: /<\/head>/i,
                fn: (snippet) => snippet
            }
        }
    });
    gulp.watch("./styles/scss/*.scss", ['sass']);
    gulp.watch("**/*.html").on('change', bs.reload);
});

gulp.task('sass', function() {
    return gulp.src("./styles/scss/*.scss")
        .pipe(sass({
            outputStyle: 'expanded',
            indentType: 'space',
            indentWidth: 4,
            linefeed: 'lf'
        }).on('error', sass.logError))
        .pipe(gulp.dest("./styles/css"))
        .pipe(bs.stream());
});

gulp.task('default', ['serve']);

