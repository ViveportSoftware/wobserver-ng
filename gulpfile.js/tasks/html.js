const config = require('../config');
if (!config.html) return;

const gulp = require('gulp');
const path = require('path')
const htmlmin = require('gulp-htmlmin');

function html() {
  return gulp.src(path.join(config.root.src, config.html.src, config.html.pattern))
    .pipe(gulp.dest(path.join(config.root.dest, config.html.dest)));
}

function htmlProd() {
  return gulp.src(path.join(config.root.src, config.html.src, config.html.pattern))
    .pipe(htmlmin({ collapseWhitespace: true }))
    .pipe(gulp.dest(path.join(config.root.dest, config.html.dest)));
}

exports.html = html;
exports['html-prod'] = htmlProd;