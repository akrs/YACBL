chai = require 'chai'
expect = chai.expect
sinon = require 'sinon'
sinonChai = require 'sinon-chai'
chai.use sinonChai

error = require '../error'
sinon.stub(error, 'scannerError');

scan = require '../scanner'
scanLine = scan.scanString

describe 'Scanner', ->
    after 'remove stub', ->
        error.scannerError.restore()

    describe 'Finding numbers: ', ->
        describe 'an integer declaration', ->
            tokens = scanLine 'x : int = 38437'
            it 'should contain the number', ->
                expect(tokens).to.contain {kind: 'INTLIT', lexeme: '38437', line: 1, col: 11}
            it 'should have 6 tokens', ->
                expect(tokens).to.have.length(6)
            it 'should contain the variable', ->
                expect(tokens).to.contain {kind: 'ID', lexeme: 'x', line: 1, col: 1}

        describe 'a float declaration', ->
            context 'with no zeros', ->
                tokens = scanLine 'pi : float = 3.1415'
                it 'should contain the number', ->
                    expect(tokens).to.contain {kind: 'FLOATLIT', lexeme: '3.1415', line: 1, col: 14}
                it 'should have 6 tokens', ->
                    expect(tokens).to.have.length(6)
                it 'should contain the variable', ->
                    expect(tokens).to.contain {kind: 'ID', lexeme: 'pi', line: 1, col: 1}

            context 'with leading zero', ->
                tokens = scanLine 'half : float = 0.5'
                it 'should contain the number', ->
                    expect(tokens).to.contain {kind: 'FLOATLIT', lexeme: '0.5', line: 1, col: 16}
                it 'should have 6 tokens', ->
                    expect(tokens).to.have.length(6)
                it 'should contain the variable', ->
                    expect(tokens).to.contain {kind: 'ID', lexeme: 'half', line: 1, col: 1}

            context 'with no leading zero', ->
                tokens = scanLine 'half : float = .5'
                it 'should contain the number', ->
                    expect(tokens).to.contain {kind: 'FLOATLIT', lexeme: '.5', line: 1, col: 16}
                it 'should have 6 tokens', ->
                    expect(tokens).to.have.length(6)
                it 'should contain the variable', ->
                    expect(tokens).to.contain {kind: 'ID', lexeme: 'half', line: 1, col: 1}

    describe 'Finding declarations: ', ->
        context 'declaration with infered type', ->
            tokens = scanLine 'x := 5'
            it 'should have 4 tokens', ->
                expect(tokens).to.have.length(4)
            it 'should contain the variable', ->
                expect(tokens).to.contain {kind: 'ID', lexeme: 'x', line: 1, col: 1}
            it 'should contain :=', ->
                expect(tokens).to.contain {kind: ':=', lexeme: ':=', line: 1, col: 3}

        context 'declaration with type', ->
            tokens = scanLine 'x : int = 5'
            it 'should have 6 tokens', ->
                expect(tokens).to.have.length(6)
            it 'should have the variable', ->
                expect(tokens).to.contain {kind: 'ID', lexeme: 'x', line: 1, col: 1}
            it 'should have the colon', ->
                expect(tokens).to.contain {kind: ':', lexeme: ':', line: 1, col: 3}
            it 'should have the type', ->
                expect(tokens).to.contain {kind: 'int', lexeme: 'int', line: 1, col: 5}

    describe 'Finding assignments:', ->
        context 'literal assigned to variable', ->
            tokens = scanLine 'y = 5'
            it 'should have the id', ->
                expect(tokens).to.contain {kind: 'ID', lexeme: 'y', line: 1, col: 1}
            it 'should have the =', ->
                expect(tokens).to.contain {kind: '=', lexeme: '=', line: 1, col: 3}
            it 'should have the literal', ->
                expect(tokens).to.contain {kind: 'INTLIT', lexeme: '5', line: 1, col: 5}
        context 'variable assigned to variable', ->
            tokens = scanLine 'z = y'
            it 'should have the first id', ->
                expect(tokens).to.contain {kind: 'ID', lexeme: 'z', line: 1, col: 1}
            it 'should have the =', ->
                expect(tokens).to.contain {kind: '=', lexeme: '=', line: 1, col: 3}
            it 'should have the second id', ->
                expect(tokens).to.contain {kind: 'ID', lexeme: 'y', line: 1, col: 5}
        context 'multiple variables assigned to literals', ->
            tokens = scanLine 'x, y, z = 1, 2, 3'
            it 'should have the ids', ->
                expect(tokens).to.contain {kind: 'ID', lexeme: 'x', line: 1, col: 1}
                expect(tokens).to.contain {kind: 'ID', lexeme: 'y', line: 1, col: 4}
                expect(tokens).to.contain {kind: 'ID', lexeme: 'z', line: 1, col: 7}
            it 'should have the commas between the ids', ->
                expect(tokens).to.contain {kind: ',', lexeme: ',', line: 1, col: 2}
                expect(tokens).to.contain {kind: ',', lexeme: ',', line: 1, col: 5}
            it 'should have the literals', ->
                expect(tokens).to.contain {kind: 'INTLIT', lexeme: '1', line: 1, col: 11}
                expect(tokens).to.contain {kind: 'INTLIT', lexeme: '2', line: 1, col: 14}
                expect(tokens).to.contain {kind: 'INTLIT', lexeme: '3', line: 1, col: 17}
            it 'should have the commas between the literals', ->
                expect(tokens).to.contain {kind: ',', lexeme: ',', line: 1, col: 12}
                expect(tokens).to.contain {kind: ',', lexeme: ',', line: 1, col: 15}

    describe 'Finding string literals', ->
        context 'positive tests', ->
            context 'string with no internal quotes or UTF8', ->
                tokens = scanLine 'x := "Yaks grunt!"'
                it 'should have the string', ->
                    expect(tokens).to.contain {kind: 'STRLIT', lexeme: 'Yaks grunt!', line: 1, col: 7}
            context 'string with internal quotes', ->
                tokens = scanLine 'x := "Yaks say \\"hrumph\\""'
                it 'should have the string', ->
                    expect(tokens).to.contain {kind: 'STRLIT', lexeme: 'Yaks say \\"hrumph\\"', line: 1, col: 7}
            context 'string with internal UTF8', ->
                tokens = scanLine 'x := "Chinese for Yak is 犛"'
                it 'should have the string', ->
                    expect(tokens).to.contain {kind: 'STRLIT', lexeme: 'Chinese for Yak is 犛', line: 1, col: 7}
            context 'string with control characters', ->
                tokens = scanLine 'x := "Name\\tColor\\tTag number"'
                it 'should have the control characters', ->
                    expect(tokens).to.contain {kind: 'STRLIT', lexeme: 'Name\\tColor\\tTag number', line: 1, col: 7}
            context 'don\'t want to loose tokens around the string', ->
                tokens = scanLine 'print("Hello, World!")'
                it 'should have the tokens', ->
                    expect(tokens).to.contain {kind: '(', lexeme: '(', line: 1, col: 6}
                    expect(tokens).to.contain {kind: ')', lexeme: ')', line: 1, col: 22}
            context 'string with interpolation', ->
                tokens = scanLine 'x := "Yaks $(yak_sound)!"'
                it 'should have the parts of the string', ->
                    expect(tokens).to.contain {kind: 'STRPRT', lexeme: 'Yaks ', line: 1, col: 7}
                    expect(tokens).to.contain {kind: 'STRPRT', lexeme: '!', line: 1, col: 24}
                it 'should have the markers', ->
                    expect(tokens).to.contain {kind: '$(', lexeme: '$(', line: 1, col: 12}
                    expect(tokens).to.contain {kind: ')', lexeme: ')', line: 1, col: 23}
                it 'should have the interpolation part', ->
                    expect(tokens).to.contain {kind: 'ID', lexeme: 'yak_sound', line: 1, col: 14}
            context 'string with complex interpolation', ->
                tokens = scanLine 'x := "There are $((3 + 2) * 5) yaks"'
                it 'should have the parts of the string', ->
                    expect(tokens).to.contain {kind: 'STRPRT', lexeme: 'There are ', line: 1, col: 7}
                    expect(tokens).to.contain {kind: 'STRPRT', lexeme: ' yaks', line: 1, col: 31}
                it 'should have the markers', ->
                    expect(tokens).to.contain {kind: '$(', lexeme: '$(', line: 1, col: 17}
                    expect(tokens).to.contain {kind: ')', lexeme: ')', line: 1, col: 30}
                it 'should have the interpolation part', ->
                    expect(tokens).to.contain {kind: '(', lexeme: '(', line: 1, col: 19}
                    expect(tokens).to.contain {kind: 'INTLIT', lexeme: '3', line: 1, col: 20}
                    expect(tokens).to.contain {kind: '+', lexeme: '+', line: 1, col: 22}
                    expect(tokens).to.contain {kind: 'INTLIT', lexeme: '2', line: 1, col: 24}
                    expect(tokens).to.contain {kind: ')', lexeme: ')', line: 1, col: 25}
                    expect(tokens).to.contain {kind: '*', lexeme: '*', line: 1, col: 27}
                    expect(tokens).to.contain {kind: 'INTLIT', lexeme: '5', line: 1, col: 29}
            context 'string with multiple interpolation', ->
                tokens = scanLine 'print("$(x), $(y), $(z)")'
                it 'should have the $(s', ->
                    expect(tokens).to.contain {kind: '$(', lexeme: '$(', line: 1, col: 8}
                    expect(tokens).to.contain {kind: ')', lexeme: ')', line: 1, col: 11}
                    expect(tokens).to.contain {kind: '$(', lexeme: '$(', line: 1, col: 14}
                    expect(tokens).to.contain {kind: ')', lexeme: ')', line: 1, col: 17}
                    expect(tokens).to.contain {kind: '$(', lexeme: '$(', line: 1, col: 20}
                    expect(tokens).to.contain {kind: ')', lexeme: ')', line: 1, col: 23}
                it 'should have the string parts', ->
                    expect(tokens).to.contain {kind: 'STRPRT', lexeme: '', line: 1, col: 8}
                    expect(tokens).to.contain {kind: 'STRPRT', lexeme: ', ', line: 1, col: 12}
                    expect(tokens).to.contain {kind: 'STRPRT', lexeme: ', ', line: 1, col: 18}
                    expect(tokens).to.contain {kind: 'STRPRT', lexeme: '', line: 1, col: 24}
        context 'negative tests', ->
            beforeEach 'reset stub', ->
                error.scannerError.reset()
            it 'should error on unclosed "', (done) ->
                scanLine 'x := "This goes on and on'
                expect(error.scannerError).to.have.been.called
                done()
            it 'should error on an unclosed interpolation', (done) ->
                scanLine 'x := "This y is $(y'
                expect(error.scannerError).to.have.been.called
                done()
            it 'should error on an unclosed " after interpolation', (done) ->
                scanLine 'x := "This y is $(y)'
                expect(error.scannerError).to.have.been.called
                done()

    describe 'Finding ranges', ->
        context 'with numbers and ..<', ->
            tokens = scanLine 'for (x in 0 ..< 10) {'
            it 'should find the first bound', ->
                expect(tokens).to.contain {kind: 'INTLIT', lexeme: '0', line: 1, col: 11}
            it 'should find the second bound', ->
                expect(tokens).to.contain {kind: 'INTLIT', lexeme: '10', line: 1, col: 17}
            it 'should find ..<', ->
                expect(tokens).to.contain {kind: '..<', lexeme: '..<', line: 1, col: 13}
        context 'with numbers and ...', ->
            tokens = scanLine 'for (x in 0 ... 10) {'
            it 'should find the first bound', ->
                expect(tokens).to.contain {kind: 'INTLIT', lexeme: '0', line: 1, col: 11}
            it 'should find the second bound', ->
                expect(tokens).to.contain {kind: 'INTLIT', lexeme: '10', line: 1, col: 17}
            it 'should find ...', ->
                expect(tokens).to.contain {kind: '...', lexeme: '...', line: 1, col: 13}
        context 'with variables', ->
            tokens = scanLine 'for (x in y ... z) {'
            it 'should find the first bound', ->
                expect(tokens).to.contain {kind: 'ID', lexeme: 'y', line: 1, col: 11}
            it 'should find the second bound', ->
                expect(tokens).to.contain {kind: 'ID', lexeme: 'z', line: 1, col: 17}
            it 'should find ...', ->
                expect(tokens).to.contain {kind: '...', lexeme: '...', line: 1, col: 13}

    describe 'Finding object . properties', ->
        context '\'normal\' object', ->
            tokens = scanLine 's := yak.sound'
            it 'should have the object name', ->
                expect(tokens).to.contain {kind: 'ID', lexeme: 'yak', line: 1, col: 6}
            it 'should have the dot', ->
                expect(tokens).to.contain {kind: '.', lexeme: '.', line: 1, col: 9}
            it 'should have the property', ->
                expect(tokens).to.contain {kind: 'ID', lexeme: 'sound', line: 1, col: 10}

        context 'object with numbers in its name', ->
            tokens = scanLine 'y0.color = "black"'
            it 'should have the object name', ->
                expect(tokens).to.contain {kind: 'ID', lexeme: 'y0', line: 1, col: 1}
            it 'should have the dot', ->
                expect(tokens).to.contain {kind: '.', lexeme: '.', line: 1, col: 3}
            it 'should have the property', ->
                expect(tokens).to.contain {kind: 'ID', lexeme: 'color', line: 1, col: 4}

        context 'object with UTF8 in its name', ->
            tokens = scanLine '犛.聲音 = "咕嚕"' # This translates to yak.sound = grunt
            it 'should have the object name', ->
                expect(tokens).to.contain {kind: 'ID', lexeme: '犛', line: 1, col: 1}
            it 'should have the dot', ->
                expect(tokens).to.contain {kind: '.', lexeme: '.', line: 1, col: 2}
            it 'should have the property', ->
                expect(tokens).to.contain {kind: 'ID', lexeme: '聲音', line: 1, col: 3}

    describe 'Array indexing', ->
        context 'simple access', ->
            tokens = scanLine 'arr[1] = other_arr[1]'
            it 'should have the array ids', ->
                expect(tokens).to.contain {kind: 'ID', lexeme: 'arr', line: 1, col: 1}
                expect(tokens).to.contain {kind: 'ID', lexeme: 'other_arr', line: 1, col: 10}
            it 'should have all the square braces', ->
                expect(tokens).to.contain {kind: '[', lexeme: '[', line: 1, col: 4}
                expect(tokens).to.contain {kind: ']', lexeme: ']', line: 1, col: 6}
                expect(tokens).to.contain {kind: '[', lexeme: '[', line: 1, col: 19}
                expect(tokens).to.contain {kind: ']', lexeme: ']', line: 1, col: 21}
        context 'complex access', ->
            tokens = scanLine 'arr[3 + 5 * 6] = other_arr[some_function()]'
            it 'should have the array ids', ->
                expect(tokens).to.contain {kind: 'ID', lexeme: 'arr', line: 1, col: 1}
                expect(tokens).to.contain {kind: 'ID', lexeme: 'other_arr', line: 1, col: 18}
            it 'should have all the square braces', ->
                expect(tokens).to.contain {kind: '[', lexeme: '[', line: 1, col: 4}
                expect(tokens).to.contain {kind: ']', lexeme: ']', line: 1, col: 14}
                expect(tokens).to.contain {kind: '[', lexeme: '[', line: 1, col: 27}
                expect(tokens).to.contain {kind: ']', lexeme: ']', line: 1, col: 43}

    describe 'Finding comments', ->
        context 'single line comments', ->
            tokens = scanLine 'x := 3 # This is a comment'
            it 'should only have the code tokens', ->
                expect(tokens).to.eql [{kind: 'ID', lexeme: 'x', line: 1, col: 1},
                                       {kind: ':=', lexeme: ':=', line: 1, col: 3},
                                       {kind: 'INTLIT', lexeme: '3', line: 1, col: 6},
                                       {kind: 'EOL', lexeme: 'EOL', line: 1}]

        context 'multiline comments', ->
            context 'with no trailing code', ->
                it 'should only have the code tokens', (done) ->
                    scan './tests/test_files/scanner/multiline_1.yak', (tokens) ->
                        expect(tokens).to.eql [{kind: 'ID', lexeme: 'x', line: 1, col: 1},
                                               {kind: ':=', lexeme: ':=', line: 1, col: 3},
                                               {kind: 'INTLIT', lexeme: '1', line: 1, col: 6},
                                               {kind: 'EOL', lexeme: 'EOL', line: 1},
                                               {kind: 'EOL', lexeme: 'EOL', line: 2},
                                               {kind: 'EOL', lexeme: 'EOL', line: 3},
                                               {kind: 'EOL', lexeme: 'EOL', line: 4},
                                               {kind: 'ID', lexeme: 'x', line: 5, col: 1},
                                               {kind: '=', lexeme: '=', line: 5, col: 3},
                                               {kind: 'INTLIT', lexeme: '2', line: 5, col: 5},
                                               {kind: 'EOL', lexeme: 'EOL', line: 5},
                                               {kind: 'EOF', lexeme: 'EOF'}]
                        done()

            context 'with trailing code', ->
                it 'should only have the code tokens', (done) ->
                    scan './tests/test_files/scanner/multiline_2.yak', (tokens) ->
                        expect(tokens).to.eql [{kind: 'ID', lexeme: 'x', line: 1, col: 1},
                                               {kind: ':=', lexeme: ':=', line: 1, col: 3},
                                               {kind: 'INTLIT', lexeme: '1', line: 1, col: 6},
                                               {kind: 'EOL', lexeme: 'EOL', line: 1},
                                               {kind: 'ID', lexeme: 'x', line: 2, col: 4},
                                               {kind: '=', lexeme: '=', line: 2, col: 6},
                                               {kind: 'INTLIT', lexeme: '2', line: 2, col: 8},
                                               {kind: 'EOL', lexeme: 'EOL', line: 2},
                                               {kind: 'EOF', lexeme: 'EOF'}]
                        done()

