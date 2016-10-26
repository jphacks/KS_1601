class CompaniesController < ApplicationController
  def index
    @q=Company.search(params[:q])
    @companies=@q.result(distinct:true)
  end

  private
  def company_params
    params.require(:company).permit(:name,:code)
  end


end
