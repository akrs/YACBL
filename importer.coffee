fs = require 'fs'
byline = require 'byline'
{XRegExp} = require 'xregexp'

LETTER = XRegExp '[\\p{L}]'
DIGIT = XRegExp '[\\p{Nd}]'
WORD_CHAR = XRegExp '[\\p{L}\\p{Nd}_]'
IMPORT_LINE = XRegExp '/import ([a-zA-Z_][a-zA-Z0-9]*)\s*\n/'

importer = 
    listOfImports: []
    importCode : (filename, callback) ->    
        if filename not in importer.listOfImports    
            importer.listOfImports.push filename
            fs.writeFileSync 'imported.yac', fs.readFileSync filename, 'utf8'

        baseStream = fs.createReadStream filename, {encoding: 'utf8'}
        stream = byline baseStream, {keepEmptyLines: true}
        tokens = []
        linenumber = 0
        stream.on 'readable', () ->
            importer.scanForImports stream.read(), ++linenumber, 'imported.yac'
        stream.once 'end', () ->
            callback 'imported.yac'
    commenting : false
    scanForImports : (line, linenumber, filename) ->
        return if not line

        [start, pos] = [0, 0]
        interpolating = false
        interpolatingDepth = 0

        loop
            if commenting
                pos++ until (line.substring(pos, pos + 3) is '###') or (pos >= line.length)
                if pos >= line.length
                    break
                pos += 3
                commenting = false

            else
                # Skip spaces
                pos++ while /\s/.test line[pos]
                start = pos

                # Nothing on the line
                if pos >= line.length
                    break

                # Multi-line comment
                if line.substring(pos, pos + 3) is '###'
                    commenting = true
                    pos += 3
                    continue

                # Comment
                if line[pos] is '#'
                    break

                if /import ([a-zA-Z_][a-zA-Z0-9]*)\s*/.test line
                        # get the file name
                        file = line.substring(7) + '.yac'

                        # remove the import statement and write back to file
                        currentCode = fs.readFileSync(filename, 'utf8').toString()
                        indexOfLine = currentCode.indexOf line
                        newCode = currentCode.substring(0, indexOfLine) + currentCode.substring(indexOfLine + line.length)
                        fs.writeFileSync filename, newCode
                        
                        if file not in importer.listOfImports 
                            importer.listOfImports.push file
                            codeToImport = fs.readFileSync file, 'utf8'
                            fs.appendFileSync 'imported.yac', codeToImport
                            fs.appendFileSync 'imported.yac', '\n'
                        
                        if fs.readFileSync('imported.yac', 'utf8').toString().indexOf('import') > -1
                            console.log 'here'
                            importer.importCode 'imported.yac'
                        
                        break

                else
                    pos++

module.exports = importer














