module ApplicationHelper
  class CodeRayify < Redcarpet::Render::HTML
    def block_code(code, language)
      CodeRay.scan(code, language).div
    end
  end

  def markdown(text)
    coderayified = CodeRayify.new(filter_html: true, hard_wrap: true)

    options = {
      fenced_code_blocks: true,
      no_intra_emphasis: true,
      autolink: true,
      lax_html_blocks: true
    }

    markdown_to_html = Redcarpet::Markdown.new(coderayified, options)
    markdown_to_html.render(text).html_safe
  end

  def login_helper style = ''
    if current_user.is_a?(GuestUser)
      (link_to "Register", new_user_registration_path, class: style) +
      " ".html_safe +
      (link_to "Login", new_user_session_path, class: style)
    else
      link_to "Logout", destroy_user_session_path, method: :delete, class: style
    end
  end

  def source_helper layout_name
    if session[:source]
      greeting = "Thanks for visiting me from #{session[:source]}, you are on the #{layout_name} page."
      content_tag(:p, greeting, class: "source-greeting")
    end
  end

  def copyright_generator
    BakerViewTool::Renderer.copyright "Joseph Baker", "All rights reserved"
  end

  def nav_items
    [
      {
        url: root_path,
        title: "Home"
      },
      {
        url: about_me_path,
        title: "About"
      },
      {
        url: portfolios_path,
        title: "Projects"
      },
      {
        url: tech_news_path,
        title: "News"
      }
    ]
  end

  def nav_helper style, tag_type
    nav_links = ""

    nav_items.each do |item|
      nav_links << "<#{tag_type}><a href='#{item[:url]}' class='#{style} #{active? item[:url]}'>#{item[:title]}</a></#{tag_type}>"
    end
    nav_links.html_safe
  end

  def active? path
    "active" if current_page? path
  end
end
