# encoding: utf-8

describe 'generator' do
  drafts = [:draft3, :draft4].each do |draft|
    context "supports #{draft}" do
      context 'the description' do
        let(:schema) { invoke_generator 'spec/fixtures/examples/simple.json', draft }
        it 'includes the file name' do
          expect(schema).to include('Generated from spec/fixtures/examples/simple.json')
        end
        it 'includes the file shasum' do
          expect(schema).to include('with shasum e7f0e9796c7719ec437027ff34c84b353dabd49e')
        end
      end

      context 'generates the examples' do
        Dir['spec/fixtures/examples/*.json'].each do |example_file|
          example = File.basename example_file
          expected = File.expand_path(example, "spec/fixtures/schemas/#{draft.to_s}")
          it "for #{example}" do
            schema = invoke_generator example_file, draft
            compare_without_whitespace schema, File.read(expected)
            validate schema, example_file, draft
          end
        end
      end
    end
  end
end