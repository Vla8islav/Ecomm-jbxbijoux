
Deface::Override.new( :name => "remove_filter_choice",
                     :virtual_path => "spree/shared/_filters",
                     :remove => "div.navigation")

Deface::Override.new( :name => "remove_search_button",
                      :virtual_path => "spree/shared/_filters",
                      :remove => "code[erb-loud]:contains('submit_tag t(:search)')")
