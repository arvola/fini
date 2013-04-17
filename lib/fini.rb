require_relative "fini/version"

module Fini

    # Instance class for accessing Fini functionality
    #
    class Ini
        def parse content
            Fini.parse content
        end
        def load file
            Fini.parse File.read(file)
        end
    end

    NUMBER_REGEX = /\A[+-]?[\d]+\.?\d*\Z/

    def self.is_number? string
        # Regex has the best performance overall, and it doesn't take longer with
        # long strings that are not numbers. In other words, getting a false is very fast,
        # and getting a true is only slightly slower than using Float()
        if NUMBER_REGEX === string
            true
        else
            false
        end
    end

    # A static method for parsing a string with ini content.
    #
    # @param [String] content       Ini text to parse
    # @return [Fini::IniObject]     Parsed values
    def self.parse content
        source = content
        data = IniObject.new
        section = nil
        source.lines do |line|
            line.strip!
            case line[0]
                when '['
                    key = line.delete "[]"
                    section = data.get_section key
                when ';'
                    next
                else
                    next if section.nil?
                    pos = line.index '='
                    unless pos.nil?
                        key = line[0, pos]
                        val = line[(pos + 1)..-1]
                        unless key.nil? || val.nil?
                            key.strip!
                            val.strip!
                            if Fini.is_number? val
                                if val.include?('.')
                                    section[key] = Float(val)
                                else
                                    section[key] = Integer(val)
                                end
                            elsif (val[0] == '"' && val[-1] == '"') or (val[0] == "'" && val[-1] == "'")
                                section[key] = val.chop.reverse.chop.reverse
                            elsif val == "true"
                                section[key] = true
                            elsif val == "false"
                                section[key] = false
                            else
                                section[key] = val
                            end
                        end
                    end
            end
        end
        @data = data
    end

    # An object that holds the data from the parsed ini-file. Sections are
    # accessed as methods, which returns a hash.
    class IniObject
        def initialize
            @data = {}
        end

        # @param [String] key
        # @return [Hash]
        def get_section key
            if key.include? '.'
                sections = key.split('.')
                obj = do_get_section sections.shift

                sections.each do |key|
                    key = key.to_sym
                    if obj.has_key? key
                        obj = obj[key]
                    else
                        obj = obj[key] = {}
                    end
                end
                obj
            else
                do_get_section key
            end
        end

        protected

        # @param [String] key
        # @return [Hash]
        def do_get_section key
            key = key.to_sym
            if @data.has_key? key
                @data[key]
            else
                create_section key
            end
        end

        # @param [Symbol] key
        # @return [Hash]
        def create_section key
            data = @data[key] = {}
            method = Proc.new do |k = nil, default = nil|
                if k.nil?
                    data
                else
                    data.has_key?(k) ? data[k] : default
                end
            end
            define_singleton_method(key, method)
            data
        end
    end
end
