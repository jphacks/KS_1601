class TopicsController < ApplicationController

require 'csv'

  def index
    @companies=Company.all
    @selected_companies=SelectedCompany.all
    @selected_company=SelectedCompany.new
    @q=Topic.ransack(params[:q])
    @topics=@q.result(distinct:true)

    @result=get_csv


    @graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: '予想推移')
      f.xAxis(categories:(1..364))
      f.series(name: '在庫数', data: @result)
    end
  end




  def show
    @topic=Topic.find(params[:id])
    @posts=@topic.posts
  end


  def get_csv
    csv_data=CSV.table('result.csv')
    result=csv_data[:result]
    return result
  end

  private
  def topic_params
    params.require(:topic).permit(:title)
  end

  def selected_company_params
    params.require(:selected_company).permit(:name,:code,:days,:runs)
  end

end
