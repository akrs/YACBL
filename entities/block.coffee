class Block
    constructor: (@statements) ->

    toString: ->
        "(#{@statements.join(' ')})"