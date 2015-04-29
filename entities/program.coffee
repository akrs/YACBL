class Program
    constructor: (@declarations) ->

    toString: ->
        "(Program #{@declarations.join(' ')})"

module.exports = Program
