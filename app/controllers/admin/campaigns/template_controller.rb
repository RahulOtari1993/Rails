class Admin::Campaigns::TemplateController < Admin::Campaigns::BaseController
  before_action :set_template

  def edit
  end

  def update
    build_template_design_params
    respond_to do |format|
      if @template_details.update(template_params)
        format.html { redirect_to edit_admin_campaign_template_path(@campaign, @template_details),
                                  notice: 'Template details were successfully updated.' }
        format.json { render :edit, status: :updated }
      else
        format.html { render :edit }
        format.json { render json: @template_details.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def template_params
    params.require(:campaign_template_detail).permit(:favicon_file, :footer_background_color, :footer_font_color,
                                                     :footer_font_size, :header_background_image, :header_logo, :header_text,
                                                     :header_description, :header_font_color, :header_font_size,
                                                     :header_description_font_size, :header_description_font_color, :element_css_style => {})
  end

  ## Set Template
  def set_template
    @template_details = CampaignTemplateDetail.where(id: params[:id]).first
  end

  ## build elementory design params
  def build_template_design_params
    temp_hash = params[:campaign_template_detail][:element_css_style]

    ## remove null hashes
    temp_hash.each do |key, items|
      items.delete_if { |item| item["value"].blank? }
    end
  end
end
