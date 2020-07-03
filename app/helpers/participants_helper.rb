module ParticipantsHelper
  ## Display Challenges of a Campaign
  def all_challenges_filter
    @campaign.challenges.pluck(:name, :id)
  end

  ## Display Rewards of a Campaign
  def all_rewards_filter
    @campaign.rewards.pluck(:name, :id)
  end

  # Dynamically Pick Tags UI Class
  def tags_class
    ['chip-success', 'chip-warning', 'chip-danger', 'chip-primary'].sample
  end

  # Checking Birth Date and Showing in Specific Format
  def participant_birth_date(participant)
    participant.birth_date.present? ? participant.birth_date.strftime("%m/%d/%y")+ ' - ': ''
  end

  # Checking Age and Birth Date
  def participant_age(participant) 
    if participant.age == 0
      participant.birth_date.present? ? (Date.current.strftime("%Y").to_i - participant.birth_date.strftime("%Y").to_i) : ''
    else
      participant.age
    end
  end

  # Displaying Title and Details together
  def title_details(participant_action)
    "#{participant_action.title} #{participant_action.details}"
  end

  # Displaying Participant Notes List in Descending Order
  def participant_notes_by_desc(participant)
    return participant.notes.order('description desc')
  end
    
  ## Display % of Targeted Users
  def targeted_users_percentage
    total_participants = @challenge.campaign.participants.count
    targeted_participants = @challenge.targeted_participants
    if targeted_participants.count > 0 && total_participants.to_i > 0
      percentage = (targeted_participants.count * 100 ) / total_participants.to_i
    else
      percentage = 0
    end

    percentage
  end
end
