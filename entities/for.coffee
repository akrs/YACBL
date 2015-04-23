class For
    # This should be varref, expresson, block
    constructor: (@innerId, @generator, @block) ->

    toString: ->
        "(#{@innerId} #{@generator} #{@block})"

    generator: {
        java: -> # TODO: check if type of generator is binary expression or iterable object
            if (@generator.op is "..<" or @generator.op is "...")
                return "for (int yac_#{@innerId.generator.java()} = #{@generator.leftSide.generator.java()}; i #{if @iterator.op is '..<' then '<' else '<='} #{@iterator.op.rightSide.generator.java()}; i++) #{@block.generator.java()}"
    }

module.exports = For
