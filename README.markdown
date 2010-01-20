# Neurosis

## Description

Neurosis is an example application to show off [Hubris]:(http://github.com/mwotton/Hubris) (a Haskell -> Ruby bridge) being used with non-trivial Haskell-code. See [this post]:(http://engineyard.com/blog/2010/a-hint-of-hubris/) for an intro to Hubris and for which Neurosis was written.

Feel free to fork the code and send in pull requests if you would like to see this turn into a more sophisticated example webservice. I will be hacking on little improvements here and there as time goes on. 

## Installation

    git clone git@github.com:larrytheliquid/neurosis.git
    cd neurosis
    gem bundle --cached

That will take care of Ruby side of installation, unfortunately the [Haskell side is a bit more tricky at the moment]:(http://wiki.github.com/mwotton/Hubris/Installation/).

Take a look at `neurosis_spec` for an integration test running through rack-test, and `PerceptronTest` for Haskell unit tests of the underlying algorithm (if you are interested).

## License

(The MIT License)

Copyright (c) 2010 Larry Diehl

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
