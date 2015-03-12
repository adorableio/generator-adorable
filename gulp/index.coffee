coffee  = require("gulp-coffee")
gulp    = require("gulp")
plumber = require("gulp-plumber")
watch   = require("gulp-watch")

srcPath = "src/**/*.coffee"
# Task
gulp.task 'compile', ->
  gulp.src(srcPath)
    .pipe(plumber())
    .pipe(coffee({bare: true}))
    .pipe(gulp.dest("."))

# Watch
gulp.task "watch", ["default"], ->
  watch(srcPath, -> gulp.start("compile"))

gulp.task("default", ["compile"])
