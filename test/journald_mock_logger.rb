class JournaldMockLogger
  attr_reader :logs

  def initialize
    @logs = []
  end

  def send_message(msg)
    @logs << msg
  end
end
