# frozen_string_literal: true

ROOT_ROUTE = proc do
  get '' do
    { status: 'running' }.to_json
  end

  get ':commodity_id/comments' do |commodity_id|
    page = (params[:page] || 1).to_i
    size = (params[:size] || 10).to_i
    comments = Comment.where(commodity_id: commodity_id)
    yajl :comments, locals: { count: comments.count,
                              page: page,
                              size: size,
                              comments: comments.paginate(page, size) }
  end

  post ':commodity_id/comments' do |commodity_id|
    req = JSON.parse(request.body.read)
    comment = Comment.create(
      commodity_id: commodity_id,
      user_id: req['userId'],
      content: req['content']
    )
    yajl :comment, locals: { comment: comment }
  end

  delete ':commodity_id/comments/:id' do |commodity_id, id|
    comment = Comment.where(commodity_id: commodity_id, id: id)&.first
    raise NotFoundError.new("Comment: #{comment}", 'Comment Not Existed') if comment.nil?

    comment.delete
    yajl :empty
  end
end
