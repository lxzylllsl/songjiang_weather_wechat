json.array!(@followers) do |follower|
  json.extract! follower, :id
  json.url follower_url(follower, format: :json)
end
