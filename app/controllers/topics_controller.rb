class TopicsController < ApplicationController

require 'csv'

  def index
    @companies=Company.all
    @q=Topic.ransack(params[:q])
    @topics=@q.result(distinct:true)
    x_axis=
    result=get_csv


    @graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: '解析結果')
      f.xAxis(categories:(0..1000))
      f.series(name: 'あ', data: result)
    end
  end

  def show
    @topic=Topic.find(params[:id])
    @posts=@topic.posts
  end

  def new
    @topic=Topic.new
  end

  def create
    @topic=Topic.new(topic_params)
    if @topic.save
      redirect_to topics_path
    else
      render 'new'
    end
  end

  def get_csv
    csv_data=CSV.table('results.csv')
    result=csv_data[:result]
    return result
  end

  private
  def topic_params
    params.require(:topic).permit(:title)
  end

end
