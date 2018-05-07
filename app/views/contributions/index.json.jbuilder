json.array!(@contributions) do |contribution|
  if contribution.url != ""
    json.extract! contribution, :id, :title, :url, :text, :user_id, :created_at, :updated_at, :points
    json.set! "_links" do
      json.set! "self" do
        json.set! "href", contribution_url(contribution, format: :json)
      end
      json.set! "user" do
        json.set! "href", user_url(contribution.user, format: :json)
      end
  end
  end
end
