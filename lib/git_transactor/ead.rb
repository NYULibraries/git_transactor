require 'nokogiri'
module GitTransactor
  # class for extracting information from EAD files
  class EAD
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def eadid
      @eadid ||= begin
                   xpath='xmlns:ead/xmlns:eadheader/xmlns:eadid'
                   doc.xpath(xpath).text
                 end
    end

    private
    def doc
      @doc ||= Nokogiri::XML(File.open(path))
    end
  end
end
