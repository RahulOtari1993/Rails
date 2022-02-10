class Achievement < ApplicationRecord
    belongs_to :player

    validates :award, :medal, :player, presence: true 
    extend FriendlyId
    friendly_id :award, use: :slugged
end
