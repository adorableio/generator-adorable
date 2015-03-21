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
      message: "This will add boilerplate gulp files, and update your package.json. Do you want to continue?"
      default: true

    @prompt @prompts, (answers) =>
      for question, answer of answers
        @config[question] = answer
      done()

  projectfiles: ->
    return unless @config.generate
    @fs.copyTpl(
      @templatePath('_Gulpfile.js')
      @destinationPath('Gulpfile.js')
    )
    @fs.copy(
      @templatePath('gulp')
      @destinationPath('gulp')
    )

  packageFile: ->
    return unless @config.generate
    packageFile = {
      to: @destinationPath('package.json')
      from: @templatePath('_package.json')
    }
    return unless @fs.exists(packageFile.to)
    pkgTo = @fs.readJSON(packageFile.to)
    pkgFrom = @fs.readJSON(packageFile.from)

    @fs.writeJSON(packageFile.to, _.merge(pkgTo, pkgFrom))

   end: ->
    @options['callback'] = => @emit('allDone')

    @on 'allDone', ->
      @log chalk.green("\n# Awesome. Everything generated just fine!")
