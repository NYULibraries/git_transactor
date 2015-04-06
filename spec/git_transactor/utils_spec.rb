require 'spec_helper'

module GitTransactor
  describe Utils do

    let(:repo_file_path)   { 'd/foo.xml' }
    let(:source_file_path) { '/a/b/c/d/foo.xml' }

    describe '.source_path_to_repo_path' do
      let(:dummy_class) { Class.new { include Utils } }
      let(:o) { dummy_class.new }
      it "should perform the correct conversion" do
        expect(o.send(:source_path_to_repo_path, source_file_path)).to be == repo_file_path
      end
    end
  end
end
