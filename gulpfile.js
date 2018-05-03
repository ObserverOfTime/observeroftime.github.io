'use strict';

const gulp = require('gulp');
const sass = require('gulp-sass');
const sasslint = require('gulp-sass-lint');
const htmllint = require('gulp-html5-lint');
const bs = require('browser-sync').create();

const files = {
    styles: {
        src: 'styles/scss/*.scss',
        dist: 'styles/css/'
    },
    pages: [
        './index.html',
        'SciADVLists/*.html'
    ]
};

function serve(done) {
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
    done();
}

function reload(done) {
    bs.reload();
    done();
}

function compile() {
    return gulp.src(files.styles.src)
        .pipe(sass({
            outputStyle: 'expanded',
            indentType: 'space',
            indentWidth: 4,
            linefeed: 'lf'
        }).on('error', sass.logError))
        .pipe(gulp.dest(files.styles.dist))
        .pipe(bs.stream());
}

function watch() {
    gulp.watch(files.styles.src, gulp.series(lintScss, compile));
    gulp.watch(files.pages, gulp.series(lintHtml, reload));
}

function lintScss() {
    return gulp.src(files.styles.src)
        .pipe(sasslint())
        .pipe(sasslint.failOnError());
}

function lintHtml() {
    return gulp.src(files.pages)
        .pipe(htmllint())
        .pipe(htmllint.failOnError());
}

gulp.task('lint', gulp.parallel(lintHtml, lintScss));
gulp.task('default', gulp.series(serve, compile, watch));

