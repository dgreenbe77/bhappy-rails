json.array!(@infos) do |info|
  json.extract! info, :id, :created_at
  json.url info_url(info, format: :json)
end
