class Program
    constructor: (@declarations) ->

  	# console.log @declarations

    toString: ->
        "(Program #{@declarations.join(' ')})"

module.exports = Program
 