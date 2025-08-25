class StaticPagesController < ApplicationController
  def about
    @page = StaticPage.about_page
  end

  def contact
    @page = StaticPage.contact_page
  end
end