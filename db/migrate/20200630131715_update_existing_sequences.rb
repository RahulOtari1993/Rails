class UpdateExistingSequences < ActiveRecord::Migration[5.2]
  def change
    Challenge.all.each do |challenge|
      challenge.questions.each_with_index do |question, index|
        question.update_attribute(:sequence, index + 1)

        question.question_options.each_with_index do |option, index|
          option.update_attribute(:sequence, index + 1)
        end
      end
    end
  end
end
