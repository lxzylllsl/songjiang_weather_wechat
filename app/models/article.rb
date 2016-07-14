# == Schema Information
#
# Table name: articles
#
#  id                   :integer          not null, primary key
#  title                :string(255)
#  description          :string(255)
#  datetime             :datetime
#  author               :string(255)
#  content              :text(65535)
#  picture_file_name    :string(255)
#  picture_content_type :string(255)
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class Article < ActiveRecord::Base
  has_attached_file :picture, styles: { mini: '48x48>', small: '150x150>', medium: '300x300>', product: '600x600>', large: '1280x1280>' }

  validates_attachment_presence :picture
  validates_attachment_size     :picture, less_than: 5.megabytes
  validates_attachment_content_type :picture, content_type: /image\/.*\Z/

  
end
