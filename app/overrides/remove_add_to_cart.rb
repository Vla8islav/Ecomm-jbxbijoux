

Deface::Override.new( :name => "remove_cart",
                      :virtual_path => "spree/shared/_store_menu",
                      :remove => "li#link-to-cart")

Deface::Override.new( :name => "remove_cart_form",
                      :virtual_path => "spree/products/show",
                      :remove => "div#cart-form")
