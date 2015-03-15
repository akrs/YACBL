class PrimDec 
    constructor: (@id, @type, @exp) ->
    
    toString: ->
        "(Program #{@id} #{@type} #{@exp})"
