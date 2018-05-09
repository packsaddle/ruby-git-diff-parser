require 'spec_helper'

module GitDiffParser
  describe Patches do
    describe '#parse' do
      let(:file0) { 'lib/saddler/reporter/github.rb' }
      let(:body0) { File.read('spec/support/fixtures/file0.diff') }
      let(:file1) { 'lib/saddler/reporter/github/commit_comment.rb' }
      let(:body1) { File.read('spec/support/fixtures/file1.diff') }
      let(:file2) { 'lib/saddler/reporter/github/helper.rb' }
      let(:body2) { File.read('spec/support/fixtures/file2.diff') }
      let(:file3) { 'lib/saddler/reporter/github/support.rb' }
      let(:body3) { File.read('spec/support/fixtures/file3.diff') }

      let(:sjis_file) { 'spec/support/fixtures/sjis.csv' }
      let(:sjis_diff) { sjis_file.gsub(/\.csv\z/, '.diff') }
      let(:sjis_body) { File.read(sjis_diff) }

      let(:deleted_diff) { 'spec/support/fixtures/deleted.diff' }
      let(:deleted_file) { 'spec/support/fixtures/hello.txt' }
      let(:deleted_body) { File.read(deleted_diff.gsub(/\.diff\z/, '.body')) }

      it 'returns parsed patches' do
        diff_body = File.read('spec/support/fixtures/d1bd180-c27866c.diff')
        patches = Patches.parse(diff_body)

        expect(patches.size).to eq 4
        expect(patches[0].file).to eq file0
        expect(patches[0].body).to eq body0
        expect(patches[1].file).to eq file1
        expect(patches[1].body).to eq body1
        expect(patches[2].file).to eq file2
        expect(patches[2].body).to eq body2
        expect(patches[3].file).to eq file3
        expect(patches[3].body).to eq body3
      end

      it 'handles non UTF-8 encoding characters' do
        patches = nil
        expect { patches = Patches.parse(sjis_body) }.not_to raise_error
        expect(patches[0].file).to eq sjis_file
      end

      it 'returns patches for a deleted file' do
        diff_body = File.read(deleted_diff)
        patches = Patches.parse(diff_body)
        expect(patches.size).to eq 1
        expect(patches[0].file).to eq deleted_file
        expect(patches[0].body).to eq deleted_body
      end
    end
  end
end
