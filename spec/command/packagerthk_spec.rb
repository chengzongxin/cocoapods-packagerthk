require File.expand_path('../../spec_helper', __FILE__)

module Pod
  describe Command::Packagerthk do
    describe 'CLAide' do
      it 'registers it self' do
        Command.parse(%w{ packagerthk }).should.be.instance_of Command::Packagerthk
      end
    end
  end
end

