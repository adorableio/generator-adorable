'use strict'
yeoman  = require('yeoman-generator')
chalk   = require('chalk')
_       = require('lodash')

module.exports = AdorableGulpGenerator = yeoman.generators.Base.extend
  constructor: (args, options, config) ->
    yeoman.generators.Base.apply(this, arguments)

  init: ->
    @prompts = []
    @configPath = @destinationPath('config.json')

    try
      @config = require(@configPath)
    catch
      @config = {}

  askFor: ->
    done = @async()

    @log(chalk.magenta('You\'re using the fantastic adorable generator.'))

    @prompts.push
      name: 'generate',
      type: 'confirm',
      message: "This will scaffold an angular project. Do you want to continue?"
      default: true

    @prompts.push
      name: 'src',
      type: 'confirm',
      message: "Do you want to generate the full src folder?"
      default: true

    @prompts.push
      name: 'gulp',
      type: 'confirm',
      message: "Do you want to generate the gulp files?"
      default: true

    @prompt @prompts, (answers) =>
      for question, answer of answers
        @config[question] = answer
      done()

  projectFile: ->
    @fs.copy @templatePath('.jshintrc'), @destinationPath('.jshintrc')
    @fs.copy @templatePath('Gulpfile.js'), @destinationPath('Gulpfile.js')
    @fs.copy @templatePath('Procfile'), @destinationPath('Procfile')
    @fs.copy @templatePath('server.js'), @destinationPath('server.js')
    @fs.copy @templatePath('webpack.config.js'), @destinationPath('webpack.config.js')

  gulpfiles: ->
    return if !@config.generate || !@config.gulp
    @fs.copyTpl(
      @templatePath('_Gulpfile.js')
      @destinationPath('Gulpfile.js')
    )
    @fs.copy(
      @templatePath('gulp')
      @destinationPath('gulp')
    )

  srcfiles: ->
    return if !@config.generate || !@config.src
    @fs.copy(
      @templatePath('src')
      @destinationPath('src')
    )
    @fs.copyTpl(
      @templatePath('_src_app_components_data_data.js')
      @destinationPath('src/app/components/data/data.js')
    )
    @fs.copyTpl(
      @templatePath('_src_app_components_navbar_navbar.js')
      @destinationPath('src/app/components/navbar/navbar.js')
    )
    @fs.copyTpl(
      @templatePath('_src_app_index.jade')
      @destinationPath('src/app/index.jade')
    )
    @fs.copyTpl(
      @templatePath('_src_app_index.js')
      @destinationPath('src/app/index.js')
    )
    @fs.copyTpl(
      @templatePath('_src_app_main_main.js')
      @destinationPath('src/app/main/main.js')
    )
    @fs.copyTpl(
      @templatePath('_src_app_main_thing_thing.js')
      @destinationPath('src/app/main/thing/thing.js')
    )

  packageFile: ->
    return if !@config.generate
    packageFile = {
      to: @destinationPath('package.json')
      from: @templatePath('_package.json')
    }
    return if !@fs.exists(packageFile.to)
    pkgTo = @fs.readJSON(packageFile.to)
    pkgFrom = @fs.readJSON(packageFile.from)

    @fs.writeJSON(packageFile.to, _.merge(pkgTo, pkgFrom))

   end: ->
    @options['callback'] = => @emit('allDone')

    @on 'allDone', ->
      @log chalk.green("\n# Awesome. Everything generated just fine!")
