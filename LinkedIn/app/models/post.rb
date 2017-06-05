

class Post < ActiveRecord::Base
  include Shared::Callbacks

  
  # include Mongoid::Document
  # include Mongoid::Timestamps
  # def user
  #   User.find(self.user_id)
  # end
  # belongs_to : Post.user


  belongs_to :user
  counter_culture :user
  acts_as_votable
  acts_as_commentable

  include PublicActivity::Model
  tracked only: [:create, :like], owner: proc { |_controller, model| model.user }

  default_scope -> { order('created_at DESC') }

  mount_uploader :attachment, AvatarUploader

  validates_presence_of :content
  validates_presence_of :user

  auto_html_for :content do
    image(width: 300, height: 300)
    youtube(width: 300, height: 300, autoplay: true)
    link target: '_blank', rel: 'nofollow'
    simple_format
  end


end
