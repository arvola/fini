require 'spec_helper'

describe Fini do
    let(:data) do
        content = %q{
            [section]
            string = string
            boolean = true
            number = 1
            float = 1.1
            ;[commented]
            ;foo = foo}
        Fini.parse content
    end
    let (:subsection) do
        content = %q{
            [section]
            string = string

            [section.subsection]
            key = value

            [section2.subsection]
            name = content}
        Fini.parse content
    end

    describe "::is_number?" do
        it "detects numbers correctly" do
            expect(Fini.is_number?("100")).to be_true
            expect(Fini.is_number?("100.1")).to be_true
            expect(Fini.is_number?("0.9876543210")).to be_true
        end

        it "rejects non-numbers" do
            expect(Fini.is_number?("1000000000-")).to be_false
            expect(Fini.is_number?("a.123")).to be_false
            expect(Fini.is_number?("123.123.123")).to be_false
        end
    end

    describe Fini::IniObject do
        it "has a section method" do
            expect(data).to respond_to(:section)
        end
    end

    describe "::parse" do
        it "parses a string" do
            expect(data.section).to include('string' => 'string')
        end

        it "parses a boolean" do
            expect(data.section).to include('boolean' => true)
        end

        it "parses numbers" do
            expect(data.section).to include('number' => 1)
            expect(data.section).to include('float' => 1.1)
        end

        it "ignores comments" do
            expect{data.commented}.to raise_error(NoMethodError)
        end

        it "parses subsections" do
            expect(subsection.section[:subsection]).to include('key' => 'value')
        end

        it "creates sections automatically with subsections" do
            expect(subsection.section2[:subsection]).to include('name' => 'content')
        end
    end
end