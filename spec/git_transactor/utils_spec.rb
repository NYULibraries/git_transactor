require 'spec_helper'

module GitTransactor
  describe Utils do

    let(:repo_file_path)   { 'd/foo.xml' }
    let(:source_file_path) { '/a/b/c/d/foo.xml' }

    describe '.source_path_to_repo_path' do
      it "should perform the correct conversion" do
        expect(Utils.source_path_to_repo_path(source_file_path)).to be == repo_file_path
      end
    end
  end
end
