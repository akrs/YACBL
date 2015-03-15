

class Program
    constructor: (@declarations) ->
        # Should we check length of declarations array?
    
    toString: ->
        "(Program #{@declarations.join(' ')})"