class Entree < ActiveRecord::Base
  has_many :users
	has_many :plus_one_users, through: :users, :foreign_key => :plus_one_entree_id
end
