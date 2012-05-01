

Deface::Override.new( :name => "add_map",
                      :virtual_path => "spree/shared/_store_menu",
                      :insert_after => "li#link-to-cart",
                      :text => "<li id=\"road-map\" data-hook><%= link_to t(:road_map), \"/static/road-map.html\" %></li>")


Deface::Override.new( :name => "telephone",
                      :virtual_path => "spree/shared/_store_menu",
                      :insert_after => "li#link-to-cart",
                      :text => "<li id=\"telephone\" data-hook><%= link_to t(:telephone), \"/static/telephone.html\" %></li>")

Deface::Override.new( :name => "deliver-and-pay",
                      :virtual_path => "spree/shared/_store_menu",
                      :insert_after => "li#link-to-cart",
                      :text => "<li id=\"deliver-and-pay\" data-hook><%= link_to t(:deliver_and_pay), \"/static/deliver-and-pay.html\" %></li>")

Deface::Override.new( :name => "news",
                      :virtual_path => "spree/shared/_store_menu",
                      :insert_after => "li#link-to-cart",
                      :text => "<li id=\"news\" data-hook><%= link_to t(:news), \"/static/news.html\" %></li>")


#mount Spree::Core::Engine, :at => '/'
#mount Spree::Core::Engine, :at => '/road-map/'
#mount Spree::Core::Engine, :at => '/news/'
#mount Spree::Core::Engine, :at => '/deliver-and-pay/'
