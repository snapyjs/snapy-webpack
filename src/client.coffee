webpack = null
MemoryFS = null
module.exports = client: ({snap,position,Promise,config,util}) ->
  snap.hookIn position.before, (obj, {chalk}) ->
    if (webConf = obj.state.webpack)? and chalk?
      Promise.resolve()
      .then -> webConf
      .then (webConf) -> new Promise (res) ->
        webConf = {entry: webConf} if util.isString(webConf)
        webConf.mode ?= "development"

        unless webpack?
          webpack = require "webpack"
          MemoryFS = require "memory-fs"
        mfs = new MemoryFS()
        lines = []
        resolve = ->
          obj.state.obj = lines.join("\n")
          return res()
        try
          compiler = webpack webConf
        catch err
          lines.push err.toString()
          console.log err.stack if err.stack?
          resolve()
        compiler.outputFileSystem = mfs
        compiler.run (err, stats) ->
          if err?
            lines.push err.toString()
            lines.push err.details if err.details?
            console.log err.stack if err.stack?
          else 
            if stats.hasErrors()
              for error in stats.toJson().errors
                lines.push error.toString()
            else 
              if stats.hasWarnings()
                for warning in stats.toJson().warnings 
                  lines.push warning
              console.log stats.toString(chunks: false, colors: true) if config.verbose > 1
              lines = stats.compilation.chunks.map((chunk) => 
                name = chalk.bold("chunk: " + (chunk.name or chunk.id))
                if chunk.entryModule?
                  name += " ("+chunk.entryModule.id+")"
                lines2 = ["", name]
                chunk._modules.forEach (module) -> lines2.push "  " + module.id
                return lines2.join("\n")
              )
          resolve()
       