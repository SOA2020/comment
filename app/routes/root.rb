# frozen_string_literal: true

ROOT_ROUTE = proc do
  get '' do
    { status: 'running' }.to_json
  end

  get ':item_id/comments' do |item_id|
    page = (params[:page] || 1).to_i
    size = (params[:size] || 10).to_i
    comments = Comment.where(item_id: item_id)
    yajl :comments, locals: { count: comments.count,
                              page: page,
                              size: size,
                              comments: comments.paginate(page, size) }
  end

  post ':item_id/comments' do |item_id|
    req = JSON.parse(request.body.read)
    comment = Comment.create(
      item_id: item_id,
      user_id: req['userId'],
      content: req['content']
    )
    yajl :comment, locals: { comment: comment }
  end

  delete ':item_id/comments/:id' do |item_id, id|
    comment = Comment.where(item_id: item_id, id: id)&.first
    raise NotFoundError.new("Comment: #{comment}", 'Comment Not Existed') if comment.nil?

    comment.delete
    yajl :empty
  end
end
