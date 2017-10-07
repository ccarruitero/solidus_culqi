require 'spec_helper'

describe Solidus::Gateway::CulqiGateway, type: :model do
  let!(:gateway) { described_class.new }

  context new_gateway: true do
    it { gateway.respond_to?(:partial_name) }
    it { expect(gateway.partial_name).to eq('culqi') }
    it { expect(gateway.gateway_class).to eq(Solidus::Gateway::CulqiGateway) }
  end

  context old_gateway: true do
    it { expect(gateway.method_type).to eq('culqi') }
    it { expect(gateway.provider_class).to eq(Solidus::Gateway::CulqiGateway) }
  end
end
