error = require './error'

tokens = []

module.exports = (scannerOutput) ->
    tokens = scannerOutput
    program = parseProgram()
    match 'EOF'
    return program

parseProgram = ->
    program = []
    loop
        program.push parseDeclaration()
        break if at 'EOF'
    return program

parseDeclaration = ->
    if at 'class'
        return parseClass()
    else if at 'ID'
        if nextIs 'func'
            return parseFunc()
        else if nextIs [':', ':=']
            return parsePrimitive()
        else if nextIs ','
            return parseTuple()
    else
        error "Declaration expected", tokens[0]

parseClass = ->
    match('class')
    name = match 'ID'
    match ':'
    parent = undefined
    if at 'ID'
        parent = match 'ID'
    else if at 'Obj'
        parent = match 'Obj'
    else if at 'Interface'
        parent = match 'Interface'
    else
        error "Expected parent but got #{tokens[0].kind}", tokens[0]
        return
    match '{'
    declarations = []
    loop
        declarations.push parseClassDeclaration()
        break if at '}'

parseClassDeclaration = ->
    if at 'public'
        accessLevel = match 'public'
    else if at 'private'
        accessLevel = match 'private'
    else if at 'protected'
        accessLevel = match 'protected'
    else
        error "Expected access level but got #{tokens[0].kind}", tokens[0]
        return

    if at 'class'
        declaration = parseClass()
    else if at 'ID'
        if nextIs 'func'
            declaration = parseFunc()
        else if nextIs [':', ':=']
            declaration = parsePrimitive()
            if at 'where'
                match 'where'
                where = matchExpression()

parseFunc = ->
    name = match 'ID'
    match 'func'
    match ':'
    match '('
    params = parseParameters()
    match ')'
    match '->'
    returns = parseReturns()
    block = parseBlock()

parseParameters = ->
    parameters = []
    while at 'ID'
        name = match 'ID'
        match ':'
        type = parseType()
        match ',' if at ','
        # parameters.push new param here
    return parameters

parseReturns = ->
    returns = []
    if at 'void'
        return #void
    loop
        if at 'ID'
            match 'ID'
            match ':'
        returns.push parseType()
    return returns

at = ->
    if tokens.length is 0
        return false
    else if Array.isArray kind
        return kind.some(at)
    else
        return kind is tokens[0].kind

matched = [] # push here whenever we pop off of tokens. This allows for restoration of state

match = (kind) ->
    if tokens.length is 0
        error 'Unexpected end of file'
    else if kind is undefined or kind is tokens[0].kind
        token = tokens.shift()
        matched.push(token)
        return token
    else
        error "Expected #{kind} but found #{tokens[0].kind}", tokens[0]
