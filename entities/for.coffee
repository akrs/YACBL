class For
    constructor: (@innerId, @iterator, @block) ->

    toString: ->
        "(#{@innerId} #{@iterator} #{@block})"

    generator: {
        java: -> # TODO: check if type of iterator is binary expression or iterable object
            if (@iterator.op is "..<" or @iterator.op is "...")
                return "for (int yac_#{@innerId.generator.java()} = #{@iterator.leftSide.generator.java()}; i #{if @iterator.op is '..<' then '<' else '<='} #{@iterator.op.rightSide.generator.java()}; i++) #{@block.generator.java()}"
    }

module.exports = For
