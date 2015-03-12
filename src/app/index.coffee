'use strict'
yeoman  = require('yeoman-generator')
chalk   = require('chalk')

module.exports = AdorableDocsGenerator = yeoman.generators.Base.extend
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

    @log(chalk.magenta('You\'re using the fantastic adorable-docs generator.'))

    @prompts.push
      name: 'generate',
      type: 'confirm',
      message: "Do you want to add the default adorable docs to this project?"
      default: true

    @prompt @prompts, (answers) =>
      for question, answer of answers
        @config[question] = answer
      done()

  projectfiles: ->
    @copy('CONTRIBUTING.md', 'CONTRIBUTING.md')

   end: ->
    @options['callback'] = => @emit('allDone')

    @on 'allDone', ->
      @log chalk.green("\n# Awesome. Everything generated just fine!")
