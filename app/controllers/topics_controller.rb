class TopicsController < ApplicationController

require 'csv'

  def index
    @companies=Company.all
    @selected_companies=SelectedCompany.all
    @selected_company=SelectedCompany.new
    @q=Topic.ransack(params[:q])
    @topics=@q.result(distinct:true)

    @result=get_csv
    gon.csv_data=@result

  end




  def show
    @topic=Topic.find(params[:id])
    @posts=@topic.posts
  end


  def get_csv
    csv_data=CSV.read('result.csv')
    csv_data.shift
    csv_data.pop
    return csv_data
  end

  private
  def topic_params
    params.require(:topic).permit(:title)
  end

  def selected_company_params
    params.require(:selected_company).permit(:name,:code,:days,:runs)
  end

end
