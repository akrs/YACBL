fs = require 'fs'
module.exports = (program) ->
    fs.writeFile "Program.java", program.java(), (error) ->
        console.error("Error writing file", error) if error

lookup = Object.create(null)
lookup.main = 'main'
lookup.print = 'System.out.println'
module.exports.lookup = lookup