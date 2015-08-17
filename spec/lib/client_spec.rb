require 'spec_helper'

describe Stellae::Client do
  let(:client) { Stellae::Client.new("TESTACCOUNT", "TESTPASSWORD") }

  describe '#send_order_request', :vcr do
    let(:result) { client.send_order_request(order_hash) }

    it 'sends an order request and returns a parsed respose' do
      expect(result).to be_a(Stellae::Response)
      expect(result.success?).to eq(true)
    end
  end

  context 'inventory methods' do
    let(:result) { client.get_inventory }
    let(:upcs)   { client.upcs(result)  }

    describe '#get_inventory' do
      it 'gets inventory and maps results into an array of hashes' do
        expect(result).to be_a(Array)
        expect(result.first).to have_key("qty")
      end
    end

    describe '#upcs' do
      it 'returns an array of upcs' do
        expect(upcs).to be_a(Array)
        expect(upcs).not_to be_empty
      end
    end

    describe '#mapped_inventory' do
      let(:mapped_inventory) { client.mapped_inventory(upcs, result) }

      it 'returns an array of quantity hashes' do
        expect(mapped_inventory).to be_a(Array)
        expect(mapped_inventory.first).to have_key(:quantity)
      end
    end

  end

  describe '#request_uri' do
    it 'returns the complete request uri' do
      expect(client.request_uri).to eq("https://www.stellae.us/webservices/SIIService.svc?wsdl")
    end
  end

end
