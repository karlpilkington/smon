class MonitSettings
  attr_accessor :HealthCheckInterval
  attr_accessor :HealthCheckCount

  def initialize
    @HealthCheckInterval = 1
    @HealthCheckCount =5
  end

  def load_settings=(path)
  end
end
