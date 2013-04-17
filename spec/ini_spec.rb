require 'spec_helper'

describe Fini::Ini do
    let (:parser) { Fini::Ini.new }

    it "loads and parses files" do
        data = parser.load(File.dirname(__FILE__) + '/ini/file.ini')
        expect(data.section).to include('string' => 'string')
    end
end