var gulp = require('gulp'),
    gutil = require('gulp-util'),
    runSequence = require('run-sequence'),
    less = require('gulp-less'),
    clean = require('gulp-clean'),
    minifyHtml = require('gulp-minify-html'),
    ftp = require( 'vinyl-ftp' ),
    path = require('path'),
    LessPluginCleanCSS = require('less-plugin-clean-css'),
    cleancss = new LessPluginCleanCSS({
        advanced: true,
        mediaMerging: true
    });

var paths = {
    less: './public/css/*.less',
    html: './public/**/*.html',
    dest: './public',
    less_dest: './public/css'
};

gulp.task('clean', function () {
    return gulp.src(paths.less, {
        read: false
    })
        .pipe(clean());
});

gulp.task('less', function () {
    var DEST = './public/css';
    return gulp.src('./public/css/style.less')
        .pipe(less({
            plugins: [cleancss]
        }))
        .pipe(gulp.dest(paths.less_dest));
});

gulp.task('minify-html', function () {
    return gulp.src(paths.html)
        .pipe(minifyHtml({}))
        .pipe(gulp.dest(paths.dest));
});

gulp.task('deploy', function () {
    var connection = ftp.create({
        host: process.env.FTP_HOST,
        user: process.env.FTP_USER,
        password: process.env.FTP_PASSWORD,
        parallel: 2,
        log: gutil.log
    });

    var output = 'public/**';

    return gulp.src(output, {
        base: './public',
        buffer: false
    })
      .pipe(connection.newer('/'))
      .pipe(connection.dest('/'));
})

gulp.task('build', function (callback) {
    runSequence(['minify-html', 'less'], 'clean', callback);
});

gulp.task('default', ['build']);
