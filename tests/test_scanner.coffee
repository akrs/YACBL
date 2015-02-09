expect = require('chai').expect
fs = require 'fs'

scan = require '../scanner'
scanLine = scan.scanString

describe 'Scanner', ->
    describe 'Parsing numbers: ', ->
        describe 'an integer declaration', ->
            tokens = scanLine 'x : int = 38437'
            it 'should contain the number', ->
                expect(tokens).to.contain {kind: 'INTLIT', lexeme: '38437', line: 0, col: 11}
            it 'should have 5 items', ->
                expect(tokens).to.have.length(5)
            it 'should contain the variable', ->
                expect(tokens).to.contain {kind: 'ID', lexeme: 'x', line: 0, col: 1}

        describe 'a float declaration', ->
            context 'with no zeros', ->
                tokens = scanLine 'pi : float = 3.1415'
                it 'should contain the number', ->
                    expect(tokens).to.contain {kind: 'FLOATLIT', lexeme: '3.1415', line: 0, col: 13}
                it 'should have five items', ->
                    expect(tokens).to.have.length(5)
                it 'should contain the variable', ->
                    expect(tokens).to.contain {kind: 'ID', lexeme: 'pi', line: 0, col: 1}

            context 'with leading zero', ->
                tokens = scanLine 'half : float = 0.5'
                it 'should contain the number', ->
                    expect(tokens).to.contain {kind: 'FLOATLIT', lexeme: '.5', line: 0, col: 16}
                it 'should have 5 tokens', ->
                    expect(tokens).to.have.length(5)
                it 'should contain the variable', ->
                    expect(tokens).to.contain {kind: 'ID', lexeme: 'half', line: 0, col: 1}

            context 'with no leading zero', ->
                tokens = scanLine 'half : float = .5'
                it 'should contain the number', ->
                    expect(tokens).to.contain {kind: 'FLOATLIT', lexeme: '.5', line: 0, col: 16}
                it 'should have 5 tokens', ->
                    expect(tokens).to.have.length(5)
                it 'should contain the variable', ->
                    expect(tokens).to.contain {kind: 'ID', lexeme: 'half', line: 0, col: 1}

    describe 'Parsing declarations: ', ->
        context 'declaration with infered type', ->
            tokens = scanLine 'x := 5'
            it 'should have 3 tokens', ->
                expect(tokens).to.have.length(3)
            it 'should contain the variable', ->
                expect(tokens).to.contain {kind: 'ID', lexeme: 'x', line: 0, col: 1}
            it 'should contain :=', ->
                expect(tokens).to.contain {kind: ':=', lexeme: ':=', line: 0, col: 3}

        context 'declaration with type', ->
            tokens = scanLine 'x : int = 5'
            it 'should have 5 tokens', ->
                expect(tokens).to.have.length(5)
            it 'should have the variable', ->
                expect(tokens).to.contain {kind: 'ID', lexeme: 'x', line: 0, col: 1}
            it 'should have the colon', ->
                expect(tokens).to.contain {kind: ':', lexeme: ':', line: 0, col: 3}
            it 'should have the type', ->
                expect(tokens).to.contain {kind: 'int', lexeme: 'int', line: 0, col: 5}

    describe 'Parsing string literals', ->
        context 'string with no internal quotes or UTF8', ->
            tokens = scanLine 'x := "Yaks grunt!"'
            console.log tokens
            it 'should have the string', ->
                expect(tokens).to.contain {kind: 'STRLIT', lexeme: 'Yaks grunt!', line: 0, col: 7}
        context 'string with internal quotes', ->
            tokens = scanLine 'x := "Yaks say \"hrumph\""'
            it 'should have the string', ->
                expect(tokens).to.contain {kind: 'STRLIT', lexeme: 'Yaks say \"hrumph\"', line: 0, col: 7}

