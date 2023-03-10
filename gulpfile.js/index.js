const gulp = require('gulp');
const requireDir = require('require-dir');

const { css, js, html, watch } = requireDir('./tasks', { recurse: true });

exports.build = gulp.series(css['css'], js['js'], html['html']);
exports.deploy = gulp.series(css['css-prod'], js['js-prod'], html['html-prod']);

// Define default task as a series of build and watch tasks
exports.default = gulp.series(exports.build, watch['watch']);