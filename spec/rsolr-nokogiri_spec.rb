require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe RSolr::Nokogiri do
  
  module NokogiriEnabledHelpers
    
    def self.included base
      base.let(:rsolr){
        rsolr = RSolr.connect
        rsolr.message.use_nokogiri!
        rsolr
      }
    end
  
  end
  
  it 'should use Builder unless use_nokogiri! is called' do
    rsolr = RSolr.connect
    rsolr.message.should_not be_a(RSolr::Nokogiri::Generator)
  end
  
  it 'should use Nokogiri after use_nokogiri! is called' do
    rsolr = RSolr.connect
    rsolr.message.use_nokogiri!
    rsolr.message.should be_a(RSolr::Nokogiri::Generator)
  end
  
  context 'RSolr::Client' do
    
    include NokogiriEnabledHelpers
    
    it 'should be using Nokogiri' do
      rsolr.message.is_a? RSolr::Nokogiri::Generator
    end
    
    it 'should forward calls to message/generator' do
      rsolr.should_receive(:update).
        with("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<optimize/>\n")
      rsolr.optimize
    end
    
  end
  
  context "RSolr::Nokogiri::Generator" do
    
    include NokogiriEnabledHelpers
    
    it 'should generator proper add XML' do
      expected = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<add>\n  <doc>\n    <field name=\"id\">1</field>\n  </doc>\n</add>\n"
      rsolr.message.add(:id=>1).should == expected
    end
    
    it 'should generator proper delete XML - single id' do
      expected = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<delete>\n  <id>1</id>\n</delete>\n"
      rsolr.message.delete_by_id(1).should == expected
    end
    
    it 'should generator proper delete XML - multiple ids' do
      expected = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<delete>\n  <id>1</id>\n  <id>2</id>\n  <id>3</id>\n</delete>\n"
      rsolr.message.delete_by_id([1,2,3]).should == expected
    end
    
  end
  
end