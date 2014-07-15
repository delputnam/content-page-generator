module Jekyll
  class ContentPage < Page
    def initialize(site, base, dir, page_info)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'
      @page_info = page_info
      
      self.process(@name)
      
      self.read_yaml(File.join(base, '_layouts'), "#{page_info['layout']}.html")

      page_info.each do |key,value|
        self.data[key] = value
      end
    end

    # Returns a hash of URL placeholder names (as symbols) mapping to the
    # desired placeholder replacements. For details see "url.rb"
    def url_placeholders
      my_palceholders = super
      if site.config['content_pages'] && site.config['content_pages']['url_placeholders']
        site.config['content_pages']['url_placeholders'].each do |key,value|
          my_palceholders[key] = @page_info["#{value}"]
        end
      end
      return my_palceholders
    end

    # The template of the permalink.
    #
    # Returns the template String.
    def template
      if site.config['content_pages'] && site.config['content_pages']['permalink_template']
        site.config['content_pages']['permalink_template']
      else
        super
      end
    end
  end
  
  class ContentGenerator < Generator
    safe true
  
    def generate(site)
      if site.data['content_pages']
        site.data['content_pages'].each do |page_info|        
          #page_dir = File.join(page_info['nav'],page_info['subnav'], friendly_filename(page_info['title'].downcase ))
          page_dir = ''
          site.pages << ContentPage.new(site, site.source, page_dir, page_info)
        end
      end
    end
    
    def friendly_filename(filename)
      filename.gsub(/[^\w\s_-]+/, '')
        .gsub(/(^|\b\s)\s+($|\s?\b)/, '\\1\\2')
        .gsub(/\s+/, '_')
      end    
  end
end
   
