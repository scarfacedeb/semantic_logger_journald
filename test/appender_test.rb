require "test_helper"
require_relative "./journald_mock_logger"

module SemanticLoggerJournald
  describe Appender do
    before do
      @logger = JournaldMockLogger.new
      @appender = Appender.new(logger: @logger)
    end

    it "sends messages to journald logger" do
      @appender.info("EVENT")

      assert_equal 1, @logger.logs.count
      log = @logger.logs.first
      assert_equal "EVENT", log[:message]
    end

    it "sends payload to journald as fields" do
      @appender.info("Signed In", user: { id: 1, name: "Snowden" })

      log = @logger.logs.first
      assert_equal "Signed In", log[:message]
      assert_equal 1, log[:user__id]
      assert_equal "Snowden", log[:user__name]
    end

    it "sends tags to journald as fields" do
      @appender.tagged(ctx: "admin") do
        @appender.tagged(:authorized) do
          @appender.fatal("Server unavailable")
        end
      end

      log = @logger.logs.first
      assert_equal "Server unavailable", log[:message]
      assert_equal "admin", log[:ctx]
      assert_equal 1, log["authorized"]
    end

    it "sets correct priority based on level" do
      @appender.error("Low capacity!")

      log = @logger.logs.first
      assert_equal "Low capacity!", log[:message]
      assert_equal 3, log[:priority]
    end
  end
end
