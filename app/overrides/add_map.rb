

Deface::Override.new( :name => "add_map",
                      :virtual_path => "spree/shared/_store_menu",
                      :insert_after => "li#link-to-cart",
                      :text => "<li id=\"road-map\" data-hook>Road map</li>")



