require 'spec_helper'

describe Recurly do
  describe "api key" do
    before { @old_api_key = Recurly.api_key }
    after  { Recurly.api_key = @old_api_key }

    it "must be assignable" do
      Recurly.api_key = 'new_key'
      Recurly.api_key.must_equal 'new_key'
    end

    it "must raise an exception when not set" do
      Recurly.thread_store.delete(:api_key)
      proc { Recurly.api_key }.must_raise ConfigurationError
    end

    it "must raise an exception when set to nil" do
      Recurly.api_key = nil
      proc { Recurly.api_key }.must_raise ConfigurationError
    end

    it "must be multi-assignable" do
      Recurly.api_key ="new_api"
      threads = []
      3.times do |i|
        threads <<  Thread.new do
          Recurly.api_key = "new_key_#{i}"
          timeout = ((1..10).to_a.sample.to_f) / 10
          sleep(timeout)
          Recurly.api_key.must_equal "new_key_#{i}"
        end
      end
      threads.map(&:join)
      Recurly.api_key.must_equal 'new_api'

    end
  end
end
