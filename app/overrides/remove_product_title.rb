Deface::Override.new( :name => "remove_product_name",
                      :virtual_path => "spree/shared/_products",
                      :remove => "code[erb-loud]:contains('truncate(product.name, :length => 50)')")
