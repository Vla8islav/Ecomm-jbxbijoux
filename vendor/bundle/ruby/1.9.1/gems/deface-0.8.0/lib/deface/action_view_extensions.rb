ActionView::Template.class_eval do
  alias_method :initialize_without_deface, :initialize

  def initialize(source, identifier, handler, details)
    if Rails.application.config.deface.enabled
      haml = handler.to_s == "Haml::Plugin"

      processed_source = Deface::Override.apply(source, details, true, haml )

      if haml && processed_source != source
        handler = ActionView::Template::Handlers::ERB
      end
    else
      processed_source = source
    end

    initialize_without_deface(processed_source, identifier, handler, details)
  end

  alias_method :render_without_deface, :render

  # refresh view to get source again if
  # view needs to be recompiled
  #
  def render(view, locals, buffer=nil, &block)
    if @compiled && !view.respond_to?(method_name)
      @compiled = false
      @source = refresh(view).source
    end
    render_without_deface(view, locals, buffer, &block)
  end


  alias_method :method_name_without_deface, :method_name

  # inject deface hash into compiled view method name
  # used to determine if recompilation is needed
  #
  def method_name
    deface_hash = Deface::Override.digest(:virtual_path => @virtual_path)
    "_#{deface_hash}_#{method_name_without_deface}"
  end
end

#fix for Rails 3.1 not setting virutal_path anymore (BOO!)
if defined?(ActionView::Resolver::Path)
  ActionView::Resolver::Path.class_eval { alias_method :virtual, :to_s }
end
