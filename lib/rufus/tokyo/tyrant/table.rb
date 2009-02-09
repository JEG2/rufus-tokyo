#
#--
# Copyright (c) 2009, John Mettraux, jmettraux@gmail.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#++
#

#
# "made in Japan"
#
# jmettraux@gmail.com
#

require 'rufus/tokyo/cabinet/table'
require 'rufus/tokyo/tyrant/lib'


module Rufus::Tokyo

  class TyrantTable < Table

    def initialize (host, port)

      @db = lib.tcrdbnew

      (lib.tcrdbopen(@db, host, port) == 1) ||
        raise("couldn't connect to tyrant at #{host}:#{port}")
    end

    #
    # using the cabinet lib
    #
    def lib
      Rufus::Tokyo::TyrantLib
    end

    #
    # Inserts a record in the table db
    #
    #   table['pk1'] = { 'name' => 'jeff', 'age' => '46' }
    #
    def []= (pk, h)

      pklen = Rufus::Tokyo::CabinetLib.strlen(pk)

      m = Rufus::Tokyo::Map.from_h(h)

      r = lib.tab_put(@db, pk, pklen, m.pointer)

      m.free

      (r == 1) || raise_error

      h
    end
  end
end

