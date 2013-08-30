class Peck
  # Parser for command line options
  class OptionParser
    # Parses ARGV from a Ruby script and returns options as a hash and
    # arguments as a list.
    #
    #   OptionParser.parse(%w(create --username manfred)) #=>
    #     [{"username"=>"manfred"}, ["create"]]
    def self.parse(argv)
      return [{},[]] if argv.empty?
    
      options  = {}
      rest     = []
      switch   = nil
    
      for value in argv
        bytes = value.respond_to?(:bytes) ? value.bytes.first(2) : [value[0], value[1]]
        # value is a switch
        if bytes[0] == 45
          switch = value.slice((bytes[1] == 45 ? 2 : 1)..-1)
          options[switch] = nil
        else
          if switch
            # we encountered another switch so this
            # value belongs to the last switch
            options[switch] = value
            switch = nil
          else
            rest << value
          end
        end
      end
    
      [options, rest]
    end
  end
end