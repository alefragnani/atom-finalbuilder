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
      description: 'Indicate the folder where FinalBuilder is installed'
      default: ''


  activate: (state) ->
    @finalbuilderView = new FinalbuilderView(state.finalbuilderViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @finalbuilderView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add '.pane atom-text-editor, .tree-view .selected', 'finalbuilder:open-in-ui', @doOpenInUI
    @subscriptions.add atom.commands.add '.pane atom-text-editor, .tree-view .selected', 'finalbuilder:build-with-ui', @doBuildWithUI
    @subscriptions.add atom.commands.add '.pane atom-text-editor, .tree-view .selected', 'finalbuilder:build-with-cmd', @doBuildWithCmd

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @finalbuilderView.destroy()

  serialize: ->
    finalbuilderViewState: @finalbuilderView.serialize()

  doOpenInUI: (e) =>
    fbu = new FinalBuilderUtils()
    filePath = fbu.getFilePathFromEvent(e)

    path = require('path')
    folder = path.dirname(filePath)

    aPath = fbu.getApplicationPath('FinalBuilder7.exe')

    cmdline = "\"#{aPath}\" \"#{filePath}\" "
    exec "start \"open ui\" " + cmdline, cwd: folder


  doBuildWithUI: (e) =>
    fbu = new FinalBuilderUtils()
    filePath = fbu.getFilePathFromEvent(e)

    path = require('path')
    folder = path.dirname(filePath)

    aPath = fbu.getApplicationPath('FinalBuilder7.exe')

    cmdline = "\"#{aPath}\" -r -a \"#{filePath}\" "
    exec "start \"build ui\" " + cmdline, cwd: folder


  doBuildWithCmd: (e) =>
    fbu = new FinalBuilderUtils()
    filePath = fbu.getFilePathFromEvent(e)

    path = require('path')
    folder = path.dirname(filePath)

    aPath = fbu.getApplicationPath('FBCMD.exe')

    cmdline = "\"#{aPath}\" /P\"#{filePath}\" "
    exec "start \"build cmd\" " + cmdline, cwd: folder
