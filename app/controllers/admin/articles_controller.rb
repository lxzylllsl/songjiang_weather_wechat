module Admin
  class ArticlesController < BaseController
    
    def index
      @articles = Article.all.paginate(:page => params[:page], :per_page => 20)
    end

    def new
      @article = Article.new
    end

    def edit
      @article = Article.find_by(id: params[:id])
    end

    def create
      @article = Article.new(article_params)
      p @article
      if @article.save
        flash[:notice] = "创建成功"
        redirect_to admin_articles_path
      else
        flash[:notice] = "创建失败"
        render :new
      end
    end

    private 
    def article_params
      params.require(:article).permit(:title, :description, :datetime, :author, :content, :picture )
    end
  end
end
