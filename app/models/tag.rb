class Tag < ApplicationRecord
    belongs_to :player
    belongs_to :post
end
