class Achievement < ApplicationRecord
    belongs_to :player

    validates :award, :medal, :player, presence: true 
end
