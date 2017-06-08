assert = require 'assert'
count = require '..'
concat = require 'concat-stream'
Streamify = require 'streamify-string'
StreamifyArray = require 'stream-array'

str = 'Grumpy wizards make toxic brew for the evil Queen and Jack.'
words = str.split ' '

expected = ( val, done ) -> ( c ) ->
  assert.equal c , val
  done( ) if done?

describe 'count', ->

  it 'should return length for strings', ( done ) ->
    Streamify( str ).pipe count expected( str.length, done )

  it 'should return count for objects', ( done ) ->
    StreamifyArray( words ).pipe count.obj expected( words.length, done )

  it 'should pass through strings', ( done ) ->
    Streamify( str )
      .pipe count expected( str.length )
      .pipe concat ( s ) ->
        assert s.toString() is str
        done( )

  it 'should pass through objects', ( done ) ->
    StreamifyArray( words )
      .pipe count.obj expected( words.length )
      .pipe concat ( s ) ->
        assert.equal s.toString() , words.join('')
        done( )



