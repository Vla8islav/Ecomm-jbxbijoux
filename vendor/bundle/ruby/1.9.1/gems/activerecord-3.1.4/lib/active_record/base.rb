begin
  require 'psych'
rescue LoadError
end

require 'yaml'
require 'set'
require 'active_support/benchmarkable'
require 'active_support/dependencies'
require 'active_support/descendants_tracker'
require 'active_support/time'
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/class/attribute_accessors'
require 'active_support/core_ext/class/delegating_attributes'
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/hash/deep_merge'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/string/behavior'
require 'active_support/core_ext/kernel/singleton_class'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/module/introspection'
require 'active_support/core_ext/object/duplicable'
require 'active_support/core_ext/object/blank'
require 'active_support/deprecation'
require 'arel'
require 'active_record/errors'
require 'active_record/log_subscriber'

module ActiveRecord #:nodoc:
  # = Active Record
  #
  # Active Record objects don't specify their attributes directly, but rather infer them from
  # the table definition with which they're linked. Adding, removing, and changing attributes
  # and their type is done directly in the database. Any change is instantly reflected in the
  # Active Record objects. The mapping that binds a given Active Record class to a certain
  # database table will happen automatically in most common cases, but can be overwritten for the uncommon ones.
  #
  # See the mapping rules in table_name and the full example in link:files/activerecord/README_rdoc.html for more insight.
  #
  # == Creation
  #
  # Active Records accept constructor parameters either in a hash or as a block. The hash
  # method is especially useful when you're receiving the data from somewhere else, like an
  # HTTP request. It works like this:
  #
  #   user = User.new(:name => "David", :occupation => "Code Artist")
  #   user.name # => "David"
  #
  # You can also use block initialization:
  #
  #   user = User.new do |u|
  #     u.name = "David"
  #     u.occupation = "Code Artist"
  #   end
  #
  # And of course you can just create a bare object and specify the attributes after the fact:
  #
  #   user = User.new
  #   user.name = "David"
  #   user.occupation = "Code Artist"
  #
  # == Conditions
  #
  # Conditions can either be specified as a string, array, or hash representing the WHERE-part of an SQL statement.
  # The array form is to be used when the condition input is tainted and requires sanitization. The string form can
  # be used for statements that don't involve tainted data. The hash form works much like the array form, except
  # only equality and range is possible. Examples:
  #
  #   class User < ActiveRecord::Base
  #     def self.authenticate_unsafely(user_name, password)
  #       where("user_name = '#{user_name}' AND password = '#{password}'").first
  #     end
  #
  #     def self.authenticate_safely(user_name, password)
  #       where("user_name = ? AND password = ?", user_name, password).first
  #     end
  #
  #     def self.authenticate_safely_simply(user_name, password)
  #       where(:user_name => user_name, :password => password).first
  #     end
  #   end
  #
  # The <tt>authenticate_unsafely</tt> method inserts the parameters directly into the query
  # and is thus susceptible to SQL-injection attacks if the <tt>user_name</tt> and +password+
  # parameters come directly from an HTTP request. The <tt>authenticate_safely</tt> and
  # <tt>authenticate_safely_simply</tt> both will sanitize the <tt>user_name</tt> and +password+
  # before inserting them in the query, which will ensure that an attacker can't escape the
  # query and fake the login (or worse).
  #
  # When using multiple parameters in the conditions, it can easily become hard to read exactly
  # what the fourth or fifth question mark is supposed to represent. In those cases, you can
  # resort to named bind variables instead. That's done by replacing the question marks with
  # symbols and supplying a hash with values for the matching symbol keys:
  #
  #   Company.where(
  #     "id = :id AND name = :name AND division = :division AND created_at > :accounting_date",
  #     { :id => 3, :name => "37signals", :division => "First", :accounting_date => '2005-01-01' }
  #   ).first
  #
  # Similarly, a simple hash without a statement will generate conditions based on equality with the SQL AND
  # operator. For instance:
  #
  #   Student.where(:first_name => "Harvey", :status => 1)
  #   Student.where(params[:student])
  #
  # A range may be used in the hash to use the SQL BETWEEN operator:
  #
  #   Student.where(:grade => 9..12)
  #
  # An array may be used in the hash to use the SQL IN operator:
  #
  #   Student.where(:grade => [9,11,12])
  #
  # When joining tables, nested hashes or keys written in the form 'table_name.column_name'
  # can be used to qualify the table name of a particular condition. For instance:
  #
  #   Student.joins(:schools).where(:schools => { :category => 'public' })
  #   Student.joins(:schools).where('schools.category' => 'public' )
  #
  # == Overwriting default accessors
  #
  # All column values are automatically available through basic accessors on the Active Record
  # object, but sometimes you want to specialize this behavior. This can be done by overwriting
  # the default accessors (using the same name as the attribute) and calling
  # <tt>read_attribute(attr_name)</tt> and <tt>write_attribute(attr_name, value)</tt> to actually
  # change things.
  #
  #   class Song < ActiveRecord::Base
  #     # Uses an integer of seconds to hold the length of the song
  #
  #     def length=(minutes)
  #       write_attribute(:length, minutes.to_i * 60)
  #     end
  #
  #     def length
  #       read_attribute(:length) / 60
  #     end
  #   end
  #
  # You can alternatively use <tt>self[:attribute]=(value)</tt> and <tt>self[:attribute]</tt>
  # instead of <tt>write_attribute(:attribute, value)</tt> and <tt>read_attribute(:attribute)</tt>.
  #
  # == Attribute query methods
  #
  # In addition to the basic accessors, query methods are also automatically available on the Active Record object.
  # Query methods allow you to test whether an attribute value is present.
  #
  # For example, an Active Record User with the <tt>name</tt> attribute has a <tt>name?</tt> method that you can call
  # to determine whether the user has a name:
  #
  #   user = User.new(:name => "David")
  #   user.name? # => true
  #
  #   anonymous = User.new(:name => "")
  #   anonymous.name? # => false
  #
  # == Accessing attributes before they have been typecasted
  #
  # Sometimes you want to be able to read the raw attribute data without having the column-determined
  # typecast run its course first. That can be done by using the <tt><attribute>_before_type_cast</tt>
  # accessors that all attributes have. For example, if your Account model has a <tt>balance</tt> attribute,
  # you can call <tt>account.balance_before_type_cast</tt> or <tt>account.id_before_type_cast</tt>.
  #
  # This is especially useful in validation situations where the user might supply a string for an
  # integer field and you want to display the original string back in an error message. Accessing the
  # attribute normally would typecast the string to 0, which isn't what you want.
  #
  # == Dynamic attribute-based finders
  #
  # Dynamic attribute-based finders are a cleaner way of getting (and/or creating) objects
  # by simple queries without turning to SQL. They work by appending the name of an attribute
  # to <tt>find_by_</tt>, <tt>find_last_by_</tt>, or <tt>find_all_by_</tt> and thus produces finders
  # like <tt>Person.find_by_user_name</tt>, <tt>Person.find_all_by_last_name</tt>, and
  # <tt>Payment.find_by_transaction_id</tt>. Instead of writing
  # <tt>Person.where(:user_name => user_name).first</tt>, you just do <tt>Person.find_by_user_name(user_name)</tt>.
  # And instead of writing <tt>Person.where(:last_name => last_name).all</tt>, you just do
  # <tt>Person.find_all_by_last_name(last_name)</tt>.
  #
  # It's also possible to use multiple attributes in the same find by separating them with "_and_".
  #
  #  Person.where(:user_name => user_name, :password => password).first
  #  Person.find_by_user_name_and_password(user_name, password) # with dynamic finder
  #
  # It's even possible to call these dynamic finder methods on relations and named scopes.
  #
  #   Payment.order("created_on").find_all_by_amount(50)
  #   Payment.pending.find_last_by_amount(100)
  #
  # The same dynamic finder style can be used to create the object if it doesn't already exist.
  # This dynamic finder is called with <tt>find_or_create_by_</tt> and will return the object if
  # it already exists and otherwise creates it, then returns it. Protected attributes won't be set
  # unless they are given in a block.
  #
  #   # No 'Summer' tag exists
  #   Tag.find_or_create_by_name("Summer") # equal to Tag.create(:name => "Summer")
  #
  #   # Now the 'Summer' tag does exist
  #   Tag.find_or_create_by_name("Summer") # equal to Tag.find_by_name("Summer")
  #
  #   # Now 'Bob' exist and is an 'admin'
  #   User.find_or_create_by_name('Bob', :age => 40) { |u| u.admin = true }
  #
  # Use the <tt>find_or_initialize_by_</tt> finder if you want to return a new record without
  # saving it first. Protected attributes won't be set unless they are given in a block.
  #
  #   # No 'Winter' tag exists
  #   winter = Tag.find_or_initialize_by_name("Winter")
  #   winter.persisted? # false
  #
  # To find by a subset of the attributes to be used for instantiating a new object, pass a hash instead of
  # a list of parameters.
  #
  #   Tag.find_or_create_by_name(:name => "rails", :creator => current_user)
  #
  # That will either find an existing tag named "rails", or create a new one while setting the
  # user that created it.
  #
  # Just like <tt>find_by_*</tt>, you can also use <tt>scoped_by_*</tt> to retrieve data. The good thing about
  # using this feature is that the very first time result is returned using <tt>method_missing</tt> technique
  # but after that the method is declared on the class. Henceforth <tt>method_missing</tt> will not be hit.
  #
  #  User.scoped_by_user_name('David')
  #
  # == Saving arrays, hashes, and other non-mappable objects in text columns
  #
  # Active Record can serialize any object in text columns using YAML. To do so, you must
  # specify this with a call to the class method +serialize+.
  # This makes it possible to store arrays, hashes, and other non-mappable objects without doing
  # any additional work.
  #
  #   class User < ActiveRecord::Base
  #     serialize :preferences
  #   end
  #
  #   user = User.create(:preferences => { "background" => "black", "display" => large })
  #   User.find(user.id).preferences # => { "background" => "black", "display" => large }
  #
  # You can also specify a class option as the second parameter that'll raise an exception
  # if a serialized object is retrieved as a descendant of a class not in the hierarchy.
  #
  #   class User < ActiveRecord::Base
  #     serialize :preferences, Hash
  #   end
  #
  #   user = User.create(:preferences => %w( one two three ))
  #   User.find(user.id).preferences    # raises SerializationTypeMismatch
  #
  # When you specify a class option, the default value for that attribute will be a new
  # instance of that class.
  #
  #   class User < ActiveRecord::Base
  #     serialize :preferences, OpenStruct
  #   end
  #
  #   user = User.new
  #   user.preferences.theme_color = "red"
  #
  #
  # == Single table inheritance
  #
  # Active Record allows inheritance by storing the name of the class in a column that by
  # default is named "type" (can be changed by overwriting <tt>Base.inheritance_column</tt>).
  # This means that an inheritance looking like this:
  #
  #   class Company < ActiveRecord::Base; end
  #   class Firm < Company; end
  #   class Client < Company; end
  #   class PriorityClient < Client; end
  #
  # When you do <tt>Firm.create(:name => "37signals")</tt>, this record will be saved in
  # the companies table with type = "Firm". You can then fetch this row again using
  # <tt>Company.where(:name => '37signals').first</tt> and it will return a Firm object.
  #
  # If you don't have a type column defined in your table, single-table inheritance won't
  # be triggered. In that case, it'll work just like normal subclasses with no special magic
  # for differentiating between them or reloading the right type with find.
  #
  # Note, all the attributes for all the cases are kept in the same table. Read more:
  # http://www.martinfowler.com/eaaCatalog/singleTableInheritance.html
  #
  # == Connection to multiple databases in different models
  #
  # Connections are usually created through ActiveRecord::Base.establish_connection and retrieved
  # by ActiveRecord::Base.connection. All classes inheriting from ActiveRecord::Base will use this
  # connection. But you can also set a class-specific connection. For example, if Course is an
  # ActiveRecord::Base, but resides in a different database, you can just say <tt>Course.establish_connection</tt>
  # and Course and all of its subclasses will use this connection instead.
  #
  # This feature is implemented by keeping a connection pool in ActiveRecord::Base that is
  # a Hash indexed by the class. If a connection is requested, the retrieve_connection method
  # will go up the class-hierarchy until a connection is found in the connection pool.
  #
  # == Exceptions
  #
  # * ActiveRecordError - Generic error class and superclass of all other errors raised by Active Record.
  # * AdapterNotSpecified - The configuration hash used in <tt>establish_connection</tt> didn't include an
  #   <tt>:adapter</tt> key.
  # * AdapterNotFound - The <tt>:adapter</tt> key used in <tt>establish_connection</tt> specified a
  #   non-existent adapter
  #   (or a bad spelling of an existing one).
  # * AssociationTypeMismatch - The object assigned to the association wasn't of the type
  #   specified in the association definition.
  # * SerializationTypeMismatch - The serialized object wasn't of the class specified as the second parameter.
  # * ConnectionNotEstablished+ - No connection has been established. Use <tt>establish_connection</tt>
  #   before querying.
  # * RecordNotFound - No record responded to the +find+ method. Either the row with the given ID doesn't exist
  #   or the row didn't meet the additional restrictions. Some +find+ calls do not raise this exception to signal
  #   nothing was found, please check its documentation for further details.
  # * StatementInvalid - The database server rejected the SQL statement. The precise error is added in the message.
  # * MultiparameterAssignmentErrors - Collection of errors that occurred during a mass assignment using the
  #   <tt>attributes=</tt> method. The +errors+ property of this exception contains an array of
  #   AttributeAssignmentError
  #   objects that should be inspected to determine which attributes triggered the errors.
  # * AttributeAssignmentError - An error occurred while doing a mass assignment through the
  #   <tt>attributes=</tt> method.
  #   You can inspect the +attribute+ property of the exception object to determine which attribute
  #   triggered the error.
  #
  # *Note*: The attributes listed are class-level attributes (accessible from both the class and instance level).
  # So it's possible to assign a logger to the class through <tt>Base.logger=</tt> which will then be used by all
  # instances in the current object space.
  class Base
    ##
    # :singleton-method:
    # Accepts a logger conforming to the interface of Log4r or the default Ruby 1.8+ Logger class,
    # which is then passed on to any new database connections made and which can be retrieved on both
    # a class and instance level by calling +logger+.
    cattr_accessor :logger, :instance_writer => false

    ##
    # :singleton-method:
    # Contains the database configuration - as is typically stored in config/database.yml -
    # as a Hash.
    #
    # For example, the following database.yml...
    #
    #   development:
    #     adapter: sqlite3
    #     database: db/development.sqlite3
    #
    #   production:
    #     adapter: sqlite3
    #     database: db/production.sqlite3
    #
    # ...would result in ActiveRecord::Base.configurations to look like this:
    #
    #   {
    #      'development' => {
    #         'adapter'  => 'sqlite3',
    #         'database' => 'db/development.sqlite3'
    #      },
    #      'production' => {
    #         'adapter'  => 'sqlite3',
    #         'database' => 'db/production.sqlite3'
    #      }
    #   }
    cattr_accessor :configurations, :instance_writer => false
    @@configurations = {}

    ##
    # :singleton-method:
    # Accessor for the prefix type that will be prepended to every primary key column name.
    # The options are :table_name and :table_name_with_underscore. If the first is specified,
    # the Product class will look for "productid" instead of "id" as the primary column. If the
    # latter is specified, the Product class will look for "product_id" instead of "id". Remember
    # that this is a global setting for all Active Records.
    cattr_accessor :primary_key_prefix_type, :instance_writer => false
    @@primary_key_prefix_type = nil

    ##
    # :singleton-method:
    # Accessor for the name of the prefix string to prepend to every table name. So if set
    # to "basecamp_", all table names will be named like "basecamp_projects", "basecamp_people",
    # etc. This is a convenient way of creating a namespace for tables in a shared database.
    # By default, the prefix is the empty string.
    #
    # If you are organising your models within modules you can add a prefix to the models within
    # a namespace by defining a singleton method in the parent module called table_name_prefix which
    # returns your chosen prefix.
    class_attribute :table_name_prefix, :instance_writer => false
    self.table_name_prefix = ""

    ##
    # :singleton-method:
    # Works like +table_name_prefix+, but appends instead of prepends (set to "_basecamp" gives "projects_basecamp",
    # "people_basecamp"). By default, the suffix is the empty string.
    class_attribute :table_name_suffix, :instance_writer => false
    self.table_name_suffix = ""

    ##
    # :singleton-method:
    # Indicates whether table names should be the pluralized versions of the corresponding class names.
    # If true, the default table name for a Product class will be +products+. If false, it would just be +product+.
    # See table_name for the full rules on table/class naming. This is true, by default.
    class_attribute :pluralize_table_names, :instance_writer => false
    self.pluralize_table_names = true

    ##
    # :singleton-method:
    # Determines whether to use Time.local (using :local) or Time.utc (using :utc) when pulling
    # dates and times from the database. This is set to :local by default.
    cattr_accessor :default_timezone, :instance_writer => false
    @@default_timezone = :local

    ##
    # :singleton-method:
    # Specifies the format to use when dumping the database schema with Rails'
    # Rakefile. If :sql, the schema is dumped as (potentially database-
    # specific) SQL statements. If :ruby, the schema is dumped as an
    # ActiveRecord::Schema file which can be loaded into any database that
    # supports migrations. Use :ruby if you want to have different database
    # adapters for, e.g., your development and test environments.
    cattr_accessor :schema_format , :instance_writer => false
    @@schema_format = :ruby

    ##
    # :singleton-method:
    # Specify whether or not to use timestamps for migration versions
    cattr_accessor :timestamped_migrations , :instance_writer => false
    @@timestamped_migrations = true

    # Determine whether to store the full constant name including namespace when using STI
    class_attribute :store_full_sti_class
    self.store_full_sti_class = true

    # Stores the default scope for the class
    class_attribute :default_scopes, :instance_writer => false
    self.default_scopes = []

    # Returns a hash of all the attributes that have been specified for serialization as
    # keys and their class restriction as values.
    class_attribute :serialized_attributes
    self.serialized_attributes = {}

    class_attribute :_attr_readonly, :instance_writer => false
    self._attr_readonly = []

    class << self # Class methods
      delegate :find, :first, :first!, :last, :last!, :all, :exists?, :any?, :many?, :to => :scoped
      delegate :destroy, :destroy_all, :delete, :delete_all, :update, :update_all, :to => :scoped
      delegate :find_each, :find_in_batches, :to => :scoped
      delegate :select, :group, :order, :except, :reorder, :limit, :offset, :joins, :where, :preload, :eager_load, :includes, :from, :lock, :readonly, :having, :create_with, :to => :scoped
      delegate :count, :average, :minimum, :maximum, :sum, :calculate, :to => :scoped

      # Executes a custom SQL query against your database and returns all the results. The results will
      # be returned as an array with columns requested encapsulated as attributes of the model you call
      # this method from. If you call <tt>Product.find_by_sql</tt> then the results will be returned in
      # a Product object with the attributes you specified in the SQL query.
      #
      # If you call a complicated SQL query which spans multiple tables the columns specified by the
      # SELECT will be attributes of the model, whether or not they are columns of the corresponding
      # table.
      #
      # The +sql+ parameter is a full SQL query as a string. It will be called as is, there will be
      # no database agnostic conversions performed. This should be a last resort because using, for example,
      # MySQL specific terms will lock you to using that particular database engine or require you to
      # change your call if you switch engines.
      #
      # ==== Examples
      #   # A simple SQL query spanning multiple tables
      #   Post.find_by_sql "SELECT p.title, c.author FROM posts p, comments c WHERE p.id = c.post_id"
      #   > [#<Post:0x36bff9c @attributes={"title"=>"Ruby Meetup", "first_name"=>"Quentin"}>, ...]
      #
      #   # You can use the same string replacement techniques as you can with ActiveRecord#find
      #   Post.find_by_sql ["SELECT title FROM posts WHERE author = ? AND created > ?", author_id, start_date]
      #   > [#<Post:0x36bff9c @attributes={"title"=>"The Cheap Man Buys Twice"}>, ...]
      def find_by_sql(sql, binds = [])
        connection.select_all(sanitize_sql(sql), "#{name} Load", binds).collect! { |record| instantiate(record) }
      end

      # Creates an object (or multiple objects) and saves it to the database, if validations pass.
      # The resulting object is returned whether the object was saved successfully to the database or not.
      #
      # The +attributes+ parameter can be either be a Hash or an Array of Hashes. These Hashes describe the
      # attributes on the objects that are to be created.
      #
      # +create+ respects mass-assignment security and accepts either +:as+ or +:without_protection+ options
      # in the +options+ parameter.
      #
      # ==== Examples
      #   # Create a single new object
      #   User.create(:first_name => 'Jamie')
      #
      #   # Create a single new object using the :admin mass-assignment security role
      #   User.create({ :first_name => 'Jamie', :is_admin => true }, :as => :admin)
      #
      #   # Create a single new object bypassing mass-assignment security
      #   User.create({ :first_name => 'Jamie', :is_admin => true }, :without_protection => true)
      #
      #   # Create an Array of new objects
      #   User.create([{ :first_name => 'Jamie' }, { :first_name => 'Jeremy' }])
      #
      #   # Create a single object and pass it into a block to set other attributes.
      #   User.create(:first_name => 'Jamie') do |u|
      #     u.is_admin = false
      #   end
      #
      #   # Creating an Array of new objects using a block, where the block is executed for each object:
      #   User.create([{ :first_name => 'Jamie' }, { :first_name => 'Jeremy' }]) do |u|
      #     u.is_admin = false
      #   end
      def create(attributes = nil, options = {}, &block)
        if attributes.is_a?(Array)
          attributes.collect { |attr| create(attr, options, &block) }
        else
          object = new(attributes, options)
          yield(object) if block_given?
          object.save
          object
        end
      end

      # Returns the result of an SQL statement that should only include a COUNT(*) in the SELECT part.
      # The use of this method should be restricted to complicated SQL queries that can't be executed
      # using the ActiveRecord::Calculations class methods. Look into those before using this.
      #
      # ==== Parameters
      #
      # * +sql+ - An SQL statement which should return a count query from the database, see the example below.
      #
      # ==== Examples
      #
      #   Product.count_by_sql "SELECT COUNT(*) FROM sales s, customers c WHERE s.customer_id = c.id"
      def count_by_sql(sql)
        sql = sanitize_conditions(sql)
        connection.select_value(sql, "#{name} Count").to_i
      end

      # Attributes listed as readonly will be used to create a new record but update operations will
      # ignore these fields.
      def attr_readonly(*attributes)
        self._attr_readonly = Set.new(attributes.map { |a| a.to_s }) + (self._attr_readonly || [])
      end

      # Returns an array of all the attributes that have been specified as readonly.
      def readonly_attributes
        self._attr_readonly
      end

      # If you have an attribute that needs to be saved to the database as an object, and retrieved as the same object,
      # then specify the name of that attribute using this method and it will be handled automatically.
      # The serialization is done through YAML. If +class_name+ is specified, the serialized object must be of that
      # class on retrieval or SerializationTypeMismatch will be raised.
      #
      # ==== Parameters
      #
      # * +attr_name+ - The field name that should be serialized.
      # * +class_name+ - Optional, class name that the object type should be equal to.
      #
      # ==== Example
      #   # Serialize a preferences attribute
      #   class User < ActiveRecord::Base
      #     serialize :preferences
      #   end
      def serialize(attr_name, class_name = Object)
        coder = if [:load, :dump].all? { |x| class_name.respond_to?(x) }
                  class_name
                else
                  Coders::YAMLColumn.new(class_name)
                end

        # merge new serialized attribute and create new hash to ensure that each class in inheritance hierarchy
        # has its own hash of own serialized attributes
        self.serialized_attributes = serialized_attributes.merge(attr_name.to_s => coder)
      end

      # Guesses the table name (in forced lower-case) based on the name of the class in the
      # inheritance hierarchy descending directly from ActiveRecord::Base. So if the hierarchy
      # looks like: Reply < Message < ActiveRecord::Base, then Message is used
      # to guess the table name even when called on Reply. The rules used to do the guess
      # are handled by the Inflector class in Active Support, which knows almost all common
      # English inflections. You can add new inflections in config/initializers/inflections.rb.
      #
      # Nested classes are given table names prefixed by the singular form of
      # the parent's table name. Enclosing modules are not considered.
      #
      # ==== Examples
      #
      #   class Invoice < ActiveRecord::Base
      #   end
      #
      #   file                  class               table_name
      #   invoice.rb            Invoice             invoices
      #
      #   class Invoice < ActiveRecord::Base
      #     class Lineitem < ActiveRecord::Base
      #     end
      #   end
      #
      #   file                  class               table_name
      #   invoice.rb            Invoice::Lineitem   invoice_lineitems
      #
      #   module Invoice
      #     class Lineitem < ActiveRecord::Base
      #     end
      #   end
      #
      #   file                  class               table_name
      #   invoice/lineitem.rb   Invoice::Lineitem   lineitems
      #
      # Additionally, the class-level +table_name_prefix+ is prepended and the
      # +table_name_suffix+ is appended. So if you have "myapp_" as a prefix,
      # the table name guess for an Invoice class becomes "myapp_invoices".
      # Invoice::Lineitem becomes "myapp_invoice_lineitems".
      #
      # You can also overwrite this class method to allow for unguessable
      # links, such as a Mouse class with a link to a "mice" table. Example:
      #
      #   class Mouse < ActiveRecord::Base
      #     set_table_name "mice"
      #   end
      def table_name
        reset_table_name
      end

      # Returns a quoted version of the table name, used to construct SQL statements.
      def quoted_table_name
        @quoted_table_name ||= connection.quote_table_name(table_name)
      end

      # Computes the table name, (re)sets it internally, and returns it.
      def reset_table_name #:nodoc:
        return if abstract_class?

        self.table_name = compute_table_name
      end

      def full_table_name_prefix #:nodoc:
        (parents.detect{ |p| p.respond_to?(:table_name_prefix) } || self).table_name_prefix
      end

      # Defines the column name for use with single table inheritance. Use
      # <tt>set_inheritance_column</tt> to set a different value.
      def inheritance_column
        @inheritance_column ||= "type"
      end

      # Lazy-set the sequence name to the connection's default. This method
      # is only ever called once since set_sequence_name overrides it.
      def sequence_name #:nodoc:
        reset_sequence_name
      end

      def reset_sequence_name #:nodoc:
        default = connection.default_sequence_name(table_name, primary_key)
        set_sequence_name(default)
        default
      end

      # Sets the table name. If the value is nil or false then the value returned by the given
      # block is used.
      #
      #   class Project < ActiveRecord::Base
      #     set_table_name "project"
      #   end
      def set_table_name(value = nil, &block)
        @quoted_table_name = nil
        define_attr_method :table_name, value, &block
        @arel_table = nil

        @arel_table = Arel::Table.new(table_name, arel_engine)
        @relation = Relation.new(self, arel_table)
      end
      alias :table_name= :set_table_name

      # Sets the name of the inheritance column to use to the given value,
      # or (if the value # is nil or false) to the value returned by the
      # given block.
      #
      #   class Project < ActiveRecord::Base
      #     set_inheritance_column do
      #       original_inheritance_column + "_id"
      #     end
      #   end
      def set_inheritance_column(value = nil, &block)
        define_attr_method :inheritance_column, value, &block
      end
      alias :inheritance_column= :set_inheritance_column

      # Sets the name of the sequence to use when generating ids to the given
      # value, or (if the value is nil or false) to the value returned by the
      # given block. This is required for Oracle and is useful for any
      # database which relies on sequences for primary key generation.
      #
      # If a sequence name is not explicitly set when using Oracle or Firebird,
      # it will default to the commonly used pattern of: #{table_name}_seq
      #
      # If a sequence name is not explicitly set when using PostgreSQL, it
      # will discover the sequence corresponding to your primary key for you.
      #
      #   class Project < ActiveRecord::Base
      #     set_sequence_name "projectseq"   # default would have been "project_seq"
      #   end
      def set_sequence_name(value = nil, &block)
        define_attr_method :sequence_name, value, &block
      end
      alias :sequence_name= :set_sequence_name

      # Indicates whether the table associated with this class exists
      def table_exists?
        connection.table_exists?(table_name)
      end

      # Returns an array of column objects for the table associated with this class.
      def columns
        if defined?(@primary_key)
          connection_pool.primary_keys[table_name] ||= primary_key
        end

        connection_pool.columns[table_name]
      end

      # Returns a hash of column objects for the table associated with this class.
      def columns_hash
        connection_pool.columns_hash[table_name]
      end

      # Returns a hash where the keys are column names and the values are
      # default values when instantiating the AR object for this table.
      def column_defaults
        connection_pool.column_defaults[table_name]
      end

      # Returns an array of column names as strings.
      def column_names
        @column_names ||= columns.map { |column| column.name }
      end

      # Returns an array of column objects where the primary id, all columns ending in "_id" or "_count",
      # and columns used for single table inheritance have been removed.
      def content_columns
        @content_columns ||= columns.reject { |c| c.primary || c.name =~ /(_id|_count)$/ || c.name == inheritance_column }
      end

      # Returns a hash of all the methods added to query each of the columns in the table with the name of the method as the key
      # and true as the value. This makes it possible to do O(1) lookups in respond_to? to check if a given method for attribute
      # is available.
      def column_methods_hash #:nodoc:
        @dynamic_methods_hash ||= column_names.inject(Hash.new(false)) do |methods, attr|
          attr_name = attr.to_s
          methods[attr.to_sym]       = attr_name
          methods["#{attr}=".to_sym] = attr_name
          methods["#{attr}?".to_sym] = attr_name
          methods["#{attr}_before_type_cast".to_sym] = attr_name
          methods
        end
      end

      # Resets all the cached information about columns, which will cause them
      # to be reloaded on the next request.
      #
      # The most common usage pattern for this method is probably in a migration,
      # when just after creating a table you want to populate it with some default
      # values, eg:
      #
      #  class CreateJobLevels < ActiveRecord::Migration
      #    def up
      #      create_table :job_levels do |t|
      #        t.integer :id
      #        t.string :name
      #
      #        t.timestamps
      #      end
      #
      #      JobLevel.reset_column_information
      #      %w{assistant executive manager director}.each do |type|
      #        JobLevel.create(:name => type)
      #      end
      #    end
      #
      #    def down
      #      drop_table :job_levels
      #    end
      #  end
      def reset_column_information
        connection.clear_cache!
        undefine_attribute_methods
        connection_pool.clear_table_cache!(table_name) if table_exists?

        @column_names = @content_columns = @dynamic_methods_hash = @inheritance_column = nil
        @arel_engine = @relation = nil
      end

      def clear_cache! # :nodoc:
        connection_pool.clear_cache!
      end

      def attribute_method?(attribute)
        super || (table_exists? && column_names.include?(attribute.to_s.sub(/=$/, '')))
      end

      # Returns an array of column names as strings if it's not
      # an abstract class and table exists.
      # Otherwise it returns an empty array.
      def attribute_names
        @attribute_names ||= if !abstract_class? && table_exists?
            column_names
          else
            []
          end
      end

      # Set the lookup ancestors for ActiveModel.
      def lookup_ancestors #:nodoc:
        klass = self
        classes = [klass]
        return classes if klass == ActiveRecord::Base

        while klass != klass.base_class
          classes << klass = klass.superclass
        end
        classes
      end

      # Set the i18n scope to overwrite ActiveModel.
      def i18n_scope #:nodoc:
        :activerecord
      end

      # True if this isn't a concrete subclass needing a STI type condition.
      def descends_from_active_record?
        if superclass.abstract_class?
          superclass.descends_from_active_record?
        else
          superclass == Base || !columns_hash.include?(inheritance_column)
        end
      end

      def finder_needs_type_condition? #:nodoc:
        # This is like this because benchmarking justifies the strange :false stuff
        :true == (@finder_needs_type_condition ||= descends_from_active_record? ? :false : :true)
      end

      # Returns a string like 'Post(id:integer, title:string, body:text)'
      def inspect
        if self == Base
          super
        elsif abstract_class?
          "#{super}(abstract)"
        elsif table_exists?
          attr_list = columns.map { |c| "#{c.name}: #{c.type}" } * ', '
          "#{super}(#{attr_list})"
        else
          "#{super}(Table doesn't exist)"
        end
      end

      def quote_value(value, column = nil) #:nodoc:
        connection.quote(value,column)
      end

      # Used to sanitize objects before they're used in an SQL SELECT statement. Delegates to <tt>connection.quote</tt>.
      def sanitize(object) #:nodoc:
        connection.quote(object)
      end

      # Overwrite the default class equality method to provide support for association proxies.
      def ===(object)
        object.is_a?(self)
      end

      def symbolized_base_class
        @symbolized_base_class ||= base_class.to_s.to_sym
      end

      def symbolized_sti_name
        @symbolized_sti_name ||= sti_name.present? ? sti_name.to_sym : symbolized_base_class
      end

      # Returns the base AR subclass that this class descends from. If A
      # extends AR::Base, A.base_class will return A. If B descends from A
      # through some arbitrarily deep hierarchy, B.base_class will return A.
      #
      # If B < A and C < B and if A is an abstract_class then both B.base_class
      # and C.base_class would return B as the answer since A is an abstract_class.
      def base_class
        class_of_active_record_descendant(self)
      end

      # Set this to true if this is an abstract class (see <tt>abstract_class?</tt>).
      attr_accessor :abstract_class

      # Returns whether this class is an abstract class or not.
      def abstract_class?
        defined?(@abstract_class) && @abstract_class == true
      end

      def respond_to?(method_id, include_private = false)
        if match = DynamicFinderMatch.match(method_id)
          return true if all_attributes_exists?(match.attribute_names)
        elsif match = DynamicScopeMatch.match(method_id)
          return true if all_attributes_exists?(match.attribute_names)
        end

        super
      end

      def sti_name
        store_full_sti_class ? name : name.demodulize
      end

      def arel_table
        @arel_table ||= Arel::Table.new(table_name, arel_engine)
      end

      def arel_engine
        @arel_engine ||= begin
          if self == ActiveRecord::Base
            ActiveRecord::Base
          else
            connection_handler.connection_pools[name] ? self : superclass.arel_engine
          end
        end
      end

      # Returns a scope for this class without taking into account the default_scope.
      #
      #   class Post < ActiveRecord::Base
      #     def self.default_scope
      #       where :published => true
      #     end
      #   end
      #
      #   Post.all          # Fires "SELECT * FROM posts WHERE published = true"
      #   Post.unscoped.all # Fires "SELECT * FROM posts"
      #
      # This method also accepts a block meaning that all queries inside the block will
      # not use the default_scope:
      #
      #   Post.unscoped {
      #     Post.limit(10) # Fires "SELECT * FROM posts LIMIT 10"
      #   }
      #
      # It is recommended to use block form of unscoped because chaining unscoped with <tt>scope</tt>
      # does not work. Assuming that <tt>published</tt> is a <tt>scope</tt> following two statements are same.
      #
      # Post.unscoped.published
      # Post.published
      def unscoped #:nodoc:
        block_given? ? relation.scoping { yield } : relation
      end

      def before_remove_const #:nodoc:
        self.current_scope = nil
      end

      # Finder methods must instantiate through this method to work with the
      # single-table inheritance model that makes it possible to create
      # objects of different types from the same table.
      def instantiate(record)
        sti_class = find_sti_class(record[inheritance_column])
        record_id = sti_class.primary_key && record[sti_class.primary_key]

        if ActiveRecord::IdentityMap.enabled? && record_id
          if (column = sti_class.columns_hash[sti_class.primary_key]) && column.number?
            record_id = record_id.to_i
          end
          if instance = IdentityMap.get(sti_class, record_id)
            instance.reinit_with('attributes' => record)
          else
            instance = sti_class.allocate.init_with('attributes' => record)
            IdentityMap.add(instance)
          end
        else
          instance = sti_class.allocate.init_with('attributes' => record)
        end

        instance
      end

      private

        def relation #:nodoc:
          @relation ||= Relation.new(self, arel_table)

          if finder_needs_type_condition?
            @relation.where(type_condition).create_with(inheritance_column.to_sym => sti_name)
          else
            @relation
          end
        end

        def find_sti_class(type_name)
          if type_name.blank? || !columns_hash.include?(inheritance_column)
            self
          else
            begin
              if store_full_sti_class
                ActiveSupport::Dependencies.constantize(type_name)
              else
                compute_type(type_name)
              end
            rescue NameError
              raise SubclassNotFound,
                "The single-table inheritance mechanism failed to locate the subclass: '#{type_name}'. " +
                "This error is raised because the column '#{inheritance_column}' is reserved for storing the class in case of inheritance. " +
                "Please rename this column if you didn't intend it to be used for storing the inheritance class " +
                "or overwrite #{name}.inheritance_column to use another column for that information."
            end
          end
        end

        def construct_finder_arel(options = {}, scope = nil)
          relation = options.is_a?(Hash) ? unscoped.apply_finder_options(options) : options
          relation = scope.merge(relation) if scope
          relation
        end

        def type_condition(table = arel_table)
          sti_column = table[inheritance_column.to_sym]
          sti_names  = ([self] + descendants).map { |model| model.sti_name }

          sti_column.in(sti_names)
        end

        # Guesses the table name, but does not decorate it with prefix and suffix information.
        def undecorated_table_name(class_name = base_class.name)
          table_name = class_name.to_s.demodulize.underscore
          table_name = table_name.pluralize if pluralize_table_names
          table_name
        end

        # Computes and returns a table name according to default conventions.
        def compute_table_name
          base = base_class
          if self == base
            # Nested classes are prefixed with singular parent table name.
            if parent < ActiveRecord::Base && !parent.abstract_class?
              contained = parent.table_name
              contained = contained.singularize if parent.pluralize_table_names
              contained += '_'
            end
            "#{full_table_name_prefix}#{contained}#{undecorated_table_name(name)}#{table_name_suffix}"
          else
            # STI subclasses always use their superclass' table.
            base.table_name
          end
        end

        # Enables dynamic finders like <tt>User.find_by_user_name(user_name)</tt> and
        # <tt>User.scoped_by_user_name(user_name). Refer to Dynamic attribute-based finders
        # section at the top of this file for more detailed information.
        #
        # It's even possible to use all the additional parameters to +find+. For example, the
        # full interface for +find_all_by_amount+ is actually <tt>find_all_by_amount(amount, options)</tt>.
        #
        # Each dynamic finder using <tt>scoped_by_*</tt> is also defined in the class after it
        # is first invoked, so that future attempts to use it do not run through method_missing.
        def method_missing(method_id, *arguments, &block)
          if match = DynamicFinderMatch.match(method_id)
            attribute_names = match.attribute_names
            super unless all_attributes_exists?(attribute_names)
            if !arguments.first.is_a?(Hash) && arguments.size < attribute_names.size
              ActiveSupport::Deprecation.warn(<<-eowarn)
Calling dynamic finder with less number of arguments than the number of attributes in method name is deprecated and will raise an ArguementError in the next version of Rails. Please passing `nil' to the argument you want it to be nil.
                eowarn
            end
            if match.finder?
              options = arguments.extract_options!
              relation = options.any? ? scoped(options) : scoped
              relation.send :find_by_attributes, match, attribute_names, *arguments
            elsif match.instantiator?
              scoped.send :find_or_instantiator_by_attributes, match, attribute_names, *arguments, &block
            end
          elsif match = DynamicScopeMatch.match(method_id)
            attribute_names = match.attribute_names
            super unless all_attributes_exists?(attribute_names)
            if arguments.size < attribute_names.size
              ActiveSupport::Deprecation.warn(
                "Calling dynamic scope with less number of arguments than the number of attributes in " \
                "method name is deprecated and will raise an ArguementError in the next version of Rails. " \
                "Please passing `nil' to the argument you want it to be nil."
              )
            end
            if match.scope?
              self.class_eval <<-METHOD, __FILE__, __LINE__ + 1
                def self.#{method_id}(*args)                                    # def self.scoped_by_user_name_and_password(*args)
                  attributes = Hash[[:#{attribute_names.join(',:')}].zip(args)] #   attributes = Hash[[:user_name, :password].zip(args)]
                                                                                #
                  scoped(:conditions => attributes)                             #   scoped(:conditions => attributes)
                end                                                             # end
              METHOD
              send(method_id, *arguments)
            end
          else
            super
          end
        end

        # Similar in purpose to +expand_hash_conditions_for_aggregates+.
        def expand_attribute_names_for_aggregates(attribute_names)
          attribute_names.map { |attribute_name|
            unless (aggregation = reflect_on_aggregation(attribute_name.to_sym)).nil?
              aggregate_mapping(aggregation).map do |field_attr, _|
                field_attr.to_sym
              end
            else
              attribute_name.to_sym
            end
          }.flatten
        end

        def all_attributes_exists?(attribute_names)
          (expand_attribute_names_for_aggregates(attribute_names) -
           column_methods_hash.keys).empty?
        end

      protected
        # with_scope lets you apply options to inner block incrementally. It takes a hash and the keys must be
        # <tt>:find</tt> or <tt>:create</tt>. <tt>:find</tt> parameter is <tt>Relation</tt> while
        # <tt>:create</tt> parameters are an attributes hash.
        #
        #   class Article < ActiveRecord::Base
        #     def self.create_with_scope
        #       with_scope(:find => where(:blog_id => 1), :create => { :blog_id => 1 }) do
        #         find(1) # => SELECT * from articles WHERE blog_id = 1 AND id = 1
        #         a = create(1)
        #         a.blog_id # => 1
        #       end
        #     end
        #   end
        #
        # In nested scopings, all previous parameters are overwritten by the innermost rule, with the exception of
        # <tt>where</tt>, <tt>includes</tt>, and <tt>joins</tt> operations in <tt>Relation</tt>, which are merged.
        #
        # <tt>joins</tt> operations are uniqued so multiple scopes can join in the same table without table aliasing
        # problems. If you need to join multiple tables, but still want one of the tables to be uniqued, use the
        # array of strings format for your joins.
        #
        #   class Article < ActiveRecord::Base
        #     def self.find_with_scope
        #       with_scope(:find => where(:blog_id => 1).limit(1), :create => { :blog_id => 1 }) do
        #         with_scope(:find => limit(10)) do
        #           all # => SELECT * from articles WHERE blog_id = 1 LIMIT 10
        #         end
        #         with_scope(:find => where(:author_id => 3)) do
        #           all # => SELECT * from articles WHERE blog_id = 1 AND author_id = 3 LIMIT 1
        #         end
        #       end
        #     end
        #   end
        #
        # You can ignore any previous scopings by using the <tt>with_exclusive_scope</tt> method.
        #
        #   class Article < ActiveRecord::Base
        #     def self.find_with_exclusive_scope
        #       with_scope(:find => where(:blog_id => 1).limit(1)) do
        #         with_exclusive_scope(:find => limit(10)) do
        #           all # => SELECT * from articles LIMIT 10
        #         end
        #       end
        #     end
        #   end
        #
        # *Note*: the +:find+ scope also has effect on update and deletion methods, like +update_all+ and +delete_all+.
        def with_scope(scope = {}, action = :merge, &block)
          # If another Active Record class has been passed in, get its current scope
          scope = scope.current_scope if !scope.is_a?(Relation) && scope.respond_to?(:current_scope)

          previous_scope = self.current_scope

          if scope.is_a?(Hash)
            # Dup first and second level of hash (method and params).
            scope = scope.dup
            scope.each do |method, params|
              scope[method] = params.dup unless params == true
            end

            scope.assert_valid_keys([ :find, :create ])
            relation = construct_finder_arel(scope[:find] || {})
            relation.default_scoped = true unless action == :overwrite

            if previous_scope && previous_scope.create_with_value && scope[:create]
              scope_for_create = if action == :merge
                previous_scope.create_with_value.merge(scope[:create])
              else
                scope[:create]
              end

              relation = relation.create_with(scope_for_create)
            else
              scope_for_create = scope[:create]
              scope_for_create ||= previous_scope.create_with_value if previous_scope
              relation = relation.create_with(scope_for_create) if scope_for_create
            end

            scope = relation
          end

          scope = previous_scope.merge(scope) if previous_scope && action == :merge

          self.current_scope = scope
          begin
            yield
          ensure
            self.current_scope = previous_scope
          end
        end

        # Works like with_scope, but discards any nested properties.
        def with_exclusive_scope(method_scoping = {}, &block)
          if method_scoping.values.any? { |e| e.is_a?(ActiveRecord::Relation) }
            raise ArgumentError, <<-MSG
New finder API can not be used with_exclusive_scope. You can either call unscoped to get an anonymous scope not bound to the default_scope:

  User.unscoped.where(:active => true)

Or call unscoped with a block:

  User.unscoped do
    User.where(:active => true).all
  end

MSG
          end
          with_scope(method_scoping, :overwrite, &block)
        end

        def current_scope #:nodoc:
          Thread.current["#{self}_current_scope"]
        end

        def current_scope=(scope) #:nodoc:
          Thread.current["#{self}_current_scope"] = scope
        end

        # Use this macro in your model to set a default scope for all operations on
        # the model.
        #
        #   class Article < ActiveRecord::Base
        #     default_scope where(:published => true)
        #   end
        #
        #   Article.all # => SELECT * FROM articles WHERE published = true
        #
        # The <tt>default_scope</tt> is also applied while creating/building a record. It is not
        # applied while updating a record.
        #
        #   Article.new.published    # => true
        #   Article.create.published # => true
        #
        # You can also use <tt>default_scope</tt> with a block, in order to have it lazily evaluated:
        #
        #   class Article < ActiveRecord::Base
        #     default_scope { where(:published_at => Time.now - 1.week) }
        #   end
        #
        # (You can also pass any object which responds to <tt>call</tt> to the <tt>default_scope</tt>
        # macro, and it will be called when building the default scope.)
        #
        # If you use multiple <tt>default_scope</tt> declarations in your model then they will
        # be merged together:
        #
        #   class Article < ActiveRecord::Base
        #     default_scope where(:published => true)
        #     default_scope where(:rating => 'G')
        #   end
        #
        #   Article.all # => SELECT * FROM articles WHERE published = true AND rating = 'G'
        #
        # This is also the case with inheritance and module includes where the parent or module
        # defines a <tt>default_scope</tt> and the child or including class defines a second one.
        #
        # If you need to do more complex things with a default scope, you can alternatively
        # define it as a class method:
        #
        #   class Article < ActiveRecord::Base
        #     def self.default_scope
        #       # Should return a scope, you can call 'super' here etc.
        #     end
        #   end
        def default_scope(scope = {})
          scope = Proc.new if block_given?
          self.default_scopes = default_scopes + [scope]
        end

        def build_default_scope #:nodoc:
          if method(:default_scope).owner != Base.singleton_class
            evaluate_default_scope { default_scope }
          elsif default_scopes.any?
            evaluate_default_scope do
              default_scopes.inject(relation) do |default_scope, scope|
                if scope.is_a?(Hash)
                  default_scope.apply_finder_options(scope)
                elsif !scope.is_a?(Relation) && scope.respond_to?(:call)
                  default_scope.merge(scope.call)
                else
                  default_scope.merge(scope)
                end
              end
            end
          end
        end

        def ignore_default_scope? #:nodoc:
          Thread.current["#{self}_ignore_default_scope"]
        end

        def ignore_default_scope=(ignore) #:nodoc:
          Thread.current["#{self}_ignore_default_scope"] = ignore
        end

        # The ignore_default_scope flag is used to prevent an infinite recursion situation where
        # a default scope references a scope which has a default scope which references a scope...
        def evaluate_default_scope
          return if ignore_default_scope?

          begin
            self.ignore_default_scope = true
            yield
          ensure
            self.ignore_default_scope = false
          end
        end

        # Returns the class type of the record using the current module as a prefix. So descendants of
        # MyApp::Business::Account would appear as MyApp::Business::AccountSubclass.
        def compute_type(type_name)
          if type_name.match(/^::/)
            # If the type is prefixed with a scope operator then we assume that
            # the type_name is an absolute reference.
            ActiveSupport::Dependencies.constantize(type_name)
          else
            # Build a list of candidates to search for
            candidates = []
            name.scan(/::|$/) { candidates.unshift "#{$`}::#{type_name}" }
            candidates << type_name

            candidates.each do |candidate|
              begin
                constant = ActiveSupport::Dependencies.constantize(candidate)
                return constant if candidate == constant.to_s
              rescue NameError => e
                # We don't want to swallow NoMethodError < NameError errors
                raise e unless e.instance_of?(NameError)
              end
            end

            raise NameError, "uninitialized constant #{candidates.first}"
          end
        end

        # Returns the class descending directly from ActiveRecord::Base or an
        # abstract class, if any, in the inheritance hierarchy.
        def class_of_active_record_descendant(klass)
          if klass.superclass == Base || klass.superclass.abstract_class?
            klass
          elsif klass.superclass.nil?
            raise ActiveRecordError, "#{name} doesn't belong in a hierarchy descending from ActiveRecord"
          else
            class_of_active_record_descendant(klass.superclass)
          end
        end

        # Accepts an array, hash, or string of SQL conditions and sanitizes
        # them into a valid SQL fragment for a WHERE clause.
        #   ["name='%s' and group_id='%s'", "foo'bar", 4]  returns  "name='foo''bar' and group_id='4'"
        #   { :name => "foo'bar", :group_id => 4 }  returns "name='foo''bar' and group_id='4'"
        #   "name='foo''bar' and group_id='4'" returns "name='foo''bar' and group_id='4'"
        def sanitize_sql_for_conditions(condition, table_name = self.table_name)
          return nil if condition.blank?

          case condition
            when Array; sanitize_sql_array(condition)
            when Hash;  sanitize_sql_hash_for_conditions(condition, table_name)
            else        condition
          end
        end
        alias_method :sanitize_sql, :sanitize_sql_for_conditions

        # Accepts an array, hash, or string of SQL conditions and sanitizes
        # them into a valid SQL fragment for a SET clause.
        #   { :name => nil, :group_id => 4 }  returns "name = NULL , group_id='4'"
        def sanitize_sql_for_assignment(assignments)
          case assignments
            when Array; sanitize_sql_array(assignments)
            when Hash;  sanitize_sql_hash_for_assignment(assignments)
            else        assignments
          end
        end

        def aggregate_mapping(reflection)
          mapping = reflection.options[:mapping] || [reflection.name, reflection.name]
          mapping.first.is_a?(Array) ? mapping : [mapping]
        end

        # Accepts a hash of SQL conditions and replaces those attributes
        # that correspond to a +composed_of+ relationship with their expanded
        # aggregate attribute values.
        # Given:
        #     class Person < ActiveRecord::Base
        #       composed_of :address, :class_name => "Address",
        #         :mapping => [%w(address_street street), %w(address_city city)]
        #     end
        # Then:
        #     { :address => Address.new("813 abc st.", "chicago") }
        #       # => { :address_street => "813 abc st.", :address_city => "chicago" }
        def expand_hash_conditions_for_aggregates(attrs)
          expanded_attrs = {}
          attrs.each do |attr, value|
            unless (aggregation = reflect_on_aggregation(attr.to_sym)).nil?
              mapping = aggregate_mapping(aggregation)
              mapping.each do |field_attr, aggregate_attr|
                if mapping.size == 1 && !value.respond_to?(aggregate_attr)
                  expanded_attrs[field_attr] = value
                else
                  expanded_attrs[field_attr] = value.send(aggregate_attr)
                end
              end
            else
              expanded_attrs[attr] = value
            end
          end
          expanded_attrs
        end

        # Sanitizes a hash of attribute/value pairs into SQL conditions for a WHERE clause.
        #   { :name => "foo'bar", :group_id => 4 }
        #     # => "name='foo''bar' and group_id= 4"
        #   { :status => nil, :group_id => [1,2,3] }
        #     # => "status IS NULL and group_id IN (1,2,3)"
        #   { :age => 13..18 }
        #     # => "age BETWEEN 13 AND 18"
        #   { 'other_records.id' => 7 }
        #     # => "`other_records`.`id` = 7"
        #   { :other_records => { :id => 7 } }
        #     # => "`other_records`.`id` = 7"
        # And for value objects on a composed_of relationship:
        #   { :address => Address.new("123 abc st.", "chicago") }
        #     # => "address_street='123 abc st.' and address_city='chicago'"
        def sanitize_sql_hash_for_conditions(attrs, default_table_name = self.table_name)
          attrs = expand_hash_conditions_for_aggregates(attrs)

          table = Arel::Table.new(table_name).alias(default_table_name)
          PredicateBuilder.build_from_hash(arel_engine, attrs, table).map { |b|
            connection.visitor.accept b
          }.join(' AND ')
        end
        alias_method :sanitize_sql_hash, :sanitize_sql_hash_for_conditions

        # Sanitizes a hash of attribute/value pairs into SQL conditions for a SET clause.
        #   { :status => nil, :group_id => 1 }
        #     # => "status = NULL , group_id = 1"
        def sanitize_sql_hash_for_assignment(attrs)
          attrs.map do |attr, value|
            "#{connection.quote_column_name(attr)} = #{quote_bound_value(value)}"
          end.join(', ')
        end

        # Accepts an array of conditions. The array has each value
        # sanitized and interpolated into the SQL statement.
        #   ["name='%s' and group_id='%s'", "foo'bar", 4]  returns  "name='foo''bar' and group_id='4'"
        def sanitize_sql_array(ary)
          statement, *values = ary
          if values.first.is_a?(Hash) && statement =~ /:\w+/
            replace_named_bind_variables(statement, values.first)
          elsif statement.include?('?')
            replace_bind_variables(statement, values)
          elsif statement.blank?
            statement
          else
            statement % values.collect { |value| connection.quote_string(value.to_s) }
          end
        end

        alias_method :sanitize_conditions, :sanitize_sql

        def replace_bind_variables(statement, values) #:nodoc:
          raise_if_bind_arity_mismatch(statement, statement.count('?'), values.size)
          bound = values.dup
          c = connection
          statement.gsub('?') { quote_bound_value(bound.shift, c) }
        end

        def replace_named_bind_variables(statement, bind_vars) #:nodoc:
          statement.gsub(/(:?):([a-zA-Z]\w*)/) do
            if $1 == ':' # skip postgresql casts
              $& # return the whole match
            elsif bind_vars.include?(match = $2.to_sym)
              quote_bound_value(bind_vars[match])
            else
              raise PreparedStatementInvalid, "missing value for :#{match} in #{statement}"
            end
          end
        end

        def expand_range_bind_variables(bind_vars) #:nodoc:
          expanded = []

          bind_vars.each do |var|
            next if var.is_a?(Hash)

            if var.is_a?(Range)
              expanded << var.first
              expanded << var.last
            else
              expanded << var
            end
          end

          expanded
        end

        def quote_bound_value(value, c = connection) #:nodoc:
          if value.respond_to?(:map) && !value.acts_like?(:string)
            if value.respond_to?(:empty?) && value.empty?
              c.quote(nil)
            else
              value.map { |v| c.quote(v) }.join(',')
            end
          else
            c.quote(value)
          end
        end

        def raise_if_bind_arity_mismatch(statement, expected, provided) #:nodoc:
          unless expected == provided
            raise PreparedStatementInvalid, "wrong number of bind variables (#{provided} for #{expected}) in: #{statement}"
          end
        end

        def encode_quoted_value(value) #:nodoc:
          quoted_value = connection.quote(value)
          quoted_value = "'#{quoted_value[1..-2].gsub(/\'/, "\\\\'")}'" if quoted_value.include?("\\\'") # (for ruby mode) "
          quoted_value
        end
    end

    public
      # New objects can be instantiated as either empty (pass no construction parameter) or pre-set with
      # attributes but not yet saved (pass a hash with key names matching the associated table column names).
      # In both instances, valid attribute keys are determined by the column names of the associated table --
      # hence you can't have attributes that aren't part of the table columns.
      #
      # +initialize+ respects mass-assignment security and accepts either +:as+ or +:without_protection+ options
      # in the +options+ parameter.
      #
      # ==== Examples
      #   # Instantiates a single new object
      #   User.new(:first_name => 'Jamie')
      #
      #   # Instantiates a single new object using the :admin mass-assignment security role
      #   User.new({ :first_name => 'Jamie', :is_admin => true }, :as => :admin)
      #
      #   # Instantiates a single new object bypassing mass-assignment security
      #   User.new({ :first_name => 'Jamie', :is_admin => true }, :without_protection => true)
      def initialize(attributes = nil, options = {})
        @attributes = attributes_from_column_definition
        @association_cache = {}
        @aggregation_cache = {}
        @attributes_cache = {}
        @new_record = true
        @readonly = false
        @destroyed = false
        @marked_for_destruction = false
        @previously_changed = {}
        @changed_attributes = {}
        @relation = nil

        ensure_proper_type
        set_serialized_attributes

        populate_with_current_scope_attributes

        assign_attributes(attributes, options) if attributes

        yield self if block_given?
        run_callbacks :initialize
      end

      # Populate +coder+ with attributes about this record that should be
      # serialized. The structure of +coder+ defined in this method is
      # guaranteed to match the structure of +coder+ passed to the +init_with+
      # method.
      #
      # Example:
      #
      #   class Post < ActiveRecord::Base
      #   end
      #   coder = {}
      #   Post.new.encode_with(coder)
      #   coder # => { 'id' => nil, ... }
      def encode_with(coder)
        coder['attributes'] = attributes
      end

      # Initialize an empty model object from +coder+. +coder+ must contain
      # the attributes necessary for initializing an empty model object. For
      # example:
      #
      #   class Post < ActiveRecord::Base
      #   end
      #
      #   post = Post.allocate
      #   post.init_with('attributes' => { 'title' => 'hello world' })
      #   post.title # => 'hello world'
      def init_with(coder)
        @attributes = coder['attributes']
        @relation = nil

        set_serialized_attributes

        @attributes_cache, @previously_changed, @changed_attributes = {}, {}, {}
        @association_cache = {}
        @aggregation_cache = {}
        @readonly = @destroyed = @marked_for_destruction = false
        @new_record = false
        run_callbacks :find
        run_callbacks :initialize

        self
      end

      # Returns a String, which Action Pack uses for constructing an URL to this
      # object. The default implementation returns this record's id as a String,
      # or nil if this record's unsaved.
      #
      # For example, suppose that you have a User model, and that you have a
      # <tt>resources :users</tt> route. Normally, +user_path+ will
      # construct a path with the user object's 'id' in it:
      #
      #   user = User.find_by_name('Phusion')
      #   user_path(user)  # => "/users/1"
      #
      # You can override +to_param+ in your model to make +user_path+ construct
      # a path using the user's name instead of the user's id:
      #
      #   class User < ActiveRecord::Base
      #     def to_param  # overridden
      #       name
      #     end
      #   end
      #
      #   user = User.find_by_name('Phusion')
      #   user_path(user)  # => "/users/Phusion"
      def to_param
        # We can't use alias_method here, because method 'id' optimizes itself on the fly.
        id && id.to_s # Be sure to stringify the id for routes
      end

      # Returns a cache key that can be used to identify this record.
      #
      # ==== Examples
      #
      #   Product.new.cache_key     # => "products/new"
      #   Product.find(5).cache_key # => "products/5" (updated_at not available)
      #   Person.find(5).cache_key  # => "people/5-20071224150000" (updated_at available)
      def cache_key
        case
        when new_record?
          "#{self.class.model_name.cache_key}/new"
        when timestamp = self[:updated_at]
          timestamp = timestamp.utc.to_s(:number)
          "#{self.class.model_name.cache_key}/#{id}-#{timestamp}"
        else
          "#{self.class.model_name.cache_key}/#{id}"
        end
      end

      def quoted_id #:nodoc:
        quote_value(id, column_for_attribute(self.class.primary_key))
      end

      # Returns true if the given attribute is in the attributes hash
      def has_attribute?(attr_name)
        @attributes.has_key?(attr_name.to_s)
      end

      # Returns an array of names for the attributes available on this object.
      def attribute_names
        @attributes.keys
      end

      # Allows you to set all the attributes at once by passing in a hash with keys
      # matching the attribute names (which again matches the column names).
      #
      # If any attributes are protected by either +attr_protected+ or
      # +attr_accessible+ then only settable attributes will be assigned.
      #
      # The +guard_protected_attributes+ argument is now deprecated, use
      # the +assign_attributes+ method if you want to bypass mass-assignment security.
      #
      #   class User < ActiveRecord::Base
      #     attr_protected :is_admin
      #   end
      #
      #   user = User.new
      #   user.attributes = { :username => 'Phusion', :is_admin => true }
      #   user.username   # => "Phusion"
      #   user.is_admin?  # => false
      def attributes=(new_attributes, guard_protected_attributes = nil)
        unless guard_protected_attributes.nil?
          message = "the use of 'guard_protected_attributes' will be removed from the next minor release of rails, " +
                    "if you want to bypass mass-assignment security then look into using assign_attributes"
          ActiveSupport::Deprecation.warn(message)
        end

        return unless new_attributes.is_a?(Hash)

        if guard_protected_attributes == false
          assign_attributes(new_attributes, :without_protection => true)
        else
          assign_attributes(new_attributes)
        end
      end

      # Allows you to set all the attributes for a particular mass-assignment
      # security role by passing in a hash of attributes with keys matching
      # the attribute names (which again matches the column names) and the role
      # name using the :as option.
      #
      # To bypass mass-assignment security you can use the :without_protection => true
      # option.
      #
      #   class User < ActiveRecord::Base
      #     attr_accessible :name
      #     attr_accessible :name, :is_admin, :as => :admin
      #   end
      #
      #   user = User.new
      #   user.assign_attributes({ :name => 'Josh', :is_admin => true })
      #   user.name       # => "Josh"
      #   user.is_admin?  # => false
      #
      #   user = User.new
      #   user.assign_attributes({ :name => 'Josh', :is_admin => true }, :as => :admin)
      #   user.name       # => "Josh"
      #   user.is_admin?  # => true
      #
      #   user = User.new
      #   user.assign_attributes({ :name => 'Josh', :is_admin => true }, :without_protection => true)
      #   user.name       # => "Josh"
      #   user.is_admin?  # => true
      def assign_attributes(new_attributes, options = {})
        return unless new_attributes

        attributes = new_attributes.stringify_keys
        multi_parameter_attributes = []
        @mass_assignment_options = options

        unless options[:without_protection]
          attributes = sanitize_for_mass_assignment(attributes, mass_assignment_role)
        end

        attributes.each do |k, v|
          if k.include?("(")
            multi_parameter_attributes << [ k, v ]
          elsif respond_to?("#{k}=")
            send("#{k}=", v)
          else
            raise(UnknownAttributeError, "unknown attribute: #{k}")
          end
        end

        @mass_assignment_options = nil
        assign_multiparameter_attributes(multi_parameter_attributes)
      end

      # Returns a hash of all the attributes with their names as keys and the values of the attributes as values.
      def attributes
        Hash[@attributes.map { |name, _| [name, read_attribute(name)] }]
      end

      # Returns an <tt>#inspect</tt>-like string for the value of the
      # attribute +attr_name+. String attributes are truncated upto 50
      # characters, and Date and Time attributes are returned in the
      # <tt>:db</tt> format. Other attributes return the value of
      # <tt>#inspect</tt> without modification.
      #
      #   person = Person.create!(:name => "David Heinemeier Hansson " * 3)
      #
      #   person.attribute_for_inspect(:name)
      #   # => '"David Heinemeier Hansson David Heinemeier Hansson D..."'
      #
      #   person.attribute_for_inspect(:created_at)
      #   # => '"2009-01-12 04:48:57"'
      def attribute_for_inspect(attr_name)
        value = read_attribute(attr_name)

        if value.is_a?(String) && value.length > 50
          "#{value[0..50]}...".inspect
        elsif value.is_a?(Date) || value.is_a?(Time)
          %("#{value.to_s(:db)}")
        else
          value.inspect
        end
      end

      # Returns true if the specified +attribute+ has been set by the user or by a database load and is neither
      # nil nor empty? (the latter only applies to objects that respond to empty?, most notably Strings).
      def attribute_present?(attribute)
        !_read_attribute(attribute).blank?
      end

      # Returns the column object for the named attribute.
      def column_for_attribute(name)
        self.class.columns_hash[name.to_s]
      end

      # Returns true if +comparison_object+ is the same exact object, or +comparison_object+
      # is of the same type and +self+ has an ID and it is equal to +comparison_object.id+.
      #
      # Note that new records are different from any other record by definition, unless the
      # other record is the receiver itself. Besides, if you fetch existing records with
      # +select+ and leave the ID out, you're on your own, this predicate will return false.
      #
      # Note also that destroying a record preserves its ID in the model instance, so deleted
      # models are still comparable.
      def ==(comparison_object)
        super ||
          comparison_object.instance_of?(self.class) &&
          id.present? &&
          comparison_object.id == id
      end
      alias :eql? :==

      # Delegates to id in order to allow two records of the same type and id to work with something like:
      #   [ Person.find(1), Person.find(2), Person.find(3) ] & [ Person.find(1), Person.find(4) ] # => [ Person.find(1) ]
      def hash
        id.hash
      end

      # Freeze the attributes hash such that associations are still accessible, even on destroyed records.
      def freeze
        @attributes.freeze; self
      end

      # Returns +true+ if the attributes hash has been frozen.
      def frozen?
        @attributes.frozen?
      end

      # Allows sort on objects
      def <=>(other_object)
        if other_object.is_a?(self.class)
          self.to_key <=> other_object.to_key
        else
          nil
        end
      end

      # Backport dup from 1.9 so that initialize_dup() gets called
      unless Object.respond_to?(:initialize_dup)
        def dup # :nodoc:
          copy = super
          copy.initialize_dup(self)
          copy
        end
      end

      # Duped objects have no id assigned and are treated as new records. Note
      # that this is a "shallow" copy as it copies the object's attributes
      # only, not its associations. The extent of a "deep" copy is application
      # specific and is therefore left to the application to implement according
      # to its need.
      # The dup method does not preserve the timestamps (created|updated)_(at|on).
      def initialize_dup(other)
        cloned_attributes = other.clone_attributes(:read_attribute_before_type_cast)
        cloned_attributes.delete(self.class.primary_key)

        @attributes = cloned_attributes

        _run_after_initialize_callbacks if respond_to?(:_run_after_initialize_callbacks)

        @changed_attributes = {}
        attributes_from_column_definition.each do |attr, orig_value|
          @changed_attributes[attr] = orig_value if field_changed?(attr, orig_value, @attributes[attr])
        end

        @aggregation_cache = {}
        @association_cache = {}
        @attributes_cache = {}
        @new_record  = true

        ensure_proper_type
        populate_with_current_scope_attributes
        clear_timestamp_attributes
      end

      # Returns +true+ if the record is read only. Records loaded through joins with piggy-back
      # attributes will be marked as read only since they cannot be saved.
      def readonly?
        @readonly
      end

      # Marks this record as read only.
      def readonly!
        @readonly = true
      end

      # Returns the contents of the record as a nicely formatted string.
      def inspect
        attributes_as_nice_string = self.class.column_names.collect { |name|
          if has_attribute?(name)
            "#{name}: #{attribute_for_inspect(name)}"
          end
        }.compact.join(", ")
        "#<#{self.class} #{attributes_as_nice_string}>"
      end

    protected
      def clone_attributes(reader_method = :read_attribute, attributes = {})
        attribute_names.each do |name|
          attributes[name] = clone_attribute_value(reader_method, name)
        end
        attributes
      end

      def clone_attribute_value(reader_method, attribute_name)
        value = send(reader_method, attribute_name)
        value.duplicable? ? value.clone : value
      rescue TypeError, NoMethodError
        value
      end

      def mass_assignment_options
        @mass_assignment_options ||= {}
      end

      def mass_assignment_role
        mass_assignment_options[:as] || :default
      end

    private

      # Under Ruby 1.9, Array#flatten will call #to_ary (recursively) on each of the elements
      # of the array, and then rescues from the possible NoMethodError. If those elements are
      # ActiveRecord::Base's, then this triggers the various method_missing's that we have,
      # which significantly impacts upon performance.
      #
      # So we can avoid the method_missing hit by explicitly defining #to_ary as nil here.
      #
      # See also http://tenderlovemaking.com/2011/06/28/til-its-ok-to-return-nil-from-to_ary/
      def to_ary # :nodoc:
        nil
      end

      def set_serialized_attributes
        sattrs = self.class.serialized_attributes

        sattrs.each do |key, coder|
          @attributes[key] = coder.load @attributes[key] if @attributes.key?(key)
        end
      end

      # Sets the attribute used for single table inheritance to this class name if this is not the
      # ActiveRecord::Base descendant.
      # Considering the hierarchy Reply < Message < ActiveRecord::Base, this makes it possible to
      # do Reply.new without having to set <tt>Reply[Reply.inheritance_column] = "Reply"</tt> yourself.
      # No such attribute would be set for objects of the Message class in that example.
      def ensure_proper_type
        klass = self.class
        if klass.finder_needs_type_condition?
          write_attribute(klass.inheritance_column, klass.sti_name)
        end
      end

      # The primary key and inheritance column can never be set by mass-assignment for security reasons.
      def self.attributes_protected_by_default
        default = [ primary_key, inheritance_column ]
        default << 'id' unless primary_key.eql? 'id'
        default
      end

      # Returns a copy of the attributes hash where all the values have been safely quoted for use in
      # an Arel insert/update method.
      def arel_attributes_values(include_primary_key = true, include_readonly_attributes = true, attribute_names = @attributes.keys)
        attrs      = {}
        klass      = self.class
        arel_table = klass.arel_table

        attribute_names.each do |name|
          if (column = column_for_attribute(name)) && (include_primary_key || !column.primary)

            if include_readonly_attributes || (!include_readonly_attributes && !self.class.readonly_attributes.include?(name))

              value = if coder = klass.serialized_attributes[name]
                        coder.dump @attributes[name]
                      else
                        # FIXME: we need @attributes to be used consistently.
                        # If the values stored in @attributes were already type
                        # casted, this code could be simplified
                        read_attribute(name)
                      end

              attrs[arel_table[name]] = value
            end
          end
        end
        attrs
      end

      # Quote strings appropriately for SQL statements.
      def quote_value(value, column = nil)
        self.class.connection.quote(value, column)
      end

      # Instantiates objects for all attribute classes that needs more than one constructor parameter. This is done
      # by calling new on the column type or aggregation type (through composed_of) object with these parameters.
      # So having the pairs written_on(1) = "2004", written_on(2) = "6", written_on(3) = "24", will instantiate
      # written_on (a date type) with Date.new("2004", "6", "24"). You can also specify a typecast character in the
      # parentheses to have the parameters typecasted before they're used in the constructor. Use i for Fixnum,
      # f for Float, s for String, and a for Array. If all the values for a given attribute are empty, the
      # attribute will be set to nil.
      def assign_multiparameter_attributes(pairs)
        execute_callstack_for_multiparameter_attributes(
          extract_callstack_for_multiparameter_attributes(pairs)
        )
      end

      def instantiate_time_object(name, values)
        if self.class.send(:create_time_zone_conversion_attribute?, name, column_for_attribute(name))
          Time.zone.local(*values)
        else
          Time.time_with_datetime_fallback(@@default_timezone, *values)
        end
      end

      def execute_callstack_for_multiparameter_attributes(callstack)
        errors = []
        callstack.each do |name, values_with_empty_parameters|
          begin
            send(name + "=", read_value_from_parameter(name, values_with_empty_parameters))
          rescue => ex
            errors << AttributeAssignmentError.new("error on assignment #{values_with_empty_parameters.values.inspect} to #{name}", ex, name)
          end
        end
        unless errors.empty?
          raise MultiparameterAssignmentErrors.new(errors), "#{errors.size} error(s) on assignment of multiparameter attributes"
        end
      end

      def read_value_from_parameter(name, values_hash_from_param)
        klass = (self.class.reflect_on_aggregation(name.to_sym) || column_for_attribute(name)).klass
        if values_hash_from_param.values.all?{|v|v.nil?}
          nil
        elsif klass == Time
          read_time_parameter_value(name, values_hash_from_param)
        elsif klass == Date
          read_date_parameter_value(name, values_hash_from_param)
        else
          read_other_parameter_value(klass, name, values_hash_from_param)
        end
      end

      def read_time_parameter_value(name, values_hash_from_param)
        # If Date bits were not provided, error
        raise "Missing Parameter" if [1,2,3].any?{|position| !values_hash_from_param.has_key?(position)}
        max_position = extract_max_param_for_multiparameter_attributes(values_hash_from_param, 6)
        set_values = (1..max_position).collect{|position| values_hash_from_param[position] }
        # If Date bits were provided but blank, then default to 1
        # If Time bits are not there, then default to 0
        [1,1,1,0,0,0].each_with_index{|v,i| set_values[i] = set_values[i].blank? ? v : set_values[i]}
        instantiate_time_object(name, set_values)
      end

      def read_date_parameter_value(name, values_hash_from_param)
        set_values = (1..3).collect{|position| values_hash_from_param[position].blank? ? 1 : values_hash_from_param[position]}
        begin
          Date.new(*set_values)
        rescue ArgumentError => ex # if Date.new raises an exception on an invalid date
          instantiate_time_object(name, set_values).to_date # we instantiate Time object and convert it back to a date thus using Time's logic in handling invalid dates
        end
      end

      def read_other_parameter_value(klass, name, values_hash_from_param)
        max_position = extract_max_param_for_multiparameter_attributes(values_hash_from_param)
        values = (1..max_position).collect do |position|
          raise "Missing Parameter" if !values_hash_from_param.has_key?(position)
          values_hash_from_param[position]
        end
        klass.new(*values)
      end

      def extract_max_param_for_multiparameter_attributes(values_hash_from_param, upper_cap = 100)
        [values_hash_from_param.keys.max,upper_cap].min
      end

      def extract_callstack_for_multiparameter_attributes(pairs)
        attributes = { }

        pairs.each do |pair|
          multiparameter_name, value = pair
          attribute_name = multiparameter_name.split("(").first
          attributes[attribute_name] = {} unless attributes.include?(attribute_name)

          parameter_value = value.empty? ? nil : type_cast_attribute_value(multiparameter_name, value)
          attributes[attribute_name][find_parameter_position(multiparameter_name)] ||= parameter_value
        end

        attributes
      end

      def type_cast_attribute_value(multiparameter_name, value)
        multiparameter_name =~ /\([0-9]*([if])\)/ ? value.send("to_" + $1) : value
      end

      def find_parameter_position(multiparameter_name)
        multiparameter_name.scan(/\(([0-9]*).*\)/).first.first.to_i
      end

      # Returns a comma-separated pair list, like "key1 = val1, key2 = val2".
      def comma_pair_list(hash)
        hash.map { |k,v| "#{k} = #{v}" }.join(", ")
      end

      def quote_columns(quoter, hash)
        Hash[hash.map { |name, value| [quoter.quote_column_name(name), value] }]
      end

      def quoted_comma_pair_list(quoter, hash)
        comma_pair_list(quote_columns(quoter, hash))
      end

      def convert_number_column_value(value)
        if value == false
          0
        elsif value == true
          1
        elsif value.is_a?(String) && value.blank?
          nil
        else
          value
        end
      end

      def populate_with_current_scope_attributes
        return unless self.class.scope_attributes?

        self.class.scope_attributes.each do |att,value|
          send("#{att}=", value) if respond_to?("#{att}=")
        end
      end

      # Clear attributes and changed_attributes
      def clear_timestamp_attributes
        all_timestamp_attributes_in_model.each do |attribute_name|
          self[attribute_name] = nil
          changed_attributes.delete(attribute_name)
        end
      end
  end

  Base.class_eval do
    include ActiveRecord::Persistence
    extend ActiveModel::Naming
    extend QueryCache::ClassMethods
    extend ActiveSupport::Benchmarkable
    extend ActiveSupport::DescendantsTracker

    include ActiveModel::Conversion
    include Validations
    extend CounterCache
    include Locking::Optimistic, Locking::Pessimistic
    include AttributeMethods
    include AttributeMethods::Read, AttributeMethods::Write, AttributeMethods::BeforeTypeCast, AttributeMethods::Query
    include AttributeMethods::PrimaryKey
    include AttributeMethods::TimeZoneConversion
    include AttributeMethods::Dirty
    include ActiveModel::MassAssignmentSecurity
    include Callbacks, ActiveModel::Observing, Timestamp
    include Associations, NamedScope
    include IdentityMap
    include ActiveModel::SecurePassword

    # AutosaveAssociation needs to be included before Transactions, because we want
    # #save_with_autosave_associations to be wrapped inside a transaction.
    include AutosaveAssociation, NestedAttributes
    include Aggregations, Transactions, Reflection, Serialization

    # Returns the value of the attribute identified by <tt>attr_name</tt> after it has been typecast (for example,
    # "2004-12-12" in a data column is cast to a date object, like Date.new(2004, 12, 12)).
    # (Alias for the protected read_attribute method).
    def [](attr_name)
      read_attribute(attr_name)
    end

    # Updates the attribute identified by <tt>attr_name</tt> with the specified +value+.
    # (Alias for the protected write_attribute method).
    def []=(attr_name, value)
      write_attribute(attr_name, value)
    end
  end
end

# TODO: Remove this and make it work with LAZY flag
require 'active_record/connection_adapters/abstract_adapter'
ActiveSupport.run_load_hooks(:active_record, ActiveRecord::Base)
