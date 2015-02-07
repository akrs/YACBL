fs = require('fs')

printInput = (err, data) ->
    console.log(data)

fs.readFile('test.txt', 'utf8', printInput)

do ->
  fn = "test.txt"
  for line in fs.readFileSync(fn).toString().split '\n'
    console.log line
  console.log "DONE SYNC!"


LineByLineReader = (fn, cb) ->
  fs.open fn, 'r', (err, fd) ->
    bufsize = 256
    pos = 0
    text = ''
    eof = false
    closed = false
    reader =
      next_line: (line_cb, done_cb) ->
        if eof
          if text
            last_line = text
            text = ''
            line_cb last_line
          else
            done_cb()
          return
 
        new_line_index = text.indexOf '\n'
        if new_line_index >= 0
          line = text.substr 0, new_line_index
          text = text.substr new_line_index + 1, text.length - new_line_index - 1
          line_cb line
        else
          frag = new Buffer(bufsize)
          fs.read fd, frag, 0, bufsize, pos, (err, bytesRead) ->
            s = frag.toString('utf8', 0, bytesRead)
            text += s
            pos += bytesRead
            if (bytesRead)
              reader.next_line line_cb, done_cb
            else
              eof = true
              fs.closeSync(fd)
              closed = true
              reader.next_line line_cb, done_cb
        close: ->
          # The reader should call this if they abandon mid-file.
          fs.closeSync(fd) unless closed
 
    cb reader
 
# Test our interface here.
do ->
  console.log '---'
  fn = 'test.txt'
  LineByLineReader fn, (reader) -> 
    callbacks =
      process_line: (line) ->
         console.log line
         reader.next_line callbacks.process_line, callbacks.all_done
      all_done: ->
        console.log "DONE ASYNC!"
    reader.next_line callbacks.process_line, callbacks.all_done
 