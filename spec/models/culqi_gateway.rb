require 'spec_helper'

describe Solidus::Gateway::CulqiGateway, type: :model do
  let!(:gateway) { described_class.new }
  it { gateway.respond_to?(:partial_name) }
  it 'return partial name' do
    expect(gateway.partial_name).to eq('culqi')
  end
end
