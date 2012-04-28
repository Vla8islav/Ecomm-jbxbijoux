
Deface::Override.new(:virtual_path  => "spree/checkout/registration",
                     :insert_before => "div#registration",
                     :text          => "<p>Registration is the future!</p>",
                     :name          => "registration_future")