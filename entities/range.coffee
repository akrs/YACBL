class Range
    constructor: (@startIntLit, @upToAndIncludes, @endIntLit) ->

    toString: ->
        "(#{@startIntLit} #{@upToAndIncludes} #{@endIntLit})"

module.exports = Range