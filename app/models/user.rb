class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessor :login

	belongs_to :entree
  belongs_to :plus_one_entree, class_name: "Entree", :foreign_key => :plus_one_entree_id

	validates :username,
					  :presence => true,
						  :uniqueness => {
					    :case_sensitive => false
	  }

  def self.find_first_by_auth_conditions(warden_conditions)
					conditions = warden_conditions.dup
					if login = conditions.delete(:login)
									where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
					else
									if conditions[:username].nil?
													where(conditions).first
									else
													where(username: conditions[:username]).first
									end
					end
	end

  def email_required?
    false
  end

  def self.to_csv(exportable_users)
    attributes = ["First Name", "Last Name", "Username", "Email", "RSVP?", "Plus one?","Entree", "Plus One Entree"]

    CSV.generate(headers: true) do |csv|
      csv << attributes.map{ |value| value}
      exportable_users.each do |guest|
        csv << [guest.first_name, guest.last_name, guest.username, guest.email, guest.attending, guest.plusone, guest.entree ? guest.entree.description : "", guest.plus_one_entree ? guest.plus_one_entree.description : ""]
      end
    end
  end
end
