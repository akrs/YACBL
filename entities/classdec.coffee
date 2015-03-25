class ClassDec
    constructor: (@id, @type, @propdec) ->
    
    toString: ->
        "(Program #{@id} #{@type} #{@propdec.join(' ')})"

module.exports = ClassDec