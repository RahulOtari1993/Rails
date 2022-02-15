json.set! :data do
  json.array! @sportannouncements do |sportannouncement|
    json.partial! 'sportannouncements/sportannouncement', sportannouncement: sportannouncement
    json.url  "
              #{link_to 'Show', sportannouncement }
              #{link_to 'Edit', edit_sportannouncement_path(sportannouncement)}
              #{link_to 'Destroy', sportannouncement, method: :delete, data: { confirm: 'Are you sure?' }}
              "
  end
end