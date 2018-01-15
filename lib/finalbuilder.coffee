FinalbuilderView = require './finalbuilder-view'
FinalBuilderUtils = require './finalbuilder-utils'

{CompositeDisposable} = require 'atom'

exec = require('child_process').exec
path = require('path')

module.exports = Finalbuilder =
  finalbuilderView: null
  modalPanel: null
  subscriptions: null

  config:
    installPath:
      type: 'string'
      title: 'FinalBuilder Installation Path'
      description: 'Indicates the folder where FinalBuilder is installed'
      default: ''

    installVersion:
      type: 'integer'
      title: 'FinalBuilder Version'
      description: 'Indicates the FinalBuilder Version'
      default: 7
      enum: [7, 8]


  activate: (state) ->
    @finalbuilderView = new FinalbuilderView(state.finalbuilderViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @finalbuilderView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add '.pane atom-text-editor, .tree-view .selected', 'finalbuilder:open-in-finalbuilder', @doOpenInFinalBuilder
    @subscriptions.add atom.commands.add '.pane atom-text-editor, .tree-view .selected', 'finalbuilder:build-in-finalbuilder', @doBuildInFinalBuilder
    @subscriptions.add atom.commands.add '.pane atom-text-editor, .tree-view .selected', 'finalbuilder:build-with-fbcmd', @doBuildWithFBCmd

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @finalbuilderView.destroy()

  serialize: ->
    finalbuilderViewState: @finalbuilderView.serialize()

  doOpenInFinalBuilder: (e) =>
    fbu = new FinalBuilderUtils()
    filePath = fbu.getFilePathFromEvent(e)

    path = require('path')
    folder = path.dirname(filePath)

    ver = 7
    if atom.config.get("finalbuilder.installVersion") == 8
      ver = 8
    aPath = fbu.getApplicationPath('FinalBuilder' + ver + '.exe')

    cmdline = "\"#{aPath}\" \"#{filePath}\" "
    exec "start \"open ui\" " + cmdline, cwd: folder


  doBuildInFinalBuilder: (e) =>
    fbu = new FinalBuilderUtils()
    filePath = fbu.getFilePathFromEvent(e)

    path = require('path')
    folder = path.dirname(filePath)

    ver = 7
    if atom.config.get("finalbuilder.installVersion") == 8
      ver = 8
    aPath = fbu.getApplicationPath('FinalBuilder' + ver + '.exe')

    cmdline = "\"#{aPath}\" -r -a \"#{filePath}\" "
    exec "start \"build ui\" " + cmdline, cwd: folder


  doBuildWithFBCmd: (e) =>
    fbu = new FinalBuilderUtils()
    filePath = fbu.getFilePathFromEvent(e)

    path = require('path')
    folder = path.dirname(filePath)

    aPath = fbu.getApplicationPath('FBCMD.exe')

    param = '/p'
    if atom.config.get("finalbuilder.installVersion") == 8
      param = ''
    cmdline = "\"#{aPath}\" " + param + "\"#{filePath}\" "
    console.log cmdline
    exec "start \"build cmd\" " + cmdline, cwd: folder
