class Block
    constructor: (@statements) ->

    toString: ->
        "(#{@statements.join(' ')})"

module.exports = Block