json.extract! @reply, :id, :content, :user_id, :comment_id
json.set! "_links" do
    json.set! "self" do
      json.set! "href", reply_url(@reply, format: :json)
    end
    json.set! "user" do
      json.set! "href", user_url(@reply.user, format: :json)
    end
    json.set! "comment" do
      json.set! "href", comment_url(@reply.comment, format: :json)
    end
    json.set! "contribution" do
      json.set! "href", contribution_url(@reply.contribution, format: :json)
    end
  end
