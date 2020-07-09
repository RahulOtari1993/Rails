class UpdateQuestionCategory < ActiveRecord::Migration[5.2]
  def change
    Challenge.all.each do |challenge|
      challenge.questions.update_all(category: challenge.parameters.to_s) if challenge.questions.present?
    end
  end
end
