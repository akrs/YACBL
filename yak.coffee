#!/usr/bin/env coffee

argv = require 'yargs'
                .usage '$0 [-t] [-a] [-i] filename'
                .boolean ['t','a','i']
                .describe 't', 'show tokens after scanning then stop'
                .describe 'a', 'show abstract syntax tree after parsing then stop'
                .describe 'i', 'generate and show the intermediate code then stop'
                .demand(1)
                .argv

scan = require './scanner'
error = require './error'

scan argv._[0], (tokens) ->
    return if error.count > 0
    if argv.t
        console.log t for t in tokens
        return