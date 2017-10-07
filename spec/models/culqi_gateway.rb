require 'spec_helper'

describe Solidus::Gateway::CulqiGateway, type: :model do
  let!(:gateway) { described_class.new }
  it { gateway.respond_to?(:partial_name) }
  it { expect(gateway.partial_name).to eq('culqi') }
  it { expect(gateway.gateway_class).to eq(Solidus::Gateway::CulqiGateway) }
end
