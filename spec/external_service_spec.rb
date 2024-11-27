# frozen_string_literal: true

require "rspec"
require "json"
require_relative "../lib/external_service"
require_relative "support/capture_stdout_helper"

RSpec.describe ExternalService do
  let(:external_service) { ExternalService.new }

  describe "#call" do
    let(:batch_data) { [{"id" => "1", "title" => "Test Product", "description" => "Description"}].to_json }

    it "increments the batch number on each call" do
      expect { external_service.call(batch_data) }.to change {
        external_service.instance_variable_get(:@batch_num)
      }.by(1)
    end

    it "prints the expected output" do
      output = capture_stdout { external_service.call(batch_data) }
      expect(output).to match(/Received batch/)
      expect(output).to match(/Size: *\d+\.\d+MB/)
      expect(output).to match(/Products: *1/)
    end
  end
end
