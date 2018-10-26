require 'sqlite3'
require 'active_record'

# Set up a database that resides in RAM
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

# Set up database tables and columns
ActiveRecord::Schema.define do
  create_table :campaigns, force: true do |t|
    t.string :product_code
    t.string :name
    t.string :status
    t.references :partner
    t.references :vertical
  end
  create_table :partners, force: true do |t|
    t.string :name
    t.string :code
    t.references :vertical
  end
  create_table :verticals, force: true do |t|
    t.string :name
  end
end

# Set up model classes
class Campaign < ActiveRecord::Base
  belongs_to :partner
  belongs_to :vertical
end
class Partner < ActiveRecord::Base
  has_many :campaigns
  belongs_to :vertical
end
class Vertical < ActiveRecord::Base
  has_many :partners
end
