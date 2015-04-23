class ReturnStatement
    constructor: (@exp) ->
    
    toString: ->
        "#{@exp}"

module.exports = ReturnStatement