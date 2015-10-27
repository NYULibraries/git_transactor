require 'spec_helper'

module GitTransactor
  describe EAD do
    let(:ead_file_path) { 'spec/fixtures/ead/wag_108.xml' }
    let(:ead) { GitTransactor::EAD.new(ead_file_path) }
    describe '.eadid' do
      it 'should return the correct eadid' do
        expect(ead.eadid).to be == 'wag_108'
      end
    end
  end
end
