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
        declarations.push parsePropertyDeclaration()
        break if at '}'

parsePropertyDeclaration = ->
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
    match 'EOL'

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

parsePrimitive = ->
    name = match 'ID'
    if at ':'
        match ':'
        type = parseType()
        if at '='
            match '='
            exp = parseExp()
    else
        match ':='
        exp = parseExp()

parseTupleDeclaration = ->
    names = []
    names.push match 'ID'
    while at ','
        match ','
        names.push match 'ID'
    if at ':'
        types = []
        types.push matchType()
        if at '='
            match '='
            exps = parseExpList()
    else
        match ':='
        exps = parseExpList()

parseExpList = ->
    exps = []
    exps.push parseExp()
    while at ','
        match ','
        parseExp()
    return exps

parseBlock = ->
    stmts = []
    match '{'
    match 'EOL'
    while not at 'EOL'
        if at ['ID', 'for', 'while', 'if']
            stmts.push parseDeclaration() if at 'ID'
            stmts.push parseIf() if at 'if'
            stmts.push parseForLoop() if at 'for'
            stmts.push parseWhileLoop() if at 'while'
            stmts.push parseAssignment() if at 'if'
        else
            stmts.push parseExp()
        match 'EOL'
    match '}'
    match 'EOL'

parseIf = ->
    match 'if'
    match '('
    condition = parseExp()
    match ')'
    block = parseBlock()

parseForLoop = ->
    match 'for'
    match '('
    innerId = match 'ID'
    match 'in'
    generator = if at 'ID' then match 'ID' else parseRange()
    block = parseBlock()

parseRange = ->
    leftSide = parseExp()
    op = if at '...' then match '...' else match '..<'
    rightSide = parseExp()

parseWhileLoop = ->
    match 'while'
    match '('
    condition = parseExp()
    match '('
    block = parseBlock()

parseAssignment = ->
    if nextIs ['ID', ',']
        ids = []
        ids.push match 'ID'
        while at ','
            match ','
            ids.push match 'ID'
        match '='
        exps = []
        exps.push parseExp()
        if at ','
            exps.push parseExp()
        # return tuple assign thingy
    else nextIs ['+=', '-=', '*=', '/=', '%=']
        id = match 'ID'
        op = match()
        exp = parseExp()
        # return modify assign thingy


parseExp = ->
    leftside = parseExp1()
    while at ['||', '&&']
        operation = if at '||' then match '||' else match '&&'
        rightside = parseExp1()

parseExp1 = ->
    leftside = parseExp2()
    if at ['<', '<=', '==', '!=', '>=', '>']
        operation = getExp1Op()
        rightside = parseExp2()

getExp1Op = ->
    if at '<' then match '<'
    else if at '<=' then match '<='
    else if at '==' then match '=='
    else if at '!=' then match '!='
    else if at '>=' then match '>='
    else match '>'

parseExp2 = ->
    leftside = parseExp3()
    while at ['|', '&', '^']
        operation = getExp2Op()
        rightside = parseExp3()

getExp2Op = ->
    if at '|' then match '|'
    else if at '&' then match '&'
    else if at '^' then match '^'

parseExp3 = ->
    leftside = parseExp4()
    while at ['<<', '>>']
        operation = if at '<<' then match '<<' else match '>>'
        rightside = parseExp4()

parseExp4 = ->
    leftside = parseExp5()
    while at ['+', '-']
        operation = if at '+' then match '+' else match '-'
        rightside = parseExp5()

parseExp5 = ->
    leftside = parseExp6()
    while at ['*', '/', '%']
        operation = getExp5Op()
        rightside = parseExp6()

getExp5Op = ->
    if at '*' then match '*'
    else if at '/' then match '/'
    else if at '%' then match '%'

parseExp6 = ->
    if at ['-', '!']
        operation = if at '-' then match '-' else match '!'
    rightside = parseExp7()

parseExp7 = ->
    if at ['++', '--']
        operation = if at '++' then match '++' else match '--'
    rightside = parseExp8()

parseExp8 = ->
    leftside = parseExp9()
    if at ['++', '--']
        operation = if at '++' then match '++' else match '--'

parseExp9 = ->
    if at 'ID' and nextIs '(' 
        parseFunc()
    else if at 'ID' 
        return match 'ID'
    else if at '('
        match '('
        result = parseExp()
        match ')'
        return result
    else 
        return

parseFuncCall = ->
    id = match 'ID'
    match '('
    params = []
    while not at ')'
        params.push parseExp()
        match ',' if at ','
    match ')'

at = (kind) -> 
    if tokens.length is 0
        return false
    else if Array.isArray kind
        return kind.some(at)
    else
        return kind is tokens[0].kind

match = (kind) ->
    if tokens.length is 0
        error 'Unexpected end of file'
    else if kind is undefined or kind is tokens[0].kind
        return tokens.shift()
    else
        error "Expected #{kind} but found #{tokens[0].kind}", tokens[0]
