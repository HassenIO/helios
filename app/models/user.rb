class User < ActiveRecord::Base

	ROLES = %w[admin user]

	rolify
	# Include default devise modules. Others available are:
	# :token_authenticatable, :confirmable,
	# :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable, :confirmable,
				 :recoverable, :rememberable, :trackable, :validatable

	devise :omniauthable, :omniauth_providers => [:facebook, :facebook_signup_tc]

	# Setup accessible (or protected) attributes for your model
	attr_accessible :role_ids, :as => :admin
	attr_accessible :name, :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :provider, :uid
	attr_accessible :address, :city, :country, :zip_code, :license, :license_year, :birth_date


	has_many :cars
	has_many :travels
	has_many :rents


	#validates :address, :presence => true, :on => :update
	#validates :city, :presence => true, :on => :update
	#validates :country, :presence => true, :on => :update
	#validates :zip_code, :presence => true, :on => :update
	#validates :first_name, :presence => true, :on => :update
	#validates :last_name, :presence => true, :on => :update
	#validates :license, :presence => true
	#validates :license_year, :presence => true
	#
	#
	#with_options :unless => :is_omniauth? do
	#  validates :address, :presence => true, :on => :create
	#  validates :city, :presence => true, :on => :create
	#  validates :country, :presence => true, :on => :create
	#  validates :zip_code, :presence => true, :on => :create
	#  validates :first_name, :presence => true, :on => :create
	#  validates :last_name, :presence => true, :on => :create
	#end


	def is_omniauth
		true
	end

	def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
		user = User.where(:provider => auth.provider, :uid => auth.uid).first
		unless user
			#associate if email exist but not a facebook one
			user = User.find_by_email(auth.info.email)

			if user
				user.birth_date ||= auth.extra.raw_info.birthday
				user.first_name ||= auth.info.first_name
				user.last_name ||= auth.info.last_name
				user.provider ||= auth.provider
				user.uid ||= auth.uid

				user.save

			else
				user = User.create(	first_name: auth.info.first_name,
									last_name: auth.info.last_name,
									provider: auth.provider,
									uid: auth.uid,
									birth_date: auth.extra.raw_info.birthday,
									email: auth.info.email,
									password: Devise.friendly_token[0, 20]
				)
				#user.skip_confirmation!
				#user.save
			end


		end
		user
	end

	def self.new_with_session(params, session)
		super.tap do |user|
			if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
				user.email = data["email"] if user.email.blank?
				user.first_name = data["first_name"] if user.first_name.blank?
				user.last_name = data["last_name"] if user.last_name.blank?
			end
		end
	end

end
