const config = require('../config');
if (!config.js) return;

const gulp = require('gulp');
const path = require('path')
const sourcemaps = require('gulp-sourcemaps');
const browserify = require('browserify');
const babelify = require('babelify');
const source = require('vinyl-source-stream');
const buffer = require('vinyl-buffer');
const uglify = require('gulp-uglify');
const concat = require("gulp-concat");

function createJs() {
  return browserify({ entries: path.join(config.root.src, config.js.src, 'app.js'), extensions: ['.js'], debug: true })
    .transform(babelify, { sourceMapsAbsolute: true, presets: ["@babel/preset-env"] })
    .bundle()
    .pipe(source('app.js'))
    .pipe(buffer())
    .pipe(sourcemaps.init({ loadMaps: true }))
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest(path.join(config.root.dest, config.js.dest)));
}

function createJsProd() {
  return browserify({ entries: path.join(config.root.src, config.js.src, 'app.js'), extensions: ['.js'], debug: false })
    .transform(babelify, { sourceMapsAbsolute: false, presets: ["@babel/preset-env"] })
    .bundle()
    .pipe(source('app.js'))
    .pipe(buffer())
    .pipe(uglify())
    .pipe(gulp.dest(path.join(config.root.dest, config.js.dest)));
}

function js() {
  return gulp.src([
    path.join(config.root.src, config.js.src, 'external/*'),
    path.join(config.root.dest, config.js.dest, 'app.js')
  ])
    .pipe(buffer())
    .pipe(sourcemaps.init({ loadMaps: true }))
    .pipe(concat('app.js'))
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest(path.join(config.root.dest, config.js.dest)));
}

function jsProd() {
  return gulp.src([
    path.join(config.root.src, config.js.src, 'external/*'),
    path.join(config.root.dest, config.js.dest, 'app.js')
  ])
    .pipe(buffer())
    .pipe(uglify())
    .pipe(concat('app.js'))
    .pipe(gulp.dest(path.join(config.root.dest, config.js.dest)));
}

exports['create-js'] = createJs;
exports['create-js-prod'] = createJsProd;
exports['js'] = gulp.series(createJs, js);
exports['js-prod'] = gulp.series(createJsProd, jsProd);