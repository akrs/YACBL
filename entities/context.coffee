class Context
    constructor: (parent) ->
        @parent    = parent ?= null
        @variables = Object.create(@parent)
