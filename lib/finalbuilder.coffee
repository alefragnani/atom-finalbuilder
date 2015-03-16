FinalbuilderView = require './finalbuilder-view'
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
    console.log 'openInUI'
    target = e.currentTarget
    filePath = target.getPath?() ? target.getModel?().getPath()
    path = require('path')
    folder = path.dirname(filePath)
    #aPath = getApplicationPath('FinalBuilder7.exe')

    installPath = atom.config.get("finalbuilder.installPath")
    if installPath == undefined or installPath == ''
      atom.notifications.addError('FinalBuilder Installation Path not defined')
      return
    aPath = path.join(installPath, 'FinalBuilder7.exe')

#    aPath = 'C:\\Program Files\\FinalBuilder 7\\FinalBuilder7.exe'
    cmdline = "\"#{aPath}\" \"#{filePath}\" "
    exec "start \"open ui\" " + cmdline, cwd: folder


  doBuildWithUI: (e) =>
    console.log 'buildWithUI'
    target = e.currentTarget
    filePath = target.getPath?() ? target.getModel?().getPath()
    path = require('path')
    folder = path.dirname(filePath)
    #aPath = getApplicationPath('FinalBuilder7.exe')
    #aPath = 'C:\\Program Files\\FinalBuilder 7\\FinalBuilder7.exe'
    installPath = atom.config.get("finalbuilder.installPath")
    if installPath == undefined or installPath == ''
      atom.notifications.addError('FinalBuilder Installation Path not defined')
      return
    aPath = path.join(installPath, 'FinalBuilder7.exe')
    cmdline = "\"#{aPath}\" -r -a \"#{filePath}\" "
    exec "start \"build ui\" " + cmdline, cwd: folder


  doBuildWithCmd: (e) =>
    console.log 'buildWithCmd'
    target = e.currentTarget
    filePath = target.getPath?() ? target.getModel?().getPath()
    path = require('path')
    folder = path.dirname(filePath)
    #aPath = getApplicationPath('FBCMD.exe')
    #aPath = 'C:\\Program Files\\FinalBuilder 7\\FBCMD.exe'
    installPath = atom.config.get("finalbuilder.installPath")
    if installPath == undefined or installPath == ''
      atom.notifications.addError('FinalBuilder Installation Path not defined')
      return
    aPath = path.join(installPath, 'FBCMD.exe')
    cmdline = "\"#{aPath}\" /P\"#{filePath}\" "
    exec "start \"build cmd\" " + cmdline, cwd: folder
