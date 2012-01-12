require "user_agent_info/version"
require "ostruct"

##
# Usage:
#   info = UserAgentInfo.parse(user_agent_string)
#   self.user_agent_name = info.agent.name
#   self.user_agent_version = info.agent.version
#   self.os = info.os.name
#   self.os_version = info.os.version
##

module UserAgentInfo

  def self.parse(user_agent_string)
    Parser.new(user_agent_string)
  end

  class Parser

    attr_reader :agent
    attr_reader :os

    def initialize(user_agent_string)
      @user_agent_string = user_agent_string
      @agent = OpenStruct.new({})
      @os = OpenStruct.new({})
      parse!
    end

    private

    def parse!
      @agent.name, @agent.version, @os.name, @os.version = agent_info
      @os.name, @os.version = os_info unless @os.name || @os.version
    end

    ##
    # The order of parsing is important,
    # so beware when refactoring this.
    ##
    def agent_info
      outlook_versions = {'12' => '2007'}
      uas = %w{Firefox Chrome Thunderbird Netscape UltraBrowser Konqueror Epiphany Iceweasel SeaMonkey Blackbird Songbird Lotus-Notes}
      slash_uas = /(#{uas.join('|')})\/(\d+)/
      case @user_agent_string
      when /IEMobile (\d+)/
        ['IE Mobile', $1]
      when /MSOffice (\d+)/
        ['Outlook', outlook_versions[$1]]
      when /Lobo\/(\d+)/
        ['Lobo', $1]
      when /Maxthon[\/\s](\d+)/i
        ['Maxthon', $1]      
      when /MSIE (\d+)/
        ['Internet Explorer', $1]
      when slash_uas
        [$1, $2]
      when /Version\/(\d+)[\.\d+]*? Safari/
        ['Safari', $1]
      when /Opera\/(\d+)/
        version = $1
        ['Opera', @user_agent_string =~ /Version\/10/ ? '10' : version]
      when /BrowserNG\/(\d+)/
        ['Nokia Web Browser', $1]
      when /rekonq/
        ['rekonq', 'Unknown']
      when /Android (\d+)/
        ['Android', $1]
      when /BlackBerry(\d+)\/(\d+)/
        ['BlackBerry', $1, 'RIM OS', $2]
      when /iPhone OS (\d+).+Version\/(\d+)/
        ['Safari', $2, 'iPhone', $1]
      else
        ['Unknown', 'Unknown']
      end
    end

    def os_info
      win_versions = {'5.1' => 'XP', 'XP' => 'XP', '6.0' => 'Vista', '6.1' => '7', 'CE' => 'CE', '95' => '95'}
      mac_versions = {'10_7' => 'Lion', '10_6' => 'Snow Leopard', '10_5' => 'Leopard', '10_4' => 'Tiger'}
      linux_versions = /(Ubuntu|Mandriva|SUSE|Debian)/
      case @user_agent_string
      when /Windows (NT )?(.+?)[;\)\s]/
        ['Windows', $2 ? win_versions[$2] : 'Unknown']
      when /SymbianOS\/(\d+)?/ 
        ['Symbian', $1]
      when /Windows-NT/
        ['Windows', 'NT']
      when /Android/
        ['Android', 'Unknown']
      when /Linux/
        ['Linux', @user_agent_string =~ linux_versions ? $1 : 'Unknown']
      when /Mac OS X (\d+_\d+)?/
        ['MacOS', $1 ? mac_versions[$1] : 'Unknown']
      else
        ['Unknown', 'Unknown']
      end
    end

  end

end