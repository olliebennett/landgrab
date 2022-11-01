# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :subscriptions, dependent: :restrict_with_exception
  has_many :posts_authored, class_name: 'Post', foreign_key: 'author_id', inverse_of: :author, dependent: :restrict_with_exception

  def display_name
    email.split('@').first
  end
end
