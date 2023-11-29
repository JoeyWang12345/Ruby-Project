class Admin::CategoriesController < Admin::BaseController
  # 过滤器，对only后面的方法适用
  before_action :find_root_categories, only: [:new, :create, :edit, :update]
  before_action :find_category, only: [:edit, :update, :destroy, :show]
  def index
    # 如果id为空，即刚点进来
    if params[:id].blank?
      # 取得列表(只支持二级分类) 先分页再排序
      @categories = Category.roots
    else
      # 否则，先找到当前的一级分类
      @category = Category.find(params[:id])
      # 找到所有的子分类
      @categories = @category.children
    end
    # 消除冗余
    @categories = @categories.page(params[:page] || 1)
       .per_page(params[:per_page] || 10).order(id: "desc")
  end

  def new
    @category = Category.new # 初始化
  end

  def create # 表单提交来到create这里
    @category = Category.new(params.require(:category).permit!) # 所有的属性全允许
    # 由于new里面有需要有@root_categories，所以这里也要有
    if @category.save # 保存
      flash[:notice] = "保存成功"
      redirect_to admin_categories_path # 重定向到列表页面
    else # 模型验证没有通过，说明表单提交失败，即创建category失败
      render action: :new # 保存失败
    end
  end

  def edit
    # puts params
    # puts "11111111111111111111111"

    # 获得所有的一级评论
    render action: :new
  end

  def update # 编辑过后，会被提交到这里
    @category.attributes = params.require(:category).permit!

    if @category.save
      flash[:notice] = "编辑成功"
      redirect_to admin_categories_path
    else
      render action: :new
    end
  end

  def destroy
    # puts "123224234234243"
    if @category.destroy
      # puts "34823842893"
      flash[:notice] = "删除成功"
      redirect_to admin_categories_path
    else
      # puts "324872329"
      flash[:notice] = "删除失败"
      # 重定向到来源页面，也就是发起删除请求的页面(如果在第五六页删除失败，就不会返回到第一页面)
      redirect_to :back
    end
  end

  def show
    # destroy回来，是在这被调用的
    if @category.destroy
      # puts "34823842893"
      flash[:notice] = "删除成功"
      redirect_to admin_categories_path
    else
      # puts "324872329"
      flash[:notice] = "删除失败"
      # 重定向到来源页面，也就是发起删除请求的页面(如果在第五六页删除失败，就不会返回到第一页面)
      redirect_to :back
    end
    # render json: @category
    # redirect_to admin_categories_path
  end

  def find_root_categories
    # 查询出当前所有的一级分类，供选择使用
    @root_categories = Category.roots.order(id: "desc")
  end

  def find_category
    # 需要保证命名一致，因为用的是同一个html模板
    @category = Category.find(params[:id])
  end
end
