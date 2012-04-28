require 'rubygems'
require 'rspec'
require 'action_view'
require 'action_controller'
require 'deface'
#have to manually require following three for testing purposes
require 'deface/action_view_extensions'
require 'haml'
require 'deface/haml_converter'

Haml.init_rails(nil)

RSpec.configure do |config|
  config.mock_framework = :rspec
end

module ActionView::CompiledTemplates
  #empty module for testing purposes
end

shared_context "mock Rails" do
  before(:each) do
    unless defined? Rails
      Rails = mock 'Rails'
    end

    Rails.stub :application => mock('application')
    Rails.application.stub :config => mock('config')
    Rails.application.config.stub :cache_classes => true
    Rails.application.config.stub :deface => ActiveSupport::OrderedOptions.new
    Rails.application.config.deface.enabled = true

    Rails.stub :logger => mock('logger')
    Rails.logger.stub(:error)
    Rails.logger.stub(:warning)
    Rails.logger.stub(:info)
  end
end

shared_context "mock Rails.application" do
  include_context "mock Rails"

  before(:each) do
    Rails.application.config.stub :deface => Deface::Environment.new
    Rails.application.config.deface.haml_support = true
  end
end
