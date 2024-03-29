## Rails 3.1.4 (unreleased) ##

*   Fix a custom primary key regression *GH 3987*

    *Jon Leighton*

*   Perf fix (second try): don't load records for `has many :dependent =>
    :delete_all` *GH 3672*

    *Jon Leighton*

*   Fix accessing `proxy_association` method from an association extension
    where the calls are chained. *GH #3890*

    (E.g. `post.comments.where(bla).my_proxy_method`)

    *Jon Leighton*

*   Perf fix: MySQL primary key lookup was still slow for very large
    tables. *GH 3678*

    *Kenny J*

*   Perf fix: If a table has no primary key, don't repeatedly ask the database for it.

    *Julius de Bruijn*

## Rails 3.1.3 (unreleased) ##

*   Perf fix: If we're deleting all records in an association, don't add a IN(..) clause
    to the query. *GH 3672*

    *Jon Leighton*

*   Fix bug with referencing other mysql databases in set_table_name. *GH 3690*

*   Fix performance bug with mysql databases on a server with lots of other databses. *GH 3678*

    *Christos Zisopoulos and Kenny J*

## Rails 3.1.2 (unreleased) ##

*   Fix problem with prepared statements and PostgreSQL when multiple schemas are used.
    *GH #3232*

    *Juan M. Cuello*

*   Fix bug with PostgreSQLAdapter#indexes. When the search path has multiple schemas, spaces
    were not being stripped from the schema names after the first.

    *Sean Kirby*

*   Preserve SELECT columns on the COUNT for finder_sql when possible. *GH 3503*

    *Justin Mazzi*

*   Reset prepared statement cache when schema changes impact statement results. *GH 3335*

    *Aaron Patterson*

*   Postgres: Do not attempt to deallocate a statement if the connection is no longer active.

    *Ian Leitch*

*   Prevent QueryCache leaking database connections. *GH 3243*

    *Mark J. Titorenko*

*   Fix bug where building the conditions of a nested through association could potentially
    modify the conditions of the through and/or source association. If you have experienced
    bugs with conditions appearing in the wrong queries when using nested through associations,
    this probably solves your problems. *GH #3271*

    *Jon Leighton*

*   If a record is removed from a has_many :through, all of the join records relating to that
    record should also be removed from the through association's target.

    *Jon Leighton*

*   Fix adding multiple instances of the same record to a has_many :through. *GH #3425*

    *Jon Leighton*

*   Fix creating records in a through association with a polymorphic source type. *GH #3247*

    *Jon Leighton*

*   MySQL: use the information_schema than the describe command when we look for a primary key. *GH #3440*
    *Kenny J*

## Rails 3.1.1 (October 7, 2011) ##

*   Raise an exception if the primary key of a model in an association is needed
    but unknown. Fixes #3207.

    *Jon Leighton*

*   Add deprecation for the preload_associations method. Fixes #3022.

    *Jon Leighton*

*   Don't require a DB connection when loading a model that uses set_primary_key. GH #2807.

    *Jon Leighton*

*   Fix using select() with a habtm association, e.g. Person.friends.select(:name). GH #3030 and
    \#2923.

    *Hendy Tanata*

*   Fix belongs_to polymorphic with custom primary key on target. GH #3104.

    *Jon Leighton*

*   CollectionProxy#replace should change the DB records rather than just mutating the array.
    Fixes #3020.

    *Jon Leighton*

*   LRU cache in mysql and sqlite are now per-process caches.

    * lib/active_record/connection_adapters/mysql_adapter.rb: LRU cache
  	  keys are per process id.
    * lib/active_record/connection_adapters/sqlite_adapter.rb: ditto

    *Aaron Patterson*

*   Database adapters use a statement pool for limiting the number of open
    prepared statments on the database.  The limit defaults to 1000, but can
    be adjusted in your database config by changing 'statement_limit'.

*   Fix clash between using 'preload', 'joins' or 'eager_load' in a default scope and including the
    default scoped model in a nested through association. (GH #2834.) *Jon Leighton*

*   Ensure we are not comparing a string with a symbol in HasManyAssociation#inverse_updates_counter_cache?.
    Fixes GH #2755, where a counter cache could be decremented twice as far as it was supposed to be.

    *Jon Leighton*

*   Don't send any queries to the database when the foreign key of a belongs_to is nil. Fixes
    GH #2828. *Georg Friedrich*

*   Fixed find_in_batches method to not include order from default_scope. See GH #2832 *Arun Agrawal*

*   Don't compute table name for abstract classes. Fixes problem with setting the primary key
    in an abstract class. See GH #2791. *Akira Matsuda*

*   Psych errors with poor yaml formatting are proxied. Fixes GH #2645 and
    GH #2731

*   Use the LIMIT word with the methods #last and #first. Fixes GH #2783 *Damien Mathieu*

## Rails 3.1.0 (August 30, 2011) ##

*   Add a proxy_association method to association proxies, which can be called by association
    extensions to access information about the association. This replaces proxy_owner etc with
    proxy_association.owner.

    *Jon Leighton*

*   Active Record's dynamic finder will now show a deprecation warning if you passing in less number of arguments than what you call in method signature. This behavior will raise ArgumentError in the next version of Rails *Prem Sichanugrist*

*   Deprecated the AssociationCollection constant. CollectionProxy is now the appropriate constant
    to use, though be warned that this is not really a public API.

    This should solve upgrade problems with the will_paginate plugin (and perhaps others). Thanks
    Paul Battley for reporting.

    *Jon Leighton*

*   ActiveRecord::MacroReflection::AssociationReflection#build_record has a new method signature.

    Before: def build_association(*options)
    After:  def build_association(*options, &block)

    Users who are redefining this method to extend functionality should ensure that the block is
    passed through to ActiveRecord::Base#new.

    This change is necessary to fix https://github.com/rails/rails/issues/1842.

    A deprecation warning and workaround has been added to 3.1, but authors will need to update
    their code for it to work correctly in 3.2.

    *Jon Leighton*

*   AR#pluralize_table_names can be used to singularize/pluralize table name of an individual model:

        class User < ActiveRecord::Base
          self.pluralize_table_names = false
        end

    Previously this could only be set globally for all models through ActiveRecord::Base.pluralize_table_names. *Guillermo Iguaran*

*   Add block setting of attributes to singular associations:

        class User < ActiveRecord::Base
          has_one :account
        end

        user.build_account{ |a| a.credit_limit => 100.0 }

    The block is called after the instance has been initialized. *Andrew White*

*   Add ActiveRecord::Base.attribute_names to return a list of attribute names. This will return an empty array if the model is abstract or table does not exists. *Prem Sichanugrist*

*   CSV Fixtures are deprecated and support will be removed in Rails 3.2.0

*   AR#new, AR#create, AR#create!, AR#update_attributes and AR#update_attributes! all accept a second hash as option that allows you
    to specify which role to consider when assigning attributes. This is built on top of ActiveModel's
    new mass assignment capabilities:

        class Post < ActiveRecord::Base
          attr_accessible :title
          attr_accessible :title, :published_at, :as => :admin
        end

        Post.new(params[:post], :as => :admin)

    assign_attributes() with similar API was also added and attributes=(params, guard) was deprecated.

    Please note that this changes the method signatures for AR#new, AR#create, AR#create!, AR#update_attributes and AR#update_attributes!. If you have overwritten these methods you should update them accordingly.

    *Josh Kalderimis*

*   default_scope can take a block, lambda, or any other object which responds to `call` for lazy
    evaluation:

        default_scope { ... }
        default_scope lambda { ... }
        default_scope method(:foo)

    This feature was originally implemented by Tim Morgan, but was then removed in favour of
    defining a 'default_scope' class method, but has now been added back in by Jon Leighton.
    The relevant lighthouse ticket is #1812.

*   Default scopes are now evaluated at the latest possible moment, to avoid problems where
    scopes would be created which would implicitly contain the default scope, which would then
    be impossible to get rid of via Model.unscoped.

    Note that this means that if you are inspecting the internal structure of an
    ActiveRecord::Relation, it will *not* contain the default scope, though the resulting
    query will do. You can get a relation containing the default scope by calling
    ActiveRecord#with_default_scope, though this is not part of the public API.

    *Jon Leighton*

*   If you wish to merge default scopes in special ways, it is recommended to define your default
    scope as a class method and use the standard techniques for sharing code (inheritance, mixins,
    etc.):

        class Post < ActiveRecord::Base
          def self.default_scope
            where(:published => true).where(:hidden => false)
          end
        end

    *Jon Leighton*

*   PostgreSQL adapter only supports PostgreSQL version 8.2 and higher.

*   ConnectionManagement middleware is changed to clean up the connection pool
    after the rack body has been flushed.

*   Added an update_column method on ActiveRecord. This new method updates a given attribute on an object, skipping validations and callbacks.
    It is recommended to use #update_attribute unless you are sure you do not want to execute any callback, including the modification of
    the updated_at column. It should not be called on new records.
    Example:

        User.first.update_column(:name, "sebastian")         # => true

    *Sebastian Martinez*

*   Associations with a :through option can now use *any* association as the
    through or source association, including other associations which have a
    :through option and has_and_belongs_to_many associations

    *Jon Leighton*

*   The configuration for the current database connection is now accessible via
    ActiveRecord::Base.connection_config. *fxn*

*   limits and offsets are removed from COUNT queries unless both are supplied.
    For example:

        People.limit(1).count           # => 'SELECT COUNT(*) FROM people'
        People.offset(1).count          # => 'SELECT COUNT(*) FROM people'
        People.limit(1).offset(1).count # => 'SELECT COUNT(*) FROM people LIMIT 1 OFFSET 1'

    *lighthouse #6262*

*   ActiveRecord::Associations::AssociationProxy has been split. There is now an Association class
    (and subclasses) which are responsible for operating on associations, and then a separate,
    thin wrapper called CollectionProxy, which proxies collection associations.

    This prevents namespace pollution, separates concerns, and will allow further refactorings.

    Singular associations (has_one, belongs_to) no longer have a proxy at all. They simply return
    the associated record or nil. This means that you should not use undocumented methods such
    as bob.mother.create - use bob.create_mother instead.

    *Jon Leighton*

*   Make has_many :through associations work correctly when you build a record and then save it. This
    requires you to set the :inverse_of option on the source reflection on the join model, like so:

    class Post < ActiveRecord::Base
        has_many :taggings
        has_many :tags, :through => :taggings
    end

    class Tagging < ActiveRecord::Base
        belongs_to :post
        belongs_to :tag, :inverse_of => :tagging # :inverse_of must be set!
    end

    class Tag < ActiveRecord::Base
        has_many :taggings
        has_many :posts, :through => :taggings
    end

    post = Post.first
    tag = post.tags.build :name => "ruby"
    tag.save # will save a Taggable linking to the post

    *Jon Leighton*

*   Support the :dependent option on has_many :through associations. For historical and practical
    reasons, :delete_all is the default deletion strategy employed by association.delete(*records),
    despite the fact that the default strategy is :nullify for regular has_many. Also, this only
    works at all if the source reflection is a belongs_to. For other situations, you should directly
    modify the through association.

    *Jon Leighton*

*   Changed the behaviour of association.destroy for has_and_belongs_to_many and has_many :through.
    From now on, 'destroy' or 'delete' on an association will be taken to mean 'get rid of the link',
    not (necessarily) 'get rid of the associated records'.

    Previously, has_and_belongs_to_many.destroy(*records) would destroy the records themselves. It
    would not delete any records in the join table. Now, it deletes the records in the join table.

    Previously, has_many_through.destroy(*records) would destroy the records themselves, and the
    records in the join table. [Note: This has not always been the case; previous version of Rails
    only deleted the records themselves.] Now, it destroys only the records in the join table.

    Note that this change is backwards-incompatible to an extent, but there is unfortunately no
    way to 'deprecate' it before changing it. The change is being made in order to have
    consistency as to the meaning of 'destroy' or 'delete' across the different types of associations.

    If you wish to destroy the records themselves, you can do records.association.each(&:destroy)

    *Jon Leighton*

*   Add :bulk => true option to change_table to make all the schema changes defined in change_table block using a single ALTER statement. *Pratik Naik*

    Example:

    change_table(:users, :bulk => true) do |t|
        t.string :company_name
        t.change :birthdate, :datetime
    end

    This will now result in:

        ALTER TABLE `users` ADD COLUMN `company_name` varchar(255), CHANGE `updated_at` `updated_at` datetime DEFAULT NULL

*   Removed support for accessing attributes on a has_and_belongs_to_many join table. This has been
    documented as deprecated behaviour since April 2006. Please use has_many :through instead.
    *Jon Leighton*

*   Added a create_association! method for has_one and belongs_to associations. *Jon Leighton*

*   Migration files generated from model and constructive migration generators
    (for example, add_name_to_users) use the reversible migration's `change`
    method instead of the ordinary `up` and `down` methods. *Prem Sichanugrist*

*   Removed support for interpolating string SQL conditions on associations. Instead, you should
    use a proc, like so:

    Before:

        has_many :things, :conditions => 'foo = #{bar}'

    After:

        has_many :things, :conditions => proc { "foo = #{bar}" }

    Inside the proc, 'self' is the object which is the owner of the association, unless you are
    eager loading the association, in which case 'self' is the class which the association is within.

    You can have any "normal" conditions inside the proc, so the following will work too:

        has_many :things, :conditions => proc { ["foo = ?", bar] }

    Previously :insert_sql and :delete_sql on has_and_belongs_to_many association allowed you to call
    'record' to get the record being inserted or deleted. This is now passed as an argument to
    the proc.

*   Added ActiveRecord::Base#has_secure_password (via ActiveModel::SecurePassword) to encapsulate dead-simple password usage with BCrypt encryption and salting [DHH]. Example:

        # Schema: User(name:string, password_digest:string, password_salt:string)
        class User < ActiveRecord::Base
          has_secure_password
        end

        user = User.new(:name => "david", :password => "", :password_confirmation => "nomatch")
        user.save                                                      # => false, password required
        user.password = "mUc3m00RsqyRe"
        user.save                                                      # => false, confirmation doesn't match
        user.password_confirmation = "mUc3m00RsqyRe"
        user.save                                                      # => true
        user.authenticate("notright")                                  # => false
        user.authenticate("mUc3m00RsqyRe")                             # => user
        User.find_by_name("david").try(:authenticate, "notright")      # => nil
        User.find_by_name("david").try(:authenticate, "mUc3m00RsqyRe") # => user


*   When a model is generated add_index is added by default for belongs_to or references columns

    rails g model post user:belongs_to will generate the following:

        class CreatePosts < ActiveRecord::Migration
          def change
            create_table :posts do |t|
              t.belongs_to :user
              t.timestamps
            end
            add_index :posts, :user_id
          end
        end

    *Santiago Pastorino*

*   Setting the id of a belongs_to object will update the reference to the
    object. *#2989 state:resolved*

*   ActiveRecord::Base#dup and ActiveRecord::Base#clone semantics have changed
    to closer match normal Ruby dup and clone semantics.

*   Calling ActiveRecord::Base#clone will result in a shallow copy of the record,
    including copying the frozen state.  No callbacks will be called.

*   Calling ActiveRecord::Base#dup will duplicate the record, including calling
    after initialize hooks.  Frozen state will not be copied, and all associations
    will be cleared.  A duped record will return true for new_record?, have a nil
    id field, and is saveable.

*   Migrations can be defined as reversible, meaning that the migration system
    will figure out how to reverse your migration.  To use reversible migrations,
    just define the "change" method.  For example:

        class MyMigration < ActiveRecord::Migration
          def change
            create_table(:horses) do
              t.column :content, :text
              t.column :remind_at, :datetime
            end
          end
        end

    Some things cannot be automatically reversed for you.  If you know how to
    reverse those things, you should define 'up' and 'down' in your migration.  If
    you define something in `change` that cannot be reversed, an
    IrreversibleMigration exception will be raised when going down.

*   Migrations should use instance methods rather than class methods:
        class FooMigration < ActiveRecord::Migration
          def up
            ...
          end
        end

    *Aaron Patterson*

*   has_one maintains the association with separate after_create/after_update instead
    of a single after_save. *fxn*

*   The following code:

        Model.limit(10).scoping { Model.count }

    now generates the following SQL:

        SELECT COUNT(*) FROM models LIMIT 10

    This may not return what you want.  Instead, you may with to do something
    like this:

        Model.limit(10).scoping { Model.all.size }

    *Aaron Patterson*


## Rails 3.0.7 (April 18, 2011) ##

*   Destroying records via nested attributes works independent of reject_if LH #6006 *Durran Jordan*

*   Delegate any? and many? to Model.scoped for consistency *Andrew White*

*   Quote the ORDER BY clause in batched finds - fixes #6620 *Andrew White*

*   Change exists? so records are not instantiated - fixes #6127. This prevents after_find
    and after_initialize callbacks being triggered when checking for record existence.
    *Andrew White*

*   Fix performance bug with attribute accessors which only occurred on Ruby 1.8.7, and ensure we
    cache type-casted values when the column returned from the db contains non-standard chars.
    *Jon Leighton*

*   Fix a performance regression introduced here 86acbf1cc050c8fa8c74a10c735e467fb6fd7df8
    related to read_attribute method *Stian Grytøyr*


## Rails 3.0.6 (April 5, 2011) ##

*   Un-deprecate reorder method *Sebastian Martinez*

*   Extensions are applied when calling +except+ or +only+ on relations.
    Thanks to Iain Hecker.

*   Schemas set in set_table_name are respected by the mysql adapter. LH #5322

*   Fixed a bug when empty? was called on a grouped Relation that wasn't loaded.
    LH #5829

*   Reapply extensions when using except and only. Thanks Iain Hecker.

*   Binary data is escaped when being inserted to SQLite3 Databases. Thanks
    Naruse!


## Rails 3.0.5 (February 26, 2011) ##

*   Model.where(:column => 1).where(:column => 2) will always produce an AND
    query.

    *Aaron Patterson*

*   Deprecated support for interpolated association conditions in the form of :conditions => 'foo = #{bar}'.

    Instead, you should use a proc, like so:

    Before:

        has_many :things, :conditions => 'foo = #{bar}'

    After:

        has_many :things, :conditions => proc { "foo = #{bar}" }

    Inside the proc, 'self' is the object which is the owner of the association, unless you are
    eager loading the association, in which case 'self' is the class which the association is within.

    You can have any "normal" conditions inside the proc, so the following will work too:

        has_many :things, :conditions => proc { ["foo = ?", bar] }

    Previously :insert_sql and :delete_sql on has_and_belongs_to_many association allowed you to call
    'record' to get the record being inserted or deleted. This is now passed as an argument to
    the proc.

    *Jon Leighton*


## Rails 3.0.4 (February 8, 2011) ##

*   Added deprecation warning for has_and_belongs_to_many associations where the join table has
    additional attributes other than the keys. Access to these attributes is removed in 3.1.
    Please use has_many :through instead. *Jon Leighton*


## Rails 3.0.3 (November 16, 2010) ##

*   Support find by class like this: Post.where(:name => Post)


## Rails 3.0.2 (November 15, 2010) ##

*   Dramatic speed increase (see: http://engineering.attinteractive.com/2010/10/arel-two-point-ohhhhh-yaaaaaa/) *Aaron Patterson*

*   reorder is deprecated in favor of except(:order).order(...) *Santiago Pastorino*

*   except is now AR public API

        Model.order('name').except(:order).order('salary')

    generates:

        SELECT * FROM models ORDER BY salary

    *Santiago Pastorino*

*   The following code:

        Model.limit(10).scoping { Model.count }

    now generates the following SQL:

        SELECT COUNT(*) FROM models LIMIT 10

    This may not return what you want.  Instead, you may with to do something
    like this:

        Model.limit(10).scoping { Model.all.size }

    *Aaron Patterson*


## Rails 3.0.1 (October 15, 2010) ##

*   Introduce a fix for CVE-2010-3993


## Rails 3.0.0 (August 29, 2010) ##

*   Changed update_attribute to not run callbacks and update the record directly in the database *Neeraj Singh*

*   Add scoping and unscoped as the syntax to replace the old with_scope and with_exclusive_scope *José Valim*

*   New rake task, db:migrate:status, displays status of migrations #4947 *Kevin Skoglund*

*   select and order for ActiveRecord now always concatenate nested calls. Use reorder if you want the original order to be overwritten *Santiago Pastorino*

*   PostgreSQL: ensure the database time zone matches Ruby's time zone #4895 *Aaron Patterson*

*   Fixed that ActiveRecord::Base.compute_type would swallow NoMethodError #4751 *Andrew Bloomgarden, Andrew White*

*   Add index length support for MySQL. #1852 *Emili Parreno, Pratik Naik*

    Example:

        add_index(:accounts, :name, :name => 'by_name', :length => 10)
        => CREATE INDEX by_name ON accounts(name(10))

        add_index(:accounts, [:name, :surname], :name => 'by_name_surname', :length => {:name => 10, :surname => 15})
        => CREATE INDEX by_name_surname ON accounts(name(10), surname(15))

*   find_or_create_by_attr(value, ...) works when attr is protected.  #4457 *Santiago Pastorino, Marc-André Lafortune*

*   New callbacks: after_commit and after_rollback. Do expensive operations like image thumbnailing after_commit instead of after_save.  #2991 *Brian Durand*

*   Serialized attributes are not converted to YAML if they are any of the formats that can be serialized to XML (like Hash, Array and Strings). *José Valim*

*   Destroy uses optimistic locking. If lock_version on the record you're destroying doesn't match lock_version in the database, a StaleObjectError is raised.  #1966 *Curtis Hawthorne*

*   PostgreSQL: drop support for old postgres driver. Use pg 0.9.0 or later.  *Jeremy Kemper*

*   Observers can prevent records from saving by returning false, just like before_save and friends.  #4087 *Mislav Marohnić*

*   Add Relation extensions. *Pratik Naik*

    users = User.where(:admin => true).extending(User::AdminPowers)

    latest_users = User.order('created_at DESC') do
        def posts_count
          Post.count(:user_id => to_a.map(&:id))
        end
    end

*   To prefix the table names of all models in a module, define self.table_name_prefix on the module.  #4032 *Andrew White*

*   Silenced "SHOW FIELDS" and "SET SQL_AUTO_IS_NULL=0" statements from the MySQL driver to improve log signal to noise ration in development *DHH*

*   PostgreSQLAdapter: set time_zone to UTC when Base.default_timezone == :utc so that Postgres doesn't incorrectly offset-adjust values inserted into TIMESTAMP WITH TIME ZONE columns. #3777 *Jack Christensen*

*   Allow relations to be used as scope.

    class Item
        scope :red, where(:colour => 'red')
    end

    Item.red.limit(10) # Ten red items

*   Rename named_scope to scope. *Pratik Naik*

*   Changed ActiveRecord::Base.store_full_sti_class to be true by default reflecting the previously announced Rails 3 default *DHH*

*   Add Relation#except. *Pratik Naik*

    one_red_item = Item.where(:colour => 'red').limit(1)
    all_items = one_red_item.except(:where, :limit)

*   Add Relation#delete_all. *Pratik Naik*

    Item.where(:colour => 'red').delete_all

*   Add Model.having and Relation#having. *Pratik Naik*

    Developer.group("salary").having("sum(salary) >  10000").select("salary")

*   Add Relation#count. *Pratik Naik*

    legends = People.where("age > 100")
    legends.count
    legends.count(:age, :distinct => true)
    legends.select('id').count

*   Add Model.readonly and association_collection#readonly finder method. *Pratik Naik*

    Post.readonly.to_a # Load all posts in readonly mode
    @user.items.readonly(false).to_a # Load all the user items in writable mode

*   Add .lock finder method *Pratik Naik*

    User.lock.where(:name => 'lifo').to_a

    old_items = Item.where("age > 100")
    old_items.lock.each {|i| .. }

*   Add Model.from and association_collection#from finder methods *Pratik Naik*

    user = User.scoped
    user.select('*').from('users, items')

*   Add relation.destroy_all *Pratik Naik*

    old_items = Item.where("age > 100")
    old_items.destroy_all

*   Add relation.exists? *Pratik Naik*

    red_items = Item.where(:colours => 'red')
    red_items.exists?
    red_items.exists?(1)

*   Add find(ids) to relations. *Pratik Naik*

    old_users = User.order("age DESC")
    old_users.find(1)
    old_users.find(1, 2, 3)

*   Add new finder methods to association collection. *Pratik Naik*

    class User < ActiveRecord::Base
        has_many :items
    end

    user = User.first
    user.items.where(:items => {:colour => 'red'})
    user.items.select('items.id')

*   Add relation.reload to force reloading the records. *Pratik Naik*

    topics = Topic.scoped
    topics.to_a  # force load
    topics.first # returns a cached record
    topics.reload
    topics.first # Fetches a new record from the database

*   Rename Model.conditions and relation.conditions to .where. *Pratik Naik*

    Before :
        User.conditions(:name => 'lifo')
        User.select('id').conditions(["age > ?", 21])

    Now :
        User.where(:name => 'lifo')
        User.select('id').where(["age > ?", 21])

*   Add Model.select/group/order/limit/joins/conditions/preload/eager_load class methods returning a lazy relation. *Pratik Naik*

    Examples :

        posts = Post.select('id).order('name') # Returns a lazy relation
        posts.each {|p| puts p.id } # Fires "select id from posts order by name"

*   Model.scoped now returns a relation if invoked without any arguments. *Pratik Naik*

    Example :

        posts = Post.scoped
        posts.size # Fires "select count(*) from  posts" and returns the count
        posts.each {|p| puts p.name } # Fires "select * from posts" and loads post objects

*   Association inverses for belongs_to, has_one, and has_many. Optimization to reduce database queries.  #3533 *Murray Steele*

        # post.comments sets each comment's post without needing to :include
        class Post < ActiveRecord::Base
          has_many :comments, :inverse_of => :post
        end

*   MySQL: add_ and change_column support positioning.  #3286 *Ben Marini*

*   Reset your Active Record counter caches with the reset_counter_cache class method.  #1211 *Mike Breen, Gabe da Silveira*

*   Remove support for SQLite 2. Please upgrade to SQLite 3+ or install the plugin from git://github.com/rails/sqlite2_adapter.git *Pratik Naik*

*   PostgreSQL: XML datatype support.  #1874 *Leonardo Borges*

*   quoted_date converts time-like objects to ActiveRecord::Base.default_timezone before serialization. This allows you to use Time.now in find conditions and have it correctly be serialized as the current time in UTC when default_timezone == :utc. #2946 *Geoff Buesing*

*   SQLite: drop support for 'dbfile' option in favor of 'database.'  #2363 *Paul Hinze, Jeremy Kemper*

*   Added :primary_key option to belongs_to associations.  #765 *Szymon Nowak, Philip Hallstrom, Noel Rocha*
        # employees.company_name references companies.name
        Employee.belongs_to :company, :primary_key => 'name', :foreign_key => 'company_name'

*   Implement #many? for NamedScope and AssociationCollection using #size. #1500 *Chris Kampmeier*

*   Added :touch option to belongs_to associations that will touch the parent record when the current record is saved or destroyed *DHH*

*   Added ActiveRecord::Base#touch to update the updated_at/on attributes (or another specified timestamp) with the current time *DHH*


## 2.3.2 Final (March 15, 2009) ##

*   Added ActiveRecord::Base.find_each and ActiveRecord::Base.find_in_batches for batch processing *DHH/Jamis Buck*

*   Added that ActiveRecord::Base.exists? can be called with no arguments #1817 *Scott Taylor*

*   Add Support for updating deeply nested models from a single form. #1202 *Eloy Duran*

    class Book < ActiveRecord::Base
        has_one :author
        has_many :pages

        accepts_nested_attributes_for :author, :pages
    end

*   Make after_save callbacks fire only if the record was successfully saved.  #1735 *Michael Lovitt*

    Previously the callbacks would fire if a before_save cancelled saving.

*   Support nested transactions using database savepoints.  #383 *Jonathan Viney, Hongli Lai*

*   Added dynamic scopes ala dynamic finders #1648 *Yaroslav Markin*

*   Fixed that ActiveRecord::Base#new_record? should return false (not nil) for existing records #1219 *Yaroslav Markin*

*   I18n the word separator for error messages. Introduces the activerecord.errors.format.separator translation key.  #1294 *Akira Matsuda*

*   Add :having as a key to find and the relevant associations.  *Emilio Tagua*

*   Added default_scope to Base #1381 [Paweł Kondzior]. Example:

        class Person < ActiveRecord::Base
          default_scope :order => 'last_name, first_name'
        end

        class Company < ActiveRecord::Base
          has_many :people
        end

        Person.all             # => Person.find(:all, :order => 'last_name, first_name')
        Company.find(1).people # => Person.find(:all, :order => 'last_name, first_name', :conditions => { :company_id => 1 })


## 2.2.1 RC2 (November 14th, 2008) ##

*   Ensure indices don't flip order in schema.rb #1266 *Jordi Bunster*

*   Fixed that serialized strings should never be type-casted (i.e. turning "Yes" to a boolean) #857 *Andreas Korth*


## 2.2.0 RC1 (October 24th, 2008) ##

*   Skip collection ids reader optimization if using :finder_sql *Jeremy Kemper*

*   Add Model#delete instance method, similar to Model.delete class method. #1086 *Hongli Lai (Phusion)*

*   MySQL: cope with quirky default values for not-null text columns.  #1043 *Frederick Cheung*

*   Multiparameter attributes skip time zone conversion for time-only columns [#1030 state:resolved] *Geoff Buesing*

*   Base.skip_time_zone_conversion_for_attributes uses class_inheritable_accessor, so that subclasses don't overwrite Base [#346 state:resolved] *Emilio Tagua*

*   Added find_last_by dynamic finder #762 *Emilio Tagua*

*   Internal API: configurable association options and build_association method for reflections so plugins may extend and override.  #985 *Hongli Lai (Phusion)*

*   Changed benchmarks to be reported in milliseconds *David Heinemeier Hansson*

*   Connection pooling.  #936 *Nick Sieger*

*   Merge scoped :joins together instead of overwriting them. May expose scoping bugs in your code!  #501 *Andrew White*

*   before_save, before_validation and before_destroy callbacks that return false will now ROLLBACK the transaction.  Previously this would have been committed before the processing was aborted. #891 *Xavier Noria*

*   Transactional migrations for databases which support them.  #834 *divoxx, Adam Wiggins, Tarmo Tänav*

*   Set config.active_record.timestamped_migrations = false to have migrations with numeric prefix instead of UTC timestamp. #446. *Andrew Stone, Nik Wakelin*

*   change_column_default preserves the not-null constraint.  #617 *Tarmo Tänav*

*   Fixed that create database statements would always include "DEFAULT NULL" (Nick Sieger) *#334*

*   Add :tokenizer option to validates_length_of to specify how to split up the attribute string. #507. [David Lowenfels] Example :

    \# Ensure essay contains at least 100 words.
    validates_length_of :essay, :minimum => 100, :too_short => "Your essay must be at least %d words."), :tokenizer => lambda {|str| str.scan(/\w+/) }

*   Allow conditions on multiple tables to be specified using hash. [Pratik Naik]. Example:

    User.all :joins => :items, :conditions => { :age => 10, :items => { :color => 'black' } }
    Item.first :conditions => { :items => { :color => 'red' } }

*   Always treat integer :limit as byte length.  #420 *Tarmo Tänav*

*   Partial updates don't update lock_version if nothing changed.  #426 *Daniel Morrison*

*   Fix column collision with named_scope and :joins.  #46 *Duncan Beevers, Mark Catley*

*   db:migrate:down and :up update schema_migrations.  #369 *Michael Raidel, RaceCondition*

*   PostgreSQL: support :conditions => [':foo::integer', { :foo => 1 }] without treating the ::integer typecast as a bind variable.  *Tarmo Tänav*

*   MySQL: rename_column preserves column defaults.  #466 *Diego Algorta*

*   Add :from option to calculations.  #397 *Ben Munat*

*   Add :validate option to associations to enable/disable the automatic validation of associated models. Resolves #301. *Jan De Poorter*

*   PostgreSQL: use 'INSERT ... RETURNING id' for 8.2 and later.  *Jeremy Kemper*

*   Added SQL escaping for :limit and :offset in MySQL *Jonathan Wiess*


## 2.1.0 (May 31st, 2008) ##

*   Add ActiveRecord::Base.sti_name that checks ActiveRecord::Base#store_full_sti_class? and returns either the full or demodulized name. *Rick Olson*

*   Add first/last methods to associations/named_scope. Resolved #226. *Ryan Bates*

*   Added SQL escaping for :limit and :offset #288 *Aaron Bedra, Steven Bristol, Jonathan Wiess*

*   Added first/last methods to associations/named_scope. Resolved #226. *Ryan Bates*

*   Ensure hm:t preloading honours reflection options. Resolves #137. *Frederick Cheung*

*   Added protection against duplicate migration names (Aslak Hellesøy) *#112*

*   Base#instantiate_time_object: eliminate check for Time.zone, since we can assume this is set if time_zone_aware_attributes is set to true *Geoff Buesing*

*   Time zone aware attribute methods use Time.zone.parse instead of #to_time for String arguments, so that offset information in String is respected. Resolves #105. *Scott Fleckenstein, Geoff Buesing*

*   Added change_table for migrations (Jeff Dean) [#71]. Example:

        change_table :videos do |t|
          t.timestamps                          # adds created_at, updated_at
          t.belongs_to :goat                    # adds goat_id integer
          t.string :name, :email, :limit => 20  # adds name and email both with a 20 char limit
          t.remove :name, :email                # removes the name and email columns
        end

*   Fixed has_many :through .create with no parameters caused a "can't dup NilClass" error (Steven Soroka) *#85*

*   Added block-setting of attributes for Base.create like Base.new already has (Adam Meehan) *#39*

*   Fixed that pessimistic locking you reference the quoted table name (Josh Susser) *#67*

*   Fixed that change_column should be able to use :null => true on a field that formerly had false [Nate Wiger] *#26*

*   Added that the MySQL adapter should map integer to either smallint, int, or bigint depending on the :limit just like PostgreSQL *David Heinemeier Hansson*

*   Change validates_uniqueness_of :case_sensitive option default back to true (from [9160]).  Love your database columns, don't LOWER them.  *Rick Olson*

*   Add support for interleaving migrations by storing which migrations have run in the new schema_migrations table. Closes #11493 *Jordi Bunster*

*   ActiveRecord::Base#sum defaults to 0 if no rows are returned.  Closes #11550 *Kamal Fariz Mahyuddin*

*   Ensure that respond_to? considers dynamic finder methods. Closes #11538. *James Mead*

*   Ensure that save on parent object fails for invalid has_one association. Closes #10518. *Pratik Naik*

*   Remove duplicate code from associations. *Pratik Naik*

*   Refactor HasManyThroughAssociation to inherit from HasManyAssociation. Association callbacks and <association>_ids= now work with hm:t. #11516 *Ruy Asan*

*   Ensure HABTM#create and HABTM#build do not load entire association. *Pratik Naik*

*   Improve documentation. *Xavier Noria, Jack Danger Canty, leethal*

*   Tweak ActiveRecord::Base#to_json to include a root value in the returned hash: {"post": {"title": ...}} *Rick Olson*

    Post.find(1).to_json # => {"title": ...}
    config.active_record.include_root_in_json = true
    Post.find(1).to_json # => {"post": {"title": ...}}

*   Add efficient #include? to AssociationCollection (for has_many/has_many :through/habtm).  *stopdropandrew*

*   PostgreSQL: create_ and drop_database support.  #9042 *ez, pedz, Nick Sieger*

*   Ensure that validates_uniqueness_of works with with_scope. Closes #9235. *Nik Wakelin, cavalle*

*   Partial updates include only unsaved attributes. Off by default; set YourClass.partial_updates = true to enable.  *Jeremy Kemper*

*   Removing unnecessary uses_tzinfo helper from tests, given that TZInfo is now bundled *Geoff Buesing*

*   Fixed that validates_size_of :within works in associations #11295, #10019 *cavalle*

*   Track changes to unsaved attributes.  *Jeremy Kemper*

*   Switched to UTC-timebased version numbers for migrations and the schema. This will as good as eliminate the problem of multiple migrations getting the same version assigned in different branches. Also added rake db:migrate:up/down to apply individual migrations that may need to be run when you merge branches #11458 *John Barnette*

*   Fixed that has_many :through would ignore the hash conditions #11447 *Emilio Tagua*

*   Fix issue where the :uniq option of a has_many :through association is ignored when find(:all) is called.  Closes #9407 *cavalle*

*   Fix duplicate table alias error when including an association with a has_many :through association on the same join table.  Closes #7310 *cavalle*

*   More efficient association preloading code that compacts a through_records array in a central location.  Closes #11427 *Jack Danger Canty*

*   Improve documentation. *Ryan Bigg, Jan De Poorter, Cheah Chu Yeow, Xavier Shay, Jack Danger Canty, Emilio Tagua, Xavier Noria,  Sunny Ripert*

*   Fixed that ActiveRecord#Base.find_or_create/initialize would not honor attr_protected/accessible when used with a hash #11422 *Emilio Tagua*

*   Added ActiveRecord#Base.all/first/last as aliases for find(:all/:first/:last) #11413 *nkallen, Chris O'Sullivan*

*   Merge the has_finder gem, renamed as 'named_scope'.  #11404 *nkallen*

    class Article < ActiveRecord::Base
        named_scope :published, :conditions => {:published => true}
        named_scope :popular, :conditions => ...
    end

    Article.published.paginate(:page => 1)
    Article.published.popular.count
    Article.popular.find(:first)
    Article.popular.find(:all, :conditions => {...})

    See http://pivots.pivotallabs.com/users/nick/blog/articles/284-hasfinder-it-s-now-easier-than-ever-to-create-complex-re-usable-sql-queries

*   Add has_one :through support.  #4756 *Chris O'Sullivan*

*   Migrations: create_table supports primary_key_prefix_type.  #10314 *student, Chris O'Sullivan*

*   Added logging for dependency load errors with fixtures #11056 *stuthulhu*

*   Time zone aware attributes use Time#in_time_zone *Geoff Buesing*

*   Fixed that scoped joins would not always be respected #6821 *Theory/Jack Danger Canty*

*   Ensure that ActiveRecord::Calculations disambiguates field names with the table name.  #11027 *cavalle*

*   Added add/remove_timestamps to the schema statements for adding the created_at/updated_at columns on existing tables #11129 *jramirez*

*   Added ActiveRecord::Base.find(:last) #11338 *Emilio Tagua*

*   test_native_types expects DateTime.local_offset instead of DateTime.now.offset; fixes test breakage due to dst transition *Geoff Buesing*

*   Add :readonly option to HasManyThrough associations. #11156 *Emilio Tagua*

*   Improve performance on :include/:conditions/:limit queries by selectively joining in the pre-query.  #9560 *dasil003*

*   Perf fix: Avoid the use of named block arguments.  Closes #11109 *adymo*

*   PostgreSQL: support server versions 7.4 through 8.0 and the ruby-pg driver.  #11127 *jdavis*

*   Ensure association preloading doesn't break when an association returns nil. ##11145 *GMFlash*

*   Make dynamic finders respect the :include on HasManyThrough associations.  #10998. *cpytel*

*   Base#instantiate_time_object only uses Time.zone when Base.time_zone_aware_attributes is true; leverages Time#time_with_datetime_fallback for readability *Geoff Buesing*

*   Refactor ConnectionAdapters::Column.new_time: leverage DateTime failover behavior of Time#time_with_datetime_fallback *Geoff Buesing*

*   Improve associations performance by using symbol callbacks instead of string callbacks. #11108 *adymo*

*   Optimise the BigDecimal conversion code.  #11110 *adymo*

*   Introduce the :readonly option to all associations. Records from the association cannot be saved.  #11084 *Emilio Tagua*

*   Multiparameter attributes for time columns fail over to DateTime when out of range of Time *Geoff Buesing*

*   Base#instantiate_time_object uses Time.zone.local() *Geoff Buesing*

*   Add timezone-aware attribute readers and writers. #10982 *Geoff Buesing*

*   Instantiating time objects in multiparameter attributes uses Time.zone if available.  #10982 *Rick Olson*

*   Add note about how ActiveRecord::Observer classes are initialized in a Rails app. #10980 *Xavier Noria*

*   MySQL: omit text/blob defaults from the schema instead of using an empty string.  #10963 *mdeiters*

*   belongs_to supports :dependent => :destroy and :delete.  #10592 *Jonathan Viney*

*   Introduce preload query strategy for eager :includes.  #9640 *Frederick Cheung, Aliaksey Kandratsenka, codafoo*

*   Support aggregations in finder conditions.  #10572 *Ryan Kinderman*

*   Organize and clean up the Active Record test suite.  #10742 *John Barnette*

*   Ensure that modifying has_and_belongs_to_many actions clear the query cache.  Closes #10840 *john.andrews*

*   Fix issue where Table#references doesn't pass a :null option to a *_type attribute for polymorphic associations.  Closes #10753 *railsjitsu*

*   Fixtures: removed support for the ancient pre-YAML file format.  #10736 *John Barnette*

*   More thoroughly quote table names.  #10698 *dimdenis, lotswholetime, Jeremy Kemper*

*   update_all ignores scoped :order and :limit, so post.comments.update_all doesn't try to include the comment order in the update statement.  #10686 *Brendan Ribera*

*   Added ActiveRecord::Base.cache_key to make it easier to cache Active Records in combination with the new ActiveSupport::Cache::* libraries *David Heinemeier Hansson*

*   Make sure CSV fixtures are compatible with ruby 1.9's new csv implementation. *JEG2*

*   Added by parameter to increment, decrement, and their bang varieties so you can do player1.increment!(:points, 5) #10542 *Sam*

*   Optimize ActiveRecord::Base#exists? to use #select_all instead of #find.  Closes #10605 *jamesh, Frederick Cheung, protocool*

*   Don't unnecessarily load has_many associations in after_update callbacks.  Closes #6822 *stopdropandrew, canadaduane*

*   Eager belongs_to :include infers the foreign key from the association name rather than the class name.  #10517 *Jonathan Viney*

*   SQLite: fix rename_ and remove_column for columns with unique indexes.  #10576 *Brandon Keepers*

*   Ruby 1.9 compatibility.  #10655 *Jeremy Kemper, Dirkjan Bussink*


## 2.0.2 (December 16th, 2007) ##

*   Ensure optimistic locking handles nil #lock_version values properly.  Closes #10510 *Rick Olson*

*   Make the Fixtures Test::Unit enhancements more supporting for double-loaded test cases.  Closes #10379 *brynary*

*   Fix that validates_acceptance_of still works for non-existent tables (useful for bootstrapping new databases).  Closes #10474 *Josh Susser*

*   Ensure that the :uniq option for has_many :through associations retains the order.  #10463 *remvee*

*   Base.exists? doesn't rescue exceptions to avoid hiding SQL errors.  #10458 *Michael Klishin*

*   Documentation: Active Record exceptions, destroy_all and delete_all.  #10444, #10447 *Michael Klishin*


## 2.0.1 (December 7th, 2007) ##

*   Removed query cache rescue as it could cause code to be run twice (closes #10408) *David Heinemeier Hansson*


## 2.0.0 (December 6th, 2007) ##

*   Anchor DateTimeTest to fixed DateTime instead of a variable value based on Time.now#advance#to_datetime, so that this test passes on 64-bit platforms running Ruby 1.8.6+ *Geoff Buesing*

*   Fixed that the Query Cache should just be ignored if the database is misconfigured (so that the "About your applications environment" works even before the database has been created) *David Heinemeier Hansson*

*   Fixed that the truncation of strings longer than 50 chars should use inspect
    so newlines etc are escaped #10385 *Norbert Crombach*

*   Fixed that habtm associations should be able to set :select as part of their definition and have that honored *David Heinemeier Hansson*

*   Document how the :include option can be used in Calculations::calculate.  Closes #7446 *adamwiggins, ultimoamore*

*   Fix typo in documentation for polymorphic associations w/STI. Closes #7461 *johnjosephbachir*

*   Reveal that the type option in migrations can be any supported column type for your database but also include caveat about agnosticism. Closes #7531 *adamwiggins, mikong*

*   More complete documentation for find_by_sql. Closes #7912 *fearoffish*

*   Added ActiveRecord::Base#becomes to turn a record into one of another class (mostly relevant for STIs) [David Heinemeier Hansson]. Example:

        render :partial => @client.becomes(Company) # renders companies/company instead of clients/client

*   Fixed that to_xml should not automatically pass :procs to associations included with :include #10162 *Cheah Chu Yeow*

*   Fix documentation typo introduced in [8250]. Closes #10339 *Henrik N*

*   Foxy fixtures: support single-table inheritance.  #10234 *tom*

*   Foxy fixtures: allow mixed usage to make migration easier and more attractive.  #10004 *lotswholetime*

*   Make the record_timestamps class-inheritable so it can be set per model.  #10004 *tmacedo*

*   Allow validates_acceptance_of to use a real attribute instead of only virtual (so you can record that the acceptance occured) #7457 *ambethia*

*   DateTimes use Ruby's default calendar reform setting. #10201 *Geoff Buesing*

*   Dynamic finders on association collections respect association :order and :limit.  #10211, #10227 *Patrick Joyce, Rick Olson, Jack Danger Canty*

*   Add 'foxy' support for fixtures of polymorphic associations. #10183 *John Barnette, David Lowenfels*

*   validates_inclusion_of and validates_exclusion_of allow formatted :message strings.  #8132 *devrieda, Mike Naberezny*

*   attr_readonly behaves well with optimistic locking.  #10188 *Nick Bugajski*

*   Base#to_xml supports the nil="true" attribute like Hash#to_xml.  #8268 *Jonathan del Strother*

*   Change plings to the more conventional quotes in the documentation. Closes #10104 *Jack Danger Canty*

*   Fix HasManyThrough Association so it uses :conditions on the HasMany Association.  Closes #9729 *Jack Danger Canty*

*   Ensure that column names are quoted.  Closes #10134 *wesley.moxam*

*   Smattering of grammatical fixes to documentation. Closes #10083 *Bob Silva*

*   Enhance explanation with more examples for attr_accessible macro. Closes #8095 *fearoffish, Marcel Molina Jr.*

*   Update association/method mapping table to refected latest collection methods for has_many :through. Closes #8772 *Pratik Naik*

*   Explain semantics of having several different AR instances in a transaction block. Closes #9036 *jacobat, Marcel Molina Jr.*

*   Update Schema documentation to use updated sexy migration notation. Closes #10086 *Sam Granieri*

*   Make fixtures work with the new test subclasses. *Tarmo Tänav, Michael Koziarski*

*   Introduce finder :joins with associations. Same :include syntax but with inner rather than outer joins.  #10012 *RubyRedRick*
        # Find users with an avatar
        User.find(:all, :joins => :avatar)

        # Find posts with a high-rated comment.
        Post.find(:all, :joins => :comments, :conditions => 'comments.rating > 3')

*   Associations: speedup duplicate record check.  #10011 *Pratik Naik*

*   Make sure that << works on has_many associations on unsaved records.  Closes #9989 *Josh Susser*

*   Allow association redefinition in subclasses.  #9346 *wildchild*

*   Fix has_many :through delete with custom foreign keys.  #6466 *naffis*

*   Foxy fixtures, from rathole (http://svn.geeksomnia.com/rathole/trunk/README)
        - stable, autogenerated IDs
        - specify associations (belongs_to, has_one, has_many) by label, not ID
        - specify HABTM associations as inline lists
        - autofill timestamp columns
        - support YAML defaults
        - fixture label interpolation
    Enabled for fixtures that correspond to a model class and don't specify a primary key value.  #9981 *John Barnette*

*   Add docs explaining how to protect all attributes using attr_accessible with no arguments. Closes #9631 *boone, rmm5t*

*   Update add_index documentation to use new options api. Closes #9787 *Kamal Fariz Mahyuddin*

*   Allow find on a has_many association defined with :finder_sql to accept id arguments as strings like regular find does. Closes #9916 *krishna*

*   Use VALID_FIND_OPTIONS when resolving :find scoping rather than hard coding the list of valid find options. Closes #9443 *sur*

*   Limited eager loading no longer ignores scoped :order. Closes #9561 *Jack Danger Canty, Josh Peek*

*   Assigning an instance of a foreign class to a composed_of aggregate calls an optional conversion block. Refactor and simplify composed_of implementation.  #6322 *brandon, Chris Cruft*

*   Assigning nil to a composed_of aggregate also sets its immediate value to nil.  #9843 *Chris Cruft*

*   Ensure that mysql quotes table names with database names correctly.  Closes #9911 *crayz*

    "foo.bar" => "`foo`.`bar`"

*   Complete the assimilation of Sexy Migrations from ErrFree *Chris Wanstrath, PJ Hyett*
    http://errtheblog.com/post/2381

*   Qualified column names work in hash conditions, like :conditions => { 'comments.created_at' => ... }.  #9733 *Jack Danger Canty*

*   Fix regression where the association would not construct new finder SQL on save causing bogus queries for "WHERE owner_id = NULL" even after owner was saved.  #8713 *Bryan Helmkamp*

*   Refactor association create and build so before & after callbacks behave consistently.  #8854 *Pratik Naik, mortent*

*   Quote table names. Defaults to column quoting.  #4593 *Justin Lynn, gwcoffey, eadz, Dmitry V. Sabanin, Jeremy Kemper*

*   Alias association #build to #new so it behaves predictably.  #8787 *Pratik Naik*

*   Add notes to documentation regarding attr_readonly behavior with counter caches and polymorphic associations.  Closes #9835 *saimonmoore, Rick Olson*

*   Observers can observe model names as symbols properly now.  Closes #9869  *queso*

*   find_and_(initialize|create)_by methods can now properly initialize protected attributes *Tobias Lütke*

*   belongs_to infers the foreign key from the association name instead of from the class name.  *Jeremy Kemper*

*   PostgreSQL: support multiline default values.  #7533 *Carl Lerche, aguynamedryan, Rein Henrichs, Tarmo Tänav*

*   MySQL: fix change_column on not-null columns that don't accept dfeault values of ''.  #6663 *Jonathan Viney, Tarmo Tänav*

*   validates_uniqueness_of behaves well with abstract superclasses and
    single-table inheritance.  #3833, #9886 *Gabriel Gironda, rramdas, François Beausoleil, Josh Peek, Tarmo Tänav, pat*

*   Warn about protected attribute assigments in development and test environments when mass-assigning to an attr_protected attribute.  #9802 *Henrik N*

*   Speedup database date/time parsing.  *Jeremy Kemper, Tarmo Tänav*

*   Fix calling .clear on a has_many :dependent=>:delete_all association. *Tarmo Tänav*

*   Allow change_column to set NOT NULL in the PostgreSQL adapter *Tarmo Tänav*

*   Fix that ActiveRecord would create attribute methods and override custom attribute getters if the method is also defined in Kernel.methods. *Rick Olson*

*   Don't call attr_readonly on polymorphic belongs_to associations, in case it matches the name of some other non-ActiveRecord class/module.  *Rick Olson*

*   Try loading activerecord-<adaptername>-adapter gem before trying a plain require so you can use custom gems for the bundled adapters. Also stops gems from requiring an adapter from an old Active Record gem.  *Jeremy Kemper, Derrick Spell*


## 2.0.0 Preview Release (September 29th, 2007) Includes duplicates of changes from 1.14.2 - 1.15.3 ##

*   Add attr_readonly to specify columns that are skipped during a normal ActiveRecord #save operation. Closes #6896 *Dan Manges*

    class Comment < ActiveRecord::Base
        # Automatically sets Article#comments_count as readonly.
        belongs_to :article, :counter_cache => :comments_count
    end

    class Article < ActiveRecord::Base
        attr_readonly :approved_comments_count
    end

*   Make size for has_many :through use counter cache if it exists.  Closes #9734 *Xavier Shay*

*   Remove DB2 adapter since IBM chooses to maintain their own adapter instead.  *Jeremy Kemper*

*   Extract Oracle, SQLServer, and Sybase adapters into gems.  *Jeremy Kemper*

*   Added fixture caching that'll speed up a normal fixture-powered test suite between 50% and 100% #9682 *Frederick Cheung*

*   Correctly quote id list for limited eager loading.  #7482 *tmacedo*

*   Fixed that using version-targetted migrates would fail on loggers other than the default one #7430 *valeksenko*

*   Fixed rename_column for SQLite when using symbols for the column names #8616 *drodriguez*

*   Added the possibility of using symbols in addition to concrete classes with ActiveRecord::Observer#observe.  #3998 *Robby Russell, Tarmo Tänav*

*   Added ActiveRecord::Base#to_json/from_json *David Heinemeier Hansson, Cheah Chu Yeow*

*   Added ActiveRecord::Base#from_xml [David Heinemeier Hansson]. Example:

        xml = "<person><name>David</name></person>"
        Person.new.from_xml(xml).name # => "David"

*   Define dynamic finders as real methods after first usage. *bscofield*

*   Deprecation: remove deprecated threaded_connections methods. Use allow_concurrency instead.  *Jeremy Kemper*

*   Associations macros accept extension blocks alongside modules.  #9346 *Josh Peek*

*   Speed up and simplify query caching.  *Jeremy Kemper*

*   connection.select_rows 'sql' returns an array (rows) of arrays (field values).  #2329 *Michael Schuerig*

*   Eager loading respects explicit :joins.  #9496 *dasil003*

*   Extract Firebird, FrontBase, and OpenBase adapters into gems.  #9508, #9509, #9510 *Jeremy Kemper*

*   RubyGem database adapters: expects a gem named activerecord-<database>-adapter with active_record/connection_adapters/<database>_adapter.rb in its load path.  *Jeremy Kemper*

*   Fixed that altering join tables in migrations would fail w/ sqlite3 #7453 *TimoMihaljov/brandon*

*   Fix association writer with :dependent => :nullify.  #7314 *Jonathan Viney*

*   OpenBase: update for new lib and latest Rails. Support migrations.  #8748 *dcsesq*

*   Moved acts_as_tree into a plugin of the same name on the official Rails svn.  #9514 *Pratik Naik*

*   Moved acts_as_nested_set into a plugin of the same name on the official Rails svn.  #9516 *Josh Peek*

*   Moved acts_as_list into a plugin of the same name on the official Rails svn.  *Josh Peek*

*   Explicitly require active_record/query_cache before using it.  *Jeremy Kemper*

*   Fix bug where unserializing an attribute attempts to modify a frozen @attributes hash for a deleted record.  *Rick Olson, marclove*

*   Performance: absorb instantiate and initialize_with_callbacks into the Base methods. *Jeremy Kemper*

*   Fixed that eager loading queries and with_scope should respect the :group option *David Heinemeier Hansson*

*   Improve performance and functionality of the postgresql adapter.  Closes #8049 *roderickvd*

    For more information see: http://dev.rubyonrails.org/ticket/8049

*   Don't clobber includes passed to has_many.count *Jack Danger Canty*

*   Make sure has_many uses :include when counting *Jack Danger Canty*

*   Change the implementation of ActiveRecord's attribute reader and writer methods *Michael Koziarski*
    - Generate Reader and Writer methods which cache attribute values in hashes.  This is to avoid repeatedly parsing the same date or integer columns.
    - Change exception raised when users use find with :select then try to access a skipped column.  Plugins could override missing_attribute() to lazily load the columns.
    - Move method definition to the class, instead of the instance
    - Always generate the readers, writers and predicate methods.

*   Perform a deep #dup on query cache results so that modifying activerecord attributes does not modify the cached attributes.  *Rick Olson*

    \# Ensure that has_many :through associations use a count query instead of loading the target when #size is called.  Closes #8800 *Pratik Naik*

*   Added :unless clause to validations #8003 [monki]. Example:

        def using_open_id?
          !identity_url.blank?
        end

        validates_presence_of :identity_url, :if => using_open_id?
        validates_presence_of :username, :unless => using_open_id?
        validates_presence_of :password, :unless => using_open_id?

*   Fix #count on a has_many :through association so that it recognizes the :uniq option.  Closes #8801 *Pratik Naik*

*   Fix and properly document/test count(column_name) usage. Closes #8999 *Pratik Naik*

*   Remove deprecated count(conditions=nil, joins=nil) usage.  Closes #8993 *Pratik Naik*

*   Change belongs_to so that the foreign_key assumption is taken from the association name, not the class name.  Closes #8992 *Josh Susser*

    OLD
        belongs_to :visitor, :class_name => 'User' # => inferred foreign_key is user_id

    NEW
        belongs_to :visitor, :class_name => 'User' # => inferred foreign_key is visitor_id

*   Remove spurious tests from deprecated_associations_test, most of these aren't deprecated, and are duplicated in associations_test.  Closes #8987 *Pratik Naik*

*   Make create! on a has_many :through association return the association object.  Not the collection.  Closes #8786 *Pratik Naik*

*   Move from select * to select tablename.* to avoid clobbering IDs. Closes #8889 *dasil003*

*   Don't call unsupported methods on associated objects when using :include, :method with to_xml #7307, *Manfred Stienstra, jwilger*

*   Define collection singular ids method for has_many :through associations.  #8763 *Pratik Naik*

*   Array attribute conditions work with proxied association collections.  #8318 *Kamal Fariz Mahyuddin, theamazingrando*

*   Fix polymorphic has_one associations declared in an abstract class.  #8638 *Pratik Naik, Dax Huiberts*

*   Fixed validates_associated should not stop on the first error.  #4276 *mrj, Manfred Stienstra, Josh Peek*

*   Rollback if commit raises an exception.  #8642 *kik, Jeremy Kemper*

*   Update tests' use of fixtures for the new collections api.  #8726 *Kamal Fariz Mahyuddin*

*   Save associated records only if the association is already loaded.  #8713 *Blaine*

*   MySQL: fix show_variable.  #8448 *matt, Jeremy Kemper*

*   Fixtures: correctly delete and insert fixtures in a single transaction.  #8553 *Michael Schuerig*

*   Fixtures: people(:technomancy, :josh) returns both fixtures.  #7880 *technomancy, Josh Peek*

*   Calculations support non-numeric foreign keys.  #8154 *Kamal Fariz Mahyuddin*

*   with_scope is protected.  #8524 *Josh Peek*

*   Quickref for association methods.  #7723 *marclove, Mindsweeper*

*   Calculations: return nil average instead of 0 when there are no rows to average.  #8298 *davidw*

*   acts_as_nested_set: direct_children is sorted correctly.  #4761 *Josh Peek, rails@33lc0.net*

*   Raise an exception if both attr_protected and attr_accessible are declared.  #8507 *stellsmi*

*   SQLite, MySQL, PostgreSQL, Oracle: quote column names in column migration SQL statements.  #8466 *marclove, lorenjohnson*

*   Allow nil serialized attributes with a set class constraint.  #7293 *sandofsky*

*   Oracle: support binary fixtures.  #7987 *Michael Schoen*

*   Fixtures: pull fixture insertion into the database adapters.  #7987 *Michael Schoen*

*   Announce migration versions as they're performed.  *Jeremy Kemper*

*   find gracefully copes with blank :conditions.  #7599 *Dan Manges, johnnyb*

*   validates_numericality_of takes :greater_than, :greater_than_or_equal_to, :equal_to, :less_than, :less_than_or_equal_to, :odd, and :even options.  #3952 *Bob Silva, Dan Kubb, Josh Peek*

*   MySQL: create_database takes :charset and :collation options. Charset defaults to utf8.  #8448 *matt*

*   Find with a list of ids supports limit/offset.  #8437 *hrudududu*

*   Optimistic locking: revert the lock version when an update fails.  #7840 *plang*

*   Migrations: add_column supports custom column types.  #7742 *jsgarvin, Theory*

*   Load database adapters on demand. Eliminates config.connection_adapters and RAILS_CONNECTION_ADAPTERS. Add your lib directory to the $LOAD_PATH and put your custom adapter in lib/active_record/connection_adapters/adaptername_adapter.rb. This way you can provide custom adapters as plugins or gems without modifying Rails. *Jeremy Kemper*

*   Ensure that associations with :dependent => :delete_all respect :conditions option.  Closes #8034 *Jack Danger Canty, Josh Peek, Rick Olson*

*   belongs_to assignment creates a new proxy rather than modifying its target in-place.  #8412 *mmangino@elevatedrails.com*

*   Fix column type detection while loading fixtures.  Closes #7987 *roderickvd*

*   Document deep eager includes.  #6267 *Josh Susser, Dan Manges*

*   Document warning that associations names shouldn't be reserved words.  #4378 *murphy@cYcnus.de, Josh Susser*

*   Sanitize Base#inspect.  #8392, #8623 *Nik Wakelin, jnoon*

*   Replace the transaction {|transaction|..} semantics with a new Exception ActiveRecord::Rollback.   *Michael Koziarski*

*   Oracle: extract column length for CHAR also.  #7866 *ymendel*

*   Document :allow_nil option for validates_acceptance_of since it defaults to true. *tzaharia*

*   Update documentation for :dependent declaration so that it explicitly uses the non-deprecated API. *Jack Danger Canty*

*   Add documentation caveat about when to use count_by_sql. *fearoffish*

*   Enhance documentation for increment_counter and decrement_counter. *fearoffish*

*   Provide brief introduction to what optimistic locking is. *fearoffish*

*   Add documentation for :encoding option to mysql adapter. *marclove*

*   Added short-hand declaration style to migrations (inspiration from Sexy Migrations, http://errtheblog.com/post/2381) [David Heinemeier Hansson]. Example:

        create_table "products" do |t|
          t.column "shop_id",    :integer
          t.column "creator_id", :integer
          t.column "name",       :string,   :default => "Untitled"
          t.column "value",      :string,   :default => "Untitled"
          t.column "created_at", :datetime
          t.column "updated_at", :datetime
        end

    ...can now be written as:

        create_table :products do |t|
          t.integer :shop_id, :creator_id
          t.string  :name, :value, :default => "Untitled"
          t.timestamps
        end

*   Use association name for the wrapper element when using .to_xml.  Previous behavior lead to non-deterministic situations with STI and polymorphic associations. *Michael Koziarski, jstrachan*

*   Improve performance of calling .create on has_many :through associations. *evan*

*   Improved cloning performance by relying less on exception raising #8159 *Blaine*

*   Added ActiveRecord::Base.inspect to return a column-view like #<Post id:integer, title:string, body:text> *David Heinemeier Hansson*

*   Added yielding of Builder instance for ActiveRecord::Base#to_xml calls *David Heinemeier Hansson*

*   Small additions and fixes for ActiveRecord documentation.  Closes #7342 *Jeremy McAnally*

*   Add helpful debugging info to the ActiveRecord::StatementInvalid exception in ActiveRecord::ConnectionAdapters::SqliteAdapter#table_structure.  Closes #7925. *court3nay*

*   SQLite: binary escaping works with $KCODE='u'.  #7862 *tsuka*

*   Base#to_xml supports serialized attributes.  #7502 *jonathan*

*   Base.update_all :order and :limit options. Useful for MySQL updates that must be ordered to avoid violating unique constraints.  *Jeremy Kemper*

*   Remove deprecated object transactions.  People relying on this functionality should install the object_transactions plugin at http://code.bitsweat.net/svn/object_transactions.  Closes #5637 *Michael Koziarski, Jeremy Kemper*

*   PostgreSQL: remove DateTime -> Time downcast. Warning: do not enable translate_results for the C bindings if you have timestamps outside Time's domain.  *Jeremy Kemper*

*   find_or_create_by_* takes a hash so you can create with more attributes than are in the method name. For example, Person.find_or_create_by_name(:name => 'Henry', :comments => 'Hi new user!') is equivalent to Person.find_by_name('Henry') || Person.create(:name => 'Henry', :comments => 'Hi new user!').  #7368 *Josh Susser*

*   Make sure with_scope takes both :select and :joins into account when setting :readonly.  Allows you to save records you retrieve using method_missing on a has_many :through associations.  *Michael Koziarski*

*   Allow a polymorphic :source for has_many :through associations.  Closes #7143 *protocool*

*   Consistent public/protected/private visibility for chained methods.  #7813 *Dan Manges*

*   Oracle: fix quoted primary keys and datetime overflow.  #7798 *Michael Schoen*

*   Consistently quote primary key column names.  #7763 *toolmantim*

*   Fixtures: fix YAML ordered map support.  #2665 *Manuel Holtgrewe, nfbuckley*

*   DateTimes assume the default timezone.  #7764 *Geoff Buesing*

*   Sybase: hide timestamp columns since they're inherently read-only.  #7716 *Mike Joyce*

*   Oracle: overflow Time to DateTime.  #7718 *Michael Schoen*

*   PostgreSQL: don't use async_exec and async_query with postgres-pr.  #7727, #7762 *flowdelic, toolmantim*

*   Fix has_many :through << with custom foreign keys.  #6466, #7153 *naffis, Rich Collins*

*   Test DateTime native type in migrations, including an edge case with dates
    during calendar reform.  #7649, #7724 *fedot, Geoff Buesing*

*   SQLServer: correctly schema-dump tables with no indexes or descending indexes.  #7333, #7703 *Jakob Skjerning, Tom Ward*

*   SQLServer: recognize real column type as Ruby float.  #7057 *sethladd, Tom Ward*

*   Added fixtures :all as a way of loading all fixtures in the fixture directory at once #7214 *Manfred Stienstra*

*   Added database connection as a yield parameter to ActiveRecord::Base.transaction so you can manually rollback [David Heinemeier Hansson]. Example:

        transaction do |transaction|
          david.withdrawal(100)
          mary.deposit(100)
          transaction.rollback! # rolls back the transaction that was otherwise going to be successful
        end

*   Made increment_counter/decrement_counter play nicely with optimistic locking, and added a more general update_counters method *Jamis Buck*

*   Reworked David's query cache to be available as Model.cache {...}. For the duration of the block no select query should be run more then once. Any inserts/deletes/executes will flush the whole cache however *Tobias Lütke*
    Task.cache { Task.find(1); Task.find(1) } # => 1 query

*   When dealing with SQLite3, use the table_info pragma helper, so that the bindings can do some translation for when sqlite3 breaks incompatibly between point releases. *Jamis Buck*

*   Oracle: fix lob and text default handling.  #7344 *gfriedrich, Michael Schoen*

*   SQLServer: don't choke on strings containing 'null'.  #7083 *Jakob Skjerning*

*   MySQL: blob and text columns may not have defaults in 5.x. Update fixtures schema for strict mode.  #6695 *Dan Kubb*

*   update_all can take a Hash argument. sanitize_sql splits into two methods for conditions and assignment since NULL values and delimiters are handled differently.  #6583, #7365 *sandofsky, Assaf*

*   MySQL: SET SQL_AUTO_IS_NULL=0 so 'where id is null' doesn't select the last inserted id.  #6778 *Jonathan Viney, timc*

*   Use Date#to_s(:db) for quoted dates.  #7411 *Michael Schoen*

*   Don't create instance writer methods for class attributes.  Closes #7401 *Rick Olson*

*   Docs: validations examples.  #7343 *zackchandler*

*   Add missing tests ensuring callbacks work with class inheritance.  Closes #7339 *sandofsky*

*   Fixtures use the table name and connection from set_fixture_class.  #7330 *Anthony Eden*

*   Remove useless code in #attribute_present? since 0 != blank?.  Closes #7249 *Josh Susser*

*   Fix minor doc typos. Closes #7157 *Josh Susser*

*   Fix incorrect usage of #classify when creating the eager loading join statement.  Closes #7044 *Josh Susser*

*   SQLServer: quote table name in indexes query.  #2928 *keithm@infused.org*

*   Subclasses of an abstract class work with single-table inheritance.  #5704, #7284 *BertG, nick+rails@ag.arizona.edu*

*   Make sure sqlite3 driver closes open connections on disconnect *Rob Rasmussen*

*   [DOC] clear up some ambiguity with the way has_and_belongs_to_many creates the default join table name.  #7072 *Jeremy McAnally*

*   change_column accepts :default => nil. Skip column options for primary keys.  #6956, #7048 *Dan Manges, Jeremy Kemper*

*   MySQL, PostgreSQL: change_column_default quotes the default value and doesn't lose column type information.  #3987, #6664 *Jonathan Viney, Manfred Stienstra, altano@bigfoot.com*

*   Oracle: create_table takes a :sequence_name option to override the 'tablename_seq' default.  #7000 *Michael Schoen*

*   MySQL: retain SSL settings on reconnect.  #6976 *randyv2*

*   Apply scoping during initialize instead of create.  Fixes setting of foreign key when using find_or_initialize_by with scoping. *Cody Fauser*

*   SQLServer: handle [quoted] table names.  #6635 *rrich*

*   acts_as_nested_set works with single-table inheritance.  #6030 *Josh Susser*

*   PostgreSQL, Oracle: correctly perform eager finds with :limit and :order.  #4668, #7021 *eventualbuddha, Michael Schoen*

*   Pass a range in :conditions to use the SQL BETWEEN operator.  #6974 *Dan Manges*
        Student.find(:all, :conditions => { :grade => 9..12 })

*   Fix the Oracle adapter for serialized attributes stored in CLOBs.  Closes #6825 *mschoen, tdfowler*

*   [DOCS] Apply more documentation for ActiveRecord Reflection.  Closes #4055 *Robby Russell*

*   [DOCS] Document :allow_nil option of #validate_uniqueness_of. Closes #3143 *Caio Chassot*

*   Bring the sybase adapter up to scratch for 1.2 release. *jsheets*

*   Rollback new_record? and id when an exception is raised in a save callback.  #6910 *Ben Curren, outerim*

*   Pushing a record on an association collection doesn't unnecessarily load all the associated records.  *Obie Fernandez, Jeremy Kemper*

*   Oracle: fix connection reset failure.  #6846 *leonlleslie*

*   Subclass instantiation doesn't try to explicitly require the corresponding subclass.  #6840 *leei, Jeremy Kemper*

*   fix faulty inheritance tests and that eager loading grabs the wrong inheritance column when the class of your association is an STI subclass. Closes #6859 *protocool*

*   Consolidated different create and create! versions to call through to the base class with scope. This fixes inconsistencies, especially related to protected attribtues. Closes #5847 *Alexander Dymo, Tobias Lütke*

*   find supports :lock with :include. Check whether your database allows SELECT ... FOR UPDATE with outer joins before using.  #6764 *vitaly, Jeremy Kemper*

*   Add AssociationCollection#create! to be consistent with AssociationCollection#create when dealing with a foreign key that is a protected attribute *Cody Fauser*

*   Added counter optimization for AssociationCollection#any? so person.friends.any? won't actually load the full association if we have the count in a cheaper form *David Heinemeier Hansson*

*   Change fixture_path to a class inheritable accessor allowing test cases to have their own custom set of fixtures. #6672 *Zach Dennis*

*   Quote ActiveSupport::Multibyte::Chars.  #6653 *Julian Tarkhanov*

*   Simplify query_attribute by typecasting the attribute value and checking whether it's nil, false, zero or blank.  #6659 *Jonathan Viney*

*   validates_numericality_of uses \A \Z to ensure the entire string matches rather than ^ $ which may match one valid line of a multiline string.  #5716 *Andreas Schwarz*

*   Run validations in the order they were declared.  #6657 *obrie*

*   MySQL: detect when a NOT NULL column without a default value is misreported as default ''.  Can't detect for string, text, and binary columns since '' is a legitimate default.  #6156 *simon@redhillconsulting.com.au, obrie, Jonathan Viney, Jeremy Kemper*

*   Simplify association proxy implementation by factoring construct_scope out of method_missing.  #6643 *martin*

*   Oracle: automatically detect the primary key.  #6594 *vesaria, Michael Schoen*

*   Oracle: to increase performance, prefetch 100 rows and enable similar cursor sharing. Both are configurable in database.yml.  #6607 *philbogle@gmail.com, ray.fortna@jobster.com, Michael Schoen*

*   Don't inspect unloaded associations.  #2905 *lmarlow*

*   SQLite: use AUTOINCREMENT primary key in >= 3.1.0.  #6588, #6616 *careo, lukfugl*

*   Cache inheritance_column.  #6592 *Stefan Kaes*

*   Firebird: decimal/numeric support.  #6408 *macrnic*

*   make add_order a tad faster. #6567 *Stefan Kaes*

*   Find with :include respects scoped :order.  #5850

*   Support nil and Array in :conditions => { attr => value } hashes.  #6548 *Assaf, Jeremy Kemper*
        find(:all, :conditions => { :topic_id => [1, 2, 3], :last_read => nil }

*   Consistently use LOWER() for uniqueness validations (rather than mixing with UPPER()) so the database can always use a functional index on the lowercased column.  #6495 *Si*

*   SQLite: fix calculations workaround, remove count(distinct) query rewrite, cleanup test connection scripts.  *Jeremy Kemper*

*   SQLite: count(distinct) queries supported in >= 3.2.6.  #6544 *Bob Silva*

*   Dynamically generate reader methods for serialized attributes.  #6362 *Stefan Kaes*

*   Deprecation: object transactions warning.  *Jeremy Kemper*

*   has_one :dependent => :nullify ignores nil associates.  #4848, #6528 *bellis@deepthought.org, janovetz, Jeremy Kemper*

*   Oracle: resolve test failures, use prefetched primary key for inserts, check for null defaults, fix limited id selection for eager loading. Factor out some common methods from all adapters.  #6515 *Michael Schoen*

*   Make add_column use the options hash with the Sqlite Adapter. Closes #6464 *obrie*

*   Document other options available to migration's add_column. #6419 *grg*

*   MySQL: all_hashes compatibility with old MysqlRes class.  #6429, #6601 *Jeremy Kemper*

*   Fix has_many :through to add the appropriate conditions when going through an association using STI. Closes #5783. *Jonathan Viney*

*   fix select_limited_ids_list issues in postgresql, retain current behavior in other adapters *Rick Olson*

*   Restore eager condition interpolation, document it's differences *Rick Olson*

*   Don't rollback in teardown unless a transaction was started. Don't start a transaction in create_fixtures if a transaction is started.  #6282 *Jacob Fugal, Jeremy Kemper*

*   Add #delete support to has_many :through associations.  Closes #6049 *Martin Landers*

*   Reverted old select_limited_ids_list postgresql fix that caused issues in mysql.  Closes #5851 *Rick Olson*

*   Removes the ability for eager loaded conditions to be interpolated, since there is no model instance to use as a context for interpolation. #5553 *turnip@turnipspatch.com*

*   Added timeout option to SQLite3 configurations to deal more gracefully with SQLite3::BusyException, now the connection can instead retry for x seconds to see if the db clears up before throwing that exception #6126 *wreese@gmail.com*

*   Added update_attributes! which uses save! to raise an exception if a validation error prevents saving #6192 *jonathan*

*   Deprecated add_on_boundary_breaking (use validates_length_of instead) #6292 *Bob Silva*

*   The has_many create method works with polymorphic associations.  #6361 *Dan Peterson*

*   MySQL: introduce Mysql::Result#all_hashes to support further optimization.  #5581 *Stefan Kaes*

*   save! shouldn't validate twice.  #6324 *maiha, Bob Silva*

*   Association collections have an _ids reader method to match the existing writer for collection_select convenience (e.g. employee.task_ids). The writer method skips blank ids so you can safely do @employee.task_ids = params[:tasks] without checking every time for an empty list or blank values.  #1887, #5780 *Michael Schuerig*

*   Add an attribute reader method for ActiveRecord::Base.observers *Rick Olson*

*   Deprecation: count class method should be called with an options hash rather than two args for conditions and joins.  #6287 *Bob Silva*

*   has_one associations with a nil target may be safely marshaled.  #6279 *norbauer, Jeremy Kemper*

*   Duplicate the hash provided to AR::Base#to_xml to prevent unexpected side effects *Michael Koziarski*

*   Add a :namespace option to  AR::Base#to_xml *Michael Koziarski*

*   Deprecation tests. Remove warnings for dynamic finders and for the foo_count method if it's also an attribute. *Jeremy Kemper*

*   Mock Time.now for more accurate Touch mixin tests.  #6213 *Dan Peterson*

*   Improve yaml fixtures error reporting.  #6205 *Bruce Williams*

*   Rename AR::Base#quote so people can use that name in their models. #3628 *Michael Koziarski*

*   Add deprecation warning for inferred foreign key. #6029 *Josh Susser*

*   Fixed the Ruby/MySQL adapter we ship with Active Record to work with the new authentication handshake that was introduced in MySQL 4.1, along with the other protocol changes made at that time #5723 *jimw@mysql.com*

*   Deprecation: use :dependent => :delete_all rather than :exclusively_dependent => true.  #6024 *Josh Susser*

*   Document validates_presences_of behavior with booleans: you probably want validates_inclusion_of :attr, :in => [true, false].  #2253 *Bob Silva*

*   Optimistic locking: gracefully handle nil versions, treat as zero.  #5908 *Tom Ward*

*   to_xml: the :methods option works on arrays of records.  #5845 *Josh Starcher*

*   Deprecation: update docs. #5998 *Jakob Skjerning, Kevin Clark*

*   Add some XmlSerialization tests for ActiveRecord *Rick Olson*

*   has_many :through conditions are sanitized by the associating class.  #5971 *martin.emde@gmail.com*

*   Tighten rescue clauses.  #5985 *james@grayproductions.net*

*   Fix spurious newlines and spaces in AR::Base#to_xml output *Jamis Buck*

*   has_one supports the :dependent => :delete option which skips the typical callback chain and deletes the associated object directly from the database.  #5927 *Chris Mear, Jonathan Viney*

*   Nested subclasses are not prefixed with the parent class' table_name since they should always use the base class' table_name.  #5911 *Jonathan Viney*

*   SQLServer: work around bug where some unambiguous date formats are not correctly identified if the session language is set to german.  #5894 *Tom Ward, kruth@bfpi*

*   SQLServer: fix eager association test.  #5901 *Tom Ward*

*   Clashing type columns due to a sloppy join shouldn't wreck single-table inheritance.  #5838 *Kevin Clark*

*   Fixtures: correct escaping of \n and \r.  #5859 *evgeny.zislis@gmail.com*

*   Migrations: gracefully handle missing migration files.  #5857 *eli.gordon@gmail.com*

*   MySQL: update test schema for MySQL 5 strict mode.  #5861 *Tom Ward*

*   to_xml: correct naming of included associations.  #5831 *Josh Starcher*

*   Pushing a record onto a has_many :through sets the association's foreign key to the associate's primary key and adds it to the correct association.  #5815, #5829 *Josh Susser*

*   Add records to has_many :through using <<, push, and concat by creating the association record. Raise if base or associate are new records since both ids are required to create the association. #build raises since you can't associate an unsaved record. #create! takes an attributes hash and creates the associated record and its association in a transaction. *Jeremy Kemper*

        # Create a tagging to associate the post and tag.
        post.tags << Tag.find_by_name('old')
        post.tags.create! :name => 'general'

        # Would have been:
        post.taggings.create!(:tag => Tag.find_by_name('finally')
        transaction do
          post.taggings.create!(:tag => Tag.create!(:name => 'general'))
        end

*   Cache nil results for :included has_one associations also.  #5787 *Michael Schoen*

*   Fixed a bug which would cause .save to fail after trying to access a empty has_one association on a unsaved record. *Tobias Lütke*

*   Nested classes are given table names prefixed by the singular form of the parent's table name. *Jeremy Kemper*
        Example: Invoice::Lineitem is given table name invoice_lineitems

*   Migrations: uniquely name multicolumn indexes so you don't have to. *Jeremy Kemper*
        # people_active_last_name_index, people_active_deactivated_at_index
        add_index    :people, [:active, :last_name]
        add_index    :people, [:active, :deactivated_at]
        remove_index :people, [:active, :last_name]
        remove_index :people, [:active, :deactivated_at]

    WARNING: backward-incompatibility. Multicolumn indexes created before this
    revision were named using the first column name only. Now they're uniquely
    named using all indexed columns.

    To remove an old multicolumn index, remove_index :table_name, :first_column

*   Fix for deep includes on the same association. *richcollins@gmail.com*

*   Tweak fixtures so they don't try to use a non-ActiveRecord class.  *Kevin Clark*

*   Remove ActiveRecord::Base.reset since Dispatcher doesn't use it anymore.  *Rick Olson*

*   Document find's :from option. Closes #5762. *andrew@redlinesoftware.com*

*   PostgreSQL: autodetected sequences work correctly with multiple schemas. Rely on the schema search_path instead of explicitly qualifying the sequence name with its schema.  #5280 *guy.naor@famundo.com*

*   Replace Reloadable with Reloadable::Deprecated. *Nicholas Seckar*

*   Cache nil results for has_one associations so multiple calls don't call the database.  Closes #5757. *Michael Schoen*

*   Add documentation for how to disable timestamps on a per model basis. Closes #5684. *matt@mattmargolis.net Marcel Molina Jr.*

*   Don't save has_one associations unnecessarily.  #5735 *Jonathan Viney*

*   Refactor ActiveRecord::Base.reset_subclasses to #reset, and add global observer resetting.  *Rick Olson*

*   Formally deprecate the deprecated finders. *Michael Koziarski*

*   Formally deprecate rich associations.  *Michael Koziarski*

*   Fixed that default timezones for new / initialize should uphold utc setting #5709 *daniluk@yahoo.com*

*   Fix announcement of very long migration names.  #5722 *blake@near-time.com*

*   The exists? class method should treat a string argument as an id rather than as conditions.  #5698 *jeremy@planetargon.com*

*   Fixed to_xml with :include misbehaviors when invoked on array of model instances #5690 *alexkwolfe@gmail.com*

*   Added support for conditions on Base.exists? #5689 [Josh Peek]. Examples:

        assert (Topic.exists?(:author_name => "David"))
         assert (Topic.exists?(:author_name => "Mary", :approved => true))
         assert (Topic.exists?(["parent_id = ?", 1]))

*   Schema dumper quotes date :default values. *Dave Thomas*

*   Calculate sum with SQL, not Enumerable on HasManyThrough Associations. *Dan Peterson*

*   Factor the attribute#{suffix} methods out of method_missing for easier extension. *Jeremy Kemper*

*   Patch sql injection vulnerability when using integer or float columns. *Jamis Buck*

*   Allow #count through a has_many association to accept :include.  *Dan Peterson*

*   create_table rdoc: suggest :id => false for habtm join tables. *Zed Shaw*

*   PostgreSQL: return array fields as strings. #4664 *Robby Russell*

*   SQLServer: added tests to ensure all database statements are closed, refactored identity_insert management code to use blocks, removed update/delete rowcount code out of execute and into update/delete, changed insert to go through execute method, removed unused quoting methods, disabled pessimistic locking tests as feature is currently unsupported, fixed RakeFile to load sqlserver specific tests whether running in ado or odbc mode, fixed support for recently added decimal types, added support for limits on integer types. #5670 *Tom Ward*

*   SQLServer: fix db:schema:dump case-sensitivity. #4684 *Will Rogers*

*   Oracle: BigDecimal support. #5667 *Michael Schoen*

*   Numeric and decimal columns map to BigDecimal instead of Float. Those with scale 0 map to Integer. #5454 *robbat2@gentoo.org, work@ashleymoran.me.uk*

*   Firebird migrations support. #5337 *Ken Kunz <kennethkunz@gmail.com>*

*   PostgreSQL: create/drop as postgres user. #4790 *mail@matthewpainter.co.uk, mlaster@metavillage.com*

*   Update callbacks documentation. #3970 *Robby Russell <robby@planetargon.com>*

*   PostgreSQL: correctly quote the ' in pk_and_sequence_for. #5462 *tietew@tietew.net*

*   PostgreSQL: correctly quote microseconds in timestamps. #5641 *rick@rickbradley.com*

*   Clearer has_one/belongs_to model names (account has_one :user). #5632 *matt@mattmargolis.net*

*   Oracle: use nonblocking queries if allow_concurrency is set, fix pessimistic locking, don't guess date vs. time by default (set OracleAdapter.emulate_dates = true for the old behavior), adapter cleanup. #5635 *Michael Schoen*

*   Fixed a few Oracle issues: Allows Oracle's odd date handling to still work consistently within #to_xml, Passes test that hardcode insert statement by dropping the :id column, Updated RUNNING_UNIT_TESTS with Oracle instructions, Corrects method signature for #exec #5294 *Michael Schoen*

*   Added :group to available options for finds done on associations #5516 *mike@michaeldewey.org*

*   Minor tweak to improve performance of ActiveRecord::Base#to_param.

*   Observers also watch subclasses created after they are declared. #5535 *daniels@pronto.com.au*

*   Removed deprecated timestamps_gmt class methods. *Jeremy Kemper*

*   rake build_mysql_database grants permissions to rails@localhost. #5501 *brianegge@yahoo.com*

*   PostgreSQL: support microsecond time resolution. #5492 *alex@msgpad.com*

*   Add AssociationCollection#sum since the method_missing invokation has been shadowed by Enumerable#sum.

*   Added find_or_initialize_by_X which works like find_or_create_by_X but doesn't save the newly instantiated record. *Sam Stephenson*

*   Row locking. Provide a locking clause with the :lock finder option or true for the default "FOR UPDATE". Use the #lock! method to obtain a row lock on a single record (reloads the record with :lock => true). *Shugo Maeda*
        # Obtain an exclusive lock on person 1 so we can safely increment visits.
        Person.transaction do
          # select * from people where id=1 for update
          person = Person.find(1, :lock => true)
          person.visits += 1
          person.save!
        end

*   PostgreSQL: introduce allow_concurrency option which determines whether to use blocking or asynchronous #execute. Adapters with blocking #execute will deadlock Ruby threads. The default value is ActiveRecord::Base.allow_concurrency. *Jeremy Kemper*

*   Use a per-thread (rather than global) transaction mutex so you may execute concurrent transactions on separate connections. *Jeremy Kemper*

*   Change AR::Base#to_param to return a String instead of a Fixnum. Closes #5320. *Nicholas Seckar*

*   Use explicit delegation instead of method aliasing for AR::Base.to_param -> AR::Base.id. #5299 (skaes@web.de)

*   Refactored ActiveRecord::Base.to_xml to become a delegate for XmlSerializer, which restores sanity to the mega method. This refactoring also reinstates the opinions that type="string" is redundant and ugly and nil-differentiation is not a concern of serialization *David Heinemeier Hansson*

*   Added simple hash conditions to find that'll just convert hash to an AND-based condition string #5143 [Hampton Catlin]. Example:

        Person.find(:all, :conditions => { :last_name => "Catlin", :status => 1 }, :limit => 2)

    ...is the same as:

        Person.find(:all, :conditions => [ "last_name = ? and status = ?", "Catlin", 1 ], :limit => 2)

    This makes it easier to pass in the options from a form or otherwise outside.


*   Fixed issues with BLOB limits, charsets, and booleans for Firebird #5194, #5191, #5189 *kennethkunz@gmail.com*

*   Fixed usage of :limit and with_scope when the association in scope is a 1:m #5208 *alex@purefiction.net*

*   Fixed migration trouble with SQLite when NOT NULL is used in the new definition #5215 *greg@lapcominc.com*

*   Fixed problems with eager loading and counting on SQL Server #5212 *kajism@yahoo.com*

*   Fixed that count distinct should use the selected column even when using :include #5251 *anna@wota.jp*

*   Fixed that :includes merged from with_scope won't cause the same association to be loaded more than once if repetition occurs in the clauses #5253 *alex@purefiction.net*

*   Allow models to override to_xml.  #4989 *Blair Zajac <blair@orcaware.com>*

*   PostgreSQL: don't ignore port when host is nil since it's often used to label the domain socket.  #5247 *shimbo@is.naist.jp*

*   Records and arrays of records are bound as quoted ids. *Jeremy Kemper*
        Foo.find(:all, :conditions => ['bar_id IN (?)', bars])
        Foo.find(:first, :conditions => ['bar_id = ?', bar])

*   Fixed that Base.find :all, :conditions => [ "id IN (?)", collection ] would fail if collection was empty *David Heinemeier Hansson*

*   Add a list of regexes assert_queries skips in the ActiveRecord test suite.  *Rick Olson*

*   Fix the has_and_belongs_to_many #create doesn't populate the join for new records.  Closes #3692 *Josh Susser*

*   Provide Association Extensions access to the instance that the association is being accessed from.
    Closes #4433 *Josh Susser*

*   Update OpenBase adaterp's maintainer's email address. Closes #5176. *Derrick Spell*

*   Add a quick note about :select and eagerly included associations. *Rick Olson*

*   Add docs for the :as option in has_one associations.  Closes #5144 *cdcarter@gmail.com*

*   Fixed that has_many collections shouldn't load the entire association to do build or create *David Heinemeier Hansson*

*   Added :allow_nil option for aggregations #5091 *Ian White*

*   Fix Oracle boolean support and tests. Closes #5139. *Michael Schoen*

*   create! no longer blows up when no attributes are passed and a :create scope is in effect (e.g. foo.bars.create! failed whereas foo.bars.create!({}) didn't.) *Jeremy Kemper*

*   Call Inflector#demodulize on the class name when eagerly including an STI model.  Closes #5077 *info@loobmedia.com*

*   Preserve MySQL boolean column defaults when changing a column in a migration. Closes #5015. *pdcawley@bofh.org.uk*

*   PostgreSQL: migrations support :limit with :integer columns by mapping limit < 4 to smallint, > 4 to bigint, and anything else to integer. #2900 *keegan@thebasement.org*

*   Dates and times interpret empty strings as nil rather than 2000-01-01. #4830 *kajism@yahoo.com*

*   Allow :uniq => true with has_many :through associations. *Jeremy Kemper*

*   Ensure that StringIO is always available for the Schema dumper. *Marcel Molina Jr.*

*   Allow AR::Base#to_xml to include methods too. Closes #4921. *johan@textdrive.com*

*   Replace superfluous name_to_class_name variant with camelize. *Marcel Molina Jr.*

*   Replace alias method chaining with Module#alias_method_chain. *Marcel Molina Jr.*

*   Replace Ruby's deprecated append_features in favor of included. *Marcel Molina Jr.*

*   Remove duplicate fixture entry in comments.yml. Closes #4923. *Blair Zajac <blair@orcaware.com>*

*   Update FrontBase adapter to check binding version. Closes #4920. *mlaster@metavillage.com*

*   New Frontbase connections don't start in auto-commit mode. Closes #4922. *mlaster@metavillage.com*

*   When grouping, use the appropriate option key. *Marcel Molina Jr.*

*   Only modify the sequence name in the FrontBase adapter if the FrontBase adapter is actually being used. *Marcel Molina Jr.*

*   Add support for FrontBase (http://www.frontbase.com/) with a new adapter thanks to the hard work of one Mike Laster. Closes #4093. *mlaster@metavillage.com*

*   Add warning about the proper way to validate the presence of a foreign key. Closes #4147. *Francois Beausoleil <francois.beausoleil@gmail.com>*

*   Fix syntax error in documentation. Closes #4679. *Mislav Marohnić*

*   Add Oracle support for CLOB inserts. Closes #4748. *schoenm@earthlink.net sandra.metz@duke.edu*

*   Various fixes for sqlserver_adapter (odbc statement finishing, ado schema dumper, drop index). Closes #4831. *kajism@yahoo.com*

*   Add support for :order option to with_scope. Closes #3887. *eric.daspet@survol.net*

*   Prettify output of schema_dumper by making things line up. Closes #4241 *Caio  Chassot <caio@v2studio.com>*

*   Make build_postgresql_databases task make databases owned by the postgres user. Closes #4790. *mlaster@metavillage.com*

*   Sybase Adapter type conversion cleanup. Closes #4736. *dev@metacasa.net*

*   Fix bug where calculations with long alias names return null. *Rick Olson*

*   Raise error when trying to add to a has_many :through association.  Use the Join Model instead. *Rick Olson*

        @post.tags << @tag                  # BAD
        @post.taggings.create(:tag => @tag) # GOOD

*   Allow all calculations to take the :include option, not just COUNT (closes #4840) *Rick Olson*

*   Update inconsistent migrations documentation. #4683 *machomagna@gmail.com*

*   Add ActiveRecord::Errors#to_xml *Jamis Buck*

*   Properly quote index names in migrations (closes #4764) *John Long*

*   Fix the HasManyAssociation#count method so it uses the new ActiveRecord::Base#count syntax, while maintaining backwards compatibility.  *Rick Olson*

*   Ensure that Associations#include_eager_conditions? checks both scoped and explicit conditions *Rick Olson*

*   Associations#select_limited_ids_list adds the ORDER BY columns to the SELECT DISTINCT List for postgresql. *Rick Olson*

*   DRY up association collection reader method generation. *Marcel Molina Jr.*

*   DRY up and tweak style of the validation error object. *Marcel Molina Jr.*

*   Add :case_sensitive option to validates_uniqueness_of (closes #3090) *Rick Olson*

        class Account < ActiveRecord::Base
          validates_uniqueness_of :email, :case_sensitive => false
        end

*   Allow multiple association extensions with :extend option (closes #4666) *Josh Susser*

        class Account < ActiveRecord::Base
          has_many :people, :extend => [FindOrCreateByNameExtension, FindRecentExtension]
        end

        *1.15.3* (March 12th, 2007)

        * Allow a polymorphic :source for has_many :through associations. Closes #7143 [protocool]

        * Consistently quote primary key column names.  #7763 [toolmantim]

        * Fixtures: fix YAML ordered map support.  #2665 [Manuel Holtgrewe, nfbuckley]

        * Fix has_many :through << with custom foreign keys.  #6466, #7153 [naffis, Rich Collins]


## 1.15.2 (February 5th, 2007) ##

*   Pass a range in :conditions to use the SQL BETWEEN operator.  #6974 *Dan Manges*
        Student.find(:all, :conditions => { :grade => 9..12 })

*   Don't create instance writer methods for class attributes. *Rick Olson*

*   When dealing with SQLite3, use the table_info pragma helper, so that the bindings can do some translation for when sqlite3 breaks incompatibly between point releases. *Jamis Buck*

*   SQLServer: don't choke on strings containing 'null'.  #7083 *Jakob Skjerning*

*   Consistently use LOWER() for uniqueness validations (rather than mixing with UPPER()) so the database can always use a functional index on the lowercased column.  #6495 *Si*

*   MySQL: SET SQL_AUTO_IS_NULL=0 so 'where id is null' doesn't select the last inserted id.  #6778 *Jonathan Viney, timc*

*   Fixtures use the table name and connection from set_fixture_class.  #7330 *Anthony Eden*

*   SQLServer: quote table name in indexes query.  #2928 *keithm@infused.org*


## 1.15.1 (January 17th, 2007) ##

*   Fix nodoc breaking of adapters


## 1.15.0 (January 16th, 2007) ##

*   [DOC] clear up some ambiguity with the way has_and_belongs_to_many creates the default join table name.  #7072 *Jeremy McAnally*

*   change_column accepts :default => nil. Skip column options for primary keys.  #6956, #7048 *Dan Manges, Jeremy Kemper*

*   MySQL, PostgreSQL: change_column_default quotes the default value and doesn't lose column type information.  #3987, #6664 *Jonathan Viney, Manfred Stienstra, altano@bigfoot.com*

*   Oracle: create_table takes a :sequence_name option to override the 'tablename_seq' default.  #7000 *Michael Schoen*

*   MySQL: retain SSL settings on reconnect.  #6976 *randyv2*

*   SQLServer: handle [quoted] table names.  #6635 *rrich*

*   acts_as_nested_set works with single-table inheritance.  #6030 *Josh Susser*

*   PostgreSQL, Oracle: correctly perform eager finds with :limit and :order.  #4668, #7021 *eventualbuddha, Michael Schoen*

*   Fix the Oracle adapter for serialized attributes stored in CLOBs.  Closes #6825 *mschoen, tdfowler*

*   [DOCS] Apply more documentation for ActiveRecord Reflection.  Closes #4055 *Robby Russell*

*   [DOCS] Document :allow_nil option of #validate_uniqueness_of. Closes #3143 *Caio Chassot*

*   Bring the sybase adapter up to scratch for 1.2 release. *jsheets*

*   Oracle: fix connection reset failure.  #6846 *leonlleslie*

*   Subclass instantiation doesn't try to explicitly require the corresponding subclass.  #6840 *leei, Jeremy Kemper*

*   fix faulty inheritance tests and that eager loading grabs the wrong inheritance column when the class of your association is an STI subclass. Closes #6859 *protocool*

*   find supports :lock with :include. Check whether your database allows SELECT ... FOR UPDATE with outer joins before using.  #6764 *vitaly, Jeremy Kemper*

*   Support nil and Array in :conditions => { attr => value } hashes.  #6548 *Assaf, Jeremy Kemper*
        find(:all, :conditions => { :topic_id => [1, 2, 3], :last_read => nil }

*   Quote ActiveSupport::Multibyte::Chars.  #6653 *Julian Tarkhanov*

*   MySQL: detect when a NOT NULL column without a default value is misreported as default ''.  Can't detect for string, text, and binary columns since '' is a legitimate default.  #6156 *simon@redhillconsulting.com.au, obrie, Jonathan Viney, Jeremy Kemper*

*   validates_numericality_of uses \A \Z to ensure the entire string matches rather than ^ $ which may match one valid line of a multiline string.  #5716 *Andreas Schwarz*

*   Oracle: automatically detect the primary key.  #6594 *vesaria, Michael Schoen*

*   Oracle: to increase performance, prefetch 100 rows and enable similar cursor sharing. Both are configurable in database.yml.  #6607 *philbogle@gmail.com, ray.fortna@jobster.com, Michael Schoen*

*   Firebird: decimal/numeric support.  #6408 *macrnic*

*   Find with :include respects scoped :order.  #5850

*   Dynamically generate reader methods for serialized attributes.  #6362 *Stefan Kaes*

*   Deprecation: object transactions warning.  *Jeremy Kemper*

*   has_one :dependent => :nullify ignores nil associates.  #6528 *janovetz, Jeremy Kemper*

*   Oracle: resolve test failures, use prefetched primary key for inserts, check for null defaults, fix limited id selection for eager loading. Factor out some common methods from all adapters.  #6515 *Michael Schoen*

*   Make add_column use the options hash with the Sqlite Adapter. Closes #6464 *obrie*

*   Document other options available to migration's add_column. #6419 *grg*

*   MySQL: all_hashes compatibility with old MysqlRes class.  #6429, #6601 *Jeremy Kemper*

*   Fix has_many :through to add the appropriate conditions when going through an association using STI. Closes #5783. *Jonathan Viney*

*   fix select_limited_ids_list issues in postgresql, retain current behavior in other adapters *Rick Olson*

*   Restore eager condition interpolation, document it's differences *Rick Olson*

*   Don't rollback in teardown unless a transaction was started. Don't start a transaction in create_fixtures if a transaction is started.  #6282 *Jacob Fugal, Jeremy Kemper*

*   Add #delete support to has_many :through associations.  Closes #6049 *Martin Landers*

*   Reverted old select_limited_ids_list postgresql fix that caused issues in mysql.  Closes #5851 *Rick Olson*

*   Removes the ability for eager loaded conditions to be interpolated, since there is no model instance to use as a context for interpolation. #5553 *turnip@turnipspatch.com*

*   Added timeout option to SQLite3 configurations to deal more gracefully with SQLite3::BusyException, now the connection can instead retry for x seconds to see if the db clears up before throwing that exception #6126 *wreese@gmail.com*

*   Added update_attributes! which uses save! to raise an exception if a validation error prevents saving #6192 *jonathan*

*   Deprecated add_on_boundary_breaking (use validates_length_of instead) #6292 *Bob Silva*

*   The has_many create method works with polymorphic associations.  #6361 *Dan Peterson*

*   MySQL: introduce Mysql::Result#all_hashes to support further optimization.  #5581 *Stefan Kaes*

*   save! shouldn't validate twice.  #6324 *maiha, Bob Silva*

*   Association collections have an _ids reader method to match the existing writer for collection_select convenience (e.g. employee.task_ids). The writer method skips blank ids so you can safely do @employee.task_ids = params[:tasks] without checking every time for an empty list or blank values.  #1887, #5780 *Michael Schuerig*

*   Add an attribute reader method for ActiveRecord::Base.observers *Rick Olson*

*   Deprecation: count class method should be called with an options hash rather than two args for conditions and joins.  #6287 *Bob Silva*

*   has_one associations with a nil target may be safely marshaled.  #6279 *norbauer, Jeremy Kemper*

*   Duplicate the hash provided to AR::Base#to_xml to prevent unexpected side effects *Michael Koziarski*

*   Add a :namespace option to  AR::Base#to_xml *Michael Koziarski*

*   Deprecation tests. Remove warnings for dynamic finders and for the foo_count method if it's also an attribute. *Jeremy Kemper*

*   Mock Time.now for more accurate Touch mixin tests.  #6213 *Dan Peterson*

*   Improve yaml fixtures error reporting.  #6205 *Bruce Williams*

*   Rename AR::Base#quote so people can use that name in their models. #3628 *Michael Koziarski*

*   Add deprecation warning for inferred foreign key. #6029 *Josh Susser*

*   Fixed the Ruby/MySQL adapter we ship with Active Record to work with the new authentication handshake that was introduced in MySQL 4.1, along with the other protocol changes made at that time #5723 *jimw@mysql.com*

*   Deprecation: use :dependent => :delete_all rather than :exclusively_dependent => true.  #6024 *Josh Susser*

*   Optimistic locking: gracefully handle nil versions, treat as zero.  #5908 *Tom Ward*

*   to_xml: the :methods option works on arrays of records.  #5845 *Josh Starcher*

*   has_many :through conditions are sanitized by the associating class.  #5971 *martin.emde@gmail.com*

*   Fix spurious newlines and spaces in AR::Base#to_xml output *Jamis Buck*

*   has_one supports the :dependent => :delete option which skips the typical callback chain and deletes the associated object directly from the database.  #5927 *Chris Mear, Jonathan Viney*

*   Nested subclasses are not prefixed with the parent class' table_name since they should always use the base class' table_name.  #5911 *Jonathan Viney*

*   SQLServer: work around bug where some unambiguous date formats are not correctly identified if the session language is set to german.  #5894 *Tom Ward, kruth@bfpi*

*   Clashing type columns due to a sloppy join shouldn't wreck single-table inheritance.  #5838 *Kevin Clark*

*   Fixtures: correct escaping of \n and \r.  #5859 *evgeny.zislis@gmail.com*

*   Migrations: gracefully handle missing migration files.  #5857 *eli.gordon@gmail.com*

*   MySQL: update test schema for MySQL 5 strict mode.  #5861 *Tom Ward*

*   to_xml: correct naming of included associations.  #5831 *Josh Starcher*

*   Pushing a record onto a has_many :through sets the association's foreign key to the associate's primary key and adds it to the correct association.  #5815, #5829 *Josh Susser*

*   Add records to has_many :through using <<, push, and concat by creating the association record. Raise if base or associate are new records since both ids are required to create the association. #build raises since you can't associate an unsaved record. #create! takes an attributes hash and creates the associated record and its association in a transaction. *Jeremy Kemper*

        # Create a tagging to associate the post and tag.
        post.tags << Tag.find_by_name('old')
        post.tags.create! :name => 'general'

        # Would have been:
        post.taggings.create!(:tag => Tag.find_by_name('finally')
        transaction do
          post.taggings.create!(:tag => Tag.create!(:name => 'general'))
        end

*   Cache nil results for :included has_one associations also.  #5787 *Michael Schoen*

*   Fixed a bug which would cause .save to fail after trying to access a empty has_one association on a unsaved record. *Tobias Lütke*

*   Nested classes are given table names prefixed by the singular form of the parent's table name. *Jeremy Kemper*
        Example: Invoice::Lineitem is given table name invoice_lineitems

*   Migrations: uniquely name multicolumn indexes so you don't have to. *Jeremy Kemper*
        # people_active_last_name_index, people_active_deactivated_at_index
        add_index    :people, [:active, :last_name]
        add_index    :people, [:active, :deactivated_at]
        remove_index :people, [:active, :last_name]
        remove_index :people, [:active, :deactivated_at]

    WARNING: backward-incompatibility. Multicolumn indexes created before this
    revision were named using the first column name only. Now they're uniquely
    named using all indexed columns.

    To remove an old multicolumn index, remove_index :table_name, :first_column

*   Fix for deep includes on the same association. *richcollins@gmail.com*

*   Tweak fixtures so they don't try to use a non-ActiveRecord class.  *Kevin Clark*

*   Remove ActiveRecord::Base.reset since Dispatcher doesn't use it anymore.  *Rick Olson*

*   PostgreSQL: autodetected sequences work correctly with multiple schemas. Rely on the schema search_path instead of explicitly qualifying the sequence name with its schema.  #5280 *guy.naor@famundo.com*

*   Replace Reloadable with Reloadable::Deprecated. *Nicholas Seckar*

*   Cache nil results for has_one associations so multiple calls don't call the database.  Closes #5757. *Michael Schoen*

*   Don't save has_one associations unnecessarily.  #5735 *Jonathan Viney*

*   Refactor ActiveRecord::Base.reset_subclasses to #reset, and add global observer resetting.  *Rick Olson*

*   Formally deprecate the deprecated finders. *Michael Koziarski*

*   Formally deprecate rich associations.  *Michael Koziarski*

*   Fixed that default timezones for new / initialize should uphold utc setting #5709 *daniluk@yahoo.com*

*   Fix announcement of very long migration names.  #5722 *blake@near-time.com*

*   The exists? class method should treat a string argument as an id rather than as conditions.  #5698 *jeremy@planetargon.com*

*   Fixed to_xml with :include misbehaviors when invoked on array of model instances #5690 *alexkwolfe@gmail.com*

*   Added support for conditions on Base.exists? #5689 [Josh Peek]. Examples:

        assert (Topic.exists?(:author_name => "David"))
         assert (Topic.exists?(:author_name => "Mary", :approved => true))
         assert (Topic.exists?(["parent_id = ?", 1]))

*   Schema dumper quotes date :default values. *Dave Thomas*

*   Calculate sum with SQL, not Enumerable on HasManyThrough Associations. *Dan Peterson*

*   Factor the attribute#{suffix} methods out of method_missing for easier extension. *Jeremy Kemper*

*   Patch sql injection vulnerability when using integer or float columns. *Jamis Buck*

*   Allow #count through a has_many association to accept :include.  *Dan Peterson*

*   create_table rdoc: suggest :id => false for habtm join tables. *Zed Shaw*

*   PostgreSQL: return array fields as strings. #4664 *Robby Russell*

*   SQLServer: added tests to ensure all database statements are closed, refactored identity_insert management code to use blocks, removed update/delete rowcount code out of execute and into update/delete, changed insert to go through execute method, removed unused quoting methods, disabled pessimistic locking tests as feature is currently unsupported, fixed RakeFile to load sqlserver specific tests whether running in ado or odbc mode, fixed support for recently added decimal types, added support for limits on integer types. #5670 *Tom Ward*

*   SQLServer: fix db:schema:dump case-sensitivity. #4684 *Will Rogers*

*   Oracle: BigDecimal support. #5667 *Michael Schoen*

*   Numeric and decimal columns map to BigDecimal instead of Float. Those with scale 0 map to Integer. #5454 *robbat2@gentoo.org, work@ashleymoran.me.uk*

*   Firebird migrations support. #5337 *Ken Kunz <kennethkunz@gmail.com>*

*   PostgreSQL: create/drop as postgres user. #4790 *mail@matthewpainter.co.uk, mlaster@metavillage.com*

*   PostgreSQL: correctly quote the ' in pk_and_sequence_for. #5462 *tietew@tietew.net*

*   PostgreSQL: correctly quote microseconds in timestamps. #5641 *rick@rickbradley.com*

*   Clearer has_one/belongs_to model names (account has_one :user). #5632 *matt@mattmargolis.net*

*   Oracle: use nonblocking queries if allow_concurrency is set, fix pessimistic locking, don't guess date vs. time by default (set OracleAdapter.emulate_dates = true for the old behavior), adapter cleanup. #5635 *Michael Schoen*

*   Fixed a few Oracle issues: Allows Oracle's odd date handling to still work consistently within #to_xml, Passes test that hardcode insert statement by dropping the :id column, Updated RUNNING_UNIT_TESTS with Oracle instructions, Corrects method signature for #exec #5294 *Michael Schoen*

*   Added :group to available options for finds done on associations #5516 *mike@michaeldewey.org*

*   Observers also watch subclasses created after they are declared. #5535 *daniels@pronto.com.au*

*   Removed deprecated timestamps_gmt class methods. *Jeremy Kemper*

*   rake build_mysql_database grants permissions to rails@localhost. #5501 *brianegge@yahoo.com*

*   PostgreSQL: support microsecond time resolution. #5492 *alex@msgpad.com*

*   Add AssociationCollection#sum since the method_missing invokation has been shadowed by Enumerable#sum.

*   Added find_or_initialize_by_X which works like find_or_create_by_X but doesn't save the newly instantiated record. *Sam Stephenson*

*   Row locking. Provide a locking clause with the :lock finder option or true for the default "FOR UPDATE". Use the #lock! method to obtain a row lock on a single record (reloads the record with :lock => true). *Shugo Maeda*
        # Obtain an exclusive lock on person 1 so we can safely increment visits.
        Person.transaction do
          # select * from people where id=1 for update
          person = Person.find(1, :lock => true)
          person.visits += 1
          person.save!
        end

*   PostgreSQL: introduce allow_concurrency option which determines whether to use blocking or asynchronous #execute. Adapters with blocking #execute will deadlock Ruby threads. The default value is ActiveRecord::Base.allow_concurrency. *Jeremy Kemper*

*   Use a per-thread (rather than global) transaction mutex so you may execute concurrent transactions on separate connections. *Jeremy Kemper*

*   Change AR::Base#to_param to return a String instead of a Fixnum. Closes #5320. *Nicholas Seckar*

*   Use explicit delegation instead of method aliasing for AR::Base.to_param -> AR::Base.id. #5299 (skaes@web.de)

*   Refactored ActiveRecord::Base.to_xml to become a delegate for XmlSerializer, which restores sanity to the mega method. This refactoring also reinstates the opinions that type="string" is redundant and ugly and nil-differentiation is not a concern of serialization *David Heinemeier Hansson*

*   Added simple hash conditions to find that'll just convert hash to an AND-based condition string #5143 [Hampton Catlin]. Example:

        Person.find(:all, :conditions => { :last_name => "Catlin", :status => 1 }, :limit => 2)

    ...is the same as:

        Person.find(:all, :conditions => [ "last_name = ? and status = ?", "Catlin", 1 ], :limit => 2)

    This makes it easier to pass in the options from a form or otherwise outside.


*   Fixed issues with BLOB limits, charsets, and booleans for Firebird #5194, #5191, #5189 *kennethkunz@gmail.com*

*   Fixed usage of :limit and with_scope when the association in scope is a 1:m #5208 *alex@purefiction.net*

*   Fixed migration trouble with SQLite when NOT NULL is used in the new definition #5215 *greg@lapcominc.com*

*   Fixed problems with eager loading and counting on SQL Server #5212 *kajism@yahoo.com*

*   Fixed that count distinct should use the selected column even when using :include #5251 *anna@wota.jp*

*   Fixed that :includes merged from with_scope won't cause the same association to be loaded more than once if repetition occurs in the clauses #5253 *alex@purefiction.net*

*   Allow models to override to_xml.  #4989 *Blair Zajac <blair@orcaware.com>*

*   PostgreSQL: don't ignore port when host is nil since it's often used to label the domain socket.  #5247 *shimbo@is.naist.jp*

*   Records and arrays of records are bound as quoted ids. *Jeremy Kemper*
        Foo.find(:all, :conditions => ['bar_id IN (?)', bars])
        Foo.find(:first, :conditions => ['bar_id = ?', bar])

*   Fixed that Base.find :all, :conditions => [ "id IN (?)", collection ] would fail if collection was empty *David Heinemeier Hansson*

*   Add a list of regexes assert_queries skips in the ActiveRecord test suite.  *Rick Olson*

*   Fix the has_and_belongs_to_many #create doesn't populate the join for new records.  Closes #3692 *Josh Susser*

*   Provide Association Extensions access to the instance that the association is being accessed from.
    Closes #4433 *Josh Susser*

*   Update OpenBase adaterp's maintainer's email address. Closes #5176. *Derrick Spell*

*   Add a quick note about :select and eagerly included associations. *Rick Olson*

*   Add docs for the :as option in has_one associations.  Closes #5144 *cdcarter@gmail.com*

*   Fixed that has_many collections shouldn't load the entire association to do build or create *David Heinemeier Hansson*

*   Added :allow_nil option for aggregations #5091 *Ian White*

*   Fix Oracle boolean support and tests. Closes #5139. *Michael Schoen*

*   create! no longer blows up when no attributes are passed and a :create scope is in effect (e.g. foo.bars.create! failed whereas foo.bars.create!({}) didn't.) *Jeremy Kemper*

*   Call Inflector#demodulize on the class name when eagerly including an STI model.  Closes #5077 *info@loobmedia.com*

*   Preserve MySQL boolean column defaults when changing a column in a migration. Closes #5015. *pdcawley@bofh.org.uk*

*   PostgreSQL: migrations support :limit with :integer columns by mapping limit < 4 to smallint, > 4 to bigint, and anything else to integer. #2900 *keegan@thebasement.org*

*   Dates and times interpret empty strings as nil rather than 2000-01-01. #4830 *kajism@yahoo.com*

*   Allow :uniq => true with has_many :through associations. *Jeremy Kemper*

*   Ensure that StringIO is always available for the Schema dumper. *Marcel Molina Jr.*

*   Allow AR::Base#to_xml to include methods too. Closes #4921. *johan@textdrive.com*

*   Remove duplicate fixture entry in comments.yml. Closes #4923. *Blair Zajac <blair@orcaware.com>*

*   When grouping, use the appropriate option key. *Marcel Molina Jr.*

*   Add support for FrontBase (http://www.frontbase.com/) with a new adapter thanks to the hard work of one Mike Laster. Closes #4093. *mlaster@metavillage.com*

*   Add warning about the proper way to validate the presence of a foreign key. Closes #4147. *Francois Beausoleil <francois.beausoleil@gmail.com>*

*   Fix syntax error in documentation. Closes #4679. *Mislav Marohnić*

*   Add Oracle support for CLOB inserts. Closes #4748. *schoenm@earthlink.net sandra.metz@duke.edu*

*   Various fixes for sqlserver_adapter (odbc statement finishing, ado schema dumper, drop index). Closes #4831. *kajism@yahoo.com*

*   Add support for :order option to with_scope. Closes #3887. *eric.daspet@survol.net*

*   Prettify output of schema_dumper by making things line up. Closes #4241 *Caio  Chassot <caio@v2studio.com>*

*   Make build_postgresql_databases task make databases owned by the postgres user. Closes #4790. *mlaster@metavillage.com*

*   Sybase Adapter type conversion cleanup. Closes #4736. *dev@metacasa.net*

*   Fix bug where calculations with long alias names return null. *Rick Olson*

*   Raise error when trying to add to a has_many :through association.  Use the Join Model instead. *Rick Olson*

        @post.tags << @tag                  # BAD
        @post.taggings.create(:tag => @tag) # GOOD

*   Allow all calculations to take the :include option, not just COUNT (closes #4840) *Rick Olson*

*   Add ActiveRecord::Errors#to_xml *Jamis Buck*

*   Properly quote index names in migrations (closes #4764) *John Long*

*   Fix the HasManyAssociation#count method so it uses the new ActiveRecord::Base#count syntax, while maintaining backwards compatibility.  *Rick Olson*

*   Ensure that Associations#include_eager_conditions? checks both scoped and explicit conditions *Rick Olson*

*   Associations#select_limited_ids_list adds the ORDER BY columns to the SELECT DISTINCT List for postgresql. *Rick Olson*

*   Add :case_sensitive option to validates_uniqueness_of (closes #3090) *Rick Olson*

        class Account < ActiveRecord::Base
          validates_uniqueness_of :email, :case_sensitive => false
        end

*   Allow multiple association extensions with :extend option (closes #4666) *Josh Susser*

        class Account < ActiveRecord::Base
          has_many :people, :extend => [FindOrCreateByNameExtension, FindRecentExtension]
        end


## 1.14.4 (August 8th, 2006) ##

*   Add warning about the proper way to validate the presence of a foreign key.  #4147 *Francois Beausoleil <francois.beausoleil@gmail.com>*

*   Fix syntax error in documentation. #4679 *Mislav Marohnić*

*   Update inconsistent migrations documentation. #4683 *machomagna@gmail.com*


## 1.14.3 (June 27th, 2006) ##

*   Fix announcement of very long migration names.  #5722 *blake@near-time.com*

*   Update callbacks documentation. #3970 *Robby Russell <robby@planetargon.com>*

*   Properly quote index names in migrations (closes #4764) *John Long*

*   Ensure that Associations#include_eager_conditions? checks both scoped and explicit conditions *Rick Olson*

*   Associations#select_limited_ids_list adds the ORDER BY columns to the SELECT DISTINCT List for postgresql. *Rick Olson*


## 1.14.2 (April 9th, 2006) ##

*   Fixed calculations for the Oracle Adapter (closes #4626) *Michael Schoen*


## 1.14.1 (April 6th, 2006) ##

*   Fix type_name_with_module to handle type names that begin with '::'. Closes #4614. *Nicholas Seckar*

*   Fixed that that multiparameter assignment doesn't work with aggregations (closes #4620) *Lars Pind*

*   Enable Limit/Offset in Calculations (closes #4558) *lmarlow*

*   Fixed that loading including associations returns all results if Load IDs For Limited Eager Loading returns none (closes #4528) *Rick Olson*

*   Fixed HasManyAssociation#find bugs when :finder_sql is set #4600 *lagroue@free.fr*

*   Allow AR::Base#respond_to? to behave when @attributes is nil *Ryan Davis*

*   Support eager includes when going through a polymorphic has_many association. *Rick Olson*

*   Added support for eagerly including polymorphic has_one associations. (closes #4525) *Rick Olson*

        class Post < ActiveRecord::Base
          has_one :tagging, :as => :taggable
        end

        Post.find :all, :include => :tagging

*   Added descriptive error messages for invalid has_many :through associations: going through :has_one or :has_and_belongs_to_many *Rick Olson*

*   Added support for going through a polymorphic has_many association: (closes #4401) *Rick Olson*

        class PhotoCollection < ActiveRecord::Base
          has_many :photos, :as => :photographic
          belongs_to :firm
        end

        class Firm < ActiveRecord::Base
          has_many :photo_collections
          has_many :photos, :through => :photo_collections
        end

*   Multiple fixes and optimizations in PostgreSQL adapter, allowing ruby-postgres gem to work properly. *ruben.nine@gmail.com*

*   Fixed that AssociationCollection#delete_all should work even if the records of the association are not loaded yet. *Florian Weber*

*   Changed those private ActiveRecord methods to take optional third argument :auto instead of nil for performance optimizations.  (closes #4456) *Stefan*

*   Private ActiveRecord methods add_limit!, add_joins!, and add_conditions! take an OPTIONAL third argument 'scope' (closes #4456) *Rick Olson*

*   DEPRECATED: Using additional attributes on has_and_belongs_to_many associations. Instead upgrade your association to be a real join model *David Heinemeier Hansson*

*   Fixed that records returned from has_and_belongs_to_many associations with additional attributes should be marked as read only (fixes #4512) *David Heinemeier Hansson*

*   Do not implicitly mark recordss of has_many :through as readonly but do mark habtm records as readonly (eventually only on join tables without rich attributes). *Marcel Mollina Jr.*

*   Fixed broken OCIAdapter #4457 *Michael Schoen*


## 1.14.0 (March 27th, 2006) ##

*   Replace 'rescue Object' with a finer grained rescue. Closes #4431. *Nicholas Seckar*

*   Fixed eager loading so that an aliased table cannot clash with a has_and_belongs_to_many join table *Rick Olson*

*   Add support for :include to with_scope *andrew@redlinesoftware.com*

*   Support the use of public synonyms with the Oracle adapter; required ruby-oci8 v0.1.14 #4390 *Michael Schoen*

*   Change periods (.) in table aliases to _'s.  Closes #4251 *jeff@ministrycentered.com*

*   Changed has_and_belongs_to_many join to INNER JOIN for Mysql 3.23.x.  Closes #4348 *Rick Olson*

*   Fixed issue that kept :select options from being scoped *Rick Olson*

*   Fixed db_schema_import when binary types are present #3101 *David Heinemeier Hansson*

*   Fixed that MySQL enums should always be returned as strings #3501 *David Heinemeier Hansson*

*   Change has_many :through to use the :source option to specify the source association.  :class_name is now ignored. *Rick Olson*

        class Connection < ActiveRecord::Base
          belongs_to :user
          belongs_to :channel
        end

        class Channel < ActiveRecord::Base
          has_many :connections
          has_many :contacts, :through => :connections, :class_name => 'User' # OLD
          has_many :contacts, :through => :connections, :source => :user      # NEW
        end

*   Fixed DB2 adapter so nullable columns will be determines correctly now and quotes from column default values will be removed #4350 *contact@maik-schmidt.de*

*   Allow overriding of find parameters in scoped has_many :through calls *Rick Olson*

    In this example, :include => false disables the default eager association from loading.  :select changes the standard
    select clause.  :joins specifies a join that is added to the end of the has_many :through query.

        class Post < ActiveRecord::Base
          has_many :tags, :through => :taggings, :include => :tagging do
            def add_joins_and_select
              find :all, :select => 'tags.*, authors.id as author_id', :include => false,
                :joins => 'left outer join posts on taggings.taggable_id = posts.id left outer join authors on posts.author_id = authors.id'
            end
          end
        end

*   Fixed that schema changes while the database was open would break any connections to an SQLite database (now we reconnect if that error is throw) *David Heinemeier Hansson*

*   Don't classify the has_one class when eager loading, it is already singular. Add tests. (closes #4117) *Jonathan Viney*

*   Quit ignoring default :include options in has_many :through calls *Mark James*

*   Allow has_many :through associations to find the source association by setting a custom class (closes #4307) *Jonathan Viney*

*   Eager Loading support added for has_many :through => :has_many associations (see below).  *Rick Olson*

*   Allow has_many :through to work on has_many associations (closes #3864) [sco@scottraymond.net]  Example:

        class Firm < ActiveRecord::Base
          has_many :clients
          has_many :invoices, :through => :clients
        end

        class Client < ActiveRecord::Base
          belongs_to :firm
          has_many   :invoices
        end

        class Invoice < ActiveRecord::Base
          belongs_to :client
        end

*   Raise error when trying to select many polymorphic objects with has_many :through or :include (closes #4226) *Josh Susser*

*   Fixed has_many :through to include :conditions set on the :through association. closes #4020 *Jonathan Viney*

*   Fix that has_many :through honors the foreign key set by the belongs_to association in the join model (closes #4259) *andylien@gmail.com / Rick Olson*

*   SQL Server adapter gets some love #4298 *Ryan Tomayko*

*   Added OpenBase database adapter that builds on top of the http://www.spice-of-life.net/ruby-openbase/ driver. All functionality except LIMIT/OFFSET is supported #3528 *derrickspell@cdmplus.com*

*   Rework table aliasing to account for truncated table aliases.  Add smarter table aliasing when doing eager loading of STI associations. This allows you to use the association name in the order/where clause. [Jonathan Viney / Rick Olson] #4108 Example (SpecialComment is using STI):

        Author.find(:all, :include => { :posts => :special_comments }, :order => 'special_comments.body')

*   Add AbstractAdapter#table_alias_for to create table aliases according to the rules of the current adapter. *Rick Olson*

*   Provide access to the underlying database connection through Adapter#raw_connection. Enables the use of db-specific methods without complicating the adapters. #2090 *Michael Koziarski*

*   Remove broken attempts at handling columns with a default of 'now()' in the postgresql adapter. #2257 *Michael Koziarski*

*   Added connection#current_database that'll return of the current database (only works in MySQL, SQL Server, and Oracle so far -- please help implement for the rest of the adapters) #3663 *Tom Ward*

*   Fixed that Migration#execute would have the table name prefix appended to its query #4110 *mark.imbriaco@pobox.com*

*   Make all tinyint(1) variants act like boolean in mysql (tinyint(1) unsigned, etc.) *Jamis Buck*

*   Use association's :conditions when eager loading. [Jeremy Evans] #4144

*   Alias the has_and_belongs_to_many join table on eager includes. #4106 *Jeremy Evans*

    This statement would normally error because the projects_developers table is joined twice, and therefore joined_on would be ambiguous.

        Developer.find(:all, :include => {:projects => :developers}, :conditions => 'join_project_developers.joined_on IS NOT NULL')

*   Oracle adapter gets some love #4230 *Michael Schoen*

        * Changes :text to CLOB rather than BLOB [Moses Hohman]
        * Fixes an issue with nil numeric length/scales (several)
        * Implements support for XMLTYPE columns [wilig / Kubo Takehiro]
        * Tweaks a unit test to get it all green again
        * Adds support for #current_database

*   Added Base.abstract_class? that marks which classes are not part of the Active Record hierarchy #3704 *Rick Olson*

        class CachedModel < ActiveRecord::Base
          self.abstract_class = true
        end

        class Post < CachedModel
        end

        CachedModel.abstract_class?
        => true

        Post.abstract_class?
        => false

        Post.base_class
        => Post

        Post.table_name
        => 'posts'

*   Allow :dependent options to be used with polymorphic joins. #3820 *Rick Olson*

        class Foo < ActiveRecord::Base
          has_many :attachments, :as => :attachable, :dependent => :delete_all
        end

*   Nicer error message on has_many :through when :through reflection can not be found. #4042 *court3nay*

*   Upgrade to Transaction::Simple 1.3 *Jamis Buck*

*   Catch FixtureClassNotFound when using instantiated fixtures on a fixture that has no ActiveRecord model *Rick Olson*

*   Allow ordering of calculated results and/or grouped fields in calculations *solo@gatelys.com*

*   Make ActiveRecord::Base#save! return true instead of nil on success.  #4173 *johan@johansorensen.com*

*   Dynamically set allow_concurrency.  #4044 *Stefan Kaes*

*   Added Base#to_xml that'll turn the current record into a XML representation [David Heinemeier Hansson]. Example:

        topic.to_xml

    ...returns:

        <?xml version="1.0" encoding="UTF-8"?>
        <topic>
          <title>The First Topic</title>
          <author-name>David</author-name>
          <id type="integer">1</id>
          <approved type="boolean">false</approved>
          <replies-count type="integer">0</replies-count>
          <bonus-time type="datetime">2000-01-01 08:28:00</bonus-time>
          <written-on type="datetime">2003-07-16 09:28:00</written-on>
          <content>Have a nice day</content>
          <author-email-address>david@loudthinking.com</author-email-address>
          <parent-id></parent-id>
          <last-read type="date">2004-04-15</last-read>
        </topic>

    ...and you can configure with:

        topic.to_xml(:skip_instruct => true, :except => [ :id, bonus_time, :written_on, replies_count ])

    ...that'll return:

        <topic>
          <title>The First Topic</title>
          <author-name>David</author-name>
          <approved type="boolean">false</approved>
          <content>Have a nice day</content>
          <author-email-address>david@loudthinking.com</author-email-address>
          <parent-id></parent-id>
          <last-read type="date">2004-04-15</last-read>
        </topic>

    You can even do load first-level associations as part of the document:

        firm.to_xml :include => [ :account, :clients ]

    ...that'll return something like:

        <?xml version="1.0" encoding="UTF-8"?>
        <firm>
          <id type="integer">1</id>
          <rating type="integer">1</rating>
          <name>37signals</name>
          <clients>
            <client>
              <rating type="integer">1</rating>
              <name>Summit</name>
            </client>
            <client>
              <rating type="integer">1</rating>
              <name>Microsoft</name>
            </client>
          </clients>
          <account>
            <id type="integer">1</id>
            <credit-limit type="integer">50</credit-limit>
          </account>
        </firm>

*   Allow :counter_cache to take a column name for custom counter cache columns *Jamis Buck*

*   Documentation fixes for :dependent *robby@planetargon.com*

*   Stop the MySQL adapter crashing when views are present. #3782 *Jonathan Viney*

*   Don't classify the belongs_to class, it is already singular #4117 *keithm@infused.org*

*   Allow set_fixture_class to take Classes instead of strings for a class in a module.  Raise FixtureClassNotFound if a fixture can't load.  *Rick Olson*

*   Fix quoting of inheritance column for STI eager loading #4098 *Jonathan Viney <jonathan@bluewire.net.nz>*

*   Added smarter table aliasing for eager associations for multiple self joins #3580 *Rick Olson*

        * The first time a table is referenced in a join, no alias is used.
        * After that, the parent class name and the reflection name are used.

            Tree.find(:all, :include => :children) # LEFT OUTER JOIN trees AS tree_children ...

        * Any additional join references get a numerical suffix like '_2', '_3', etc.

*   Fixed eager loading problems with single-table inheritance #3580 [Rick Olson]. Post.find(:all, :include => :special_comments) now returns all posts, and any special comments that the posts may have. And made STI work with has_many :through and polymorphic belongs_to.

*   Added cascading eager loading that allows for queries like Author.find(:all, :include=> { :posts=> :comments }), which will fetch all authors, their posts, and the comments belonging to those posts in a single query (using LEFT OUTER JOIN) #3913 [anna@wota.jp]. Examples:

        # cascaded in two levels
        >> Author.find(:all, :include=>{:posts=>:comments})
        => authors
             +- posts
                  +- comments

        # cascaded in two levels and normal association
        >> Author.find(:all, :include=>[{:posts=>:comments}, :categorizations])
        => authors
             +- posts
                  +- comments
             +- categorizations

        # cascaded in two levels with two has_many associations
        >> Author.find(:all, :include=>{:posts=>[:comments, :categorizations]})
        => authors
             +- posts
                  +- comments
                  +- categorizations

        # cascaded in three levels
        >> Company.find(:all, :include=>{:groups=>{:members=>{:favorites}}})
        => companies
             +- groups
                  +- members
                       +- favorites

*   Make counter cache work when replacing an association #3245 *eugenol@gmail.com*

*   Make migrations verbose *Jamis Buck*

*   Make counter_cache work with polymorphic belongs_to *Jamis Buck*

*   Fixed that calling HasOneProxy#build_model repeatedly would cause saving to happen #4058 *anna@wota.jp*

*   Added Sybase database adapter that relies on the Sybase Open Client bindings (see http://raa.ruby-lang.org/project/sybase-ctlib) #3765 [John Sheets]. It's almost completely Active Record compliant (including migrations), but has the following caveats:

        * Does not support DATE SQL column types; use DATETIME instead.
        * Date columns on HABTM join tables are returned as String, not Time.
        * Insertions are potentially broken for :polymorphic join tables
        * BLOB column access not yet fully supported

*   Clear stale, cached connections left behind by defunct threads. *Jeremy Kemper*

*   CHANGED DEFAULT: set ActiveRecord::Base.allow_concurrency to false.  Most AR usage is in single-threaded applications. *Jeremy Kemper*

*   Renamed the "oci" adapter to "oracle", but kept the old name as an alias #4017 *Michael Schoen*

*   Fixed that Base.save should always return false if the save didn't succeed, including if it has halted by before_save's #1861, #2477 *David Heinemeier Hansson*

*   Speed up class -> connection caching and stale connection verification.  #3979 *Stefan Kaes*

*   Add set_fixture_class to allow the use of table name accessors with models which use set_table_name. *Kevin Clark*

*   Added that fixtures to placed in subdirectories of the main fixture files are also loaded #3937 *dblack@wobblini.net*

*   Define attribute query methods to avoid method_missing calls. #3677 *Jonathan Viney*

*   ActiveRecord::Base.remove_connection explicitly closes database connections and doesn't corrupt the connection cache. Introducing the disconnect! instance method for the PostgreSQL, MySQL, and SQL Server adapters; implementations for the others are welcome.  #3591 *Simon Stapleton, Tom Ward*

*   Added support for nested scopes #3407 [anna@wota.jp]. Examples:

        Developer.with_scope(:find => { :conditions => "salary > 10000", :limit => 10 }) do
          Developer.find(:all)     # => SELECT * FROM developers WHERE (salary > 10000) LIMIT 10

          # inner rule is used. (all previous parameters are ignored)
          Developer.with_exclusive_scope(:find => { :conditions => "name = 'Jamis'" }) do
            Developer.find(:all)   # => SELECT * FROM developers WHERE (name = 'Jamis')
          end

          # parameters are merged
          Developer.with_scope(:find => { :conditions => "name = 'Jamis'" }) do
            Developer.find(:all)   # => SELECT * FROM developers WHERE (( salary > 10000 ) AND ( name = 'Jamis' )) LIMIT 10
          end
        end

*   Fixed db2 connection with empty user_name and auth options #3622 *phurley@gmail.com*

*   Fixed validates_length_of to work on UTF-8 strings by using characters instead of bytes #3699 *Masao Mutoh*

*   Fixed that reflections would bleed across class boundaries in single-table inheritance setups #3796 *Lars Pind*

*   Added calculations: Base.count, Base.average, Base.sum, Base.minimum, Base.maxmium, and the generic Base.calculate. All can be used with :group and :having. Calculations and statitics need no longer require custom SQL. #3958 [Rick Olson]. Examples:

        Person.average :age
        Person.minimum :age
        Person.maximum :age
        Person.sum :salary, :group => :last_name

*   Renamed Errors#count to Errors#size but kept an alias for the old name (and included an alias for length too) #3920 *Luke Redpath*

*   Reflections don't attempt to resolve module nesting of association classes. Simplify type computation. *Jeremy Kemper*

*   Improved the Oracle OCI Adapter with better performance for column reflection (from #3210), fixes to migrations (from #3476 and #3742), tweaks to unit tests (from #3610), and improved documentation (from #2446) #3879 *Aggregated by schoenm@earthlink.net*

*   Fixed that the schema_info table used by ActiveRecord::Schema.define should respect table pre- and suffixes #3834 *rubyonrails@atyp.de*

*   Added :select option to Base.count that'll allow you to select something else than * to be counted on. Especially important for count queries using DISTINCT #3839 *Stefan Kaes*

*   Correct syntax error in mysql DDL,  and make AAACreateTablesTest run first *Bob Silva*

*   Allow :include to be used with has_many :through associations #3611 *Michael Schoen*

*   PostgreSQL: smarter schema dumps using pk_and_sequence_for(table).  #2920 *Blair Zajac*

*   SQLServer: more compatible limit/offset emulation.  #3779 *Tom Ward*

*   Polymorphic join support for has_one associations (has_one :foo, :as => :bar)  #3785 *Rick Olson*

*   PostgreSQL: correctly parse negative integer column defaults.  #3776 *bellis@deepthought.org*

*   Fix problems with count when used with :include *Jeremy Hopple and Kevin Clark*

*   ActiveRecord::RecordInvalid now states which validations failed in its default error message *Tobias Lütke*

*   Using AssociationCollection#build with arrays of hashes should call build, not create *David Heinemeier Hansson*

*   Remove definition of reloadable? from ActiveRecord::Base to make way for new Reloadable code. *Nicholas Seckar*

*   Fixed schema handling for DB2 adapter that didn't work: an initial schema could be set, but it wasn't used when getting tables and indexes #3678 *Maik Schmidt*

*   Support the :column option for remove_index with the PostgreSQL adapter. #3661 *Shugo Maeda*

*   Add documentation for add_index and remove_index. #3600 *Manfred Stienstra <m.stienstra@fngtps.com>*

*   If the OCI library is not available, raise an exception indicating as much. #3593 *Michael Schoen*

*   Add explicit :order in finder tests as postgresql orders results differently by default. #3577. *Rick Olson*

*   Make dynamic finders honor additional passed in :conditions. #3569 *Oleg Pudeyev <pudeyo@rpi.edu>, Marcel Molina Jr.*

*   Show a meaningful error when the DB2 adapter cannot be loaded due to missing dependencies. *Nicholas Seckar*

*   Make .count work for has_many associations with multi line finder sql *Michael Schoen*

*   Add AR::Base.base_class for querying the ancestor AR::Base subclass *Jamis Buck*

*   Allow configuration of the column used for optimistic locking *wilsonb@gmail.com*

*   Don't hardcode 'id' in acts as list.  *ror@philippeapril.com*

*   Fix date errors for SQLServer in association tests. #3406 *Kevin Clark*

*   Escape database name in MySQL adapter when creating and dropping databases. #3409 *anna@wota.jp*

*   Disambiguate table names for columns in validates_uniqueness_of's WHERE clause. #3423 *alex.borovsky@gmail.com*

*   .with_scope imposed create parameters now bypass attr_protected *Tobias Lütke*

*   Don't raise an exception when there are more keys than there are named bind variables when sanitizing conditions. *Marcel Molina Jr.*

*   Multiple enhancements and adjustments to DB2 adaptor. #3377 *contact@maik-schmidt.de*

*   Sanitize scoped conditions. *Marcel Molina Jr.*

*   Added option to Base.reflection_of_all_associations to specify a specific association to scope the call. For example Base.reflection_of_all_associations(:has_many) *David Heinemeier Hansson*

*   Added ActiveRecord::SchemaDumper.ignore_tables which tells SchemaDumper which tables to ignore. Useful for tables with funky column like the ones required for tsearch2. *Tobias Lütke*

*   SchemaDumper now doesn't fail anymore when there are unknown column types in the schema. Instead the table is ignored and a Comment is left in the schema.rb. *Tobias Lütke*

*   Fixed that saving a model with multiple habtm associations would only save the first one.  #3244 *yanowitz-rubyonrails@quantumfoam.org, Florian Weber*

*   Fix change_column to work with PostgreSQL 7.x and 8.x.  #3141 *wejn@box.cz, Rick Olson, Scott Barron*

*   removed :piggyback in favor of just allowing :select on :through associations. *Tobias Lütke*

*   made method missing delegation to class methods on relation target work on :through associations. *Tobias Lütke*

*   made .find() work on :through relations. *Tobias Lütke*

*   Fix typo in association docs. #3296. *Blair Zajac*

*   Fixed :through relations when using STI inherited classes would use the inherited class's name as foreign key on the join model *Tobias Lütke*

## 1.13.2 (December 13th, 2005) ##

*   Become part of Rails 1.0

*   MySQL: allow encoding option for mysql.rb driver.  *Jeremy Kemper*

*   Added option inheritance for find calls on has_and_belongs_to_many and has_many assosociations [David Heinemeier Hansson]. Example:

        class Post
          has_many :recent_comments, :class_name => "Comment", :limit => 10, :include => :author
        end

        post.recent_comments.find(:all) # Uses LIMIT 10 and includes authors
        post.recent_comments.find(:all, :limit => nil) # Uses no limit but include authors
        post.recent_comments.find(:all, :limit => nil, :include => nil) # Uses no limit and doesn't include authors

*   Added option to specify :group, :limit, :offset, and :select options from find on has_and_belongs_to_many and has_many assosociations *David Heinemeier Hansson*

*   MySQL: fixes for the bundled mysql.rb driver.  #3160 *Justin Forder*

*   SQLServer: fix obscure optimistic locking bug.  #3068 *kajism@yahoo.com*

*   SQLServer: support uniqueidentifier columns.  #2930 *keithm@infused.org*

*   SQLServer: cope with tables names qualified by owner.  #3067 *jeff@ministrycentered.com*

*   SQLServer: cope with columns with "desc" in the name.  #1950 *Ron Lusk, Ryan Tomayko*

*   SQLServer: cope with primary keys with "select" in the name.  #3057 *rdifrango@captechventures.com*

*   Oracle: active? performs a select instead of a commit.  #3133 *Michael Schoen*

*   MySQL: more robust test for nullified result hashes.  #3124 *Stefan Kaes*

*   Reloading an instance refreshes its aggregations as well as its associations.  #3024 *François Beausoleil*

*   Fixed that using :include together with :conditions array in Base.find would cause NoMethodError #2887 *Paul Hammmond*

*   PostgreSQL: more robust sequence name discovery.  #3087 *Rick Olson*

*   Oracle: use syntax compatible with Oracle 8.  #3131 *Michael Schoen*

*   MySQL: work around ruby-mysql/mysql-ruby inconsistency with mysql.stat.  Eliminate usage of mysql.ping because it doesn't guarantee reconnect.  Explicitly close and reopen the connection instead.  *Jeremy Kemper*

*   Added preliminary support for polymorphic associations *David Heinemeier Hansson*

*   Added preliminary support for join models *David Heinemeier Hansson*

*   Allow validate_uniqueness_of to be scoped by more than just one column.  #1559. *jeremy@jthopple.com, Marcel Molina Jr.*

*   Firebird: active? and reconnect! methods for handling stale connections.  #428 *Ken Kunz <kennethkunz@gmail.com>*

*   Firebird: updated for FireRuby 0.4.0.  #3009 *Ken Kunz <kennethkunz@gmail.com>*

*   MySQL and PostgreSQL: active? compatibility with the pure-Ruby driver.  #428 *Jeremy Kemper*

*   Oracle: active? check pings the database rather than testing the last command status.  #428 *Michael Schoen*

*   SQLServer: resolve column aliasing/quoting collision when using limit or offset in an eager find.  #2974 *kajism@yahoo.com*

*   Reloading a model doesn't lose track of its connection.  #2996 *junk@miriamtech.com, Jeremy Kemper*

*   Fixed bug where using update_attribute after pushing a record to a habtm association of the object caused duplicate rows in the join table. #2888 *colman@rominato.com, Florian Weber, Michael Schoen*

*   MySQL, PostgreSQL: reconnect! also reconfigures the connection.  Otherwise, the connection 'loses' its settings if it times out and is reconnected.  #2978 *Shugo Maeda*

*   has_and_belongs_to_many: use JOIN instead of LEFT JOIN.  *Jeremy Kemper*

*   MySQL: introduce :encoding option to specify the character set for client, connection, and results.  Only available for MySQL 4.1 and later with the mysql-ruby driver.  Do SHOW CHARACTER SET in mysql client to see available encodings.  #2975 *Shugo Maeda*

*   Add tasks to create, drop and rebuild the MySQL and PostgreSQL test  databases. *Marcel Molina Jr.*

*   Correct boolean handling in generated reader methods.  #2945 *Don Park, Stefan Kaes*

*   Don't generate read methods for columns whose names are not valid ruby method names.  #2946 *Stefan Kaes*

*   Document :force option to create_table.  #2921 *Blair Zajac <blair@orcaware.com>*

*   Don't add the same conditions twice in has_one finder sql.  #2916 *Jeremy Evans*

*   Rename Version constant to VERSION. #2802 *Marcel Molina Jr.*

*   Introducing the Firebird adapter.  Quote columns and use attribute_condition more consistently.  Setup guide: http://wiki.rubyonrails.com/rails/pages/Firebird+Adapter  #1874 *Ken Kunz <kennethkunz@gmail.com>*

*   SQLServer: active? and reconnect! methods for handling stale connections.  #428 *kajism@yahoo.com, Tom Ward <tom@popdog.net>*

*   Associations handle case-equality more consistently: item.parts.is_a?(Array) and item.parts === Array.  #1345 *MarkusQ@reality.com*

*   SQLServer: insert uses given primary key value if not nil rather than SELECT @@IDENTITY.  #2866 *kajism@yahoo.com, Tom Ward <tom@popdog.net>*

*   Oracle: active? and reconnect! methods for handling stale connections.  Optionally retry queries after reconnect.  #428 *Michael Schoen <schoenm@earthlink.net>*

*   Correct documentation for Base.delete_all.  #1568 *Newhydra*

*   Oracle: test case for column default parsing.  #2788 *Michael Schoen <schoenm@earthlink.net>*

*   Update documentation for Migrations.  #2861 *Tom Werner <tom@cube6media.com>*

*   When AbstractAdapter#log rescues an exception, attempt to detect and reconnect to an inactive database connection.  Connection adapter must respond to the active? and reconnect! instance methods.  Initial support for PostgreSQL, MySQL, and SQLite.  Make certain that all statements which may need reconnection are performed within a logged block: for example, this means no avoiding log(sql, name) { } if @logger.nil?  #428 *Jeremy Kemper*

*   Oracle: Much faster column reflection.  #2848 *Michael Schoen <schoenm@earthlink.net>*

*   Base.reset_sequence_name analogous to reset_table_name (mostly useful for testing).  Base.define_attr_method allows nil values.  *Jeremy Kemper*

*   PostgreSQL: smarter sequence name defaults, stricter last_insert_id, warn on pk without sequence.  *Jeremy Kemper*

*   PostgreSQL: correctly discover custom primary key sequences.  #2594 *Blair Zajac <blair@orcaware.com>, meadow.nnick@gmail.com, Jeremy Kemper*

*   SQLServer: don't report limits for unsupported field types.  #2835 *Ryan Tomayko*

*   Include the Enumerable module in ActiveRecord::Errors.  *Rick Bradley <rick@rickbradley.com>*

*   Add :group option, correspond to GROUP BY, to the find method and to the has_many association.  #2818 *rubyonrails@atyp.de*

*   Don't cast nil or empty strings to a dummy date.  #2789 *Rick Bradley <rick@rickbradley.com>*

*   acts_as_list plays nicely with inheritance by remembering the class which declared it.  #2811 *rephorm@rephorm.com*

*   Fix sqlite adaptor's detection of missing dbfile or database declaration. *Nicholas Seckar*

*   Fixed acts_as_list for definitions without an explicit :order #2803 *Jonathan Viney*

*   Upgrade bundled ruby-mysql 0.2.4 with mysql411 shim (see #440) to ruby-mysql 0.2.6 with a patchset for 4.1 protocol support.  Local change [301] is now a part of the main driver; reapplied local change [2182].  Removed GC.start from Result.free.  *tommy@tmtm.org, akuroda@gmail.com, Doug Fales <doug.fales@gmail.com>, Jeremy Kemper*

*   Correct handling of complex order clauses with SQL Server limit emulation.  #2770 *Tom Ward <tom@popdog.net>, Matt B.*

*   Correct whitespace problem in Oracle default column value parsing.  #2788 *rick@rickbradley.com*

*   Destroy associated has_and_belongs_to_many records after all before_destroy callbacks but before destroy.  This allows you to act on the habtm association as you please while preserving referential integrity.  #2065 *larrywilliams1@gmail.com, sam.kirchmeier@gmail.com, elliot@townx.org, Jeremy Kemper*

*   Deprecate the old, confusing :exclusively_dependent option in favor of :dependent => :delete_all.  *Jeremy Kemper*

*   More compatible Oracle column reflection.  #2771 *Ryan Davis <ryand-ruby@zenspider.com>, Michael Schoen <schoenm@earthlink.net>*


## 1.13.0 (November 7th, 2005) ##

*   Fixed faulty regex in get_table_name method (SQLServerAdapter) #2639 *Ryan Tomayko*

*   Added :include as an option for association declarations [David Heinemeier Hansson]. Example:

        has_many :posts, :include => [ :author, :comments ]

*   Rename Base.constrain to Base.with_scope so it doesn't conflict with existing concept of database constraints.  Make scoping more robust: uniform method => parameters, validated method names and supported finder parameters, raise exception on nested scopes.  [Jeremy Kemper]  Example:

        Comment.with_scope(:find => { :conditions => 'active=true' }, :create => { :post_id => 5 }) do
          # Find where name = ? and active=true
          Comment.find :all, :conditions => ['name = ?', name]
          # Create comment associated with :post_id
          Comment.create :body => "Hello world"
        end

*   Fixed that SQL Server should ignore :size declarations on anything but integer and string in the agnostic schema representation #2756 *Ryan Tomayko*

*   Added constrain scoping for creates using a hash of attributes bound to the :creation key [David Heinemeier Hansson]. Example:

        Comment.constrain(:creation => { :post_id => 5 }) do
          # Associated with :post_id
          Comment.create :body => "Hello world"
        end

    This is rarely used directly, but allows for find_or_create on associations. So you can do:

        # If the tag doesn't exist, a new one is created that's associated with the person
        person.tags.find_or_create_by_name("Summer")

*   Added find_or_create_by_X as a second type of dynamic finder that'll create the record if it doesn't already exist [David Heinemeier Hansson]. Example:

        # No 'Summer' tag exists
        Tag.find_or_create_by_name("Summer") # equal to Tag.create(:name => "Summer")

        # Now the 'Summer' tag does exist
        Tag.find_or_create_by_name("Summer") # equal to Tag.find_by_name("Summer")

*   Added extension capabilities to has_many and has_and_belongs_to_many proxies [David Heinemeier Hansson]. Example:

        class Account < ActiveRecord::Base
          has_many :people do
            def find_or_create_by_name(name)
              first_name, *last_name = name.split
              last_name = last_name.join " "

              find_or_create_by_first_name_and_last_name(first_name, last_name)
            end
          end
        end

        person = Account.find(:first).people.find_or_create_by_name("David Heinemeier Hansson")
        person.first_name # => "David"
        person.last_name  # => "Heinemeier Hansson"

    Note that the anoymous module must be declared using brackets, not do/end (due to order of evaluation).

*   Omit internal dtproperties table from SQLServer table list.  #2729 *Ryan Tomayko*

*   Quote column names in generated SQL.  #2728 *Ryan Tomayko*

*   Correct the pure-Ruby MySQL 4.1.1 shim's version test.  #2718 *Jeremy Kemper*

*   Add Model.create! to match existing model.save! method.  When save! raises RecordInvalid, you can catch the exception, retrieve the invalid record (invalid_exception.record), and see its errors (invalid_exception.record.errors).  *Jeremy Kemper*

*   Correct fixture behavior when table name pluralization is off.  #2719 *Rick Bradley <rick@rickbradley.com>*

*   Changed :dbfile to :database for SQLite adapter for consistency (old key still works as an alias) #2644 *Dan Peterson*

*   Added migration support for Oracle #2647 *Michael Schoen*

*   Worked around that connection can't be reset if allow_concurrency is off.  #2648 *Michael Schoen <schoenm@earthlink.net>*

*   Fixed SQL Server adapter to pass even more tests and do even better #2634 *Ryan Tomayko*

*   Fixed SQL Server adapter so it honors options[:conditions] when applying :limits #1978 *Tom Ward*

*   Added migration support to SQL Server adapter (please someone do the same for Oracle and DB2) #2625 *Tom Ward*

*   Use AR::Base.silence rather than AR::Base.logger.silence in fixtures to preserve Log4r compatibility.  #2618 *dansketcher@gmail.com*

*   Constraints are cloned so they can't be inadvertently modified while they're
    in effect.  Added :readonly finder constraint.  Calling an association collection's class method (Part.foobar via item.parts.foobar) constrains :readonly => false since the collection's :joins constraint would otherwise force it to true.  *Jeremy Kemper <rails@bitsweat.net>*

*   Added :offset and :limit to the kinds of options that Base.constrain can use #2466 *duane.johnson@gmail.com*

*   Fixed handling of nil number columns on Oracle and cleaned up tests for Oracle in general #2555 *Michael Schoen*

*   Added quoted_true and quoted_false methods and tables to db2_adapter and cleaned up tests for DB2 #2493, #2624 *maik schmidt*


## 1.12.2 (October 26th, 2005) ##

*   Allow symbols to rename columns when using SQLite adapter. #2531 *Kevin Clark*

*   Map Active Record time to SQL TIME.  #2575, #2576 *Robby Russell <robby@planetargon.com>*

*   Clarify semantics of ActiveRecord::Base#respond_to?  #2560 *Stefan Kaes*

*   Fixed Association#clear for associations which have not yet been accessed. #2524 *Patrick Lenz <patrick@lenz.sh>*

*   HABTM finders shouldn't return readonly records.  #2525 *Patrick Lenz <patrick@lenz.sh>*

*   Make all tests runnable on their own. #2521. *Blair Zajac <blair@orcaware.com>*


## 1.12.1 (October 19th, 2005) ##

*   Always parenthesize :conditions options so they may be safely combined with STI and constraints.

*   Correct PostgreSQL primary key sequence detection.  #2507 *tmornini@infomania.com*

*   Added support for using limits in eager loads that involve has_many and has_and_belongs_to_many associations


## 1.12.0 (October 16th, 2005) ##

*   Update/clean up documentation (rdoc)

*   PostgreSQL sequence support.  Use set_sequence_name in your model class to specify its primary key sequence.  #2292 *Rick Olson <technoweenie@gmail.com>, Robby Russell <robby@planetargon.com>*

*   Change default logging colors to work on both white and black backgrounds. *Sam Stephenson*

*   YAML fixtures support ordered hashes for fixtures with foreign key dependencies in the same table.  #1896 *purestorm@ggnore.net*

*   :dependent now accepts :nullify option. Sets the foreign key of the related objects to NULL instead of deleting them. #2015 *Robby Russell <robby@planetargon.com>*

*   Introduce read-only records.  If you call object.readonly! then it will mark the object as read-only and raise ReadOnlyRecord if you call object.save.  object.readonly? reports whether the object is read-only.  Passing :readonly => true to any finder method will mark returned records as read-only.  The :joins option now implies :readonly, so if you use this option, saving the same record will now fail.  Use find_by_sql to work around.

*   Avoid memleak in dev mode when using fcgi

*   Simplified .clear on active record associations by using the existing delete_records method. #1906 *Caleb <me@cpb.ca>*

*   Delegate access to a customized primary key to the conventional id method. #2444. *Blair Zajac <blair@orcaware.com>*

*   Fix errors caused by assigning a has-one or belongs-to property to itself

*   Add ActiveRecord::Base.schema_format setting which specifies how databases should be dumped *Sam Stephenson*

*   Update DB2 adapter. #2206. *contact@maik-schmidt.de*

*   Corrections to SQLServer native data types. #2267.  *rails.20.clarry@spamgourmet.com*

*   Deprecated ActiveRecord::Base.threaded_connection in favor of ActiveRecord::Base.allow_concurrency.

*   Protect id attribute from mass assigment even when the primary key is set to something else. #2438. *Blair Zajac <blair@orcaware.com>*

*   Misc doc fixes (typos/grammar/etc.). #2430. *coffee2code*

*   Add test coverage for content_columns. #2432. *coffee2code*

*   Speed up for unthreaded environments. #2431. *Stefan Kaes*

*   Optimization for Mysql selects using mysql-ruby extension greater than 2.6.3.  #2426. *Stefan Kaes*

*   Speed up the setting of table_name. #2428. *Stefan Kaes*

*   Optimize instantiation of STI subclass records. In partial fullfilment of #1236. *Stefan Kaes*

*   Fix typo of 'constrains' to 'contraints'. #2069. *Michael Schuerig <michael@schuerig.de>*

*   Optimization refactoring for add_limit_offset!. In partial fullfilment of #1236. *Stefan Kaes*

*   Add ability to get all siblings, including the current child, with acts_as_tree. Recloses #2140. *Michael Schuerig <michael@schuerig.de>*

*   Add geometric type for postgresql adapter. #2233 *Andrew Kaspick*

*   Add option (true by default) to generate reader methods for each attribute of a record to avoid the overhead of calling method missing. In partial fullfilment of #1236. *Stefan Kaes*

*   Add convenience predicate methods on Column class. In partial fullfilment of #1236. *Stefan Kaes*

*   Raise errors when invalid hash keys are passed to ActiveRecord::Base.find. #2363  *Chad Fowler <chad@chadfowler.com>, Nicholas Seckar*

*   Added :force option to create_table that'll try to drop the table if it already exists before creating

*   Fix transactions so that calling return while inside a transaction will not leave an open transaction on the connection. *Nicholas Seckar*

*   Use foreign_key inflection uniformly.  #2156 *Blair Zajac <blair@orcaware.com>*

*   model.association.clear should destroy associated objects if :dependent => true instead of nullifying their foreign keys.  #2221 *joergd@pobox.com, ObieFernandez <obiefernandez@gmail.com>*

*   Returning false from before_destroy should cancel the action.  #1829 *Jeremy Huffman*

*   Recognize PostgreSQL NOW() default as equivalent to CURRENT_TIMESTAMP or CURRENT_DATE, depending on the column's type.  #2256 *mat <mat@absolight.fr>*

*   Extensive documentation for the abstract database adapter.  #2250 *François Beausoleil <fbeausoleil@ftml.net>*

*   Clean up Fixtures.reset_sequences for PostgreSQL.  Handle tables with no rows and models with custom primary keys.  #2174, #2183 *jay@jay.fm, Blair Zajac <blair@orcaware.com>*

*   Improve error message when nil is assigned to an attr which validates_size_of within a range.  #2022 *Manuel Holtgrewe <purestorm@ggnore.net>*

*   Make update_attribute use the same writer method that update_attributes uses.
    \#2237 *trevor@protocool.com*

*   Make migrations honor table name prefixes and suffixes. #2298 *Jakob Skjerning, Marcel Molina Jr.*

*   Correct and optimize PostgreSQL bytea escaping.  #1745, #1837 *dave@cherryville.org, ken@miriamtech.com, bellis@deepthought.org*

*   Fixtures should only reset a PostgreSQL sequence if it corresponds to an integer primary key named id.  #1749 *chris@chrisbrinker.com*

*   Standardize the interpretation of boolean columns in the Mysql and Sqlite adapters. (Use MysqlAdapter.emulate_booleans = false to disable this behavior)

*   Added new symbol-driven approach to activating observers with Base#observers= [David Heinemeier Hansson]. Example:

        ActiveRecord::Base.observers = :cacher, :garbage_collector

*   Added AbstractAdapter#select_value and AbstractAdapter#select_values as convenience methods for selecting single values, instead of hashes, of the first column in a SELECT #2283 *solo@gatelys.com*

*   Wrap :conditions in parentheses to prevent problems with OR's #1871 *Jamis Buck*

*   Allow the postgresql adapter to work with the SchemaDumper. *Jamis Buck*

*   Add ActiveRecord::SchemaDumper for dumping a DB schema to a pure-ruby file, making it easier to consolidate large migration lists and port database schemas between databases. *Jamis Buck*

*   Fixed migrations for Windows when using more than 10 *David Naseby*

*   Fixed that the create_x method from belongs_to wouldn't save the association properly #2042 *Florian Weber*

*   Fixed saving a record with two unsaved belongs_to associations pointing to the same object #2023 *Tobias Lütke*

*   Improved migrations' behavior when the schema_info table is empty. *Nicholas Seckar*

*   Fixed that Observers didn't observe sub-classes #627 *Florian Weber*

*   Fix eager loading error messages, allow :include to specify tables using strings or symbols. Closes #2222 *Marcel Molina Jr.*

*   Added check for RAILS_CONNECTION_ADAPTERS on startup and only load the connection adapters specified within if its present (available in Rails through config.connection_adapters using the new config) #1958 *skae*

*   Fixed various problems with has_and_belongs_to_many when using customer finder_sql #2094 *Florian Weber*

*   Added better exception error when unknown column types are used with migrations #1814 *François Beausoleil*

*   Fixed "connection lost" issue with the bundled Ruby/MySQL driver (would kill the app after 8 hours of inactivity) #2163, #428 *kajism@yahoo.com*

*   Fixed comparison of Active Record objects so two new objects are not equal #2099 *deberg*

*   Fixed that the SQL Server adapter would sometimes return DBI::Timestamp objects instead of Time #2127 *Tom Ward*

*   Added the instance methods #root and #ancestors on acts_as_tree and fixed siblings to not include the current node #2142, #2140 *coffee2code*

*   Fixed that Active Record would call SHOW FIELDS twice (or more) for the same model when the cached results were available #1947 *sd@notso.net*

*   Added log_level and use_silence parameter to ActiveRecord::Base.benchmark. The first controls at what level the benchmark statement will be logged (now as debug, instead of info) and the second that can be passed false to include all logging statements during the benchmark block/

*   Make sure the schema_info table is created before querying the current version #1903

*   Fixtures ignore table name prefix and suffix #1987 *Jakob Skjerning*

*   Add documentation for index_type argument to add_index method for migrations #2005 *Blaine*

*   Modify read_attribute to allow a symbol argument #2024 *Ken Kunz*

*   Make destroy return self #1913 *Sebastian Kanthak*

*   Fix typo in validations documentation #1938 *court3nay*

*   Make acts_as_list work for insert_at(1) #1966 *hensleyl@papermountain.org*

*   Fix typo in count_by_sql documentation #1969 *Alexey Verkhovsky*

*   Allow add_column and create_table to specify NOT NULL #1712 *emptysands@gmail.com*

*   Fix create_table so that id column is implicitly added *Rick Olson*

*   Default sequence names for Oracle changed to #{table_name}_seq, which is the most commonly used standard. In addition, a new method ActiveRecord::Base#set_sequence_name allows the developer to set the sequence name per model. This is a non-backwards-compatible change -- anyone using the old-style "rails_sequence" will need to either create new sequences, or set: ActiveRecord::Base.set_sequence_name = "rails_sequence" #1798

*   OCIAdapter now properly handles synonyms, which are commonly used to separate out the schema owner from the application user #1798

*   Fixed the handling of camelCase columns names in Oracle #1798

*   Implemented for OCI the Rakefile tasks of :clone_structure_to_test, :db_structure_dump, and :purge_test_database, which enable Oracle folks to enjoy all the agile goodness of Rails for testing. Note that the current implementation is fairly limited -- only tables and sequences are cloned, not constraints or indexes. A full clone in Oracle generally requires some manual effort, and is version-specific. Post 9i, Oracle recommends the use of the DBMS_METADATA package, though that approach requires editing of the physical characteristics generated #1798

*   Fixed the handling of multiple blob columns in Oracle if one or more of them are null #1798

*   Added support for calling constrained class methods on has_many and has_and_belongs_to_many collections #1764 *Tobias Lütke*

        class Comment < AR:B
          def self.search(q)
            find(:all, :conditions => ["body = ?", q])
          end
        end

        class Post < AR:B
          has_many :comments
        end

        Post.find(1).comments.search('hi') # => SELECT * from comments WHERE post_id = 1 AND body = 'hi'

    NOTICE: This patch changes the underlying SQL generated by has_and_belongs_to_many queries. If your relying on that, such as
    by explicitly referencing the old t and j aliases, you'll need to update your code. Of course, you _shouldn't_ be relying on
    details like that no less than you should be diving in to touch private variables. But just in case you do, consider yourself
    noticed :)

*   Added migration support for SQLite (using temporary tables to simulate ALTER TABLE) #1771 *Sam Stephenson*

*   Remove extra definition of supports_migrations? from abstract_adaptor.rb *Nicholas Seckar*

*   Fix acts_as_list so that moving next-to-last item to the bottom does not result in duplicate item positions

*   Fixed incompatibility in DB2 adapter with the new limit/offset approach #1718 *Maik Schmidt*

*   Added :select option to find which can specify a different value than the default *, like find(:all, :select => "first_name, last_name"), if you either only want to select part of the columns or exclude columns otherwise included from a join #1338 *Stefan Kaes*


## 1.11.1 (11 July, 2005) ##

*   Added support for limit and offset with eager loading of has_one and belongs_to associations. Using the options with has_many and has_and_belongs_to_many associations will now raise an ActiveRecord::ConfigurationError #1692 *Rick Olson*

*   Fixed that assume_bottom_position (in acts_as_list) could be called on items already last in the list and they would move one position away from the list #1648 *tyler@kianta.com*

*   Added ActiveRecord::Base.threaded_connections flag to turn off 1-connection per thread (required for thread safety). By default it's on, but WEBrick in Rails need it off #1685 *Sam Stephenson*

*   Correct reflected table name for singular associations.  #1688 *court3nay*

*   Fixed optimistic locking with SQL Server #1660 *tom@popdog.net*

*   Added ActiveRecord::Migrator.migrate that can figure out whether to go up or down based on the target version and the current

*   Added better error message for "packets out of order" #1630 *court3nay*

*   Fixed first run of "rake migrate" on PostgreSQL by not expecting a return value on the id #1640


## 1.11.0 (6 July, 2005) ##

*   Fixed that Yaml error message in fixtures hid the real error #1623 *Nicholas Seckar*

*   Changed logging of SQL statements to use the DEBUG level instead of INFO

*   Added new Migrations framework for describing schema transformations in a way that can be easily applied across multiple databases #1604 [Tobias Lütke] See documentation under ActiveRecord::Migration and the additional support in the Rails rakefile/generator.

*   Added callback hooks to association collections #1549 [Florian Weber]. Example:

        class Project
          has_and_belongs_to_many :developers, :before_add => :evaluate_velocity

          def evaluate_velocity(developer)
            ...
          end
        end

    ..raising an exception will cause the object not to be added (or removed, with before_remove).


*   Fixed Base.content_columns call for SQL Server adapter #1450 *DeLynn Berry*

*   Fixed Base#write_attribute to work with both symbols and strings #1190 *Paul Legato*

*   Fixed that has_and_belongs_to_many didn't respect single table inheritance types #1081 *Florian Weber*

*   Speed up ActiveRecord#method_missing for the common case (read_attribute).

*   Only notify observers on after_find and after_initialize if these methods are defined on the model.  #1235 *Stefan Kaes*

*   Fixed that single-table inheritance sub-classes couldn't be used to limit the result set with eager loading #1215 *Chris McGrath*

*   Fixed validates_numericality_of to work with overrided getter-method when :allow_nil is on #1316 *raidel@onemail.at*

*   Added roots, root, and siblings to the batch of methods added by acts_as_tree #1541 *Michael Schuerig*

*   Added support for limit/offset with the MS SQL Server driver so that pagination will now work #1569 *DeLynn Berry*

*   Added support for ODBC connections to MS SQL Server so you can connect from a non-Windows machine #1569 *Mark Imbriaco/DeLynn Berry*

*   Fixed that multiparameter posts ignored attr_protected #1532 *alec+rails@veryclever.net*

*   Fixed problem with eager loading when using a has_and_belongs_to_many association using :association_foreign_key #1504 *flash@vanklinkenbergsoftware.nl*

*   Fixed Base#find to honor the documentation on how :joins work and make them consistent with Base#count #1405 [pritchie@gmail.com]. What used to be:

        Developer.find :all, :joins => 'developers_projects', :conditions => 'id=developer_id AND project_id=1'

    ...should instead be:

        Developer.find(
          :all,
          :joins => 'LEFT JOIN developers_projects ON developers.id = developers_projects.developer_id',
          :conditions => 'project_id=1'
        )

*   Fixed that validations didn't respecting custom setting for too_short, too_long messages #1437 *Marcel Molina Jr.*

*   Fixed that clear_association_cache doesn't delete new associations on new records (so you can safely place new records in the session with Action Pack without having new associations wiped) #1494 *cluon*

*   Fixed that calling Model.find([]) returns [] and doesn't throw an exception #1379

*   Fixed that adding a record to a has_and_belongs_to collection would always save it -- now it only saves if its a new record #1203 *Alisdair McDiarmid*

*   Fixed saving of in-memory association structures to happen as a after_create/after_update callback instead of after_save -- that way you can add new associations in after_create/after_update callbacks without getting them saved twice

*   Allow any Enumerable, not just Array, to work as bind variables #1344 *Jeremy Kemper*

*   Added actual database-changing behavior to collection assigment for has_many and has_and_belongs_to_many #1425 [Sebastian Kanthak].
    Example:

        david.projects = [Project.find(1), Project.new("name" => "ActionWebSearch")]
        david.save

    If david.projects already contain the project with ID 1, this is left unchanged. Any other projects are dropped. And the new
    project is saved when david.save is called.

    Also included is a way to do assignments through IDs, which is perfect for checkbox updating, so you get to do:

        david.project_ids = [1, 5, 7]

*   Corrected typo in find SQL for has_and_belongs_to_many.  #1312 *ben@bensinclair.com*

*   Fixed sanitized conditions for has_many finder method.  #1281 *jackc@hylesanderson.com, pragdave, Tobias Lütke*

*   Comprehensive PostgreSQL schema support.  Use the optional schema_search_path directive in database.yml to give a comma-separated list of schemas to search for your tables.  This allows you, for example, to have tables in a shared schema without having to use a custom table name.  See http://www.postgresql.org/docs/8.0/interactive/ddl-schemas.html to learn more.  #827 *dave@cherryville.org*

*   Corrected @@configurations typo #1410 *david@ruppconsulting.com*

*   Return PostgreSQL columns in the order they were declared #1374 *perlguy@gmail.com*

*   Allow before/after update hooks to work on models using optimistic locking

*   Eager loading of dependent has_one associations won't delete the association #1212

*   Added a second parameter to the build and create method for has_one that controls whether the existing association should be replaced (which means nullifying its foreign key as well). By default this is true, but false can be passed to prevent it.

*   Using transactional fixtures now causes the data to be loaded only once.

*   Added fixture accessor methods that can be used when instantiated fixtures are disabled.

        fixtures :web_sites

        def test_something
          assert_equal "Ruby on Rails", web_sites(:rubyonrails).name
        end

*   Added DoubleRenderError exception that'll be raised if render* is called twice #518 *Nicholas Seckar*

*   Fixed exceptions occuring after render has been called #1096 *Nicholas Seckar*

*   CHANGED: validates_presence_of now uses Errors#add_on_blank, which will make "  " fail the validation where it didn't before #1309

*   Added Errors#add_on_blank which works like Errors#add_on_empty, but uses Object#blank? instead

*   Added the :if option to all validations that can either use a block or a method pointer to determine whether the validation should be run or not. #1324 [Duane Johnson/jhosteny]. Examples:

    Conditional validations such as the following are made possible:
        validates_numericality_of :income, :if => :employed?

    Conditional validations can also solve the salted login generator problem:
        validates_confirmation_of :password, :if => :new_password?

    Using blocks:
        validates_presence_of :username, :if => Proc.new { |user| user.signup_step > 1 }

*   Fixed use of construct_finder_sql when using :join #1288 *dwlt@dwlt.net*

*   Fixed that :delete_sql in has_and_belongs_to_many associations couldn't access record properties #1299 *Rick Olson*

*   Fixed that clone would break when an aggregate had the same name as one of its attributes #1307 *Jeremy Kemper*

*   Changed that destroying an object will only freeze the attributes hash, which keeps the object from having attributes changed (as that wouldn't make sense), but allows for the querying of associations after it has been destroyed.

*   Changed the callbacks such that observers are notified before the in-object callbacks are triggered. Without this change, it wasn't possible to act on the whole object in something like a before_destroy observer without having the objects own callbacks (like deleting associations) called first.

*   Added option for passing an array to the find_all version of the dynamic finders and have it evaluated as an IN fragment. Example:

        # SELECT * FROM topics WHERE title IN ('First', 'Second')
        Topic.find_all_by_title(["First", "Second"])

*   Added compatibility with camelCase column names for dynamic finders #533 *Dee Zsombor*

*   Fixed extraneous comma in count() function that made it not work with joins #1156 *Jarkko Laine/Dee Zsombor*

*   Fixed incompatibility with Base#find with an array of ids that would fail when using eager loading #1186 *Alisdair McDiarmid*

*   Fixed that validate_length_of lost :on option when :within was specified #1195 *jhosteny@mac.com*

*   Added encoding and min_messages options for PostgreSQL #1205 [Shugo Maeda]. Configuration example:

        development:
          adapter: postgresql
          database: rails_development
          host: localhost
          username: postgres
          password:
          encoding: UTF8
          min_messages: ERROR

*   Fixed acts_as_list where deleting an item that was removed from the list would ruin the positioning of other list items #1197 *Jamis Buck*

*   Added validates_exclusion_of as a negative of validates_inclusion_of

*   Optimized counting of has_many associations by setting the association to empty if the count is 0 so repeated calls doesn't trigger database calls


## 1.10.1 (20th April, 2005) ##

*   Fixed frivilous database queries being triggered with eager loading on empty associations and other things

*   Fixed order of loading in eager associations

*   Fixed stray comma when using eager loading and ordering together from has_many associations #1143


## 1.10.0 (19th April, 2005) ##

*   Added eager loading of associations as a way to solve the N+1 problem more gracefully without piggy-back queries. Example:

        for post in Post.find(:all, :limit => 100)
          puts "Post:            " + post.title
          puts "Written by:      " + post.author.name
          puts "Last comment on: " + post.comments.first.created_on
        end

    This used to generate 301 database queries if all 100 posts had both author and comments. It can now be written as:

        for post in Post.find(:all, :limit => 100, :include => [ :author, :comments ])

    ...and the number of database queries needed is now 1.

*   Added new unified Base.find API and deprecated the use of find_first and find_all. See the documentation for Base.find. Examples:

        Person.find(1, :conditions => "administrator = 1", :order => "created_on DESC")
        Person.find(1, 5, 6, :conditions => "administrator = 1", :order => "created_on DESC")
        Person.find(:first, :order => "created_on DESC", :offset => 5)
        Person.find(:all, :conditions => [ "category IN (?)", categories], :limit => 50)
        Person.find(:all, :offset => 10, :limit => 10)

*   Added acts_as_nested_set #1000 [wschenk]. Introduction:

        This acts provides Nested Set functionality.  Nested Set is similiar to Tree, but with
        the added feature that you can select the children and all of it's descendants with
        a single query.  A good use case for this is a threaded post system, where you want
        to display every reply to a comment without multiple selects.

*   Added Base.save! that attempts to save the record just like Base.save but will raise a RecordInvalid exception instead of returning false if the record is not valid *Dave Thomas*

*   Fixed PostgreSQL usage of fixtures with regards to public schemas and table names with dots #962 *gnuman1@gmail.com*

*   Fixed that fixtures were being deleted in the same order as inserts causing FK errors #890 *andrew.john.peters@gmail.com*

*   Fixed loading of fixtures in to be in the right order (or PostgreSQL would bark) #1047 *stephenh@chase3000.com*

*   Fixed page caching for non-vhost applications living underneath the root #1004 *Ben Schumacher*

*   Fixes a problem with the SQL Adapter which was resulting in IDENTITY_INSERT not being set to ON when it should be #1104 *adelle*

*   Added the option to specify the acceptance string in validates_acceptance_of #1106 *caleb@aei-tech.com*

*   Added insert_at(position) to acts_as_list #1083 *DeLynnB*

*   Removed the default order by id on has_and_belongs_to_many queries as it could kill performance on large sets (you can still specify by hand with :order)

*   Fixed that Base.silence should restore the old logger level when done, not just set it to DEBUG #1084 *yon@milliped.com*

*   Fixed boolean saving on Oracle #1093 *mparrish@pearware.org*

*   Moved build_association and create_association for has_one and belongs_to out of deprecation as they work when the association is nil unlike association.build and association.create, which require the association to be already in place #864

*   Added rollbacks of transactions if they're active as the dispatcher is killed gracefully (TERM signal) #1054 *Leon Bredt*

*   Added quoting of column names for fixtures #997 *jcfischer@gmail.com*

*   Fixed counter_sql when no records exist in database for PostgreSQL (would give error, not 0) #1039 *Caleb Tennis*

*   Fixed that benchmarking times for rendering included db runtimes #987 *Stefan Kaes*

*   Fixed boolean queries for t/f fields in PostgreSQL #995 *dave@cherryville.org*

*   Added that model.items.delete(child) will delete the child, not just set the foreign key to nil, if the child is dependent on the model #978 *Jeremy Kemper*

*   Fixed auto-stamping of dates (created_on/updated_on) for PostgreSQL #985 *dave@cherryville.org*

*   Fixed Base.silence/benchmark to only log if a logger has been configured #986 *Stefan Kaes*

*   Added a join parameter as the third argument to Base.find_first and as the second to Base.count #426, #988 *Stefan Kaes*

*   Fixed bug in Base#hash method that would treat records with the same string-based id as different *Dave Thomas*

*   Renamed DateHelper#distance_of_time_in_words_to_now to DateHelper#time_ago_in_words (old method name is still available as a deprecated alias)


## 1.9.1 (27th March, 2005) ##

*   Fixed that Active Record objects with float attribute could not be cloned #808

*   Fixed that MissingSourceFile's wasn't properly detected in production mode #925 *Nicholas Seckar*

*   Fixed that :counter_cache option would look for a line_items_count column for a LineItem object instead of lineitems_count

*   Fixed that AR exists?() would explode on postgresql if the passed id did not match the PK type #900 *Scott Barron*

*   Fixed the MS SQL adapter to work with the new limit/offset approach and with binary data (still suffering from 7KB limit, though) #901 *delynnb*


## 1.9.0 (22th March, 2005) ##

*   Added adapter independent limit clause as a two-element array with the first being the limit, the second being the offset #795 [Sam Stephenson]. Example:

        Developer.find_all nil, 'id ASC', 5      # return the first five developers
        Developer.find_all nil, 'id ASC', [3, 8] # return three developers, starting from #8 and forward

    This doesn't yet work with the DB2 or MS SQL adapters. Patches to make that happen are encouraged.

*   Added alias_method :to_param, :id to Base, such that Active Record objects to be used as URL parameters in Action Pack automatically #812 *Nicholas Seckar/Sam Stephenson*

*   Improved the performance of the OCI8 adapter for Oracle #723 *pilx/gjenkins*

*   Added type conversion before saving a record, so string-based values like "10.0" aren't left for the database to convert #820 *dave@cherryville.org*

*   Added with additional settings for working with transactional fixtures and pre-loaded test databases #865 *mindel*

*   Fixed acts_as_list to trigger remove_from_list on destroy after the fact, not before, so a unique position can be maintained #871 *Alisdair McDiarmid*

*   Added the possibility of specifying fixtures in multiple calls #816 *kim@tinker.com*

*   Added Base.exists?(id) that'll return true if an object of the class with the given id exists #854 *stian@grytoyr.net*

*   Added optionally allow for nil or empty strings with validates_numericality_of #801 *Sebastian Kanthak*

*   Fixed problem with using slashes in validates_format_of regular expressions #801 *Sebastian Kanthak*

*   Fixed that SQLite3 exceptions are caught and reported properly #823 *yerejm*

*   Added that all types of after_find/after_initialized callbacks are triggered if the explicit implementation is present, not only the explicit implementation itself

*   Fixed that symbols can be used on attribute assignment, like page.emails.create(:subject => data.subject, :body => data.body)


## 1.8.0 (7th March, 2005) ##

*   Added ActiveRecord::Base.colorize_logging to control whether to use colors in logs or not (on by default)

*   Added support for timestamp with time zone in PostgreSQL #560 *Scott Barron*

*   Added MultiparameterAssignmentErrors and AttributeAssignmentError exceptions #777 [demetrius]. Documentation:

     * +MultiparameterAssignmentErrors+ -- collection of errors that occurred during a mass assignment using the
         +attributes=+ method. The +errors+ property of this exception contains an array of +AttributeAssignmentError+
         objects that should be inspected to determine which attributes triggered the errors.
     * +AttributeAssignmentError+ -- an error occurred while doing a mass assignment through the +attributes=+ method.
         You can inspect the +attribute+ property of the exception object to determine which attribute triggered the error.

*   Fixed that postgresql adapter would fails when reading bytea fields with null value #771 *rodrigo k*

*   Added transactional fixtures that uses rollback to undo changes to fixtures instead of DELETE/INSERT -- it's much faster. See documentation under Fixtures #760 *Jeremy Kemper*

*   Added destruction of dependent objects in has_one associations when a new assignment happens #742 [mindel]. Example:

        class Account < ActiveRecord::Base
          has_one :credit_card, :dependent => true
        end
        class CreditCard < ActiveRecord::Base
          belongs_to :account
        end

        account.credit_card # => returns existing credit card, lets say id = 12
        account.credit_card = CreditCard.create("number" => "123")
        account.save # => CC with id = 12 is destroyed


*   Added validates_numericality_of #716 [Sebastian Kanthak/Chris McGrath]. Docuemntation:

        Validates whether the value of the specified attribute is numeric by trying to convert it to
        a float with Kernel.Float (if <tt>integer</tt> is false) or applying it to the regular expression
        <tt>/^[\+\-]?\d+$/</tt> (if <tt>integer</tt> is set to true).

          class Person < ActiveRecord::Base
            validates_numericality_of :value, :on => :create
          end

        Configuration options:
        * <tt>message</tt> - A custom error message (default is: "is not a number")
        * <tt>on</tt> Specifies when this validation is active (default is :save, other options :create, :update)
        * <tt>only_integer</tt> Specifies whether the value has to be an integer, e.g. an integral value (default is false)


*   Fixed that HasManyAssociation#count was using :finder_sql rather than :counter_sql if it was available #445 *Scott Barron*

*   Added better defaults for composed_of, so statements like composed_of :time_zone, :mapping => %w( time_zone time_zone ) can be written without the mapping part (it's now assumed)

*   Added MacroReflection#macro which will return a symbol describing the macro used (like :composed_of or :has_many) #718, #248 *james@slashetc.com*


## 1.7.0 (24th February, 2005) ##

*   Changed the auto-timestamping feature to use ActiveRecord::Base.default_timezone instead of entertaining the parallel ActiveRecord::Base.timestamps_gmt method. The latter is now deprecated and will throw a warning on use (but still work) #710 *Jamis Buck*

*   Added a OCI8-based Oracle adapter that has been verified to work with Oracle 8 and 9 #629 [Graham Jenkins]. Usage notes:

        1.  Key generation uses a sequence "rails_sequence" for all tables. (I couldn't find a simple
            and safe way of passing table-specific sequence information to the adapter.)
        2.  Oracle uses DATE or TIMESTAMP datatypes for both dates and times. Consequently I have had to
            resort to some hacks to get data converted to Date or Time in Ruby.
            If the column_name ends in _at (like created_at, updated_at) it's created as a Ruby Time. Else if the
            hours/minutes/seconds are 0, I make it a Ruby Date. Else it's a Ruby Time.
            This is nasty - but if you use Duck Typing you'll probably not care very much.
            In 9i it's tempting to map DATE to Date and TIMESTAMP to Time but I don't think that is
            valid - too many databases use DATE for both.
            Timezones and sub-second precision on timestamps are not supported.
        3.  Default values that are functions (such as "SYSDATE") are not supported. This is a
            restriction of the way active record supports default values.
        4.  Referential integrity constraints are not fully supported. Under at least
            some circumstances, active record appears to delete parent and child records out of
            sequence and out of transaction scope. (Or this may just be a problem of test setup.)

    The OCI8 driver can be retrieved from http://rubyforge.org/projects/ruby-oci8/

*   Added option :schema_order to the PostgreSQL adapter to support the use of multiple schemas per database #697 *YuriSchimke*

*   Optimized the SQL used to generate has_and_belongs_to_many queries by listing the join table first #693 *yerejm*

*   Fixed that when using validation macros with a custom message, if you happened to use single quotes in the message string you would get a parsing error #657 *tonka*

*   Fixed that Active Record would throw Broken Pipe errors with FCGI when the MySQL connection timed out instead of reconnecting #428 *Nicholas Seckar*

*   Added options to specify an SSL connection for MySQL. Define the following attributes in the connection config (config/database.yml in Rails) to use it: sslkey, sslcert, sslca, sslcapath, sslcipher. To use SSL with no client certs, just set :sslca = '/dev/null'. http://dev.mysql.com/doc/mysql/en/secure-connections.html #604 *daniel@nightrunner.com*

*   Added automatic dropping/creating of test tables for running the unit tests on all databases #587 *adelle@bullet.net.au*

*   Fixed that find_by_* would fail when column names had numbers #670 *demetrius*

*   Fixed the SQL Server adapter on a bunch of issues #667 *DeLynn*

        1. Created a new columns method that is much cleaner.
        2. Corrected a problem with the select and select_all methods
           that didn't account for the LIMIT clause being passed into raw SQL statements.
        3. Implemented the string_to_time method in order to create proper instances of the time class.
        4. Added logic to the simplified_type method that allows the database to specify the scale of float data.
        5. Adjusted the quote_column_name to account for the fact that MS SQL is bothered by a forward slash in the data string.

*   Fixed that the dynamic finder like find_all_by_something_boolean(false) didn't work #649 *lmarlow*

*   Added validates_each that validates each specified attribute against a block #610 [Jeremy Kemper]. Example:

        class Person < ActiveRecord::Base
          validates_each :first_name, :last_name do |record, attr|
            record.errors.add attr, 'starts with z.' if attr[0] == ?z
          end
        end

*   Added :allow_nil as an explicit option for validates_length_of, so unless that's set to true having the attribute as nil will also return an error if a range is specified as :within #610 *Jeremy Kemper*

*   Added that validates_* now accept blocks to perform validations #618 [Tim Bates]. Example:

        class Person < ActiveRecord::Base
          validate { |person| person.errors.add("title", "will never be valid") if SHOULD_NEVER_BE_VALID }
        end

*   Addded validation for validate all the associated objects before declaring failure with validates_associated #618 *Tim Bates*

*   Added keyword-style approach to defining the custom relational bindings #545 [Jamis Buck]. Example:

        class Project < ActiveRecord::Base
          primary_key "sysid"
          table_name "XYZ_PROJECT"
          inheritance_column { original_inheritance_column + "_id" }
        end

*   Fixed Base#clone for use with PostgreSQL #565 *hanson@surgery.wisc.edu*


## 1.6.0 (January 25th, 2005) ##

*   Added that has_many association build and create methods can take arrays of record data like Base#create and Base#build to build/create multiple records at once.

*   Added that Base#delete and Base#destroy both can take an array of ids to delete/destroy #336

*   Added the option of supplying an array of attributes to Base#create, so that multiple records can be created at once.

*   Added the option of supplying an array of ids and attributes to Base#update, so that multiple records can be updated at once (inspired by #526/Duane Johnson). Example

        people = { 1 => { "first_name" => "David" }, 2 => { "first_name" => "Jeremy"} }
        Person.update(people.keys, people.values)

*   Added ActiveRecord::Base.timestamps_gmt that can be set to true to make the automated timestamping use GMT instead of local time #520 *Scott Baron*

*   Added that update_all calls sanitize_sql on its updates argument, so stuff like MyRecord.update_all(['time = ?', Time.now]) works #519 *notahat*

*   Fixed that the dynamic finders didn't treat nil as a "IS NULL" but rather "= NULL" case #515 *Demetrius*

*   Added bind-named arrays for interpolating a group of ids or strings in conditions #528 *Jeremy Kemper*

*   Added that has_and_belongs_to_many associations with additional attributes also can be created between unsaved objects and only committed to the database when Base#save is called on the associator #524 *Eric Anderson*

*   Fixed that records fetched with piggy-back attributes or through rich has_and_belongs_to_many associations couldn't be saved due to the extra attributes not part of the table #522 *Eric Anderson*

*   Added mass-assignment protection for the inheritance column -- regardless of a custom column is used or not

*   Fixed that association proxies would fail === tests like PremiumSubscription === @account.subscription

*   Fixed that column aliases didn't work as expected with the new MySql411 driver #507 *Demetrius*

*   Fixed that find_all would produce invalid sql when called sequentialy #490 *Scott Baron*


## 1.5.1 (January 18th, 2005) ##

*   Fixed that the belongs_to and has_one proxy would fail a test like 'if project.manager' -- this unfortunately also means that you can't call methods like project.manager.build unless there already is a manager on the project #492 *Tim Bates*

*   Fixed that the Ruby/MySQL adapter wouldn't connect if the password was empty #503 *Pelle*


## 1.5.0 (January 17th, 2005) ##

*   Fixed that unit tests for MySQL are now run as the "rails" user instead of root #455 *Eric Hodel*

*   Added validates_associated that enables validation of objects in an unsaved association #398 [Tim Bates]. Example:

        class Book < ActiveRecord::Base
          has_many :pages
          belongs_to :library

          validates_associated :pages, :library
        end

*   Added support for associating unsaved objects #402 [Tim Bates]. Rules that govern this addition:

        == Unsaved objects and associations

        You can manipulate objects and associations before they are saved to the database, but there is some special behaviour you should be
        aware of, mostly involving the saving of associated objects.

        === One-to-one associations

        * Assigning an object to a has_one association automatically saves that object, and the object being replaced (if there is one), in
          order to update their primary keys - except if the parent object is unsaved (new_record? == true).
        * If either of these saves fail (due to one of the objects being invalid) the assignment statement returns false and the assignment
          is cancelled.
        * If you wish to assign an object to a has_one association without saving it, use the #association.build method (documented below).
        * Assigning an object to a belongs_to association does not save the object, since the foreign key field belongs on the parent. It does
          not save the parent either.

        === Collections

        * Adding an object to a collection (has_many or has_and_belongs_to_many) automatically saves that object, except if the parent object
          (the owner of the collection) is not yet stored in the database.
        * If saving any of the objects being added to a collection (via #push or similar) fails, then #push returns false.
        * You can add an object to a collection without automatically saving it by using the #collection.build method (documented below).
        * All unsaved (new_record? == true) members of the collection are automatically saved when the parent is saved.

*   Added replace to associations, so you can do project.manager.replace(new_manager) or project.milestones.replace(new_milestones) #402 *Tim Bates*

*   Added build and create methods to has_one and belongs_to associations, so you can now do project.manager.build(attributes) #402 *Tim Bates*

*   Added that if a before_* callback returns false, all the later callbacks and the associated action are cancelled. If an after_* callback returns false, all the later callbacks are cancelled. Callbacks are generally run in the order they are defined, with the exception of callbacks defined as methods on the model, which are called last. #402 *Tim Bates*

*   Fixed that Base#== wouldn't work for multiple references to the same unsaved object #402 *Tim Bates*

*   Fixed binary support for PostgreSQL #444 *alex@byzantine.no*

*   Added a differenciation between AssociationCollection#size and -length. Now AssociationCollection#size returns the size of the
    collection by executing a SELECT COUNT(*) query if the collection hasn't been loaded and calling collection.size if it has. If
    it's more likely than not that the collection does have a size larger than zero and you need to fetch that collection afterwards,
    it'll take one less SELECT query if you use length.

*   Added Base#attributes that returns a hash of all the attributes with their names as keys and clones of their objects as values #433 *atyp.de*

*   Fixed that foreign keys named the same as the association would cause stack overflow #437 *Eric Anderson*

*   Fixed default scope of acts_as_list from "1" to "1 = 1", so it'll work in PostgreSQL (among other places) #427 *Alexey*

*   Added Base#reload that reloads the attributes of an object from the database #422 *Andreas Schwarz*

*   Added SQLite3 compatibility through the sqlite3-ruby adapter by Jamis Buck #381 *Jeremy Kemper*

*   Added support for the new protocol spoken by MySQL 4.1.1+ servers for the Ruby/MySQL adapter that ships with Rails #440 *Matt Mower*

*   Added that Observers can use the observes class method instead of overwriting self.observed_class().

        Before:
          class ListSweeper < ActiveRecord::Base
            def self.observed_class() [ List, Item ]
          end

        After:
          class ListSweeper < ActiveRecord::Base
            observes List, Item
          end

*   Fixed that conditions in has_many and has_and_belongs_to_many should be interpolated just like the finder_sql is

*   Fixed Base#update_attribute to be indifferent to whether a string or symbol is used to describe the name

*   Added Base#toggle(attribute) and Base#toggle!(attribute) that makes it easier to flip a switch or flag.

        Before: topic.update_attribute(:approved, !approved?)
        After : topic.toggle!(:approved)

*   Added Base#increment!(attribute) and Base#decrement!(attribute) that also saves the records. Example:

        page.views # => 1
        page.increment!(:views) # executes an UPDATE statement
        page.views # => 2

        page.increment(:views).increment!(:views)
        page.views # => 4

*   Added Base#increment(attribute) and Base#decrement(attribute) that encapsulates the += 1 and -= 1 patterns.




## 1.14.2 (April 9th, 2005) ##

*   Fixed calculations for the Oracle Adapter (closes #4626) *Michael Schoen*


## 1.14.1 (April 6th, 2006) ##

*   Fix type_name_with_module to handle type names that begin with '::'. Closes #4614. *Nicholas Seckar*

*   Fixed that that multiparameter assignment doesn't work with aggregations (closes #4620) *Lars Pind*

*   Enable Limit/Offset in Calculations (closes #4558) *lmarlow*

*   Fixed that loading including associations returns all results if Load IDs For Limited Eager Loading returns none (closes #4528) *Rick Olson*

*   Fixed HasManyAssociation#find bugs when :finder_sql is set #4600 *lagroue@free.fr*

*   Allow AR::Base#respond_to? to behave when @attributes is nil *Ryan Davis*

*   Support eager includes when going through a polymorphic has_many association. *Rick Olson*

*   Added support for eagerly including polymorphic has_one associations. (closes #4525) *Rick Olson*

        class Post < ActiveRecord::Base
          has_one :tagging, :as => :taggable
        end

        Post.find :all, :include => :tagging

*   Added descriptive error messages for invalid has_many :through associations: going through :has_one or :has_and_belongs_to_many *Rick Olson*

*   Added support for going through a polymorphic has_many association: (closes #4401) *Rick Olson*

        class PhotoCollection < ActiveRecord::Base
          has_many :photos, :as => :photographic
          belongs_to :firm
        end

        class Firm < ActiveRecord::Base
          has_many :photo_collections
          has_many :photos, :through => :photo_collections
        end

*   Multiple fixes and optimizations in PostgreSQL adapter, allowing ruby-postgres gem to work properly. *ruben.nine@gmail.com*

*   Fixed that AssociationCollection#delete_all should work even if the records of the association are not loaded yet. *Florian Weber*

*   Changed those private ActiveRecord methods to take optional third argument :auto instead of nil for performance optimizations.  (closes #4456) *Stefan*

*   Private ActiveRecord methods add_limit!, add_joins!, and add_conditions! take an OPTIONAL third argument 'scope' (closes #4456) *Rick Olson*

*   DEPRECATED: Using additional attributes on has_and_belongs_to_many associations. Instead upgrade your association to be a real join model *David Heinemeier Hansson*

*   Fixed that records returned from has_and_belongs_to_many associations with additional attributes should be marked as read only (fixes #4512) *David Heinemeier Hansson*

*   Do not implicitly mark recordss of has_many :through as readonly but do mark habtm records as readonly (eventually only on join tables without rich attributes). *Marcel Mollina Jr.*

*   Fixed broken OCIAdapter #4457 *Michael Schoen*


## 1.14.0 (March 27th, 2006) ##

*   Replace 'rescue Object' with a finer grained rescue. Closes #4431. *Nicholas Seckar*

*   Fixed eager loading so that an aliased table cannot clash with a has_and_belongs_to_many join table *Rick Olson*

*   Add support for :include to with_scope *andrew@redlinesoftware.com*

*   Support the use of public synonyms with the Oracle adapter; required ruby-oci8 v0.1.14 #4390 *Michael Schoen*

*   Change periods (.) in table aliases to _'s.  Closes #4251 *jeff@ministrycentered.com*

*   Changed has_and_belongs_to_many join to INNER JOIN for Mysql 3.23.x.  Closes #4348 *Rick Olson*

*   Fixed issue that kept :select options from being scoped *Rick Olson*

*   Fixed db_schema_import when binary types are present #3101 *David Heinemeier Hansson*

*   Fixed that MySQL enums should always be returned as strings #3501 *David Heinemeier Hansson*

*   Change has_many :through to use the :source option to specify the source association.  :class_name is now ignored. *Rick Olson*

        class Connection < ActiveRecord::Base
          belongs_to :user
          belongs_to :channel
        end

        class Channel < ActiveRecord::Base
          has_many :connections
          has_many :contacts, :through => :connections, :class_name => 'User' # OLD
          has_many :contacts, :through => :connections, :source => :user      # NEW
        end

*   Fixed DB2 adapter so nullable columns will be determines correctly now and quotes from column default values will be removed #4350 *contact@maik-schmidt.de*

*   Allow overriding of find parameters in scoped has_many :through calls *Rick Olson*

    In this example, :include => false disables the default eager association from loading.  :select changes the standard
    select clause.  :joins specifies a join that is added to the end of the has_many :through query.

        class Post < ActiveRecord::Base
          has_many :tags, :through => :taggings, :include => :tagging do
            def add_joins_and_select
              find :all, :select => 'tags.*, authors.id as author_id', :include => false,
                :joins => 'left outer join posts on taggings.taggable_id = posts.id left outer join authors on posts.author_id = authors.id'
            end
          end
        end

*   Fixed that schema changes while the database was open would break any connections to an SQLite database (now we reconnect if that error is throw) *David Heinemeier Hansson*

*   Don't classify the has_one class when eager loading, it is already singular. Add tests. (closes #4117) *Jonathan Viney*

*   Quit ignoring default :include options in has_many :through calls *Mark James*

*   Allow has_many :through associations to find the source association by setting a custom class (closes #4307) *Jonathan Viney*

*   Eager Loading support added for has_many :through => :has_many associations (see below).  *Rick Olson*

*   Allow has_many :through to work on has_many associations (closes #3864) [sco@scottraymond.net]  Example:

        class Firm < ActiveRecord::Base
          has_many :clients
          has_many :invoices, :through => :clients
        end

        class Client < ActiveRecord::Base
          belongs_to :firm
          has_many   :invoices
        end

        class Invoice < ActiveRecord::Base
          belongs_to :client
        end

*   Raise error when trying to select many polymorphic objects with has_many :through or :include (closes #4226) *Josh Susser*

*   Fixed has_many :through to include :conditions set on the :through association. closes #4020 *Jonathan Viney*

*   Fix that has_many :through honors the foreign key set by the belongs_to association in the join model (closes #4259) *andylien@gmail.com / Rick Olson*

*   SQL Server adapter gets some love #4298 *Ryan Tomayko*

*   Added OpenBase database adapter that builds on top of the http://www.spice-of-life.net/ruby-openbase/ driver. All functionality except LIMIT/OFFSET is supported #3528 *derrickspell@cdmplus.com*

*   Rework table aliasing to account for truncated table aliases.  Add smarter table aliasing when doing eager loading of STI associations. This allows you to use the association name in the order/where clause. [Jonathan Viney / Rick Olson] #4108 Example (SpecialComment is using STI):

        Author.find(:all, :include => { :posts => :special_comments }, :order => 'special_comments.body')

*   Add AbstractAdapter#table_alias_for to create table aliases according to the rules of the current adapter. *Rick Olson*

*   Provide access to the underlying database connection through Adapter#raw_connection. Enables the use of db-specific methods without complicating the adapters. #2090 *Michael Koziarski*

*   Remove broken attempts at handling columns with a default of 'now()' in the postgresql adapter. #2257 *Michael Koziarski*

*   Added connection#current_database that'll return of the current database (only works in MySQL, SQL Server, and Oracle so far -- please help implement for the rest of the adapters) #3663 *Tom Ward*

*   Fixed that Migration#execute would have the table name prefix appended to its query #4110 *mark.imbriaco@pobox.com*

*   Make all tinyint(1) variants act like boolean in mysql (tinyint(1) unsigned, etc.) *Jamis Buck*

*   Use association's :conditions when eager loading. [Jeremy Evans] #4144

*   Alias the has_and_belongs_to_many join table on eager includes. #4106 *Jeremy Evans*

    This statement would normally error because the projects_developers table is joined twice, and therefore joined_on would be ambiguous.

        Developer.find(:all, :include => {:projects => :developers}, :conditions => 'join_project_developers.joined_on IS NOT NULL')

*   Oracle adapter gets some love #4230 *Michael Schoen*

        * Changes :text to CLOB rather than BLOB [Moses Hohman]
        * Fixes an issue with nil numeric length/scales (several)
        * Implements support for XMLTYPE columns [wilig / Kubo Takehiro]
        * Tweaks a unit test to get it all green again
        * Adds support for #current_database

*   Added Base.abstract_class? that marks which classes are not part of the Active Record hierarchy #3704 *Rick Olson*

        class CachedModel < ActiveRecord::Base
          self.abstract_class = true
        end

        class Post < CachedModel
        end

        CachedModel.abstract_class?
        => true

        Post.abstract_class?
        => false

        Post.base_class
        => Post

        Post.table_name
        => 'posts'

*   Allow :dependent options to be used with polymorphic joins. #3820 *Rick Olson*

        class Foo < ActiveRecord::Base
          has_many :attachments, :as => :attachable, :dependent => :delete_all
        end

*   Nicer error message on has_many :through when :through reflection can not be found. #4042 *court3nay*

*   Upgrade to Transaction::Simple 1.3 *Jamis Buck*

*   Catch FixtureClassNotFound when using instantiated fixtures on a fixture that has no ActiveRecord model *Rick Olson*

*   Allow ordering of calculated results and/or grouped fields in calculations *solo@gatelys.com*

*   Make ActiveRecord::Base#save! return true instead of nil on success.  #4173 *johan@johansorensen.com*

*   Dynamically set allow_concurrency.  #4044 *Stefan Kaes*

*   Added Base#to_xml that'll turn the current record into a XML representation [David Heinemeier Hansson]. Example:

        topic.to_xml

    ...returns:

        <?xml version="1.0" encoding="UTF-8"?>
        <topic>
          <title>The First Topic</title>
          <author-name>David</author-name>
          <id type="integer">1</id>
          <approved type="boolean">false</approved>
          <replies-count type="integer">0</replies-count>
          <bonus-time type="datetime">2000-01-01 08:28:00</bonus-time>
          <written-on type="datetime">2003-07-16 09:28:00</written-on>
          <content>Have a nice day</content>
          <author-email-address>david@loudthinking.com</author-email-address>
          <parent-id></parent-id>
          <last-read type="date">2004-04-15</last-read>
        </topic>

    ...and you can configure with:

        topic.to_xml(:skip_instruct => true, :except => [ :id, bonus_time, :written_on, replies_count ])

    ...that'll return:

        <topic>
          <title>The First Topic</title>
          <author-name>David</author-name>
          <approved type="boolean">false</approved>
          <content>Have a nice day</content>
          <author-email-address>david@loudthinking.com</author-email-address>
          <parent-id></parent-id>
          <last-read type="date">2004-04-15</last-read>
        </topic>

    You can even do load first-level associations as part of the document:

        firm.to_xml :include => [ :account, :clients ]

    ...that'll return something like:

        <?xml version="1.0" encoding="UTF-8"?>
        <firm>
          <id type="integer">1</id>
          <rating type="integer">1</rating>
          <name>37signals</name>
          <clients>
            <client>
              <rating type="integer">1</rating>
              <name>Summit</name>
            </client>
            <client>
              <rating type="integer">1</rating>
              <name>Microsoft</name>
            </client>
          </clients>
          <account>
            <id type="integer">1</id>
            <credit-limit type="integer">50</credit-limit>
          </account>
        </firm>

*   Allow :counter_cache to take a column name for custom counter cache columns *Jamis Buck*

*   Documentation fixes for :dependent *robby@planetargon.com*

*   Stop the MySQL adapter crashing when views are present. #3782 *Jonathan Viney*

*   Don't classify the belongs_to class, it is already singular #4117 *keithm@infused.org*

*   Allow set_fixture_class to take Classes instead of strings for a class in a module.  Raise FixtureClassNotFound if a fixture can't load.  *Rick Olson*

*   Fix quoting of inheritance column for STI eager loading #4098 *Jonathan Viney <jonathan@bluewire.net.nz>*

*   Added smarter table aliasing for eager associations for multiple self joins #3580 *Rick Olson*

        * The first time a table is referenced in a join, no alias is used.
        * After that, the parent class name and the reflection name are used.

            Tree.find(:all, :include => :children) # LEFT OUTER JOIN trees AS tree_children ...

        * Any additional join references get a numerical suffix like '_2', '_3', etc.

*   Fixed eager loading problems with single-table inheritance #3580 [Rick Olson]. Post.find(:all, :include => :special_comments) now returns all posts, and any special comments that the posts may have. And made STI work with has_many :through and polymorphic belongs_to.

*   Added cascading eager loading that allows for queries like Author.find(:all, :include=> { :posts=> :comments }), which will fetch all authors, their posts, and the comments belonging to those posts in a single query (using LEFT OUTER JOIN) #3913 [anna@wota.jp]. Examples:

        # cascaded in two levels
        >> Author.find(:all, :include=>{:posts=>:comments})
        => authors
             +- posts
                  +- comments

        # cascaded in two levels and normal association
        >> Author.find(:all, :include=>[{:posts=>:comments}, :categorizations])
        => authors
             +- posts
                  +- comments
             +- categorizations

        # cascaded in two levels with two has_many associations
        >> Author.find(:all, :include=>{:posts=>[:comments, :categorizations]})
        => authors
             +- posts
                  +- comments
                  +- categorizations

        # cascaded in three levels
        >> Company.find(:all, :include=>{:groups=>{:members=>{:favorites}}})
        => companies
             +- groups
                  +- members
                       +- favorites

*   Make counter cache work when replacing an association #3245 *eugenol@gmail.com*

*   Make migrations verbose *Jamis Buck*

*   Make counter_cache work with polymorphic belongs_to *Jamis Buck*

*   Fixed that calling HasOneProxy#build_model repeatedly would cause saving to happen #4058 *anna@wota.jp*

*   Added Sybase database adapter that relies on the Sybase Open Client bindings (see http://raa.ruby-lang.org/project/sybase-ctlib) #3765 [John Sheets]. It's almost completely Active Record compliant (including migrations), but has the following caveats:

        * Does not support DATE SQL column types; use DATETIME instead.
        * Date columns on HABTM join tables are returned as String, not Time.
        * Insertions are potentially broken for :polymorphic join tables
        * BLOB column access not yet fully supported

*   Clear stale, cached connections left behind by defunct threads. *Jeremy Kemper*

*   CHANGED DEFAULT: set ActiveRecord::Base.allow_concurrency to false.  Most AR usage is in single-threaded applications. *Jeremy Kemper*

*   Renamed the "oci" adapter to "oracle", but kept the old name as an alias #4017 *Michael Schoen*

*   Fixed that Base.save should always return false if the save didn't succeed, including if it has halted by before_save's #1861, #2477 *David Heinemeier Hansson*

*   Speed up class -> connection caching and stale connection verification.  #3979 *Stefan Kaes*

*   Add set_fixture_class to allow the use of table name accessors with models which use set_table_name. *Kevin Clark*

*   Added that fixtures to placed in subdirectories of the main fixture files are also loaded #3937 *dblack@wobblini.net*

*   Define attribute query methods to avoid method_missing calls. #3677 *Jonathan Viney*

*   ActiveRecord::Base.remove_connection explicitly closes database connections and doesn't corrupt the connection cache. Introducing the disconnect! instance method for the PostgreSQL, MySQL, and SQL Server adapters; implementations for the others are welcome.  #3591 *Simon Stapleton, Tom Ward*

*   Added support for nested scopes #3407 [anna@wota.jp]. Examples:

        Developer.with_scope(:find => { :conditions => "salary > 10000", :limit => 10 }) do
          Developer.find(:all)     # => SELECT * FROM developers WHERE (salary > 10000) LIMIT 10

          # inner rule is used. (all previous parameters are ignored)
          Developer.with_exclusive_scope(:find => { :conditions => "name = 'Jamis'" }) do
            Developer.find(:all)   # => SELECT * FROM developers WHERE (name = 'Jamis')
          end

          # parameters are merged
          Developer.with_scope(:find => { :conditions => "name = 'Jamis'" }) do
            Developer.find(:all)   # => SELECT * FROM developers WHERE (( salary > 10000 ) AND ( name = 'Jamis' )) LIMIT 10
          end
        end

*   Fixed db2 connection with empty user_name and auth options #3622 *phurley@gmail.com*

*   Fixed validates_length_of to work on UTF-8 strings by using characters instead of bytes #3699 *Masao Mutoh*

*   Fixed that reflections would bleed across class boundaries in single-table inheritance setups #3796 *Lars Pind*

*   Added calculations: Base.count, Base.average, Base.sum, Base.minimum, Base.maxmium, and the generic Base.calculate. All can be used with :group and :having. Calculations and statitics need no longer require custom SQL. #3958 [Rick Olson]. Examples:

        Person.average :age
        Person.minimum :age
        Person.maximum :age
        Person.sum :salary, :group => :last_name

*   Renamed Errors#count to Errors#size but kept an alias for the old name (and included an alias for length too) #3920 *Luke Redpath*

*   Reflections don't attempt to resolve module nesting of association classes. Simplify type computation. *Jeremy Kemper*

*   Improved the Oracle OCI Adapter with better performance for column reflection (from #3210), fixes to migrations (from #3476 and #3742), tweaks to unit tests (from #3610), and improved documentation (from #2446) #3879 *Aggregated by schoenm@earthlink.net*

*   Fixed that the schema_info table used by ActiveRecord::Schema.define should respect table pre- and suffixes #3834 *rubyonrails@atyp.de*

*   Added :select option to Base.count that'll allow you to select something else than * to be counted on. Especially important for count queries using DISTINCT #3839 *Stefan Kaes*

*   Correct syntax error in mysql DDL,  and make AAACreateTablesTest run first *Bob Silva*

*   Allow :include to be used with has_many :through associations #3611 *Michael Schoen*

*   PostgreSQL: smarter schema dumps using pk_and_sequence_for(table).  #2920 *Blair Zajac*

*   SQLServer: more compatible limit/offset emulation.  #3779 *Tom Ward*

*   Polymorphic join support for has_one associations (has_one :foo, :as => :bar)  #3785 *Rick Olson*

*   PostgreSQL: correctly parse negative integer column defaults.  #3776 *bellis@deepthought.org*

*   Fix problems with count when used with :include *Jeremy Hopple and Kevin Clark*

*   ActiveRecord::RecordInvalid now states which validations failed in its default error message *Tobias Lütke*

*   Using AssociationCollection#build with arrays of hashes should call build, not create *David Heinemeier Hansson*

*   Remove definition of reloadable? from ActiveRecord::Base to make way for new Reloadable code. *Nicholas Seckar*

*   Fixed schema handling for DB2 adapter that didn't work: an initial schema could be set, but it wasn't used when getting tables and indexes #3678 *Maik Schmidt*

*   Support the :column option for remove_index with the PostgreSQL adapter. #3661 *Shugo Maeda*

*   Add documentation for add_index and remove_index. #3600 *Manfred Stienstra <m.stienstra@fngtps.com>*

*   If the OCI library is not available, raise an exception indicating as much. #3593 *Michael Schoen*

*   Add explicit :order in finder tests as postgresql orders results differently by default. #3577. *Rick Olson*

*   Make dynamic finders honor additional passed in :conditions. #3569 *Oleg Pudeyev <pudeyo@rpi.edu>, Marcel Molina Jr.*

*   Show a meaningful error when the DB2 adapter cannot be loaded due to missing dependencies. *Nicholas Seckar*

*   Make .count work for has_many associations with multi line finder sql *Michael Schoen*

*   Add AR::Base.base_class for querying the ancestor AR::Base subclass *Jamis Buck*

*   Allow configuration of the column used for optimistic locking *wilsonb@gmail.com*

*   Don't hardcode 'id' in acts as list.  *ror@philippeapril.com*

*   Fix date errors for SQLServer in association tests. #3406 *Kevin Clark*

*   Escape database name in MySQL adapter when creating and dropping databases. #3409 *anna@wota.jp*

*   Disambiguate table names for columns in validates_uniqueness_of's WHERE clause. #3423 *alex.borovsky@gmail.com*

*   .with_scope imposed create parameters now bypass attr_protected *Tobias Lütke*

*   Don't raise an exception when there are more keys than there are named bind variables when sanitizing conditions. *Marcel Molina Jr.*

*   Multiple enhancements and adjustments to DB2 adaptor. #3377 *contact@maik-schmidt.de*

*   Sanitize scoped conditions. *Marcel Molina Jr.*

*   Added option to Base.reflection_of_all_associations to specify a specific association to scope the call. For example Base.reflection_of_all_associations(:has_many) *David Heinemeier Hansson*

*   Added ActiveRecord::SchemaDumper.ignore_tables which tells SchemaDumper which tables to ignore. Useful for tables with funky column like the ones required for tsearch2. *Tobias Lütke*

*   SchemaDumper now doesn't fail anymore when there are unknown column types in the schema. Instead the table is ignored and a Comment is left in the schema.rb. *Tobias Lütke*

*   Fixed that saving a model with multiple habtm associations would only save the first one.  #3244 *yanowitz-rubyonrails@quantumfoam.org, Florian Weber*

*   Fix change_column to work with PostgreSQL 7.x and 8.x.  #3141 *wejn@box.cz, Rick Olson, Scott Barron*

*   removed :piggyback in favor of just allowing :select on :through associations. *Tobias Lütke*

*   made method missing delegation to class methods on relation target work on :through associations. *Tobias Lütke*

*   made .find() work on :through relations. *Tobias Lütke*

*   Fix typo in association docs. #3296. *Blair Zajac*

*   Fixed :through relations when using STI inherited classes would use the inherited class's name as foreign key on the join model *Tobias Lütke*

## 1.13.2 (December 13th, 2005) ##

*   Become part of Rails 1.0

*   MySQL: allow encoding option for mysql.rb driver.  *Jeremy Kemper*

*   Added option inheritance for find calls on has_and_belongs_to_many and has_many assosociations [David Heinemeier Hansson]. Example:

        class Post
          has_many :recent_comments, :class_name => "Comment", :limit => 10, :include => :author
        end

        post.recent_comments.find(:all) # Uses LIMIT 10 and includes authors
        post.recent_comments.find(:all, :limit => nil) # Uses no limit but include authors
        post.recent_comments.find(:all, :limit => nil, :include => nil) # Uses no limit and doesn't include authors

*   Added option to specify :group, :limit, :offset, and :select options from find on has_and_belongs_to_many and has_many assosociations *David Heinemeier Hansson*

*   MySQL: fixes for the bundled mysql.rb driver.  #3160 *Justin Forder*

*   SQLServer: fix obscure optimistic locking bug.  #3068 *kajism@yahoo.com*

*   SQLServer: support uniqueidentifier columns.  #2930 *keithm@infused.org*

*   SQLServer: cope with tables names qualified by owner.  #3067 *jeff@ministrycentered.com*

*   SQLServer: cope with columns with "desc" in the name.  #1950 *Ron Lusk, Ryan Tomayko*

*   SQLServer: cope with primary keys with "select" in the name.  #3057 *rdifrango@captechventures.com*

*   Oracle: active? performs a select instead of a commit.  #3133 *Michael Schoen*

*   MySQL: more robust test for nullified result hashes.  #3124 *Stefan Kaes*

*   Reloading an instance refreshes its aggregations as well as its associations.  #3024 *François Beausoleil*

*   Fixed that using :include together with :conditions array in Base.find would cause NoMethodError #2887 *Paul Hammmond*

*   PostgreSQL: more robust sequence name discovery.  #3087 *Rick Olson*

*   Oracle: use syntax compatible with Oracle 8.  #3131 *Michael Schoen*

*   MySQL: work around ruby-mysql/mysql-ruby inconsistency with mysql.stat.  Eliminate usage of mysql.ping because it doesn't guarantee reconnect.  Explicitly close and reopen the connection instead.  *Jeremy Kemper*

*   Added preliminary support for polymorphic associations *David Heinemeier Hansson*

*   Added preliminary support for join models *David Heinemeier Hansson*

*   Allow validate_uniqueness_of to be scoped by more than just one column.  #1559. *jeremy@jthopple.com, Marcel Molina Jr.*

*   Firebird: active? and reconnect! methods for handling stale connections.  #428 *Ken Kunz <kennethkunz@gmail.com>*

*   Firebird: updated for FireRuby 0.4.0.  #3009 *Ken Kunz <kennethkunz@gmail.com>*

*   MySQL and PostgreSQL: active? compatibility with the pure-Ruby driver.  #428 *Jeremy Kemper*

*   Oracle: active? check pings the database rather than testing the last command status.  #428 *Michael Schoen*

*   SQLServer: resolve column aliasing/quoting collision when using limit or offset in an eager find.  #2974 *kajism@yahoo.com*

*   Reloading a model doesn't lose track of its connection.  #2996 *junk@miriamtech.com, Jeremy Kemper*

*   Fixed bug where using update_attribute after pushing a record to a habtm association of the object caused duplicate rows in the join table. #2888 *colman@rominato.com, Florian Weber, Michael Schoen*

*   MySQL, PostgreSQL: reconnect! also reconfigures the connection.  Otherwise, the connection 'loses' its settings if it times out and is reconnected.  #2978 *Shugo Maeda*

*   has_and_belongs_to_many: use JOIN instead of LEFT JOIN.  *Jeremy Kemper*

*   MySQL: introduce :encoding option to specify the character set for client, connection, and results.  Only available for MySQL 4.1 and later with the mysql-ruby driver.  Do SHOW CHARACTER SET in mysql client to see available encodings.  #2975 *Shugo Maeda*

*   Add tasks to create, drop and rebuild the MySQL and PostgreSQL test  databases. *Marcel Molina Jr.*

*   Correct boolean handling in generated reader methods.  #2945 *Don Park, Stefan Kaes*

*   Don't generate read methods for columns whose names are not valid ruby method names.  #2946 *Stefan Kaes*

*   Document :force option to create_table.  #2921 *Blair Zajac <blair@orcaware.com>*

*   Don't add the same conditions twice in has_one finder sql.  #2916 *Jeremy Evans*

*   Rename Version constant to VERSION. #2802 *Marcel Molina Jr.*

*   Introducing the Firebird adapter.  Quote columns and use attribute_condition more consistently.  Setup guide: http://wiki.rubyonrails.com/rails/pages/Firebird+Adapter  #1874 *Ken Kunz <kennethkunz@gmail.com>*

*   SQLServer: active? and reconnect! methods for handling stale connections.  #428 *kajism@yahoo.com, Tom Ward <tom@popdog.net>*

*   Associations handle case-equality more consistently: item.parts.is_a?(Array) and item.parts === Array.  #1345 *MarkusQ@reality.com*

*   SQLServer: insert uses given primary key value if not nil rather than SELECT @@IDENTITY.  #2866 *kajism@yahoo.com, Tom Ward <tom@popdog.net>*

*   Oracle: active? and reconnect! methods for handling stale connections.  Optionally retry queries after reconnect.  #428 *Michael Schoen <schoenm@earthlink.net>*

*   Correct documentation for Base.delete_all.  #1568 *Newhydra*

*   Oracle: test case for column default parsing.  #2788 *Michael Schoen <schoenm@earthlink.net>*

*   Update documentation for Migrations.  #2861 *Tom Werner <tom@cube6media.com>*

*   When AbstractAdapter#log rescues an exception, attempt to detect and reconnect to an inactive database connection.  Connection adapter must respond to the active? and reconnect! instance methods.  Initial support for PostgreSQL, MySQL, and SQLite.  Make certain that all statements which may need reconnection are performed within a logged block: for example, this means no avoiding log(sql, name) { } if @logger.nil?  #428 *Jeremy Kemper*

*   Oracle: Much faster column reflection.  #2848 *Michael Schoen <schoenm@earthlink.net>*

*   Base.reset_sequence_name analogous to reset_table_name (mostly useful for testing).  Base.define_attr_method allows nil values.  *Jeremy Kemper*

*   PostgreSQL: smarter sequence name defaults, stricter last_insert_id, warn on pk without sequence.  *Jeremy Kemper*

*   PostgreSQL: correctly discover custom primary key sequences.  #2594 *Blair Zajac <blair@orcaware.com>, meadow.nnick@gmail.com, Jeremy Kemper*

*   SQLServer: don't report limits for unsupported field types.  #2835 *Ryan Tomayko*

*   Include the Enumerable module in ActiveRecord::Errors.  *Rick Bradley <rick@rickbradley.com>*

*   Add :group option, correspond to GROUP BY, to the find method and to the has_many association.  #2818 *rubyonrails@atyp.de*

*   Don't cast nil or empty strings to a dummy date.  #2789 *Rick Bradley <rick@rickbradley.com>*

*   acts_as_list plays nicely with inheritance by remembering the class which declared it.  #2811 *rephorm@rephorm.com*

*   Fix sqlite adaptor's detection of missing dbfile or database declaration. *Nicholas Seckar*

*   Fixed acts_as_list for definitions without an explicit :order #2803 *Jonathan Viney*

*   Upgrade bundled ruby-mysql 0.2.4 with mysql411 shim (see #440) to ruby-mysql 0.2.6 with a patchset for 4.1 protocol support.  Local change [301] is now a part of the main driver; reapplied local change [2182].  Removed GC.start from Result.free.  *tommy@tmtm.org, akuroda@gmail.com, Doug Fales <doug.fales@gmail.com>, Jeremy Kemper*

*   Correct handling of complex order clauses with SQL Server limit emulation.  #2770 *Tom Ward <tom@popdog.net>, Matt B.*

*   Correct whitespace problem in Oracle default column value parsing.  #2788 *rick@rickbradley.com*

*   Destroy associated has_and_belongs_to_many records after all before_destroy callbacks but before destroy.  This allows you to act on the habtm association as you please while preserving referential integrity.  #2065 *larrywilliams1@gmail.com, sam.kirchmeier@gmail.com, elliot@townx.org, Jeremy Kemper*

*   Deprecate the old, confusing :exclusively_dependent option in favor of :dependent => :delete_all.  *Jeremy Kemper*

*   More compatible Oracle column reflection.  #2771 *Ryan Davis <ryand-ruby@zenspider.com>, Michael Schoen <schoenm@earthlink.net>*


## 1.13.0 (November 7th, 2005) ##

*   Fixed faulty regex in get_table_name method (SQLServerAdapter) #2639 *Ryan Tomayko*

*   Added :include as an option for association declarations [David Heinemeier Hansson]. Example:

        has_many :posts, :include => [ :author, :comments ]

*   Rename Base.constrain to Base.with_scope so it doesn't conflict with existing concept of database constraints.  Make scoping more robust: uniform method => parameters, validated method names and supported finder parameters, raise exception on nested scopes.  [Jeremy Kemper]  Example:

        Comment.with_scope(:find => { :conditions => 'active=true' }, :create => { :post_id => 5 }) do
          # Find where name = ? and active=true
          Comment.find :all, :conditions => ['name = ?', name]
          # Create comment associated with :post_id
          Comment.create :body => "Hello world"
        end

*   Fixed that SQL Server should ignore :size declarations on anything but integer and string in the agnostic schema representation #2756 *Ryan Tomayko*

*   Added constrain scoping for creates using a hash of attributes bound to the :creation key [David Heinemeier Hansson]. Example:

        Comment.constrain(:creation => { :post_id => 5 }) do
          # Associated with :post_id
          Comment.create :body => "Hello world"
        end

    This is rarely used directly, but allows for find_or_create on associations. So you can do:

        # If the tag doesn't exist, a new one is created that's associated with the person
        person.tags.find_or_create_by_name("Summer")

*   Added find_or_create_by_X as a second type of dynamic finder that'll create the record if it doesn't already exist [David Heinemeier Hansson]. Example:

        # No 'Summer' tag exists
        Tag.find_or_create_by_name("Summer") # equal to Tag.create(:name => "Summer")

        # Now the 'Summer' tag does exist
        Tag.find_or_create_by_name("Summer") # equal to Tag.find_by_name("Summer")

*   Added extension capabilities to has_many and has_and_belongs_to_many proxies [David Heinemeier Hansson]. Example:

        class Account < ActiveRecord::Base
          has_many :people do
            def find_or_create_by_name(name)
              first_name, *last_name = name.split
              last_name = last_name.join " "

              find_or_create_by_first_name_and_last_name(first_name, last_name)
            end
          end
        end

        person = Account.find(:first).people.find_or_create_by_name("David Heinemeier Hansson")
        person.first_name # => "David"
        person.last_name  # => "Heinemeier Hansson"

    Note that the anoymous module must be declared using brackets, not do/end (due to order of evaluation).

*   Omit internal dtproperties table from SQLServer table list.  #2729 *Ryan Tomayko*

*   Quote column names in generated SQL.  #2728 *Ryan Tomayko*

*   Correct the pure-Ruby MySQL 4.1.1 shim's version test.  #2718 *Jeremy Kemper*

*   Add Model.create! to match existing model.save! method.  When save! raises RecordInvalid, you can catch the exception, retrieve the invalid record (invalid_exception.record), and see its errors (invalid_exception.record.errors).  *Jeremy Kemper*

*   Correct fixture behavior when table name pluralization is off.  #2719 *Rick Bradley <rick@rickbradley.com>*

*   Changed :dbfile to :database for SQLite adapter for consistency (old key still works as an alias) #2644 *Dan Peterson*

*   Added migration support for Oracle #2647 *Michael Schoen*

*   Worked around that connection can't be reset if allow_concurrency is off.  #2648 *Michael Schoen <schoenm@earthlink.net>*

*   Fixed SQL Server adapter to pass even more tests and do even better #2634 *Ryan Tomayko*

*   Fixed SQL Server adapter so it honors options[:conditions] when applying :limits #1978 *Tom Ward*

*   Added migration support to SQL Server adapter (please someone do the same for Oracle and DB2) #2625 *Tom Ward*

*   Use AR::Base.silence rather than AR::Base.logger.silence in fixtures to preserve Log4r compatibility.  #2618 *dansketcher@gmail.com*

*   Constraints are cloned so they can't be inadvertently modified while they're
    in effect.  Added :readonly finder constraint.  Calling an association collection's class method (Part.foobar via item.parts.foobar) constrains :readonly => false since the collection's :joins constraint would otherwise force it to true.  *Jeremy Kemper <rails@bitsweat.net>*

*   Added :offset and :limit to the kinds of options that Base.constrain can use #2466 *duane.johnson@gmail.com*

*   Fixed handling of nil number columns on Oracle and cleaned up tests for Oracle in general #2555 *Michael Schoen*

*   Added quoted_true and quoted_false methods and tables to db2_adapter and cleaned up tests for DB2 #2493, #2624 *maik schmidt*


## 1.12.2 (October 26th, 2005) ##

*   Allow symbols to rename columns when using SQLite adapter. #2531 *Kevin Clark*

*   Map Active Record time to SQL TIME.  #2575, #2576 *Robby Russell <robby@planetargon.com>*

*   Clarify semantics of ActiveRecord::Base#respond_to?  #2560 *Stefan Kaes*

*   Fixed Association#clear for associations which have not yet been accessed. #2524 *Patrick Lenz <patrick@lenz.sh>*

*   HABTM finders shouldn't return readonly records.  #2525 *Patrick Lenz <patrick@lenz.sh>*

*   Make all tests runnable on their own. #2521. *Blair Zajac <blair@orcaware.com>*


## 1.12.1 (October 19th, 2005) ##

*   Always parenthesize :conditions options so they may be safely combined with STI and constraints.

*   Correct PostgreSQL primary key sequence detection.  #2507 *tmornini@infomania.com*

*   Added support for using limits in eager loads that involve has_many and has_and_belongs_to_many associations


## 1.12.0 (October 16th, 2005) ##

*   Update/clean up documentation (rdoc)

*   PostgreSQL sequence support.  Use set_sequence_name in your model class to specify its primary key sequence.  #2292 *Rick Olson <technoweenie@gmail.com>, Robby Russell <robby@planetargon.com>*

*   Change default logging colors to work on both white and black backgrounds. *Sam Stephenson*

*   YAML fixtures support ordered hashes for fixtures with foreign key dependencies in the same table.  #1896 *purestorm@ggnore.net*

*   :dependent now accepts :nullify option. Sets the foreign key of the related objects to NULL instead of deleting them. #2015 *Robby Russell <robby@planetargon.com>*

*   Introduce read-only records.  If you call object.readonly! then it will mark the object as read-only and raise ReadOnlyRecord if you call object.save.  object.readonly? reports whether the object is read-only.  Passing :readonly => true to any finder method will mark returned records as read-only.  The :joins option now implies :readonly, so if you use this option, saving the same record will now fail.  Use find_by_sql to work around.

*   Avoid memleak in dev mode when using fcgi

*   Simplified .clear on active record associations by using the existing delete_records method. #1906 *Caleb <me@cpb.ca>*

*   Delegate access to a customized primary key to the conventional id method. #2444. *Blair Zajac <blair@orcaware.com>*

*   Fix errors caused by assigning a has-one or belongs-to property to itself

*   Add ActiveRecord::Base.schema_format setting which specifies how databases should be dumped *Sam Stephenson*

*   Update DB2 adapter. #2206. *contact@maik-schmidt.de*

*   Corrections to SQLServer native data types. #2267.  *rails.20.clarry@spamgourmet.com*

*   Deprecated ActiveRecord::Base.threaded_connection in favor of ActiveRecord::Base.allow_concurrency.

*   Protect id attribute from mass assigment even when the primary key is set to something else. #2438. *Blair Zajac <blair@orcaware.com>*

*   Misc doc fixes (typos/grammar/etc.). #2430. *coffee2code*

*   Add test coverage for content_columns. #2432. *coffee2code*

*   Speed up for unthreaded environments. #2431. *Stefan Kaes*

*   Optimization for Mysql selects using mysql-ruby extension greater than 2.6.3.  #2426. *Stefan Kaes*

*   Speed up the setting of table_name. #2428. *Stefan Kaes*

*   Optimize instantiation of STI subclass records. In partial fullfilment of #1236. *Stefan Kaes*

*   Fix typo of 'constrains' to 'contraints'. #2069. *Michael Schuerig <michael@schuerig.de>*

*   Optimization refactoring for add_limit_offset!. In partial fullfilment of #1236. *Stefan Kaes*

*   Add ability to get all siblings, including the current child, with acts_as_tree. Recloses #2140. *Michael Schuerig <michael@schuerig.de>*

*   Add geometric type for postgresql adapter. #2233 *Andrew Kaspick*

*   Add option (true by default) to generate reader methods for each attribute of a record to avoid the overhead of calling method missing. In partial fullfilment of #1236. *Stefan Kaes*

*   Add convenience predicate methods on Column class. In partial fullfilment of #1236. *Stefan Kaes*

*   Raise errors when invalid hash keys are passed to ActiveRecord::Base.find. #2363  *Chad Fowler <chad@chadfowler.com>, Nicholas Seckar*

*   Added :force option to create_table that'll try to drop the table if it already exists before creating

*   Fix transactions so that calling return while inside a transaction will not leave an open transaction on the connection. *Nicholas Seckar*

*   Use foreign_key inflection uniformly.  #2156 *Blair Zajac <blair@orcaware.com>*

*   model.association.clear should destroy associated objects if :dependent => true instead of nullifying their foreign keys.  #2221 *joergd@pobox.com, ObieFernandez <obiefernandez@gmail.com>*

*   Returning false from before_destroy should cancel the action.  #1829 *Jeremy Huffman*

*   Recognize PostgreSQL NOW() default as equivalent to CURRENT_TIMESTAMP or CURRENT_DATE, depending on the column's type.  #2256 *mat <mat@absolight.fr>*

*   Extensive documentation for the abstract database adapter.  #2250 *François Beausoleil <fbeausoleil@ftml.net>*

*   Clean up Fixtures.reset_sequences for PostgreSQL.  Handle tables with no rows and models with custom primary keys.  #2174, #2183 *jay@jay.fm, Blair Zajac <blair@orcaware.com>*

*   Improve error message when nil is assigned to an attr which validates_size_of within a range.  #2022 *Manuel Holtgrewe <purestorm@ggnore.net>*

*   Make update_attribute use the same writer method that update_attributes uses.
    \#2237 *trevor@protocool.com*

*   Make migrations honor table name prefixes and suffixes. #2298 *Jakob Skjerning, Marcel Molina Jr.*

*   Correct and optimize PostgreSQL bytea escaping.  #1745, #1837 *dave@cherryville.org, ken@miriamtech.com, bellis@deepthought.org*

*   Fixtures should only reset a PostgreSQL sequence if it corresponds to an integer primary key named id.  #1749 *chris@chrisbrinker.com*

*   Standardize the interpretation of boolean columns in the Mysql and Sqlite adapters. (Use MysqlAdapter.emulate_booleans = false to disable this behavior)

*   Added new symbol-driven approach to activating observers with Base#observers= [David Heinemeier Hansson]. Example:

        ActiveRecord::Base.observers = :cacher, :garbage_collector

*   Added AbstractAdapter#select_value and AbstractAdapter#select_values as convenience methods for selecting single values, instead of hashes, of the first column in a SELECT #2283 *solo@gatelys.com*

*   Wrap :conditions in parentheses to prevent problems with OR's #1871 *Jamis Buck*

*   Allow the postgresql adapter to work with the SchemaDumper. *Jamis Buck*

*   Add ActiveRecord::SchemaDumper for dumping a DB schema to a pure-ruby file, making it easier to consolidate large migration lists and port database schemas between databases. *Jamis Buck*

*   Fixed migrations for Windows when using more than 10 *David Naseby*

*   Fixed that the create_x method from belongs_to wouldn't save the association properly #2042 *Florian Weber*

*   Fixed saving a record with two unsaved belongs_to associations pointing to the same object #2023 *Tobias Lütke*

*   Improved migrations' behavior when the schema_info table is empty. *Nicholas Seckar*

*   Fixed that Observers didn't observe sub-classes #627 *Florian Weber*

*   Fix eager loading error messages, allow :include to specify tables using strings or symbols. Closes #2222 *Marcel Molina Jr.*

*   Added check for RAILS_CONNECTION_ADAPTERS on startup and only load the connection adapters specified within if its present (available in Rails through config.connection_adapters using the new config) #1958 *skae*

*   Fixed various problems with has_and_belongs_to_many when using customer finder_sql #2094 *Florian Weber*

*   Added better exception error when unknown column types are used with migrations #1814 *François Beausoleil*

*   Fixed "connection lost" issue with the bundled Ruby/MySQL driver (would kill the app after 8 hours of inactivity) #2163, #428 *kajism@yahoo.com*

*   Fixed comparison of Active Record objects so two new objects are not equal #2099 *deberg*

*   Fixed that the SQL Server adapter would sometimes return DBI::Timestamp objects instead of Time #2127 *Tom Ward*

*   Added the instance methods #root and #ancestors on acts_as_tree and fixed siblings to not include the current node #2142, #2140 *coffee2code*

*   Fixed that Active Record would call SHOW FIELDS twice (or more) for the same model when the cached results were available #1947 *sd@notso.net*

*   Added log_level and use_silence parameter to ActiveRecord::Base.benchmark. The first controls at what level the benchmark statement will be logged (now as debug, instead of info) and the second that can be passed false to include all logging statements during the benchmark block/

*   Make sure the schema_info table is created before querying the current version #1903

*   Fixtures ignore table name prefix and suffix #1987 *Jakob Skjerning*

*   Add documentation for index_type argument to add_index method for migrations #2005 *Blaine*

*   Modify read_attribute to allow a symbol argument #2024 *Ken Kunz*

*   Make destroy return self #1913 *Sebastian Kanthak*

*   Fix typo in validations documentation #1938 *court3nay*

*   Make acts_as_list work for insert_at(1) #1966 *hensleyl@papermountain.org*

*   Fix typo in count_by_sql documentation #1969 *Alexey Verkhovsky*

*   Allow add_column and create_table to specify NOT NULL #1712 *emptysands@gmail.com*

*   Fix create_table so that id column is implicitly added *Rick Olson*

*   Default sequence names for Oracle changed to #{table_name}_seq, which is the most commonly used standard. In addition, a new method ActiveRecord::Base#set_sequence_name allows the developer to set the sequence name per model. This is a non-backwards-compatible change -- anyone using the old-style "rails_sequence" will need to either create new sequences, or set: ActiveRecord::Base.set_sequence_name = "rails_sequence" #1798

*   OCIAdapter now properly handles synonyms, which are commonly used to separate out the schema owner from the application user #1798

*   Fixed the handling of camelCase columns names in Oracle #1798

*   Implemented for OCI the Rakefile tasks of :clone_structure_to_test, :db_structure_dump, and :purge_test_database, which enable Oracle folks to enjoy all the agile goodness of Rails for testing. Note that the current implementation is fairly limited -- only tables and sequences are cloned, not constraints or indexes. A full clone in Oracle generally requires some manual effort, and is version-specific. Post 9i, Oracle recommends the use of the DBMS_METADATA package, though that approach requires editing of the physical characteristics generated #1798

*   Fixed the handling of multiple blob columns in Oracle if one or more of them are null #1798

*   Added support for calling constrained class methods on has_many and has_and_belongs_to_many collections #1764 *Tobias Lütke*

        class Comment < AR:B
          def self.search(q)
            find(:all, :conditions => ["body = ?", q])
          end
        end

        class Post < AR:B
          has_many :comments
        end

        Post.find(1).comments.search('hi') # => SELECT * from comments WHERE post_id = 1 AND body = 'hi'

    NOTICE: This patch changes the underlying SQL generated by has_and_belongs_to_many queries. If your relying on that, such as
    by explicitly referencing the old t and j aliases, you'll need to update your code. Of course, you _shouldn't_ be relying on
    details like that no less than you should be diving in to touch private variables. But just in case you do, consider yourself
    noticed :)

*   Added migration support for SQLite (using temporary tables to simulate ALTER TABLE) #1771 *Sam Stephenson*

*   Remove extra definition of supports_migrations? from abstract_adaptor.rb *Nicholas Seckar*

*   Fix acts_as_list so that moving next-to-last item to the bottom does not result in duplicate item positions

*   Fixed incompatibility in DB2 adapter with the new limit/offset approach #1718 *Maik Schmidt*

*   Added :select option to find which can specify a different value than the default *, like find(:all, :select => "first_name, last_name"), if you either only want to select part of the columns or exclude columns otherwise included from a join #1338 *Stefan Kaes*


## 1.11.1 (11 July, 2005) ##

*   Added support for limit and offset with eager loading of has_one and belongs_to associations. Using the options with has_many and has_and_belongs_to_many associations will now raise an ActiveRecord::ConfigurationError #1692 *Rick Olson*

*   Fixed that assume_bottom_position (in acts_as_list) could be called on items already last in the list and they would move one position away from the list #1648 *tyler@kianta.com*

*   Added ActiveRecord::Base.threaded_connections flag to turn off 1-connection per thread (required for thread safety). By default it's on, but WEBrick in Rails need it off #1685 *Sam Stephenson*

*   Correct reflected table name for singular associations.  #1688 *court3nay*

*   Fixed optimistic locking with SQL Server #1660 *tom@popdog.net*

*   Added ActiveRecord::Migrator.migrate that can figure out whether to go up or down based on the target version and the current

*   Added better error message for "packets out of order" #1630 *court3nay*

*   Fixed first run of "rake migrate" on PostgreSQL by not expecting a return value on the id #1640


## 1.11.0 (6 July, 2005) ##

*   Fixed that Yaml error message in fixtures hid the real error #1623 *Nicholas Seckar*

*   Changed logging of SQL statements to use the DEBUG level instead of INFO

*   Added new Migrations framework for describing schema transformations in a way that can be easily applied across multiple databases #1604 [Tobias Lütke] See documentation under ActiveRecord::Migration and the additional support in the Rails rakefile/generator.

*   Added callback hooks to association collections #1549 [Florian Weber]. Example:

        class Project
          has_and_belongs_to_many :developers, :before_add => :evaluate_velocity

          def evaluate_velocity(developer)
            ...
          end
        end

    ..raising an exception will cause the object not to be added (or removed, with before_remove).


*   Fixed Base.content_columns call for SQL Server adapter #1450 *DeLynn Berry*

*   Fixed Base#write_attribute to work with both symbols and strings #1190 *Paul Legato*

*   Fixed that has_and_belongs_to_many didn't respect single table inheritance types #1081 *Florian Weber*

*   Speed up ActiveRecord#method_missing for the common case (read_attribute).

*   Only notify observers on after_find and after_initialize if these methods are defined on the model.  #1235 *Stefan Kaes*

*   Fixed that single-table inheritance sub-classes couldn't be used to limit the result set with eager loading #1215 *Chris McGrath*

*   Fixed validates_numericality_of to work with overrided getter-method when :allow_nil is on #1316 *raidel@onemail.at*

*   Added roots, root, and siblings to the batch of methods added by acts_as_tree #1541 *Michael Schuerig*

*   Added support for limit/offset with the MS SQL Server driver so that pagination will now work #1569 *DeLynn Berry*

*   Added support for ODBC connections to MS SQL Server so you can connect from a non-Windows machine #1569 *Mark Imbriaco/DeLynn Berry*

*   Fixed that multiparameter posts ignored attr_protected #1532 *alec+rails@veryclever.net*

*   Fixed problem with eager loading when using a has_and_belongs_to_many association using :association_foreign_key #1504 *flash@vanklinkenbergsoftware.nl*

*   Fixed Base#find to honor the documentation on how :joins work and make them consistent with Base#count #1405 [pritchie@gmail.com]. What used to be:

        Developer.find :all, :joins => 'developers_projects', :conditions => 'id=developer_id AND project_id=1'

    ...should instead be:

        Developer.find(
          :all,
          :joins => 'LEFT JOIN developers_projects ON developers.id = developers_projects.developer_id',
          :conditions => 'project_id=1'
        )

*   Fixed that validations didn't respecting custom setting for too_short, too_long messages #1437 *Marcel Molina Jr.*

*   Fixed that clear_association_cache doesn't delete new associations on new records (so you can safely place new records in the session with Action Pack without having new associations wiped) #1494 *cluon*

*   Fixed that calling Model.find([]) returns [] and doesn't throw an exception #1379

*   Fixed that adding a record to a has_and_belongs_to collection would always save it -- now it only saves if its a new record #1203 *Alisdair McDiarmid*

*   Fixed saving of in-memory association structures to happen as a after_create/after_update callback instead of after_save -- that way you can add new associations in after_create/after_update callbacks without getting them saved twice

*   Allow any Enumerable, not just Array, to work as bind variables #1344 *Jeremy Kemper*

*   Added actual database-changing behavior to collection assigment for has_many and has_and_belongs_to_many #1425 [Sebastian Kanthak].
    Example:

        david.projects = [Project.find(1), Project.new("name" => "ActionWebSearch")]
        david.save

    If david.projects already contain the project with ID 1, this is left unchanged. Any other projects are dropped. And the new
    project is saved when david.save is called.

    Also included is a way to do assignments through IDs, which is perfect for checkbox updating, so you get to do:

        david.project_ids = [1, 5, 7]

*   Corrected typo in find SQL for has_and_belongs_to_many.  #1312 *ben@bensinclair.com*

*   Fixed sanitized conditions for has_many finder method.  #1281 *jackc@hylesanderson.com, pragdave, Tobias Lütke*

*   Comprehensive PostgreSQL schema support.  Use the optional schema_search_path directive in database.yml to give a comma-separated list of schemas to search for your tables.  This allows you, for example, to have tables in a shared schema without having to use a custom table name.  See http://www.postgresql.org/docs/8.0/interactive/ddl-schemas.html to learn more.  #827 *dave@cherryville.org*

*   Corrected @@configurations typo #1410 *david@ruppconsulting.com*

*   Return PostgreSQL columns in the order they were declared #1374 *perlguy@gmail.com*

*   Allow before/after update hooks to work on models using optimistic locking

*   Eager loading of dependent has_one associations won't delete the association #1212

*   Added a second parameter to the build and create method for has_one that controls whether the existing association should be replaced (which means nullifying its foreign key as well). By default this is true, but false can be passed to prevent it.

*   Using transactional fixtures now causes the data to be loaded only once.

*   Added fixture accessor methods that can be used when instantiated fixtures are disabled.

        fixtures :web_sites

        def test_something
          assert_equal "Ruby on Rails", web_sites(:rubyonrails).name
        end

*   Added DoubleRenderError exception that'll be raised if render* is called twice #518 *Nicholas Seckar*

*   Fixed exceptions occuring after render has been called #1096 *Nicholas Seckar*

*   CHANGED: validates_presence_of now uses Errors#add_on_blank, which will make "  " fail the validation where it didn't before #1309

*   Added Errors#add_on_blank which works like Errors#add_on_empty, but uses Object#blank? instead

*   Added the :if option to all validations that can either use a block or a method pointer to determine whether the validation should be run or not. #1324 [Duane Johnson/jhosteny]. Examples:

    Conditional validations such as the following are made possible:
        validates_numericality_of :income, :if => :employed?

    Conditional validations can also solve the salted login generator problem:
        validates_confirmation_of :password, :if => :new_password?

    Using blocks:
        validates_presence_of :username, :if => Proc.new { |user| user.signup_step > 1 }

*   Fixed use of construct_finder_sql when using :join #1288 *dwlt@dwlt.net*

*   Fixed that :delete_sql in has_and_belongs_to_many associations couldn't access record properties #1299 *Rick Olson*

*   Fixed that clone would break when an aggregate had the same name as one of its attributes #1307 *Jeremy Kemper*

*   Changed that destroying an object will only freeze the attributes hash, which keeps the object from having attributes changed (as that wouldn't make sense), but allows for the querying of associations after it has been destroyed.

*   Changed the callbacks such that observers are notified before the in-object callbacks are triggered. Without this change, it wasn't possible to act on the whole object in something like a before_destroy observer without having the objects own callbacks (like deleting associations) called first.

*   Added option for passing an array to the find_all version of the dynamic finders and have it evaluated as an IN fragment. Example:

        # SELECT * FROM topics WHERE title IN ('First', 'Second')
        Topic.find_all_by_title(["First", "Second"])

*   Added compatibility with camelCase column names for dynamic finders #533 *Dee Zsombor*

*   Fixed extraneous comma in count() function that made it not work with joins #1156 *Jarkko Laine/Dee Zsombor*

*   Fixed incompatibility with Base#find with an array of ids that would fail when using eager loading #1186 *Alisdair McDiarmid*

*   Fixed that validate_length_of lost :on option when :within was specified #1195 *jhosteny@mac.com*

*   Added encoding and min_messages options for PostgreSQL #1205 [Shugo Maeda]. Configuration example:

        development:
          adapter: postgresql
          database: rails_development
          host: localhost
          username: postgres
          password:
          encoding: UTF8
          min_messages: ERROR

*   Fixed acts_as_list where deleting an item that was removed from the list would ruin the positioning of other list items #1197 *Jamis Buck*

*   Added validates_exclusion_of as a negative of validates_inclusion_of

*   Optimized counting of has_many associations by setting the association to empty if the count is 0 so repeated calls doesn't trigger database calls


## 1.10.1 (20th April, 2005) ##

*   Fixed frivilous database queries being triggered with eager loading on empty associations and other things

*   Fixed order of loading in eager associations

*   Fixed stray comma when using eager loading and ordering together from has_many associations #1143


## 1.10.0 (19th April, 2005) ##

*   Added eager loading of associations as a way to solve the N+1 problem more gracefully without piggy-back queries. Example:

        for post in Post.find(:all, :limit => 100)
          puts "Post:            " + post.title
          puts "Written by:      " + post.author.name
          puts "Last comment on: " + post.comments.first.created_on
        end

    This used to generate 301 database queries if all 100 posts had both author and comments. It can now be written as:

        for post in Post.find(:all, :limit => 100, :include => [ :author, :comments ])

    ...and the number of database queries needed is now 1.

*   Added new unified Base.find API and deprecated the use of find_first and find_all. See the documentation for Base.find. Examples:

        Person.find(1, :conditions => "administrator = 1", :order => "created_on DESC")
        Person.find(1, 5, 6, :conditions => "administrator = 1", :order => "created_on DESC")
        Person.find(:first, :order => "created_on DESC", :offset => 5)
        Person.find(:all, :conditions => [ "category IN (?)", categories], :limit => 50)
        Person.find(:all, :offset => 10, :limit => 10)

*   Added acts_as_nested_set #1000 [wschenk]. Introduction:

        This acts provides Nested Set functionality.  Nested Set is similiar to Tree, but with
        the added feature that you can select the children and all of it's descendants with
        a single query.  A good use case for this is a threaded post system, where you want
        to display every reply to a comment without multiple selects.

*   Added Base.save! that attempts to save the record just like Base.save but will raise a RecordInvalid exception instead of returning false if the record is not valid *Dave Thomas*

*   Fixed PostgreSQL usage of fixtures with regards to public schemas and table names with dots #962 *gnuman1@gmail.com*

*   Fixed that fixtures were being deleted in the same order as inserts causing FK errors #890 *andrew.john.peters@gmail.com*

*   Fixed loading of fixtures in to be in the right order (or PostgreSQL would bark) #1047 *stephenh@chase3000.com*

*   Fixed page caching for non-vhost applications living underneath the root #1004 *Ben Schumacher*

*   Fixes a problem with the SQL Adapter which was resulting in IDENTITY_INSERT not being set to ON when it should be #1104 *adelle*

*   Added the option to specify the acceptance string in validates_acceptance_of #1106 *caleb@aei-tech.com*

*   Added insert_at(position) to acts_as_list #1083 *DeLynnB*

*   Removed the default order by id on has_and_belongs_to_many queries as it could kill performance on large sets (you can still specify by hand with :order)

*   Fixed that Base.silence should restore the old logger level when done, not just set it to DEBUG #1084 *yon@milliped.com*

*   Fixed boolean saving on Oracle #1093 *mparrish@pearware.org*

*   Moved build_association and create_association for has_one and belongs_to out of deprecation as they work when the association is nil unlike association.build and association.create, which require the association to be already in place #864

*   Added rollbacks of transactions if they're active as the dispatcher is killed gracefully (TERM signal) #1054 *Leon Bredt*

*   Added quoting of column names for fixtures #997 *jcfischer@gmail.com*

*   Fixed counter_sql when no records exist in database for PostgreSQL (would give error, not 0) #1039 *Caleb Tennis*

*   Fixed that benchmarking times for rendering included db runtimes #987 *Stefan Kaes*

*   Fixed boolean queries for t/f fields in PostgreSQL #995 *dave@cherryville.org*

*   Added that model.items.delete(child) will delete the child, not just set the foreign key to nil, if the child is dependent on the model #978 *Jeremy Kemper*

*   Fixed auto-stamping of dates (created_on/updated_on) for PostgreSQL #985 *dave@cherryville.org*

*   Fixed Base.silence/benchmark to only log if a logger has been configured #986 *Stefan Kaes*

*   Added a join parameter as the third argument to Base.find_first and as the second to Base.count #426, #988 *Stefan Kaes*

*   Fixed bug in Base#hash method that would treat records with the same string-based id as different *Dave Thomas*

*   Renamed DateHelper#distance_of_time_in_words_to_now to DateHelper#time_ago_in_words (old method name is still available as a deprecated alias)


## 1.9.1 (27th March, 2005) ##

*   Fixed that Active Record objects with float attribute could not be cloned #808

*   Fixed that MissingSourceFile's wasn't properly detected in production mode #925 *Nicholas Seckar*

*   Fixed that :counter_cache option would look for a line_items_count column for a LineItem object instead of lineitems_count

*   Fixed that AR exists?() would explode on postgresql if the passed id did not match the PK type #900 *Scott Barron*

*   Fixed the MS SQL adapter to work with the new limit/offset approach and with binary data (still suffering from 7KB limit, though) #901 *delynnb*


## 1.9.0 (22th March, 2005) ##

*   Added adapter independent limit clause as a two-element array with the first being the limit, the second being the offset #795 [Sam Stephenson]. Example:

        Developer.find_all nil, 'id ASC', 5      # return the first five developers
        Developer.find_all nil, 'id ASC', [3, 8] # return three developers, starting from #8 and forward

    This doesn't yet work with the DB2 or MS SQL adapters. Patches to make that happen are encouraged.

*   Added alias_method :to_param, :id to Base, such that Active Record objects to be used as URL parameters in Action Pack automatically #812 *Nicholas Seckar/Sam Stephenson*

*   Improved the performance of the OCI8 adapter for Oracle #723 *pilx/gjenkins*

*   Added type conversion before saving a record, so string-based values like "10.0" aren't left for the database to convert #820 *dave@cherryville.org*

*   Added with additional settings for working with transactional fixtures and pre-loaded test databases #865 *mindel*

*   Fixed acts_as_list to trigger remove_from_list on destroy after the fact, not before, so a unique position can be maintained #871 *Alisdair McDiarmid*

*   Added the possibility of specifying fixtures in multiple calls #816 *kim@tinker.com*

*   Added Base.exists?(id) that'll return true if an object of the class with the given id exists #854 *stian@grytoyr.net*

*   Added optionally allow for nil or empty strings with validates_numericality_of #801 *Sebastian Kanthak*

*   Fixed problem with using slashes in validates_format_of regular expressions #801 *Sebastian Kanthak*

*   Fixed that SQLite3 exceptions are caught and reported properly #823 *yerejm*

*   Added that all types of after_find/after_initialized callbacks are triggered if the explicit implementation is present, not only the explicit implementation itself

*   Fixed that symbols can be used on attribute assignment, like page.emails.create(:subject => data.subject, :body => data.body)


## 1.8.0 (7th March, 2005) ##

*   Added ActiveRecord::Base.colorize_logging to control whether to use colors in logs or not (on by default)

*   Added support for timestamp with time zone in PostgreSQL #560 *Scott Barron*

*   Added MultiparameterAssignmentErrors and AttributeAssignmentError exceptions #777 [demetrius]. Documentation:

     * +MultiparameterAssignmentErrors+ -- collection of errors that occurred during a mass assignment using the
         +attributes=+ method. The +errors+ property of this exception contains an array of +AttributeAssignmentError+
         objects that should be inspected to determine which attributes triggered the errors.
     * +AttributeAssignmentError+ -- an error occurred while doing a mass assignment through the +attributes=+ method.
         You can inspect the +attribute+ property of the exception object to determine which attribute triggered the error.

*   Fixed that postgresql adapter would fails when reading bytea fields with null value #771 *rodrigo k*

*   Added transactional fixtures that uses rollback to undo changes to fixtures instead of DELETE/INSERT -- it's much faster. See documentation under Fixtures #760 *Jeremy Kemper*

*   Added destruction of dependent objects in has_one associations when a new assignment happens #742 [mindel]. Example:

        class Account < ActiveRecord::Base
          has_one :credit_card, :dependent => true
        end
        class CreditCard < ActiveRecord::Base
          belongs_to :account
        end

        account.credit_card # => returns existing credit card, lets say id = 12
        account.credit_card = CreditCard.create("number" => "123")
        account.save # => CC with id = 12 is destroyed


*   Added validates_numericality_of #716 [Sebastian Kanthak/Chris McGrath]. Docuemntation:

        Validates whether the value of the specified attribute is numeric by trying to convert it to
        a float with Kernel.Float (if <tt>integer</tt> is false) or applying it to the regular expression
        <tt>/^[\+\-]?\d+$/</tt> (if <tt>integer</tt> is set to true).

          class Person < ActiveRecord::Base
            validates_numericality_of :value, :on => :create
          end

        Configuration options:
        * <tt>message</tt> - A custom error message (default is: "is not a number")
        * <tt>on</tt> Specifies when this validation is active (default is :save, other options :create, :update)
        * <tt>only_integer</tt> Specifies whether the value has to be an integer, e.g. an integral value (default is false)


*   Fixed that HasManyAssociation#count was using :finder_sql rather than :counter_sql if it was available #445 *Scott Barron*

*   Added better defaults for composed_of, so statements like composed_of :time_zone, :mapping => %w( time_zone time_zone ) can be written without the mapping part (it's now assumed)

*   Added MacroReflection#macro which will return a symbol describing the macro used (like :composed_of or :has_many) #718, #248 *james@slashetc.com*


## 1.7.0 (24th February, 2005) ##

*   Changed the auto-timestamping feature to use ActiveRecord::Base.default_timezone instead of entertaining the parallel ActiveRecord::Base.timestamps_gmt method. The latter is now deprecated and will throw a warning on use (but still work) #710 *Jamis Buck*

*   Added a OCI8-based Oracle adapter that has been verified to work with Oracle 8 and 9 #629 [Graham Jenkins]. Usage notes:

        1.  Key generation uses a sequence "rails_sequence" for all tables. (I couldn't find a simple
            and safe way of passing table-specific sequence information to the adapter.)
        2.  Oracle uses DATE or TIMESTAMP datatypes for both dates and times. Consequently I have had to
            resort to some hacks to get data converted to Date or Time in Ruby.
            If the column_name ends in _at (like created_at, updated_at) it's created as a Ruby Time. Else if the
            hours/minutes/seconds are 0, I make it a Ruby Date. Else it's a Ruby Time.
            This is nasty - but if you use Duck Typing you'll probably not care very much.
            In 9i it's tempting to map DATE to Date and TIMESTAMP to Time but I don't think that is
            valid - too many databases use DATE for both.
            Timezones and sub-second precision on timestamps are not supported.
        3.  Default values that are functions (such as "SYSDATE") are not supported. This is a
            restriction of the way active record supports default values.
        4.  Referential integrity constraints are not fully supported. Under at least
            some circumstances, active record appears to delete parent and child records out of
            sequence and out of transaction scope. (Or this may just be a problem of test setup.)

    The OCI8 driver can be retrieved from http://rubyforge.org/projects/ruby-oci8/

*   Added option :schema_order to the PostgreSQL adapter to support the use of multiple schemas per database #697 *YuriSchimke*

*   Optimized the SQL used to generate has_and_belongs_to_many queries by listing the join table first #693 *yerejm*

*   Fixed that when using validation macros with a custom message, if you happened to use single quotes in the message string you would get a parsing error #657 *tonka*

*   Fixed that Active Record would throw Broken Pipe errors with FCGI when the MySQL connection timed out instead of reconnecting #428 *Nicholas Seckar*

*   Added options to specify an SSL connection for MySQL. Define the following attributes in the connection config (config/database.yml in Rails) to use it: sslkey, sslcert, sslca, sslcapath, sslcipher. To use SSL with no client certs, just set :sslca = '/dev/null'. http://dev.mysql.com/doc/mysql/en/secure-connections.html #604 *daniel@nightrunner.com*

*   Added automatic dropping/creating of test tables for running the unit tests on all databases #587 *adelle@bullet.net.au*

*   Fixed that find_by_* would fail when column names had numbers #670 *demetrius*

*   Fixed the SQL Server adapter on a bunch of issues #667 *DeLynn*

        1. Created a new columns method that is much cleaner.
        2. Corrected a problem with the select and select_all methods
           that didn't account for the LIMIT clause being passed into raw SQL statements.
        3. Implemented the string_to_time method in order to create proper instances of the time class.
        4. Added logic to the simplified_type method that allows the database to specify the scale of float data.
        5. Adjusted the quote_column_name to account for the fact that MS SQL is bothered by a forward slash in the data string.

*   Fixed that the dynamic finder like find_all_by_something_boolean(false) didn't work #649 *lmarlow*

*   Added validates_each that validates each specified attribute against a block #610 [Jeremy Kemper]. Example:

        class Person < ActiveRecord::Base
          validates_each :first_name, :last_name do |record, attr|
            record.errors.add attr, 'starts with z.' if attr[0] == ?z
          end
        end

*   Added :allow_nil as an explicit option for validates_length_of, so unless that's set to true having the attribute as nil will also return an error if a range is specified as :within #610 *Jeremy Kemper*

*   Added that validates_* now accept blocks to perform validations #618 [Tim Bates]. Example:

        class Person < ActiveRecord::Base
          validate { |person| person.errors.add("title", "will never be valid") if SHOULD_NEVER_BE_VALID }
        end

*   Addded validation for validate all the associated objects before declaring failure with validates_associated #618 *Tim Bates*

*   Added keyword-style approach to defining the custom relational bindings #545 [Jamis Buck]. Example:

        class Project < ActiveRecord::Base
          primary_key "sysid"
          table_name "XYZ_PROJECT"
          inheritance_column { original_inheritance_column + "_id" }
        end

*   Fixed Base#clone for use with PostgreSQL #565 *hanson@surgery.wisc.edu*


## 1.6.0 (January 25th, 2005) ##

*   Added that has_many association build and create methods can take arrays of record data like Base#create and Base#build to build/create multiple records at once.

*   Added that Base#delete and Base#destroy both can take an array of ids to delete/destroy #336

*   Added the option of supplying an array of attributes to Base#create, so that multiple records can be created at once.

*   Added the option of supplying an array of ids and attributes to Base#update, so that multiple records can be updated at once (inspired by #526/Duane Johnson). Example

        people = { 1 => { "first_name" => "David" }, 2 => { "first_name" => "Jeremy"} }
        Person.update(people.keys, people.values)

*   Added ActiveRecord::Base.timestamps_gmt that can be set to true to make the automated timestamping use GMT instead of local time #520 *Scott Baron*

*   Added that update_all calls sanitize_sql on its updates argument, so stuff like MyRecord.update_all(['time = ?', Time.now]) works #519 *notahat*

*   Fixed that the dynamic finders didn't treat nil as a "IS NULL" but rather "= NULL" case #515 *Demetrius*

*   Added bind-named arrays for interpolating a group of ids or strings in conditions #528 *Jeremy Kemper*

*   Added that has_and_belongs_to_many associations with additional attributes also can be created between unsaved objects and only committed to the database when Base#save is called on the associator #524 *Eric Anderson*

*   Fixed that records fetched with piggy-back attributes or through rich has_and_belongs_to_many associations couldn't be saved due to the extra attributes not part of the table #522 *Eric Anderson*

*   Added mass-assignment protection for the inheritance column -- regardless of a custom column is used or not

*   Fixed that association proxies would fail === tests like PremiumSubscription === @account.subscription

*   Fixed that column aliases didn't work as expected with the new MySql411 driver #507 *Demetrius*

*   Fixed that find_all would produce invalid sql when called sequentialy #490 *Scott Baron*


## 1.5.1 (January 18th, 2005) ##

*   Fixed that the belongs_to and has_one proxy would fail a test like 'if project.manager' -- this unfortunately also means that you can't call methods like project.manager.build unless there already is a manager on the project #492 *Tim Bates*

*   Fixed that the Ruby/MySQL adapter wouldn't connect if the password was empty #503 *Pelle*


## 1.5.0 (January 17th, 2005) ##

*   Fixed that unit tests for MySQL are now run as the "rails" user instead of root #455 *Eric Hodel*

*   Added validates_associated that enables validation of objects in an unsaved association #398 [Tim Bates]. Example:

        class Book < ActiveRecord::Base
          has_many :pages
          belongs_to :library

          validates_associated :pages, :library
        end

*   Added support for associating unsaved objects #402 [Tim Bates]. Rules that govern this addition:

        == Unsaved objects and associations

        You can manipulate objects and associations before they are saved to the database, but there is some special behaviour you should be
        aware of, mostly involving the saving of associated objects.

        === One-to-one associations

        * Assigning an object to a has_one association automatically saves that object, and the object being replaced (if there is one), in
          order to update their primary keys - except if the parent object is unsaved (new_record? == true).
        * If either of these saves fail (due to one of the objects being invalid) the assignment statement returns false and the assignment
          is cancelled.
        * If you wish to assign an object to a has_one association without saving it, use the #association.build method (documented below).
        * Assigning an object to a belongs_to association does not save the object, since the foreign key field belongs on the parent. It does
          not save the parent either.

        === Collections

        * Adding an object to a collection (has_many or has_and_belongs_to_many) automatically saves that object, except if the parent object
          (the owner of the collection) is not yet stored in the database.
        * If saving any of the objects being added to a collection (via #push or similar) fails, then #push returns false.
        * You can add an object to a collection without automatically saving it by using the #collection.build method (documented below).
        * All unsaved (new_record? == true) members of the collection are automatically saved when the parent is saved.

*   Added replace to associations, so you can do project.manager.replace(new_manager) or project.milestones.replace(new_milestones) #402 *Tim Bates*

*   Added build and create methods to has_one and belongs_to associations, so you can now do project.manager.build(attributes) #402 *Tim Bates*

*   Added that if a before_* callback returns false, all the later callbacks and the associated action are cancelled. If an after_* callback returns false, all the later callbacks are cancelled. Callbacks are generally run in the order they are defined, with the exception of callbacks defined as methods on the model, which are called last. #402 *Tim Bates*

*   Fixed that Base#== wouldn't work for multiple references to the same unsaved object #402 *Tim Bates*

*   Fixed binary support for PostgreSQL #444 *alex@byzantine.no*

*   Added a differenciation between AssociationCollection#size and -length. Now AssociationCollection#size returns the size of the
    collection by executing a SELECT COUNT(*) query if the collection hasn't been loaded and calling collection.size if it has. If
    it's more likely than not that the collection does have a size larger than zero and you need to fetch that collection afterwards,
    it'll take one less SELECT query if you use length.

*   Added Base#attributes that returns a hash of all the attributes with their names as keys and clones of their objects as values #433 *atyp.de*

*   Fixed that foreign keys named the same as the association would cause stack overflow #437 *Eric Anderson*

*   Fixed default scope of acts_as_list from "1" to "1 = 1", so it'll work in PostgreSQL (among other places) #427 *Alexey*

*   Added Base#reload that reloads the attributes of an object from the database #422 *Andreas Schwarz*

*   Added SQLite3 compatibility through the sqlite3-ruby adapter by Jamis Buck #381 *Jeremy Kemper*

*   Added support for the new protocol spoken by MySQL 4.1.1+ servers for the Ruby/MySQL adapter that ships with Rails #440 *Matt Mower*

*   Added that Observers can use the observes class method instead of overwriting self.observed_class().

        Before:
          class ListSweeper < ActiveRecord::Base
            def self.observed_class() [ List, Item ]
          end

        After:
          class ListSweeper < ActiveRecord::Base
            observes List, Item
          end

*   Fixed that conditions in has_many and has_and_belongs_to_many should be interpolated just like the finder_sql is

*   Fixed Base#update_attribute to be indifferent to whether a string or symbol is used to describe the name

*   Added Base#toggle(attribute) and Base#toggle!(attribute) that makes it easier to flip a switch or flag.

        Before: topic.update_attribute(:approved, !approved?)
        After : topic.toggle!(:approved)

*   Added Base#increment!(attribute) and Base#decrement!(attribute) that also saves the records. Example:

        page.views # => 1
        page.increment!(:views) # executes an UPDATE statement
        page.views # => 2

        page.increment(:views).increment!(:views)
        page.views # => 4

*   Added Base#increment(attribute) and Base#decrement(attribute) that encapsulates the += 1 and -= 1 patterns.


## 1.4.0 (January 4th, 2005) ##

*   Added automated optimistic locking if the field <tt>lock_version</tt> is present.  Each update to the
    record increments the lock_version column and the locking facilities ensure that records instantiated twice
    will let the last one saved raise a StaleObjectError if the first was also updated. Example:

        p1 = Person.find(1)
        p2 = Person.find(1)

        p1.first_name = "Michael"
        p1.save

        p2.first_name = "should fail"
        p2.save # Raises a ActiveRecord::StaleObjectError

    You're then responsible for dealing with the conflict by rescuing the exception and either rolling back, merging,
    or otherwise apply the business logic needed to resolve the conflict.

    \#384 *Michael Koziarski*

*   Added dynamic attribute-based finders as a cleaner way of getting objects by simple queries without turning to SQL.
    They work by appending the name of an attribute to <tt>find_by_</tt>, so you get finders like <tt>Person.find_by_user_name,
    Payment.find_by_transaction_id</tt>. So instead of writing <tt>Person.find_first(["user_name = ?", user_name])</tt>, you just do
    <tt>Person.find_by_user_name(user_name)</tt>.

    It's also possible to use multiple attributes in the same find by separating them with "_and_", so you get finders like
    <tt>Person.find_by_user_name_and_password</tt> or even <tt>Payment.find_by_purchaser_and_state_and_country</tt>. So instead of writing
    <tt>Person.find_first(["user_name = ? AND password = ?", user_name, password])</tt>, you just do
    <tt>Person.find_by_user_name_and_password(user_name, password)</tt>.

    While primarily a construct for easier find_firsts, it can also be used as a construct for find_all by using calls like
    <tt>Payment.find_all_by_amount(50)</tt> that is turned into <tt>Payment.find_all(["amount = ?", 50])</tt>. This is something not as equally useful,
    though, as it's not possible to specify the order in which the objects are returned.

*   Added block-style for callbacks #332 [Jeremy Kemper].

        Before:
          before_destroy(Proc.new{ |record| Person.destroy_all "firm_id = #{record.id}" })

        After:
          before_destroy { |record| Person.destroy_all "firm_id = #{record.id}" }

*   Added :counter_cache option to acts_as_tree that works just like the one you can define on belongs_to #371 *Josh Peek*

*   Added Base.default_timezone accessor that determines whether to use Time.local (using :local) or Time.utc (using :utc) when pulling dates
    and times from the database. This is set to :local by default.

*   Added the possibility for adapters to overwrite add_limit! to implement a different limiting scheme than "LIMIT X" used by MySQL, PostgreSQL, and SQLite.

*   Added the possibility of having objects with acts_as_list created before their scope is available or...

*   Added a db2 adapter that only depends on the Ruby/DB2 bindings (http://raa.ruby-lang.org/project/ruby-db2/) #386 *Maik Schmidt*

*   Added the final touches to the Microsoft SQL Server adapter by Joey Gibson that makes it suitable for actual use #394 *DeLynn Barry*

*   Added that Base#find takes an optional options hash, including :conditions. Base#find_on_conditions deprecated in favor of #find with :conditions #407 *Jeremy Kemper*

*   Added HasManyAssociation#count that works like Base#count #413 *intinig*

*   Fixed handling of binary content in blobs and similar fields for Ruby/MySQL and SQLite #409 *xal*

*   Fixed a bug in the Ruby/MySQL that caused binary content to be escaped badly and come back mangled #405 *Tobias Lütke*

*   Fixed that the const_missing autoload assumes the requested constant is set by require_association and calls const_get to retrieve it.
    If require_association did not set the constant then const_get will call const_missing, resulting in an infinite loop #380 *Jeremy Kemper*

*   Fixed broken transactions that were actually only running object-level and not db level transactions *andreas*

*   Fixed that validates_uniqueness_of used 'id' instead of defined primary key #406

*   Fixed that the overwritten respond_to? method didn't take two parameters like the original #391

*   Fixed quoting in validates_format_of that would allow some rules to pass regardless of input #390 *Dmitry V. Sabanin*


## 1.3.0 (December 23, 2004) ##

*   Added a require_association hook on const_missing that makes it possible to use any model class without requiring it first. This makes STI look like:

        before:
          require_association 'person'
          class Employee < Person
          end

        after:
          class Employee < Person
          end

    This also reduces the usefulness of Controller.model in Action Pack to currently only being for documentation purposes.

*   Added that Base.update_all and Base.delete_all return an integer of the number of affected rows #341

*   Added scope option to validation_uniqueness #349 *Kent Sibilev*

*   Added respondence to *_before_type_cast for all attributes to return their string-state before they were type casted by the column type.
    This is helpful for getting "100,000" back on a integer-based validation where the value would normally be "100".

*   Added allow_nil options to validates_inclusion_of so that validation is only triggered if the attribute is not nil *what-a-day*

*   Added work-around for PostgreSQL and the problem of getting fixtures to be created from id 1 on each test case.
    This only works for auto-incrementing primary keys called "id" for now #359 *Scott Baron*

*   Added Base#clear_association_cache to empty all the cached associations #347 *Tobias Lütke*

*   Added more informative exceptions in establish_connection #356 *Jeremy Kemper*

*   Added Base#update_attributes that'll accept a hash of attributes and save the record (returning true if it passed validation, false otherwise).

        Before:
          person.attributes = @params["person"]
          person.save

        Now:
          person.update_attributes(@params["person"])

*   Added Base.destroy and Base.delete to remove records without holding a reference to them first.

*   Added that query benchmarking will only happen if its going to be logged anyway #344

*   Added higher_item and lower_item as public methods for acts_as_list #342 *Tobias Lütke*

*   Fixed that options[:counter_sql] was overwritten with interpolated sql rather than original sql #355 *Jeremy Kemper*

*   Fixed that overriding an attribute's accessor would be disregarded by add_on_empty and add_on_boundary_breaking because they simply used
    the attributes[] hash instead of checking for @base.respond_to?(attr.to_s). *Marten*

*   Fixed that Base.table_name would expect a parameter when used in has_and_belongs_to_many joins *Anna Lissa Cruz*

*   Fixed that nested transactions now work by letting the outer most transaction have the responsibilty of starting and rolling back the transaction.
    If any of the inner transactions swallow the exception raised, though, the transaction will not be rolled back. So always let the transaction
    bubble up even when you've dealt with local issues. Closes #231 and #340.

*   Fixed validates_{confirmation,acceptance}_of to only happen when the virtual attributes are not nil #348 *dpiddy@gmail.com*

*   Changed the interface on AbstractAdapter to require that adapters return the number of affected rows on delete and update operations.

*   Fixed the automated timestamping feature when running under Rails' development environment that resets the inheritable attributes on each request.



## 1.2.0 ##

*   Added Base.validates_inclusion_of that validates whether the value of the specified attribute is available in a particular enumerable
    object. *what-a-day*

        class Person < ActiveRecord::Base
          validates_inclusion_of :gender, :in=>%w( m f ), :message=>"woah! what are you then!??!!"
          validates_inclusion_of :age, :in=>0..99
        end

*   Added acts_as_list that can decorates an existing class with methods like move_higher/lower, move_to_top/bottom. [Tobias Lütke] Example:

        class TodoItem < ActiveRecord::Base
          acts_as_list :scope => :todo_list_id
          belongs_to :todo_list
        end

*   Added acts_as_tree that can decorates an existing class with a many to many relationship with itself. Perfect for categories in
    categories and the likes. *Tobias Lütke*

*   Added that Active Records will automatically record creation and/or update timestamps of database objects if fields of the names
    created_at/created_on or updated_at/updated_on are present. *Tobias Lütke*

*   Added Base.default_error_messages as a hash of all the error messages used in the validates_*_of so they can be changed in one place *Tobias Lütke*

*   Added automatic transaction block around AssociationCollection.<<, AssociationCollection.delete, and AssociationCollection.destroy_all

*   Fixed that Base#find will return an array if given an array -- regardless of the number of elements #270 *Marten*

*   Fixed that has_and_belongs_to_many would generate bad sql when naming conventions differed from using vanilla "id" everywhere *RedTerror*

*   Added a better exception for when a type column is used in a table without the intention of triggering single-table inheritance. Example:

        ActiveRecord::SubclassNotFound: The single-table inheritance mechanism failed to locate the subclass: 'bad_class!'.
        This error is raised because the column 'type' is reserved for storing the class in case of inheritance.
        Please rename this column if you didn't intend it to be used for storing the inheritance class or
        overwrite Company.inheritance_column to use another column for that information.

*   Added that single-table inheritance will only kick in if the inheritance_column (by default "type") is present. Otherwise, inheritance won't
    have any magic side effects.

*   Added the possibility of marking fields as being in error without adding a message (using nil) to it that'll get displayed wth full_messages #208 *mjobin*

*   Fixed Base.errors to be indifferent as to whether strings or symbols are used. Examples:

        Before:
          errors.add(:name, "must be shorter") if name.size > 10
          errors.on(:name)  # => "must be shorter"
          errors.on("name") # => nil

        After:
          errors.add(:name, "must be shorter") if name.size > 10
          errors.on(:name)  # => "must be shorter"
          errors.on("name") # => "must be shorter"

*   Added Base.validates_format_of that Validates whether the value of the specified attribute is of the correct form by matching
    it against the regular expression provided. *Marcel Molina Jr.*

        class Person < ActiveRecord::Base
          validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/, :on => :create
        end

*   Added Base.validates_length_of that delegates to add_on_boundary_breaking #312 [Tobias Lütke]. Example:

        Validates that the specified attribute matches the length restrictions supplied in either:

          - configuration[:minimum]
          - configuration[:maximum]
          - configuration[:is]
          - configuration[:within] (aka. configuration[:in])

        Only one option can be used at a time.

          class Person < ActiveRecord::Base
            validates_length_of :first_name, :maximum=>30
            validates_length_of :last_name, :maximum=>30, :message=>"less than %d if you don't mind"
            validates_length_of :user_name, :within => 6..20, :too_long => "pick a shorter name", :too_short => "pick a longer name"
            validates_length_of :fav_bra_size, :minimum=>1, :too_short=>"please enter at least %d character"
            validates_length_of :smurf_leader, :is=>4, :message=>"papa is spelled with %d characters... don't play me."
          end

*   Added Base.validate_presence as an alternative to implementing validate and doing errors.add_on_empty yourself.

*   Added Base.validates_uniqueness_of that alidates whether the value of the specified attributes are unique across the system.
    Useful for making sure that only one user can be named "davidhh".

        class Person < ActiveRecord::Base
          validates_uniqueness_of :user_name
        end

    When the record is created, a check is performed to make sure that no record exist in the database with the given value for the specified
    attribute (that maps to a column). When the record is updated, the same check is made but disregarding the record itself.


*   Added Base.validates_confirmation_of that encapsulates the pattern of wanting to validate a password or email address field with a confirmation. Example:

         Model:
           class Person < ActiveRecord::Base
             validates_confirmation_of :password
           end

         View:
           <%= password_field "person", "password" %>
           <%= password_field "person", "password_confirmation" %>

     The person has to already have a password attribute (a column in the people table), but the password_confirmation is virtual.
     It exists only as an in-memory variable for validating the password. This check is performed both on create and update.


*   Added Base.validates_acceptance_of that encapsulates the pattern of wanting to validate the acceptance of a terms of service check box (or similar agreement). Example:

     class Person < ActiveRecord::Base
         validates_acceptance_of :terms_of_service
     end

    The terms_of_service attribute is entirely virtual. No database column is needed. This check is performed both on create and update.

    NOTE: The agreement is considered valid if it's set to the string "1". This makes it easy to relate it to an HTML checkbox.


*   Added validation macros to make the stackable just like the life cycle callbacks. Examples:

        class Person < ActiveRecord::Base
          validate { |record| record.errors.add("name", "too short") unless name.size > 10 }
          validate { |record| record.errors.add("name", "too long")  unless name.size < 20 }
          validate_on_create :validate_password

          private
            def validate_password
              errors.add("password", "too short") unless password.size > 6
            end
        end

*   Added the option for sanitizing find_by_sql and the offset parts in regular finds [Sam Stephenson]. Examples:

        Project.find_all ["category = ?", category_name], "created ASC", ["? OFFSET ?", 15, 20]
        Post.find_by_sql ["SELECT * FROM posts WHERE author = ? AND created > ?", author_id, start_date]

*   Fixed value quoting in all generated SQL statements, so that integers are not surrounded in quotes and that all sanitation are happening
    through the database's own quoting routine. This should hopefully make it lots easier for new adapters that doesn't accept '1' for integer
    columns.

*   Fixed has_and_belongs_to_many guessing of foreign key so that keys are generated correctly for models like SomeVerySpecialClient
    *Florian Weber*

*   Added counter_sql option for has_many associations [Jeremy Kemper]. Documentation:

        <tt>:counter_sql</tt> - specify a complete SQL statement to fetch the size of the association. If +:finder_sql+ is
        specified but +:counter_sql+, +:counter_sql+ will be generated by replacing SELECT ... FROM with SELECT COUNT(*) FROM.

*   Fixed that methods wrapped in callbacks still return their original result #260 *Jeremy Kemper*

*   Fixed the Inflector to handle the movie/movies pair correctly #261 *Scott Baron*

*   Added named bind-style variable interpolation #281 [Michael Koziarski]. Example:

        Person.find(["id = :id and first_name = :first_name", { :id => 5, :first_name = "bob' or 1=1" }])

*   Added bind-style variable interpolation for the condition arrays that uses the adapter's quote method *Michael Koziarski*

    Before:
        find_first([ "user_name = '%s' AND password = '%s'", user_name, password ])]
        find_first([ "firm_id = %s", firm_id ])] # unsafe!

    After:
        find_first([ "user_name = ? AND password = ?", user_name, password ])]
        find_first([ "firm_id = ?", firm_id ])]

*   Added CSV format for fixtures #272 [what-a-day]. (See the new and expanded documentation on fixtures for more information)

*   Fixed fixtures using primary key fields called something else than "id" *dave*

*   Added proper handling of time fields that are turned into Time objects with the dummy date of 2000/1/1 *HariSeldon*

*   Added reverse order of deleting fixtures, so referential keys can be maintained #247 *Tim Bates*

*   Added relative path search for sqlite dbfiles in database.yml (if RAILS_ROOT is defined) #233 *Jeremy Kemper*

*   Added option to establish_connection where you'll be able to leave out the parameter to have it use the RAILS_ENV environment variable

*   Fixed problems with primary keys and postgresql sequences (#230) *Tim Bates*

*   Added reloading for associations under cached environments like FastCGI and mod_ruby. This makes it possible to use those environments for development.
    This is turned on by default, but can be turned off with ActiveRecord::Base.reload_dependencies = false in production environments.

    NOTE: This will only have an effect if you let the associations manage the requiring of model classes. All libraries loaded through
    require will be "forever" cached. You can, however, use ActiveRecord::Base.load_or_require("library") to get this behavior outside of the
    auto-loading associations.

*   Added ERB capabilities to the fixture files for dynamic fixture generation. You don't need to do anything, just include ERB blocks like:

        david:
          id: 1
          name: David

        jamis:
          id: 2
          name: Jamis

        <% for digit in 3..10 %>
        dev_<%= digit %>:
          id: <%= digit %>
          name: fixture_<%= digit %>
        <% end %>

*   Changed the yaml fixture searcher to look in the root of the fixtures directory, so when you before could have something like:

        fixtures/developers/fixtures.yaml
        fixtures/accounts/fixtures.yaml

    ...you now need to do:

        fixtures/developers.yaml
        fixtures/accounts.yaml

*   Changed the fixture format from:

        name: david
        data:
         id: 1
         name: David Heinemeier Hansson
         birthday: 1979-10-15
         profession: Systems development
        ---
        name: steve
        data:
         id: 2
         name: Steve Ross Kellock
         birthday: 1974-09-27
         profession: guy with keyboard

    ...to:

        david:
         id: 1
         name: David Heinemeier Hansson
         birthday: 1979-10-15
         profession: Systems development

        steve:
         id: 2
         name: Steve Ross Kellock
         birthday: 1974-09-27
         profession: guy with keyboard

    The change is NOT backwards compatible. Fixtures written in the old YAML style needs to be rewritten!

*   All associations will now attempt to require the classes that they associate to. Relieving the need for most explicit 'require' statements.


## 1.1.0 (34) ##

*   Added automatic fixture setup and instance variable availability. Fixtures can also be automatically
    instantiated in instance variables relating to their names using the following style:

        class FixturesTest < Test::Unit::TestCase
          fixtures :developers # you can add more with comma separation

          def test_developers
            assert_equal 3, @developers.size # the container for all the fixtures is automatically set
            assert_kind_of Developer, @david # works like @developers["david"].find
            assert_equal "David Heinemeier Hansson", @david.name
          end
        end

*   Added HasAndBelongsToManyAssociation#push_with_attributes(object, join_attributes) that can create associations in the join table with additional
    attributes. This is really useful when you have information that's only relevant to the join itself, such as a "added_on" column for an association
    between post and category. The added attributes will automatically be injected into objects retrieved through the association similar to the piggy-back
    approach:

        post.categories.push_with_attributes(category, :added_on => Date.today)
        post.categories.first.added_on # => Date.today

    NOTE: The categories table doesn't have a added_on column, it's the categories_post join table that does!

*   Fixed that :exclusively_dependent and :dependent can't be activated at the same time on has_many associations *Jeremy Kemper*

*   Fixed that database passwords couldn't be all numeric *Jeremy Kemper*

*   Fixed that calling id would create the instance variable for new_records preventing them from being saved correctly *Jeremy Kemper*

*   Added sanitization feature to HasManyAssociation#find_all so it works just like Base.find_all *Sam Stephenson/Jeremy Kemper*

*   Added that you can pass overlapping ids to find without getting duplicated records back *Jeremy Kemper*

*   Added that Base.benchmark returns the result of the block *Jeremy Kemper*

*   Fixed problem with unit tests on Windows with SQLite *paterno*

*   Fixed that quotes would break regular non-yaml fixtures *Dmitry Sabanin/daft*

*   Fixed fixtures on windows with line endings cause problems under unix / mac *Tobias Lütke*

*   Added HasAndBelongsToManyAssociation#find(id) that'll search inside the collection and find the object or record with that id

*   Added :conditions option to has_and_belongs_to_many that works just like the one on all the other associations

*   Added AssociationCollection#clear to remove all associations from has_many and has_and_belongs_to_many associations without destroying the records *geech*

*   Added type-checking and remove in 1-instead-of-N sql statements to AssociationCollection#delete *geech*

*   Added a return of self to AssociationCollection#<< so appending can be chained, like project << Milestone.create << Milestone.create *geech*

*   Added Base#hash and Base#eql? which means that all of the equality using features of array and other containers now works:

        [ Person.find(1), Person.find(2), Person.find(3) ] & [ Person.find(1), Person.find(4) ] # => [ Person.find(1) ]

*   Added :uniq as an option to has_and_belongs_to_many which will automatically ensure that AssociateCollection#uniq is called
    before pulling records out of the association. This is especially useful for three-way (and above) has_and_belongs_to_many associations.

*   Added AssociateCollection#uniq which is especially useful for has_and_belongs_to_many associations that can include duplicates,
    which is common on associations that also use metadata. Usage: post.categories.uniq

*   Fixed respond_to? to use a subclass specific hash instead of an Active Record-wide one

*   Fixed has_and_belongs_to_many to treat associations between classes in modules properly *Florian Weber*

*   Added a NoMethod exception to be raised when query and writer methods are called for attributes that doesn't exist *geech*

*   Added a more robust version of Fixtures that throws meaningful errors when on formatting issues *geech*

*   Added Base#transaction as a compliment to Base.transaction for prettier use in instance methods *geech*

*   Improved the speed of respond_to? by placing the dynamic methods lookup table in a hash *geech*

*   Added that any additional fields added to the join table in a has_and_belongs_to_many association
    will be placed as attributes when pulling records out through has_and_belongs_to_many associations.
    This is helpful when have information about the association itself that you want available on retrival.

*   Added better loading exception catching and RubyGems retries to the database adapters *alexeyv*

*   Fixed bug with per-model transactions *daniel*

*   Fixed Base#transaction so that it returns the result of the last expression in the transaction block *alexeyv*

*   Added Fixture#find to find the record corresponding to the fixture id. The record
    class name is guessed by using Inflector#classify (also new) on the fixture directory name.

        Before: Document.find(@documents["first"]["id"])
        After : @documents["first"].find

*   Fixed that the table name part of column names ("TABLE.COLUMN") wasn't removed properly *Andreas Schwarz*

*   Fixed a bug with Base#size when a finder_sql was used that didn't capitalize SELECT and FROM *geech*

*   Fixed quoting problems on SQLite by adding quote_string to the AbstractAdapter that can be overwritten by the concrete
    adapters for a call to the dbm. *Andreas Schwarz*

*   Removed RubyGems backup strategy for requiring SQLite-adapter -- if people want to use gems, they're already doing it with AR.


## 1.0.0 (35) ##

*   Added OO-style associations methods [Florian Weber]. Examples:

        Project#milestones_count       => Project#milestones.size
        Project#build_to_milestones    => Project#milestones.build
        Project#create_for_milestones  => Project#milestones.create
        Project#find_in_milestones     => Project#milestones.find
        Project#find_all_in_milestones => Project#milestones.find_all

*   Added serialize as a new class method to control when text attributes should be YAMLized or not. This means that automated
    serialization of hashes, arrays, and so on WILL NO LONGER HAPPEN (#10). You need to do something like this:

        class User < ActiveRecord::Base
          serialize :settings
        end

    This will assume that settings is a text column and will now YAMLize any object put in that attribute. You can also specify
    an optional :class_name option that'll raise an exception if a serialized object is retrieved as a descendant of a class not in
    the hierarchy. Example:

        class User < ActiveRecord::Base
          serialize :settings, :class_name => "Hash"
        end

        user = User.create("settings" => %w( one two three ))
        User.find(user.id).settings # => raises SerializationTypeMismatch

*   Added the option to connect to a different database for one model at a time. Just call establish_connection on the class
    you want to have connected to another database than Base. This will automatically also connect decendents of that class
    to the different database [Renald Buter].

*   Added transactional protection for Base#save. Validations can now check for values knowing that it happens in a transaction and callbacks
    can raise exceptions knowing that the save will be rolled back. *Suggested by Alexey Verkhovsky*

*   Added column name quoting so reserved words, such as "references", can be used as column names *Ryan Platte*

*   Added the possibility to chain the return of what happened inside a logged block [geech]:

        This now works:
          log { ... }.map { ... }

        Instead of doing:
          result = []
          log { result = ... }
          result.map { ... }

*   Added "socket" option for the MySQL adapter, so you can change it to something else than "/tmp/mysql.sock" *Anna Lissa Cruz*

*   Added respond_to? answers for all the attribute methods. So if Person has a name attribute retrieved from the table schema,
    person.respond_to? "name" will return true.

*   Added Base.benchmark which can be used to aggregate logging and benchmark, so you can measure and represent multiple statements in a single block.
    Usage (hides all the SQL calls for the individual actions and calculates total runtime for them all):

        Project.benchmark("Creating project") do
          project = Project.create("name" => "stuff")
          project.create_manager("name" => "David")
          project.milestones << Milestone.find_all
        end

*   Added logging of invalid SQL statements *Daniel Von Fange*

*   Added alias Errors#[] for Errors#on, so you can now say person.errors["name"] to retrieve the errors for name *Andreas Schwarz*

*   Added RubyGems require attempt if sqlite-ruby is not available through regular methods.

*   Added compatibility with 2.x series of sqlite-ruby drivers. *Jamis Buck*

*   Added type safety for association assignments, so a ActiveRecord::AssociationTypeMismatch will be raised if you attempt to
    assign an object that's not of the associated class. This cures the problem with nil giving id = 4 and fixnums giving id = 1 on
    mistaken association assignments. *Reported by Andreas Schwarz*

*   Added the option to keep many fixtures in one single YAML document *what-a-day*

*   Added the class method "inheritance_column" that can be overwritten to return the name of an alternative column than "type" for storing
    the type for inheritance hierarchies. *Dave Steinberg*

*   Added [] and []= as an alternative way to access attributes when the regular methods have been overwritten *Dave Steinberg*

*   Added the option to observer more than one class at the time by specifying observed_class as an array

*   Added auto-id propagation support for tables with arbitrary primary keys that have autogenerated sequences associated with them
    on PostgreSQL. *Dave Steinberg*

*   Changed that integer and floats set to "" through attributes= remain as NULL. This was especially a problem for scaffolding and postgresql. (#49)

*   Changed the MySQL Adapter to rely on MySQL for its defaults for socket, host, and port *Andreas Schwarz*

*   Changed ActionControllerError to decent from StandardError instead of Exception. It can now be caught by a generic rescue.

*   Changed class inheritable attributes to not use eval *Caio Chassot*

*   Changed Errors#add to now use "invalid" as the default message instead of true, which means full_messages work with those *Marcel Molina Jr.*

*   Fixed spelling on Base#add_on_boundry_breaking to Base#add_on_boundary_breaking (old naming still works) *Marcel Molina Jr.*

*   Fixed that entries in the has_and_belongs_to_many join table didn't get removed when an associated object was destroyed.

*   Fixed unnecessary calls to SET AUTOCOMMIT=0/1 for MySQL adapter *Andreas Schwarz*

*   Fixed PostgreSQL defaults are now handled gracefully *Dave Steinberg*

*   Fixed increment/decrement_counter are now atomic updates *Andreas Schwarz*

*   Fixed the problems the Inflector had turning Attachment into attuchments and Cases into Casis *radsaq/Florian Gross*

*   Fixed that cloned records would point attribute references on the parent object *Andreas Schwarz*

*   Fixed SQL for type call on inheritance hierarchies *Caio Chassot*

*   Fixed bug with typed inheritance *Florian Weber*

*   Fixed a bug where has_many collection_count wouldn't use the conditions specified for that association


## 0.9.5 ##

*   Expanded the table_name guessing rules immensely [Florian Green]. Documentation:

        Guesses the table name (in forced lower-case) based on the name of the class in the inheritance hierarchy descending
        directly from ActiveRecord. So if the hierarchy looks like: Reply < Message < ActiveRecord, then Message is used
        to guess the table name from even when called on Reply. The guessing rules are as follows:
        * Class name ends in "x", "ch" or "ss": "es" is appended, so a Search class becomes a searches table.
        * Class name ends in "y" preceded by a consonant or "qu": The "y" is replaced with "ies",
          so a Category class becomes a categories table.
        * Class name ends in "fe": The "fe" is replaced with "ves", so a Wife class becomes a wives table.
        * Class name ends in "lf" or "rf": The "f" is replaced with "ves", so a Half class becomes a halves table.
        * Class name ends in "person": The "person" is replaced with "people", so a Salesperson class becomes a salespeople table.
        * Class name ends in "man": The "man" is replaced with "men", so a Spokesman class becomes a spokesmen table.
        * Class name ends in "sis": The "i" is replaced with an "e", so a Basis class becomes a bases table.
        * Class name ends in "tum" or "ium": The "um" is replaced with an "a", so a Datum class becomes a data table.
        * Class name ends in "child": The "child" is replaced with "children", so a NodeChild class becomes a node_children table.
        * Class name ends in an "s": No additional characters are added or removed.
        * Class name doesn't end in "s": An "s" is appended, so a Comment class becomes a comments table.
        * Class name with word compositions: Compositions are underscored, so CreditCard class becomes a credit_cards table.
        Additionally, the class-level table_name_prefix is prepended to the table_name and the table_name_suffix is appended.
        So if you have "myapp_" as a prefix, the table name guess for an Account class becomes "myapp_accounts".

        You can also overwrite this class method to allow for unguessable links, such as a Mouse class with a link to a
        "mice" table. Example:

          class Mouse < ActiveRecord::Base
             def self.table_name() "mice" end
          end

    This conversion is now done through an external class called Inflector residing in lib/active_record/support/inflector.rb.

*   Added find_all_in_collection to has_many defined collections. Works like this:

        class Firm < ActiveRecord::Base
          has_many :clients
        end

        firm.id # => 1
        firm.find_all_in_clients "revenue > 1000" # SELECT * FROM clients WHERE firm_id = 1 AND revenue > 1000

    *Requested by Dave Thomas*

*   Fixed finders for inheritance hierarchies deeper than one level *Florian Weber*

*   Added add_on_boundry_breaking to errors to accompany add_on_empty as a default validation method. It's used like this:

        class Person < ActiveRecord::Base
          protected
            def validation
              errors.add_on_boundry_breaking "password", 3..20
            end
        end

    This will add an error to the tune of "is too short (minimum is 3 characters)" or "is too long (minimum is 20 characters)" if
    the password is outside the boundry. The messages can be changed by passing a third and forth parameter as message strings.

*   Implemented a clone method that works properly with AR. It returns a clone of the record that
    hasn't been assigned an id yet and is treated as a new record.

*   Allow for domain sockets in PostgreSQL by not assuming localhost when no host is specified *Scott Barron*

*   Fixed that bignums are saved properly instead of attempted to be YAMLized *Andreas Schwartz*

*   Fixed a bug in the GEM where the rdoc options weren't being passed according to spec *Chad Fowler*

*   Fixed a bug with the exclusively_dependent option for has_many


## 0.9.4 ##

*   Correctly guesses the primary key when the class is inside a module [Dave Steinberg].

*   Added [] and []= as alternatives to read_attribute and write_attribute *Dave Steinberg*

*   has_and_belongs_to_many now accepts an :order key to determine in which order the collection is returned [radsaq].

*   The ids passed to find and find_on_conditions are now automatically sanitized.

*   Added escaping of plings in YAML content.

*   Multi-parameter assigns where all the parameters are empty will now be set to nil instead of a new instance of their class.

*   Proper type within an inheritance hierarchy is now ensured already at object initialization (instead of first at create)


## 0.9.3 ##

*   Fixed bug with using a different primary key name together with has_and_belongs_to_many *Investigation by Scott*

*   Added :exclusively_dependent option to the has_many association macro. The doc reads:

        If set to true all the associated object are deleted in one SQL statement without having their
        before_destroy callback run. This should only be used on associations that depend solely on
        this class and don't need to do any clean-up in before_destroy. The upside is that it's much
        faster, especially if there's a counter_cache involved.

*   Added :port key to connection options, so the PostgreSQL and MySQL adapters can connect to a database server
    running on another port than the default.

*   Converted the new natural singleton methods that prevented AR objects from being saved by PStore
    (and hence be placed in a Rails session) to a module. *Florian Weber*

*   Fixed the use of floats (was broken since 0.9.0+)

*   Fixed PostgreSQL adapter so default values are displayed properly when used in conjunction with
    Action Pack scaffolding.

*   Fixed booleans support for PostgreSQL (use real true/false on boolean fields instead of 0/1 on tinyints) *radsaq*


## 0.9.2 ##

*   Added static method for instantly updating a record

*   Treat decimal and numeric as Ruby floats *Andreas Schwartz*

*   Treat chars as Ruby strings (fixes problem for Action Pack form helpers too)

*   Removed debugging output accidently left in (which would screw web applications)


## 0.9.1 ##

*   Added MIT license

*   Added natural object-style assignment for has_and_belongs_to_many associations. Consider the following model:

        class Event < ActiveRecord::Base
          has_one_and_belongs_to_many :sponsors
        end

        class Sponsor < ActiveRecord::Base
          has_one_and_belongs_to_many :sponsors
        end

    Earlier, you'd have to use synthetic methods for creating associations between two objects of the above class:

        roskilde_festival.add_to_sponsors(carlsberg)
        roskilde_festival.remove_from_sponsors(carlsberg)

        nike.add_to_events(world_cup)
        nike.remove_from_events(world_cup)

    Now you can use regular array-styled methods:

        roskilde_festival.sponsors << carlsberg
        roskilde_festival.sponsors.delete(carlsberg)

        nike.events << world_cup
        nike.events.delete(world_cup)

*   Added delete method for has_many associations. Using this will nullify an association between the has_many and the belonging
    object by setting the foreign key to null. Consider this model:

        class Post < ActiveRecord::Base
          has_many :comments
        end

        class Comment < ActiveRecord::Base
          belongs_to :post
        end

    You could do something like:

        funny_comment.has_post? # => true
        announcement.comments.delete(funny_comment)
        funny_comment.has_post? # => false


## 0.9.0 ##

*   Active Record is now thread safe! (So you can use it with Cerise and WEBrick applications)
    *Implementation idea by Michael Neumann, debugging assistance by Jamis Buck*

*   Improved performance by roughly 400% on a basic test case of pulling 100 records and querying one attribute.
    This brings the tax for using Active Record instead of "riding on the metal" (using MySQL-ruby C-driver directly) down to ~50%.
    Done by doing lazy type conversions and caching column information on the class-level.

*   Added callback objects and procs as options for implementing the target for callback macros.

*   Added "counter_cache" option to belongs_to that automates the usage of increment_counter and decrement_counter. Consider:

        class Post < ActiveRecord::Base
          has_many :comments
        end

        class Comment < ActiveRecord::Base
          belongs_to :post
        end

    Iterating over 100 posts like this:

        <% for post in @posts %>
          <%= post.title %> has <%= post.comments_count %> comments
        <% end %>

    Will generate 100 SQL count queries -- one for each call to post.comments_count. If you instead add a "comments_count" int column
    to the posts table and rewrite the comments association macro with:

        class Comment < ActiveRecord::Base
          belongs_to :post, :counter_cache => true
        end

    Those 100 SQL count queries will be reduced to zero. Beware that counter caching is only appropriate for objects that begin life
    with the object it's specified to belong with and is destroyed like that as well. Typically objects where you would also specify
    :dependent => true. If your objects switch from one belonging to another (like a post that can be move from one category to another),
    you'll have to manage the counter yourself.

*   Added natural object-style assignment for has_one and belongs_to associations. Consider the following model:

        class Project < ActiveRecord::Base
          has_one :manager
        end

        class Manager < ActiveRecord::Base
          belongs_to :project
        end

    Earlier, assignments would work like following regardless of which way the assignment told the best story:

        active_record.manager_id = david.id

    Now you can do it either from the belonging side:

        david.project = active_record

    ...or from the having side:

        active_record.manager = david

    If the assignment happens from the having side, the assigned object is automatically saved. So in the example above, the
    project_id attribute on david would be set to the id of active_record, then david would be saved.

*   Added natural object-style assignment for has_many associations [Florian Weber]. Consider the following model:

        class Project < ActiveRecord::Base
          has_many :milestones
        end

        class Milestone < ActiveRecord::Base
          belongs_to :project
        end

    Earlier, assignments would work like following regardless of which way the assignment told the best story:

        deadline.project_id = active_record.id

    Now you can do it either from the belonging side:

        deadline.project = active_record

    ...or from the having side:

        active_record.milestones << deadline

    The milestone is automatically saved with the new foreign key.

*   API CHANGE: Attributes for text (or blob or similar) columns will now have unknown classes stored using YAML instead of using
    to_s. (Known classes that won't be yamelized are: String, NilClass, TrueClass, FalseClass, Fixnum, Date, and Time).
    Likewise, data pulled out of text-based attributes will be attempted converged using Yaml if they have the "--- " header.
    This was primarily done to be enable the storage of hashes and arrays without wrapping them in aggregations, so now you can do:

        user = User.find(1)
        user.preferences = { "background" => "black", "display" => large }
        user.save

        User.find(1).preferences # => { "background" => "black", "display" => large }

    Please note that this method should only be used when you don't care about representing the object in proper columns in
    the database. A money object consisting of an amount and a currency is still a much better fit for a value object done through
    aggregations than this new option.

*   POSSIBLE CODE BREAKAGE: As a consequence of the lazy type conversions, it's a bad idea to reference the @attributes hash
    directly (it always was, but now it's paramount that you don't). If you do, you won't get the type conversion. So to implement
    new accessors for existing attributes, use read_attribute(attr_name) and write_attribute(attr_name, value) instead. Like this:

        class Song < ActiveRecord::Base
          # Uses an integer of seconds to hold the length of the song

          def length=(minutes)
            write_attribute("length", minutes * 60)
          end

          def length
            read_attribute("length") / 60
          end
        end

    The clever kid will notice that this opens a door to sidestep the automated type conversion by using @attributes directly.
    This is not recommended as read/write_attribute may be granted additional responsibilities in the future, but if you think
    you know what you're doing and aren't afraid of future consequences, this is an option.

*   Applied a few minor bug fixes reported by Daniel Von Fange.


## 0.8.4 ##

    _Reflection_

*   Added ActiveRecord::Reflection with a bunch of methods and classes for reflecting in aggregations and associations.

*   Added Base.columns and Base.content_columns which returns arrays of column description (type, default, etc) objects.

*   Added Base#attribute_names which returns an array of names for the attributes available on the object.

*   Added Base#column_for_attribute(name) which returns the column description object for the named attribute.


    _Misc_

*   Added multi-parameter assignment:

        # Instantiate objects for all attribute classes that needs more than one constructor parameter. This is done
        # by calling new on the column type or aggregation type (through composed_of) object with these parameters.
        # So having the pairs written_on(1) = "2004", written_on(2) = "6", written_on(3) = "24", will instantiate
        # written_on (a date type) with Date.new("2004", "6", "24"). You can also specify a typecast character in the
        # parenteses to have the parameters typecasted before they're used in the constructor. Use i for Fixnum, f for Float,
        # s for String, and a for Array.

    This is incredibly useful for assigning dates from HTML drop-downs of month, year, and day.

*   Fixed bug with custom primary key column name and Base.find on multiple parameters.

*   Fixed bug with dependent option on has_one associations if there was no associated object.


## 0.8.3 ##

    _Transactions_

*   Added transactional protection for destroy (important for the new :dependent option) *Suggested by Carl Youngblood*

*   Fixed so transactions are ignored on MyISAM tables for MySQL (use InnoDB to get transactions)

*   Changed transactions so only exceptions will cause a rollback, not returned false.


    _Mapping_

*   Added support for non-integer primary keys *Aredridel/earlier work by Michael Neumann*

        User.find "jdoe"
        Product.find "PDKEY-INT-12"

*   Added option to specify naming method for primary key column. ActiveRecord::Base.primary_key_prefix_type can either
    be set to nil, :table_name, or :table_name_with_underscore. :table_name will assume that Product class has a primary key
    of "productid" and :table_name_with_underscore will assume "product_id". The default nil will just give "id".

*   Added an overwriteable primary_key method that'll instruct AR to the name of the
    id column *Aredridele/earlier work by Guan Yang*

        class Project < ActiveRecord::Base
          def self.primary_key() "project_id" end
        end

*   Fixed that Active Records can safely associate inside and out of modules.

        class MyApplication::Account < ActiveRecord::Base
          has_many :clients # will look for MyApplication::Client
          has_many :interests, :class_name => "Business::Interest" # will look for Business::Interest
        end

*   Fixed that Active Records can safely live inside modules *Aredridel*

        class MyApplication::Account < ActiveRecord::Base
        end


    _Misc_

*   Added freeze call to value object assignments to ensure they remain immutable *Spotted by Gavin Sinclair*

*   Changed interface for specifying observed class in observers. Was OBSERVED_CLASS constant, now is
    observed_class() class method. This is more consistant with things like self.table_name(). Works like this:

        class AuditObserver < ActiveRecord::Observer
          def self.observed_class() Account end
          def after_update(account)
            AuditTrail.new(account, "UPDATED")
          end
        end

    *Suggested by Gavin Sinclair*

*   Create new Active Record objects by setting the attributes through a block. Like this:

        person = Person.new do |p|
          p.name = 'Freddy'
          p.age  = 19
        end

    *Suggested by Gavin Sinclair*


## 0.8.2 ##

*   Added inheritable callback queues that can ensure that certain callback methods or inline fragments are
    run throughout the entire inheritance hierarchy. Regardless of whether a descendant overwrites the callback
    method:

        class Topic < ActiveRecord::Base
          before_destroy :destroy_author, 'puts "I'm an inline fragment"'
        end

    Learn more in link:classes/ActiveRecord/Callbacks.html

*   Added :dependent option to has_many and has_one, which will automatically destroy associated objects when
    the holder is destroyed:

        class Album < ActiveRecord::Base
          has_many :tracks, :dependent => true
        end

    All the associated tracks are destroyed when the album is.

*   Added Base.create as a factory that'll create, save, and return a new object in one step.

*   Automatically convert strings in config hashes to symbols for the _connection methods. This allows you
    to pass the argument hashes directly from yaml. (Luke)

*   Fixed the install.rb to include simple.rb *Spotted by Kevin Bullock*

*   Modified block syntax to better follow our code standards outlined in
    http://www.rubyonrails.org/CodingStandards


## 0.8.1 ##

*   Added object-level transactions *Austin Ziegler*

*   Changed adapter-specific connection methods to use centralized ActiveRecord::Base.establish_connection,
    which is parametized through a config hash with symbol keys instead of a regular parameter list.
    This will allow for database connections to be opened in a more generic fashion. (Luke)

    NOTE: This requires all *_connections to be updated! Read more in:
    http://ar.rubyonrails.org/classes/ActiveRecord/Base.html#M000081

*   Fixed SQLite adapter so objects fetched from has_and_belongs_to_many have proper attributes
    (t.name is now name). *Spotted by Garrett Rooney*

*   Fixed SQLite adapter so dates are returned as Date objects, not Time objects *Spotted by Gavin Sinclair*

*   Fixed requirement of date class, so date conversions are succesful regardless of whether you
    manually require date or not.


## 0.8.0 ##

*   Added transactions

*   Changed Base.find to also accept either a list (1, 5, 6) or an array of ids ([5, 7])
    as parameter and then return an array of objects instead of just an object

*   Fixed method has_collection? for has_and_belongs_to_many macro to behave as a
    collection, not an association

*   Fixed SQLite adapter so empty or nil values in columns of datetime, date, or time type
    aren't treated as current time *Spotted by Gavin Sinclair*


## 0.7.6 ##

*   Fixed the install.rb to create the lib/active_record/support directory *Spotted by Gavin Sinclair*
*   Fixed that has_association? would always return true *Daniel Von Fange*
