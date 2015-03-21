var coffee  = require("gulp-coffee"),
    gulp    = require("gulp"),
    plumber = require("gulp-plumber"),
    watch   = require("gulp-watch");

var compileSrc = "src/**/*.coffee",
    templatesSrc = ["src/**/*", "!src/**/*.coffee"];

// Task
gulp.task('compile', function() {
  gulp.src(compileSrc)
    .pipe(plumber())
    .pipe(coffee({bare: true}))
    .pipe(gulp.dest("."));
});

// Templates files
gulp.task("templates", function() {
  gulp.src(templatesSrc, {base: "src/"})
    .pipe(plumber())
    .pipe(gulp.dest("."));
});

// Watch
gulp.task("watch", ["default"], function() {
  watch(compileSrc, function() {
    gulp.start("compile");
  });

  watch(templatesSrc, function() {
    gulp.start("templates");
  });
});

gulp.task("default", ["compile", "templates"]);
