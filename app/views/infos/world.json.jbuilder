json.array!(@infos) do |info|
  json.extract! info, :id, :created_at, :main_post, :title
  json.url info_url(info, format: :json)
end
