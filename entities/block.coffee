class Block
    constructor: (@statements) ->

    console.log @statements

    toString: ->
        "(#{@statements.join(' ')})"

module.exports = Block