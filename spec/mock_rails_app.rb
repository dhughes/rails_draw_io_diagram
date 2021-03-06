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
    t.integer :reference_object_id
    t.string  :reference_object_type
  end
  create_table :partners, force: true do |t|
    t.string :name
    t.string :code
    t.references :vertical
  end
  create_table :verticals, force: true do |t|
    t.string :name
  end
  create_table :partner_automation_settings, force: true do |t|
    t.references :partner
  end
  create_table :real_estate_agents, force: true do |t|
    t.string :first_name
    t.string :last_name
  end
  create_table :listings, force: true do |t|
    t.string :address
    t.string :city
    t.string :state
    t.string :postal_code
  end
end

# Set up model classes
class Campaign < ActiveRecord::Base
  belongs_to :partner
  belongs_to :vertical
  belongs_to :reference_object, polymorphic: true
end
class Partner < ActiveRecord::Base
  has_many :campaigns
  belongs_to :vertical
  has_one :partner_automation_setting
end
class Vertical < ActiveRecord::Base
  has_many :partners
end
class PartnerAutomationSetting < ActiveRecord::Base
  belongs_to :partner
end
class RealEstateAgent < ActiveRecord::Base
  has_many :campaigns, as: :reference_object
end
class Listing < ActiveRecord::Base
  has_many :campaigns, as: :reference_object
end
