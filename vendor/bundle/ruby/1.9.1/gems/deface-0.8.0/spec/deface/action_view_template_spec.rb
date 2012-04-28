require 'spec_helper'

module ActionView
  describe Template do
    include_context "mock Rails.application"

    describe "with no overrides defined" do
      before(:each) do
        @updated_at = Time.now - 600
        @template = ActionView::Template.new("<p>test</p>", "/some/path/to/file.erb", ActionView::Template::Handlers::ERB, {:virtual_path=>"posts/index", :format=>:html, :updated_at => @updated_at})
        #stub for Rails < 3.1
        unless defined?(@template.updated_at)
          @template.stub(:updated_at).and_return(@updated_at)
        end
      end

      it "should initialize new template object" do
        @template.is_a?(ActionView::Template).should == true
      end

      it "should return unmodified source" do
        @template.source.should == "<p>test</p>"
      end

      it "should not change updated_at" do
        @template.updated_at.should == @updated_at
      end

    end

    describe "with a single remove override defined" do
      before(:each) do
        @updated_at = Time.now - 300
        Deface::Override.new(:virtual_path => "posts/index", :name => "Posts#index", :remove => "p", :text => "<h1>Argh!</h1>")
        @template = ActionView::Template.new("<p>test</p><%= raw(text) %>", "/some/path/to/file.erb", ActionView::Template::Handlers::ERB, {:virtual_path=>"posts/index", :format=>:html, :updated_at => @updated_at})
        #stub for Rails < 3.1
        unless defined?(@template.updated_at)
          @template.stub(:updated_at).and_return(@updated_at + 500)
        end
      end

      it "should return modified source" do
        @template.source.should == "<%= raw(text) %>"
      end

      it "should change updated_at" do
        @template.updated_at.should > @updated_at
      end
    end

  end
end
