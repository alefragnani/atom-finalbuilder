path = require 'path'

module.exports =
class FinalBuilderUtils
  constructor: ->

  getFilePathFromEvent: (e) ->
    target = e.currentTarget
    filePath = target.getPath?() ? target.getModel?().getPath()

  getApplicationPath: (application) ->
    installPath = atom.config.get("finalbuilder.installPath")
    if installPath == undefined
      return
    fbPath = path.join(installPath, application)
