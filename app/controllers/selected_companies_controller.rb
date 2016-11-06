require 'rake'
Rails.application.load_tasks
load File.join(Rails.root, 'lib', 'tasks', 'temporary.rake')

class SelectedCompaniesController < ApplicationController

  def new
    @selected_company=SelectedCompany.new
    @companies=Company.all
    @q=Topic.ransack(params[:q])
    @topics=@q.result(distinct:true)
  end

  def create
    @selected_company=SelectedCompany.new(selected_company_params)
    @selected_company.code=Company.find_by(name:@selected_company.name).code
    if @selected_company.save
      system("rake temporary:python")
      redirect_to root_url
    else
      render'new'
    end
  end


  private
  def selected_company_params
    params.require(:selected_company).permit(:name,:code,:days,:runs)
  end
end
