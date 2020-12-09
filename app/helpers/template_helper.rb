module TemplateHelper
  include HTTParty

  def unit_options_list
    options = [['PX', 'px'], ['EM', 'em'], ['REM', 'rem'], ['%', '%']]
    options
  end

  def text_transform_dropdwown_list
    options = [['lowercase', 'lowercase'], ['uppercase', 'uppercase'], ['capitilize', 'capitilize'], ['initial', 'initial'], ['inherit', 'inherit'], ['none', 'none'], ['unset', 'unset']]
    options
  end

  def font_style_dropdown_list
    options = [['initial', 'initial'], ['inherit', 'inherit'], ['italic', 'italic'], ['normal', 'normal'], ['unset', 'unset']]
    options
  end

  def text_decoration_dropdown_list
    options = [['none', 'none'], ['overline', 'overline'], ['underline', 'underline'], ['line-through', 'line-through'], ['solid', 'solid'], ['dashed', 'dashed'], ['dotted', 'dotted'], ['double', 'double'], ['initial', 'initial'], ['inherit', 'inherit']]
    options
  end

  def font_weight_dropdown_list
    options = [['100', '100'], ['200', '200'], ['300', '300'], ['400', '400'], ['500', '500'], ['600', '600'], ['700', '700'],['800', '800'], ['900', '900'], ['bold', 'bold'], ['bolder', 'bolder'], ['lighter', 'lighter'], ['inherit', 'inherit'], ['initial', 'initial'], ['normal', 'normal'], ['unset', 'unset']]
    options
  end

  def border_type_dropdown_list
    options = [['None', 'none'], ['Solid', 'solid'], ['Dotted', 'dotted'], ['Dashed', 'dashed'], ['Double', 'double']]
    options
  end

  def font_family_options_list
    response = HTTParty.get("https://www.googleapis.com/webfonts/v1/webfonts?key=AIzaSyBwIX97bVWr3-6AIUvGkcNnmFgirefZ6Sw")['items'].map{|x| x['family']}
    options = response.map{|x| [x, x] }
    options
  end

  def get_element_design_property(element, property_name)
    item = {}
    items = @template_details["element_css_style"][element] || []
    item = items.detect { |item| item["name"] == property_name }
    item || {}
  end

end
