module Admin
  class PoemsController < BaseController
    respond_to :html, :js

    def index
      @poems = Poem.all.paginate(:page => params[:page], :per_page => 20)
    end

    def new
      @poem = Poem.new
    end

    def create
      @poem = Poem.new(poem_params)
      if @poem.save
        flash[:notice] = "创建成功"
        respond_with @poems
      else
        flash[:error] = "创建失败"
        render :new
      end
    end

    def destroy
      @poem = Poem.where(id: params[:id]).first
      @poem.destroy
      redirect_to admin_poems_path
    end

    private
    def poem_params
      params.require(:poem).permit(:author, :content, :solar)
    end
  end

end
