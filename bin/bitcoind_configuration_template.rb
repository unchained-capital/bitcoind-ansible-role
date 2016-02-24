require 'set'

def bitcoind_command
  ENV['BITCOIND'] || 'bitcoind'
end

def bitcoind_help_text
  `#{bitcoind_command} -h`.chomp
end

class BitcoindHelpTransformer

  HANDLERS         = []
  IGNORED_SECTIONS = Set.new(%w[Usage])
  IGNORED_OPTIONS  = Set.new(%w[? version conf help-debug datadir])
  LISTY_OPTIONS    = Set.new(%w[whitelist rpcbind rpcauth rpcallowip])
  
  def self.ignore name, pattern
    HANDLERS << [name, pattern, nil]
  end

  def self.handle name, pattern, &block
    HANDLERS << [name, pattern, block]
  end

  ignore :whitespace, /^\s*$/

  handle :version, /^Bitcoin Core Daemon version v(.+)\s*$/ do
    write "# {{ ansible_managed }}"
    write "# Compatible with #{line}"
  end

  handle :section, /^([^\s].+):\s*$/ do
    unless IGNORED_SECTIONS.include?(matches.first)
      transform_last_option!
      write <<SECTION.chomp

#
# #{matches.first}
#
SECTION
    end
  end

  ignore :usage, /^\s+bitcoind [options]\sStart Bitcoin/

  handle :option, /^\s+-([^=]+)(?:=(.+))?/ do
    transform_last_option!
    self.last_option_name = matches[0]
    self.last_option_type = (matches[1] or '[0|1]')
  end

  handle :option_description, /^\s+(.+)$/ do
    self.last_option_description << matches.first
  end

  attr_accessor :line
  attr_accessor :matches
  attr_accessor :last_option_name
  attr_accessor :last_option_type
  attr_accessor :last_option_description
  
  def initialize text
    @text  = (text || '')
    @lines = @text.chomp.split("\n")
    @last_option_description = []
    @template = ""
  end

  def write text
    @template += text + "\n"
  end

  def to_s
    @template
  end

  def transform!
    @lines.each do |line|
      self.line = line.chomp
      HANDLERS.each do |(name, pattern, action)|
        match_data = pattern.match(line)
        next unless match_data
        self.matches = match_data[1..-1]
        self.instance_eval(&action) if action
        break
      end
    end
    self
  end

  def transform_last_option!
    return unless last_option_name
    unless IGNORED_OPTIONS.include?(last_option_name)
      option_lines = [""]
      option_lines += last_option_description.map { |line| "# #{line}" }
      option_lines << "##{last_option_name}=#{last_option_type}"
      if LISTY_OPTIONS.include?(last_option_name)
        option_lines << <<LISTY_OPTION.chomp
{% if bitcoind_#{last_option_name} is defined %}
{% for value in bitcoind_#{last_option_name} %}
#{last_option_name}={{ value }}
{% endfor %}
{% endif %}
LISTY_OPTION
      else
        option_lines << <<SCALAR_OPTION.chomp
{% if bitcoind_#{last_option_name} is defined %}
#{last_option_name}={{ bitcoind_#{last_option_name} }}
{% endif %}
SCALAR_OPTION
      end
      write option_lines.join("\n")
    end
    clear_last_option!
  end

  def clear_last_option!
    self.last_option_name = nil
    self.last_option_type = nil
    self.last_option_description = []
  end
  
end

puts BitcoindHelpTransformer.new(bitcoind_help_text).transform! if __FILE__ == $0
