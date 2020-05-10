defmodule CovTrackerServer.Aux do
  def random(low, high) do
    :rand.uniform() * (high - low) + low
  end
end
