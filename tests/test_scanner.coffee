expect = require('chai').expect
fs = require 'fs'

scan = require '../scanner'
scanLine = scan.scanString

describe 'Scanner', ->
    describe 'Finding numbers: ', ->
        describe 'an integer declaration', ->
            tokens = scanLine 'x : int = 38437'
            it 'should contain the number', ->
                expect(tokens).to.contain {kind: 'INTLIT', lexeme: '38437', line: 1, col: 11}
            it 'should have 5 items', ->
                expect(tokens).to.have.length(5)
            it 'should contain the variable', ->
                expect(tokens).to.contain {kind: 'ID', lexeme: 'x', line: 1, col: 1}

        describe 'a float declaration', ->
            context 'with no zeros', ->
                tokens = scanLine 'pi : float = 3.1415'
                it 'should contain the number', ->
                    expect(tokens).to.contain {kind: 'FLOATLIT', lexeme: '3.1415', line: 1, col: 13}
                it 'should have five items', ->
                    expect(tokens).to.have.length(5)
                it 'should contain the variable', ->
                    expect(tokens).to.contain {kind: 'ID', lexeme: 'pi', line: 1, col: 1}

            context 'with leading zero', ->
                tokens = scanLine 'half : float = 0.5'
                it 'should contain the number', ->
                    expect(tokens).to.contain {kind: 'FLOATLIT', lexeme: '.5', line: 1, col: 16}
                it 'should have 5 tokens', ->
                    expect(tokens).to.have.length(5)
                it 'should contain the variable', ->
                    expect(tokens).to.contain {kind: 'ID', lexeme: 'half', line: 1, col: 1}

            context 'with no leading zero', ->
                tokens = scanLine 'half : float = .5'
                it 'should contain the number', ->
                    expect(tokens).to.contain {kind: 'FLOATLIT', lexeme: '.5', line: 1, col: 16}
                it 'should have 5 tokens', ->
                    expect(tokens).to.have.length(5)
                it 'should contain the variable', ->
                    expect(tokens).to.contain {kind: 'ID', lexeme: 'half', line: 1, col: 1}

    describe 'Finding declarations: ', ->
        context 'declaration with infered type', ->
            tokens = scanLine 'x := 5'
            it 'should have 3 tokens', ->
                expect(tokens).to.have.length(3)
            it 'should contain the variable', ->
                expect(tokens).to.contain {kind: 'ID', lexeme: 'x', line: 1, col: 1}
            it 'should contain :=', ->
                expect(tokens).to.contain {kind: ':=', lexeme: ':=', line: 1, col: 3}

        context 'declaration with type', ->
            tokens = scanLine 'x : int = 5'
            it 'should have 5 tokens', ->
                expect(tokens).to.have.length(5)
            it 'should have the variable', ->
                expect(tokens).to.contain {kind: 'ID', lexeme: 'x', line: 1, col: 1}
            it 'should have the colon', ->
                expect(tokens).to.contain {kind: ':', lexeme: ':', line: 1, col: 3}
            it 'should have the type', ->
                expect(tokens).to.contain {kind: 'int', lexeme: 'int', line: 1, col: 5}

    describe 'Finding string literals', ->
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
                expect(tokens).to.contain {kind: 'ID', lexeme: 'sound', line: 1, col: 4}

        context 'object with UTF8 in its name', ->
            tokens = scanLine '犛.聲音 = "咕嚕"' # This translates to yak.sound = grunt
            it 'should have the object name', ->
                expect(tokens).to.contain {kind: 'ID', lexeme: '犛', line: 1, col: 1}
            it 'should have the dot', ->
                expect(tokens).to.contain {kind: '.', lexeme: '.', line: 1, col: 2}
            it 'should have the property', ->
                expect(tokens).to.contain {kind: 'ID', lexeme: '聲音', line: 1, col: 3}

    describe 'Finding comments', ->
        context 'single line comments', ->
            tokens = scanLine 'x := 3 # This is a comment'
            it 'should only have the code tokens', ->
                expect(tokens).to.equal [{kind: 'ID', lexeme: 'x', line: 1, col: 1},
                                         {kind: ':=', lexeme: ':=', line: 1, col: 3},
                                         {kind: 'INTLIT', lexeme: '3', line: 1, col: 6}]

        context 'multiline comments', ->
            context 'with no trailing code', ->
                scan './test_files/scanner_multiline_1.yak', (tokens) ->
                    it 'should only have the code tokens', ->
                        expect(tokens).to.equal [{kind: 'ID', lexeme: 'x', line: 1, col: 1},
                                                 {kind: ':=', lexeme: ':=', line: 1, col: 3},
                                                 {kind: 'INTLIT', lexeme: '1', line: 1, col: 6},
                                                 {kind: 'ID', lexeme: 'x', line: 5, col: 1},
                                                 {kind: '=', lexeme: '=', line: 5, col: 3},
                                                 {kind: 'INTLIT', lexeme: '2', line: 5, col: 5}]

            context 'with trailing code', ->
                scan './test_files/scanner_multiline_2.yak', (tokens) ->
                    it 'should only have the code tokens', ->
                        expect(tokens).to.equal [{kind: 'ID', lexeme: 'x', line: 1, col: 1},
                                                 {kind: ':=', lexeme: ':=', line: 1, col: 3},
                                                 {kind: 'INTLIT', lexeme: '1', line: 1, col: 6},
                                                 {kind: 'ID', lexeme: 'x', line: 5, col: 1},
                                                 {kind: '=', lexeme: '=', line: 5, col: 3},
                                                 {kind: 'INTLIT', lexeme: '2', line: 5, col: 5}]

