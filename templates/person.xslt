<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html"/>

  <xsl:template match="/">
    <xsl:apply-templates select="items/item"/>
  </xsl:template>

  <xsl:template match="item">
    <div class="person">
      <dl>
        <dt>First Name</dt>
        <dd>
          <xsl:value-of select="name_first" disable-output-escaping="yes"/>
        </dd>
        <dt>Last Name</dt>
        <dd>
          <xsl:value-of select="name_first" disable-output-escaping="yes"/>
        </dd>
        <dt>Middle Name</dt>
        <dd>
          <xsl:value-of select="name_first" disable-output-escaping="yes"/>
        </dd>
        <dt>Profile</dt>
        <dd>
          <dl>
            <xsl:for-each select="profile/*">
              <dt>
                <xsl:value-of select="name()" disable-output-escaping="yes"/>
              </dt>
              <dd>
                <xsl:value-of select=". " disable-output-escaping="yes"/>
              </dd>
            </xsl:for-each>
          </dl>
        </dd>
      </dl>
    </div>
  </xsl:template>
</xsl:stylesheet> 
