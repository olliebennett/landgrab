# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :subscriptions, dependent: :restrict_with_exception
  has_many :posts_authored, class_name: 'Post', foreign_key: 'author_id', inverse_of: :author, dependent: :restrict_with_exception
  has_many :comments_authored, class_name: 'Comment', inverse_of: :author, dependent: :restrict_with_exception

  validates :first_name, :last_name, length: { maximum: 255 }
  validates :stripe_customer_id, allow_blank: true,
                                 format: { with: /\Acus_[0-9a-zA-Z]+\z/ },
                                 uniqueness: true

  def full_name
    [first_name, last_name].join(' ')
  end

  def display_name
    first_name || email.split('@').first
  end

  def active_subscription_for_plot(plot)
    subscriptions.joins(:tile)
                 .where(tiles: { plot_id: plot.id })
                 .where(stripe_status: :active)
                 .first
  end
end
