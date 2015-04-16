class StringPart
    constructor: (@parts) ->

    toString: ->
        return "#{parts.join(' ')}"

module.exports = StringPart
