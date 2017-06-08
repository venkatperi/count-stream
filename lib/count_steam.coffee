Transform = require( 'readable-stream/transform' )
xtend = require 'xtend'

class CountStream extends Transform
  constructor : ( options, @finalCb, @updateCb ) ->
    if typeof(options) is 'function'
      @updateCb = @finalCb
      @finalCb = options
      options = {}

    super options

    @count = 0
    @on 'finish', => @finalCb @count if @finalCb

  _transform : ( chunk, enc, cb ) =>
    @count += if @_readableState.objectMode then 1 else chunk.length
    @updateCb( @count ) if @updateCb?
    @push chunk
    cb( )

countStream = ( args... ) -> new CountStream args...

countStream.CountStream = CountStream

countStream.obj = ( opts, f1, f2 ) ->
  if typeof opts is 'function'
    f2 = f1
    f1 = opts
    opts = {}
  new CountStream xtend( objectMode : true, opts ), f1, f2

module.exports = countStream
