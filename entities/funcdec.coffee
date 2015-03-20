class FuncDec
    constructor: (@id, @params, @return, @block) ->
        # Should we check length of declarations array?
    
    toString: ->
        "(Program #{@id} #{@params.join(' ')} 
                  #{@return} #{@block})"