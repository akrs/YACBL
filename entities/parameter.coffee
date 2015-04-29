class Parameter
    constructor: (@name, @type) ->

    toString: ->
        "(#{@name} : #{@type})"

module.exports = Parameter
