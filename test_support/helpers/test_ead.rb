class TestEad

  attr_reader :eadid

  def initialize(eadid = 'foo')
    @eadid = eadid
  end
  def to_s
<<EOF
    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<ead xsi:schemaLocation="urn:isbn:1-931666-22-9 http://www.loc.gov/ead/ead.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ns2="http://www.w3.org/1999/xlink" xmlns="urn:isbn:1-931666-22-9">
  <eadheader repositoryencoding="iso15511" countryencoding="iso3166-1" dateencoding="iso8601" langencoding="iso639-2b">
        <eadid countrycode="US">#{eadid}</eadid>
        <filedesc>
            <titlestmt>
                <titleproper>Guide to #{eadid}
                    <num>#{eadid}</num>
                </titleproper>
            </titlestmt>
        </filedesc>
    </eadheader>
    <archdesc level="collection">
        <did>
            <unittitle>Yay! #{eadid}!</unittitle>
        </did>
    </archdesc>
</ead>
EOF
  end
end
