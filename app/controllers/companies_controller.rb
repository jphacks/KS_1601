class CompaniesController < ApplicationController
  
  private
  def company_params
    params.require(:company).permit(:name,:code)
  end

end
