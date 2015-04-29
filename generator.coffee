fs = require 'fs'
module.exports = (program) ->
    fs.writeFile "program.java", program.generator.java(), (error) ->
        console.error("Error writing file", error) if error
