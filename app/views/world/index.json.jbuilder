json.array!(@happiness_logs) do |happiness_log|
  json.extract! happiness_log, :id, :created_at, :main_post, :title
  json.url happiness_log_url(happiness_log, format: :json)
end
