class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable and :omniauthable
  devise :database_authenticatable, :lockable, :registerable,
         :recoverable, :rememberable, :timeoutable, :trackable,
         :validatable
end
