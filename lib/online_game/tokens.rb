require File.join(File.dirname(__FILE__), 'attributes')
module Online
  class Token < Attributes
    prop priority: 0, power: 0, range: 0
  end

  class Priority < Token
    def initialize p
      @priority = p
    end
    def priority
      puts "Adding priority from the +4 priority token."
      @priority
    end
  end
end